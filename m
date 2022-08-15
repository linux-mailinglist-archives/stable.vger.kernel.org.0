Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65DFB593C95
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238975AbiHOUNa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346112AbiHOUKs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:10:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692FB64FD;
        Mon, 15 Aug 2022 11:56:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12D0EB81082;
        Mon, 15 Aug 2022 18:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E7FC433D6;
        Mon, 15 Aug 2022 18:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589804;
        bh=Wujj5i866p9om6sVU/5OKGHjwQgKQ35nherAfS8OOgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1b69kOmwzoLvxg5QBId2FYNh3F2K8WOv2CwxLMH5rW1jGGb7dbQr5jYWrgZgSGJou
         uT4beftPI9j4XOxXxrr3Qn2UQ07G+sexqf2sxCHXtp9+S4EZJhVbEpsZIHqpZFCLXa
         7NKgoAK8Cg/q4NGlFW98l1X6Ht4uYqxY1UjHYfK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@kernel.org
Subject: [PATCH 5.18 0053/1095] fix short copy handling in copy_mc_pipe_to_iter()
Date:   Mon, 15 Aug 2022 19:50:52 +0200
Message-Id: <20220815180431.667421965@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit c3497fd009ef2c59eea60d21c3ac22de3585ed7d upstream.

Unlike other copying operations on ITER_PIPE, copy_mc_to_iter() can
result in a short copy.  In that case we need to trim the unused
buffers, as well as the length of partially filled one - it's not
enough to set ->head, ->iov_offset and ->count to reflect how
much had we copied.  Not hard to fix, fortunately...

I'd put a helper (pipe_discard_from(pipe, head)) into pipe_fs_i.h,
rather than iov_iter.c - it has nothing to do with iov_iter and
having it will allow us to avoid an ugly kludge in fs/splice.c.
We could put it into lib/iov_iter.c for now and move it later,
but I don't see the point going that way...

Cc: stable@kernel.org # 4.19+
Fixes: ca146f6f091e "lib/iov_iter: Fix pipe handling in _copy_to_iter_mcsafe()"
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pipe_fs_i.h |    9 +++++++++
 lib/iov_iter.c            |   15 +++++++++++----
 2 files changed, 20 insertions(+), 4 deletions(-)

--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -229,6 +229,15 @@ static inline bool pipe_buf_try_steal(st
 	return buf->ops->try_steal(pipe, buf);
 }
 
+static inline void pipe_discard_from(struct pipe_inode_info *pipe,
+		unsigned int old_head)
+{
+	unsigned int mask = pipe->ring_size - 1;
+
+	while (pipe->head > old_head)
+		pipe_buf_release(pipe, &pipe->bufs[--pipe->head & mask]);
+}
+
 /* Differs from PIPE_BUF in that PIPE_SIZE is the length of the actual
    memory allocation, whereas PIPE_BUF makes atomicity guarantees.  */
 #define PIPE_SIZE		PAGE_SIZE
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -689,6 +689,7 @@ static size_t copy_mc_pipe_to_iter(const
 	struct pipe_inode_info *pipe = i->pipe;
 	unsigned int p_mask = pipe->ring_size - 1;
 	unsigned int i_head;
+	unsigned int valid = pipe->head;
 	size_t n, off, xfer = 0;
 
 	if (!sanity(i))
@@ -702,11 +703,17 @@ static size_t copy_mc_pipe_to_iter(const
 		rem = copy_mc_to_kernel(p + off, addr + xfer, chunk);
 		chunk -= rem;
 		kunmap_local(p);
-		i->head = i_head;
-		i->iov_offset = off + chunk;
-		xfer += chunk;
-		if (rem)
+		if (chunk) {
+			i->head = i_head;
+			i->iov_offset = off + chunk;
+			xfer += chunk;
+			valid = i_head + 1;
+		}
+		if (rem) {
+			pipe->bufs[i_head & p_mask].len -= rem;
+			pipe_discard_from(pipe, valid);
 			break;
+		}
 		n -= chunk;
 		off = 0;
 		i_head++;



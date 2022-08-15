Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6865934FA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239834AbiHOSST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239614AbiHOSRm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:17:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5435FAF;
        Mon, 15 Aug 2022 11:15:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88C33B81071;
        Mon, 15 Aug 2022 18:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A67AC433C1;
        Mon, 15 Aug 2022 18:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587318;
        bh=nWz37meKbo+peJBGyeJLJsBcFELwh28xHN20ySPVPcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUOvG7P0BR8lrTWetxrjJpj9bmbo2C70mPXAdkwIn7pyVu37UkJXnyMrgOfgAIc4x
         85IvsGgZOxJkEyhpLDbnXprhMxGK7WbMMfnOg9YMXSgORCMT/v59kpjF8GM8QtHKAU
         J0K287lnJSrIGB2KUzlEunPCtttgtMSZj5Mu5XtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@kernel.org
Subject: [PATCH 5.15 046/779] fix short copy handling in copy_mc_pipe_to_iter()
Date:   Mon, 15 Aug 2022 19:54:50 +0200
Message-Id: <20220815180339.215030436@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
@@ -691,6 +691,7 @@ static size_t copy_mc_pipe_to_iter(const
 	struct pipe_inode_info *pipe = i->pipe;
 	unsigned int p_mask = pipe->ring_size - 1;
 	unsigned int i_head;
+	unsigned int valid = pipe->head;
 	size_t n, off, xfer = 0;
 
 	if (!sanity(i))
@@ -704,11 +705,17 @@ static size_t copy_mc_pipe_to_iter(const
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



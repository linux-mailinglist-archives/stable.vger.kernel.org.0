Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E6B5919AA
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 11:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239096AbiHMJi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 05:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238995AbiHMJiy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 05:38:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E83F43325
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 02:38:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 258DDB8104F
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 09:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8529DC433C1;
        Sat, 13 Aug 2022 09:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660383530;
        bh=OjOYOh++cnnhYxl5+np7xv/idmxrFiSeTkf9EAxhPZk=;
        h=Subject:To:Cc:From:Date:From;
        b=s1u3rOWjGjHgbVIeZrSeihOUnmINDaTAj9kCjWTgaxYC3VJ2SFSTXwoUegEoEaAdA
         xclHTyKePf0zD3I8+336i6NQ8me1/mdNfswk2llsWPLnLZA/EUrQWkYTcXNU4qtLC0
         5X9RSMMnV0ixE+U75nU8IzbjbkqE1RdaWjgP8hBo=
Subject: FAILED: patch "[PATCH] fix short copy handling in copy_mc_pipe_to_iter()" failed to apply to 5.10-stable tree
To:     viro@zeniv.linux.org.uk, brauner@kernel.org, jlayton@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 11:38:48 +0200
Message-ID: <1660383528201188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c3497fd009ef2c59eea60d21c3ac22de3585ed7d Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Sun, 12 Jun 2022 19:50:29 -0400
Subject: [PATCH] fix short copy handling in copy_mc_pipe_to_iter()

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

diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index cb0fd633a610..4ea496924106 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -229,6 +229,15 @@ static inline bool pipe_buf_try_steal(struct pipe_inode_info *pipe,
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
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 0b64695ab632..2bf20b48a04a 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -689,6 +689,7 @@ static size_t copy_mc_pipe_to_iter(const void *addr, size_t bytes,
 	struct pipe_inode_info *pipe = i->pipe;
 	unsigned int p_mask = pipe->ring_size - 1;
 	unsigned int i_head;
+	unsigned int valid = pipe->head;
 	size_t n, off, xfer = 0;
 
 	if (!sanity(i))
@@ -702,11 +703,17 @@ static size_t copy_mc_pipe_to_iter(const void *addr, size_t bytes,
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


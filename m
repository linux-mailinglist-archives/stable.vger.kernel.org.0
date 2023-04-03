Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95346D3EB8
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 10:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjDCIOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 04:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDCIOc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 04:14:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89AB55A1
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 01:14:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CB24B812A3
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB86DC433D2;
        Mon,  3 Apr 2023 08:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680509669;
        bh=MGzIqCVT5cBDWKqYsUfBj9fSArUflpY/NC6urW9cfFU=;
        h=Subject:To:Cc:From:Date:From;
        b=GppbWy6QIYJuEmpqC5tlrRQE1xmNFj/zXFfd+l+MjYC4wMpMlt+uDFZAiQ3cO5etg
         z9yrGQDh8l8lszVWh0xXDJKGlWJY1aGRqj+cF+zmfn/X3hyD3FPtBe/uGc1dbMdwiA
         u01bM1WWWs+GDdEHOCbDJXIqLmFWrLq6KLwYpaxo=
Subject: FAILED: patch "[PATCH] zonefs: Do not propagate iomap_dio_rw() ENOTBLK error to user" failed to apply to 5.15-stable tree
To:     damien.lemoal@opensource.wdc.com, hans.holmberg@wdc.com,
        hch@infradead.org, hch@lst.de, johannes.thumshirn@wdc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Apr 2023 10:14:26 +0200
Message-ID: <2023040326-rind-claw-0bcb@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 77af13ba3c7f91d91c377c7e2d122849bbc17128
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023040326-rind-claw-0bcb@gregkh' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

77af13ba3c7f ("zonefs: Do not propagate iomap_dio_rw() ENOTBLK error to user space")
aa7f243f32e1 ("zonefs: Separate zone information from inode information")
34422914dc00 ("zonefs: Reduce struct zonefs_inode_info size")
46a9c526eef7 ("zonefs: Simplify IO error handling")
4008e2a0b01a ("zonefs: Reorganize code")
a608da3bd730 ("zonefs: Detect append writes at invalid locations")
db58653ce0c7 ("zonefs: Fix active zone accounting")
7dd12d65ac64 ("zonefs: fix zone report size in __zonefs_io_error()")
8745889a7fd0 ("Merge tag 'iomap-6.0-merge-2' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 77af13ba3c7f91d91c377c7e2d122849bbc17128 Mon Sep 17 00:00:00 2001
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Date: Thu, 30 Mar 2023 09:47:58 +0900
Subject: [PATCH] zonefs: Do not propagate iomap_dio_rw() ENOTBLK error to user
 space

The call to invalidate_inode_pages2_range() in __iomap_dio_rw() may
fail, in which case -ENOTBLK is returned and this error code is
propagated back to user space trhough iomap_dio_rw() ->
zonefs_file_dio_write() return chain. This error code is fairly obscure
and may confuse the user. Avoid this and be consistent with the behavior
of zonefs_file_dio_append() for similar invalidate_inode_pages2_range()
errors by returning -EBUSY to user space when iomap_dio_rw() returns
-ENOTBLK.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Fixes: 8dcc1a9d90c1 ("fs: New zonefs file system")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>

diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
index c6ab2732955e..132f01d3461f 100644
--- a/fs/zonefs/file.c
+++ b/fs/zonefs/file.c
@@ -581,11 +581,21 @@ static ssize_t zonefs_file_dio_write(struct kiocb *iocb, struct iov_iter *from)
 		append = sync;
 	}
 
-	if (append)
+	if (append) {
 		ret = zonefs_file_dio_append(iocb, from);
-	else
+	} else {
+		/*
+		 * iomap_dio_rw() may return ENOTBLK if there was an issue with
+		 * page invalidation. Overwrite that error code with EBUSY to
+		 * be consistent with zonefs_file_dio_append() return value for
+		 * similar issues.
+		 */
 		ret = iomap_dio_rw(iocb, from, &zonefs_write_iomap_ops,
 				   &zonefs_write_dio_ops, 0, NULL, 0);
+		if (ret == -ENOTBLK)
+			ret = -EBUSY;
+	}
+
 	if (zonefs_zone_is_seq(z) &&
 	    (ret > 0 || ret == -EIOCBQUEUED)) {
 		if (ret > 0)


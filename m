Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E32BB6D3EB9
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 10:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbjDCIOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 04:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjDCIOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 04:14:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5712755B6
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 01:14:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB9D8615E3
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFDBC433D2;
        Mon,  3 Apr 2023 08:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680509678;
        bh=ShcJBmwt6Te0jhiP6SwGoLsbJoyemqO6TfDlVJo7PWM=;
        h=Subject:To:Cc:From:Date:From;
        b=iOWxXLQUKBvVN4Ey/7mtiNgYz6YGJnYXRVPWF8xECcNDm3OFP9Zn0NB+i0Mpgwq0s
         FD+GD/1vlLbEyRke2e/2pDSBLL6TPwIg0Q7U10D4JZd7aQ/eCF1UR6ZcK4hXaEQUmk
         5AhIR2UYvjlVKXvmSVR2K5Nv4J8xg50ugwc0t3jE=
Subject: FAILED: patch "[PATCH] zonefs: Do not propagate iomap_dio_rw() ENOTBLK error to user" failed to apply to 5.10-stable tree
To:     damien.lemoal@opensource.wdc.com, hans.holmberg@wdc.com,
        hch@infradead.org, hch@lst.de, johannes.thumshirn@wdc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Apr 2023 10:14:27 +0200
Message-ID: <2023040327-freehand-water-9a7b@gregkh>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x 77af13ba3c7f91d91c377c7e2d122849bbc17128
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023040327-freehand-water-9a7b@gregkh' --subject-prefix 'PATCH 5.10.y' HEAD^..

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


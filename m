Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684C56CBDFE
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 13:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbjC1Lkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 07:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbjC1Lks (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 07:40:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3510683D9
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 04:40:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6B58616E4
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 11:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D966AC433EF;
        Tue, 28 Mar 2023 11:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680003647;
        bh=+1x1P6AAVr5WvOliKuHl8b0RPZIgaC15V6yz50Fm3gs=;
        h=Subject:To:Cc:From:Date:From;
        b=XxF0UoZv0dJF+y6XrW/EsIIxY6N81/6F1AHR26t64WcU915dmJW6aQnBh44KFxV7N
         k4l43X2gYh4dtPSSWc/Rzw5DJ9ZmKGY2qk157j5es7vUiu/MJtZutdCIfZbdMikrg5
         2mHLn26hZPo1bm/vHyPEEhGAA573UIiIY3gLm42s=
Subject: FAILED: patch "[PATCH] zonefs: Fix error message in zonefs_file_dio_append()" failed to apply to 5.10-stable tree
To:     damien.lemoal@opensource.wdc.com, hch@lst.de,
        himanshu.madhani@oracle.com, johannes.thumshirn@wdc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 13:40:32 +0200
Message-ID: <16800036329137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
git cherry-pick -x 88b170088ad2c3e27086fe35769aa49f8a512564
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16800036329137@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

88b170088ad2 ("zonefs: Fix error message in zonefs_file_dio_append()")
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

From 88b170088ad2c3e27086fe35769aa49f8a512564 Mon Sep 17 00:00:00 2001
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Date: Mon, 20 Mar 2023 22:49:15 +0900
Subject: [PATCH] zonefs: Fix error message in zonefs_file_dio_append()

Since the expected write location in a sequential file is always at the
end of the file (append write), when an invalid write append location is
detected in zonefs_file_dio_append(), print the invalid written location
instead of the expected write location.

Fixes: a608da3bd730 ("zonefs: Detect append writes at invalid locations")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
index a545a6d9a32e..617e4f9db42e 100644
--- a/fs/zonefs/file.c
+++ b/fs/zonefs/file.c
@@ -426,7 +426,7 @@ static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
 		if (bio->bi_iter.bi_sector != wpsector) {
 			zonefs_warn(inode->i_sb,
 				"Corrupted write pointer %llu for zone at %llu\n",
-				wpsector, z->z_sector);
+				bio->bi_iter.bi_sector, z->z_sector);
 			ret = -EIO;
 		}
 	}


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604906CBDFB
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 13:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbjC1Lkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 07:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbjC1Lke (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 07:40:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9264E44BE
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 04:40:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CF71616E4
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 11:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3590AC433D2;
        Tue, 28 Mar 2023 11:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680003632;
        bh=e75/R/GCcgpoUenoe+9QGZ7Dl/mbo0U+enxwPhIO9k8=;
        h=Subject:To:Cc:From:Date:From;
        b=bQvz+mFtYLLitkZY5pdnpMsf7bRkqfelMyRLatvyihVxgv15RHKeClIvxCod64NE5
         L5YXRPzTAuI0YEriGKMDwP/ZqMpUwazYdQ6P2d1QzitDLjMVsuSJrb//iuEofLdNgi
         QB8mTBpFjRItJVLhurOP3+UW7hOMOY7XOfaQ2e3s=
Subject: FAILED: patch "[PATCH] zonefs: Fix error message in zonefs_file_dio_append()" failed to apply to 6.2-stable tree
To:     damien.lemoal@opensource.wdc.com, hch@lst.de,
        himanshu.madhani@oracle.com, johannes.thumshirn@wdc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 13:40:25 +0200
Message-ID: <1680003625145213@kroah.com>
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


The patch below does not apply to the 6.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.2.y
git checkout FETCH_HEAD
git cherry-pick -x 88b170088ad2c3e27086fe35769aa49f8a512564
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1680003625145213@kroah.com' --subject-prefix 'PATCH 6.2.y' HEAD^..

Possible dependencies:

88b170088ad2 ("zonefs: Fix error message in zonefs_file_dio_append()")
aa7f243f32e1 ("zonefs: Separate zone information from inode information")
34422914dc00 ("zonefs: Reduce struct zonefs_inode_info size")
46a9c526eef7 ("zonefs: Simplify IO error handling")
4008e2a0b01a ("zonefs: Reorganize code")

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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341C96BB278
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbjCOMga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbjCOMgI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:36:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C9D8EA09
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:35:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9CF561D78
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC592C433EF;
        Wed, 15 Mar 2023 12:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883711;
        bh=Hj+XlBTIjGwPR8kKUgh8MRzNjjR262C/o9btYzaCeT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtGZ8vWKxYOXeBeVD9DUK/NE7CecX4T9AAcStGcGdP6Oe71PIaT1TFXW9PyeKNL8O
         +tK/nEB7JA0uUmD9zkG2q9ScuFRzc3T9240ojeWHZZAY7CqyDye3mGTSkHSYef8Rmx
         1lGajgEoLpcsNuK2bQ9OvmHd1i2UMGJaHsjYFQ2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+2bcc0d79e548c4f62a59@syzkaller.appspotmail.com,
        Julian Ruess <julianr@linux.ibm.com>,
        Yu Kuai <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/143] block: fix wrong mode for blkdev_put() from disk_scan_partitions()
Date:   Wed, 15 Mar 2023 13:13:08 +0100
Message-Id: <20230315115743.603682735@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 428913bce1e67ccb4dae317fd0332545bf8c9233 ]

If disk_scan_partitions() is called with 'FMODE_EXCL',
blkdev_get_by_dev() will be called without 'FMODE_EXCL', however, follow
blkdev_put() is still called with 'FMODE_EXCL', which will cause
'bd_holders' counter to leak.

Fix the problem by using the right mode for blkdev_put().

Reported-by: syzbot+2bcc0d79e548c4f62a59@syzkaller.appspotmail.com
Link: https://lore.kernel.org/lkml/f9649d501bc8c3444769418f6c26263555d9d3be.camel@linux.ibm.com/T/
Tested-by: Julian Ruess <julianr@linux.ibm.com>
Fixes: e5cfefa97bcc ("block: fix scan partition for exclusively open device again")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index 85ae755913e9e..0b6928e948f31 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -385,7 +385,7 @@ int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
 	if (IS_ERR(bdev))
 		ret =  PTR_ERR(bdev);
 	else
-		blkdev_put(bdev, mode);
+		blkdev_put(bdev, mode & ~FMODE_EXCL);
 
 	if (!(mode & FMODE_EXCL))
 		bd_abort_claiming(disk->part0, disk_scan_partitions);
-- 
2.39.2




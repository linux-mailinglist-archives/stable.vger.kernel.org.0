Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C762B6BB1A4
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbjCOM3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbjCOM3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:29:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0F523334
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:28:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B01461D50
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F983C433EF;
        Wed, 15 Mar 2023 12:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883279;
        bh=Lf7ISlneS8N4jfqBCpQNsnYrmzmgCjixd5SrJowqgxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5is4As+YVohdoZ0szFJ2YJqPtv8m81Ced9PlXK30aOpwwRimaYjgr40gaifZvwsD
         4Ki8amGUKaxLEvXufZvTzbZRw/oM1T0tiPCjsx5rbwee+3s4Tx3W1V7jEFEi/6cgUE
         Zg3p3hu6xDMO87A/NviBFGbNB8zPxI2bqnWdtT4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/145] nbd: use the correct block_device in nbd_bdev_reset
Date:   Wed, 15 Mar 2023 13:12:30 +0100
Message-Id: <20230315115741.753741936@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 2a852a693f8839bb877fc731ffbc9ece3a9c16d7 ]

The bdev parameter to ->ioctl contains the block device that the ioctl
is called on, which can be the partition.  But the openers check in
nbd_bdev_reset really needs to check use the whole device, so switch to
using that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220330052917.2566582-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: e5cfefa97bcc ("block: fix scan partition for exclusively open device again")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index c1ef1df42eb66..ade8b839e4458 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1167,11 +1167,11 @@ static int nbd_reconnect_socket(struct nbd_device *nbd, unsigned long arg)
 	return -ENOSPC;
 }
 
-static void nbd_bdev_reset(struct block_device *bdev)
+static void nbd_bdev_reset(struct nbd_device *nbd)
 {
-	if (bdev->bd_openers > 1)
+	if (nbd->disk->part0->bd_openers > 1)
 		return;
-	set_capacity(bdev->bd_disk, 0);
+	set_capacity(nbd->disk, 0);
 }
 
 static void nbd_parse_flags(struct nbd_device *nbd)
@@ -1337,7 +1337,7 @@ static int nbd_start_device(struct nbd_device *nbd)
 	return nbd_set_size(nbd, config->bytesize, nbd_blksize(config));
 }
 
-static int nbd_start_device_ioctl(struct nbd_device *nbd, struct block_device *bdev)
+static int nbd_start_device_ioctl(struct nbd_device *nbd)
 {
 	struct nbd_config *config = nbd->config;
 	int ret;
@@ -1358,7 +1358,7 @@ static int nbd_start_device_ioctl(struct nbd_device *nbd, struct block_device *b
 
 	flush_workqueue(nbd->recv_workq);
 	mutex_lock(&nbd->config_lock);
-	nbd_bdev_reset(bdev);
+	nbd_bdev_reset(nbd);
 	/* user requested, ignore socket errors */
 	if (test_bit(NBD_RT_DISCONNECT_REQUESTED, &config->runtime_flags))
 		ret = 0;
@@ -1372,7 +1372,7 @@ static void nbd_clear_sock_ioctl(struct nbd_device *nbd,
 {
 	nbd_clear_sock(nbd);
 	__invalidate_device(bdev, true);
-	nbd_bdev_reset(bdev);
+	nbd_bdev_reset(nbd);
 	if (test_and_clear_bit(NBD_RT_HAS_CONFIG_REF,
 			       &nbd->config->runtime_flags))
 		nbd_config_put(nbd);
@@ -1418,7 +1418,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		config->flags = arg;
 		return 0;
 	case NBD_DO_IT:
-		return nbd_start_device_ioctl(nbd, bdev);
+		return nbd_start_device_ioctl(nbd);
 	case NBD_CLEAR_QUE:
 		/*
 		 * This is for compatibility only.  The queue is always cleared
-- 
2.39.2




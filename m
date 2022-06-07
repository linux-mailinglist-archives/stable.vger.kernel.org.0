Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CADF5419D6
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377979AbiFGVYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379003AbiFGVXQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:23:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C3C226CC2;
        Tue,  7 Jun 2022 12:00:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F93DB8239F;
        Tue,  7 Jun 2022 19:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E04C385A2;
        Tue,  7 Jun 2022 19:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628410;
        bh=TPRFP2xRp1bygFJ1WXucBwWn0OwIarywpK7WnUbnKmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xXiJJUoLOyasTStMHctpWBorn+Ys1hW0EUDX3IJpWEtzseyLNWNpH3mY2sNVwFPuH
         vv5/y2uBa9me+Hrw9HGVJJGfGa4DPXlPP2kZNtIMHQR0o6PWkUWQtX64PcOnqHBbi9
         OHFt3PQrHMRqpaYDNc73RsX48NS89C6hpUh117G4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 318/879] drbd: use bdev based limit helpers in drbd_send_sizes
Date:   Tue,  7 Jun 2022 18:57:16 +0200
Message-Id: <20220607165012.080830401@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 7a38acce229685968b770d1d9e64e01396b93643 ]

Use the bdev based limits helpers where they exist.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Link: https://lore.kernel.org/r/20220415045258.199825-6-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 367715205c86..c39b04bda261 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -924,7 +924,9 @@ int drbd_send_sizes(struct drbd_peer_device *peer_device, int trigger_reply, enu
 
 	memset(p, 0, packet_size);
 	if (get_ldev_if_state(device, D_NEGOTIATING)) {
-		struct request_queue *q = bdev_get_queue(device->ldev->backing_bdev);
+		struct block_device *bdev = device->ldev->backing_bdev;
+		struct request_queue *q = bdev_get_queue(bdev);
+
 		d_size = drbd_get_max_capacity(device->ldev);
 		rcu_read_lock();
 		u_size = rcu_dereference(device->ldev->disk_conf)->disk_size;
@@ -933,13 +935,13 @@ int drbd_send_sizes(struct drbd_peer_device *peer_device, int trigger_reply, enu
 		max_bio_size = queue_max_hw_sectors(q) << 9;
 		max_bio_size = min(max_bio_size, DRBD_MAX_BIO_SIZE);
 		p->qlim->physical_block_size =
-			cpu_to_be32(queue_physical_block_size(q));
+			cpu_to_be32(bdev_physical_block_size(bdev));
 		p->qlim->logical_block_size =
-			cpu_to_be32(queue_logical_block_size(q));
+			cpu_to_be32(bdev_logical_block_size(bdev));
 		p->qlim->alignment_offset =
 			cpu_to_be32(queue_alignment_offset(q));
-		p->qlim->io_min = cpu_to_be32(queue_io_min(q));
-		p->qlim->io_opt = cpu_to_be32(queue_io_opt(q));
+		p->qlim->io_min = cpu_to_be32(bdev_io_min(bdev));
+		p->qlim->io_opt = cpu_to_be32(bdev_io_opt(bdev));
 		p->qlim->discard_enabled = blk_queue_discard(q);
 		put_ldev(device);
 	} else {
-- 
2.35.1




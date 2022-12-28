Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F0E657D24
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbiL1Pjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:39:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbiL1Pjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:39:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0BD167D1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:39:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE3BCB8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22DABC433D2;
        Wed, 28 Dec 2022 15:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241990;
        bh=xeHL+GUnhYwLz6unm2J4sEyw4CDuWIbUSG5lMXRq/dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lr5lDRRNwAhvNeg+XBnHTu26r2/Rj9Jjj8okAvelrK0SEFKXRKPiy6kOQeAokGsOl
         gD0qXRz4cwbZDV3Bi2HsJtY29ake3xZuWnh/xZ6KvPX5W2m+c1fkbGzjOUSJvKGYra
         uz6wC0VytQnq8nbp4J1yCgfKCzlqnCIUU9JskXkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Joel Colledge <joel.colledge@linbit.com>,
        =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0313/1146] drbd: use blk_queue_max_discard_sectors helper
Date:   Wed, 28 Dec 2022 15:30:52 +0100
Message-Id: <20221228144338.655197225@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>

[ Upstream commit 258bea6388ac93f34561fd91064232d14e174bff ]

We currently only set q->limits.max_discard_sectors, but that is not
enough. Another field, max_hw_discard_sectors, was introduced in
commit 0034af036554 ("block: make /sys/block/<dev>/queue/discard_max_bytes
writeable").

The difference is that max_discard_sectors can be changed from user
space via sysfs, while max_hw_discard_sectors is the "hardware" upper
limit.

So use this helper, which sets both.

This is also a fixup for commit 998e9cbcd615 ("drbd: cleanup
decide_on_discard_support"): if discards are not supported, that does
not necessarily mean we also want to disable write_zeroes.

Fixes: 998e9cbcd615 ("drbd: cleanup decide_on_discard_support")
Reviewed-by: Joel Colledge <joel.colledge@linbit.com>
Signed-off-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Link: https://lore.kernel.org/r/20221109133453.51652-2-christoph.boehmwalder@linbit.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_nl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 864c98e74875..249eba7d21c2 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1210,6 +1210,7 @@ static void decide_on_discard_support(struct drbd_device *device,
 	struct drbd_connection *connection =
 		first_peer_device(device)->connection;
 	struct request_queue *q = device->rq_queue;
+	unsigned int max_discard_sectors;
 
 	if (bdev && !bdev_max_discard_sectors(bdev->backing_bdev))
 		goto not_supported;
@@ -1230,15 +1231,14 @@ static void decide_on_discard_support(struct drbd_device *device,
 	 * topology on all peers.
 	 */
 	blk_queue_discard_granularity(q, 512);
-	q->limits.max_discard_sectors = drbd_max_discard_sectors(connection);
-	q->limits.max_write_zeroes_sectors =
-		drbd_max_discard_sectors(connection);
+	max_discard_sectors = drbd_max_discard_sectors(connection);
+	blk_queue_max_discard_sectors(q, max_discard_sectors);
+	blk_queue_max_write_zeroes_sectors(q, max_discard_sectors);
 	return;
 
 not_supported:
 	blk_queue_discard_granularity(q, 0);
-	q->limits.max_discard_sectors = 0;
-	q->limits.max_write_zeroes_sectors = 0;
+	blk_queue_max_discard_sectors(q, 0);
 }
 
 static void fixup_write_zeroes(struct drbd_device *device, struct request_queue *q)
-- 
2.35.1




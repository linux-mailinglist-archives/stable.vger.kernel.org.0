Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAF74EC1E0
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344495AbiC3L5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345618AbiC3Lyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:54:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E149261312;
        Wed, 30 Mar 2022 04:51:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF9A0B81C37;
        Wed, 30 Mar 2022 11:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6CEC36AE2;
        Wed, 30 Mar 2022 11:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641087;
        bh=Qwld639rWFNiSh85PW5Z3KUZfu7NCz4cuIK0UIEMmms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBSlbTX1t6cigFNjSl6PQ1m++znknmYldOpVxVg0Xu8EQTR5hMhWK/nr+rZaTfgtQ
         BkS3uFwKgSfibMfTCDs6kjDBCaY7iSk4H4N4B5rX5LZ8YdSUFuwy2xQpyZHJL7HAeZ
         2GUko0LQVdAT7xz3nPMrodtX1Z6mtKQo2LAPnn2vZcCoTvP/w28hkxlEr6JcocJJky
         JAT1h3PhRqNbxg1DZGlUDRC9PGNYg7ebpHnbvxLCGBuWs1ahq/0+I1LW6VtCUUdkir
         Tay2P91WR06ClQjmNegCFhPXHsI3W4kiltWonObLOBVY4mwnjNQLuiBVSOaoDfy7XC
         RVDJS78b5ESnw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.10 02/37] media: staging: media: zoran: calculate the right buffer number for zoran_reap_stat_com
Date:   Wed, 30 Mar 2022 07:50:47 -0400
Message-Id: <20220330115122.1671763-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115122.1671763-1-sashal@kernel.org>
References: <20220330115122.1671763-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit e3b86f4e558cea9eed71d894df2f19b10d60a207 ]

On the case tmp_dcim=1, the index of buffer is miscalculated.
This generate a NULL pointer dereference later.

So let's fix the calcul and add a check to prevent this to reappear.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/zoran/zoran_device.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/zoran/zoran_device.c b/drivers/staging/media/zoran/zoran_device.c
index e569a1341d01..913f5a3c5bfc 100644
--- a/drivers/staging/media/zoran/zoran_device.c
+++ b/drivers/staging/media/zoran/zoran_device.c
@@ -879,7 +879,7 @@ static void zoran_reap_stat_com(struct zoran *zr)
 		if (zr->jpg_settings.tmp_dcm == 1)
 			i = (zr->jpg_dma_tail - zr->jpg_err_shift) & BUZ_MASK_STAT_COM;
 		else
-			i = ((zr->jpg_dma_tail - zr->jpg_err_shift) & 1) * 2 + 1;
+			i = ((zr->jpg_dma_tail - zr->jpg_err_shift) & 1) * 2;
 
 		stat_com = le32_to_cpu(zr->stat_com[i]);
 		if ((stat_com & 1) == 0) {
@@ -891,6 +891,11 @@ static void zoran_reap_stat_com(struct zoran *zr)
 		size = (stat_com & GENMASK(22, 1)) >> 1;
 
 		buf = zr->inuse[i];
+		if (!buf) {
+			spin_unlock_irqrestore(&zr->queued_bufs_lock, flags);
+			pci_err(zr->pci_dev, "No buffer at slot %d\n", i);
+			return;
+		}
 		buf->vbuf.vb2_buf.timestamp = ktime_get_ns();
 
 		if (zr->codec_mode == BUZ_MODE_MOTION_COMPRESS) {
-- 
2.34.1


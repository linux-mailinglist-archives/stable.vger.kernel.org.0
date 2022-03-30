Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E2B4EBFFD
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343757AbiC3Lsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343752AbiC3Lsg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:48:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162761D914D;
        Wed, 30 Mar 2022 04:46:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E5F461618;
        Wed, 30 Mar 2022 11:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2326AC34111;
        Wed, 30 Mar 2022 11:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640811;
        bh=1mzmburc3X+szuNAEo1tXUhYMeph1aGhucbEOTahC2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgz8IXmrbuif2hxx0jHchR2UcscV8Crqmddv/ZEjdoRlWlE4I26GKxBAnnZzw8BcS
         pz9zg9+xMcVNFzmvX3T5cRVG1IWwABvcq3dHgXqI0uohfsrvTGGDFeGY1UV9Ug92PI
         plL251DKVgiCwGh12uGCfjgDRKy89UY1Z8jE3S5w51oiG29KaduPFFbrL/9DX4mazL
         GUBvU2+U9nxW+gHQXwiCt3Z/2nL0G2HrFtaoAJYvywmgwy3zZfPQ3I6y8IMC31qDT8
         83UZcd0EjnjS/G4tRwG3S2lYUsQ0T+tR/YW2V5bZBpFZklro4Wz1OiWzueOpuuorJx
         6nowcH18Fx1ww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.17 02/66] media: staging: media: zoran: calculate the right buffer number for zoran_reap_stat_com
Date:   Wed, 30 Mar 2022 07:45:41 -0400
Message-Id: <20220330114646.1669334-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114646.1669334-1-sashal@kernel.org>
References: <20220330114646.1669334-1-sashal@kernel.org>
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
index 5b12a730a229..fb1f0465ca87 100644
--- a/drivers/staging/media/zoran/zoran_device.c
+++ b/drivers/staging/media/zoran/zoran_device.c
@@ -814,7 +814,7 @@ static void zoran_reap_stat_com(struct zoran *zr)
 		if (zr->jpg_settings.tmp_dcm == 1)
 			i = (zr->jpg_dma_tail - zr->jpg_err_shift) & BUZ_MASK_STAT_COM;
 		else
-			i = ((zr->jpg_dma_tail - zr->jpg_err_shift) & 1) * 2 + 1;
+			i = ((zr->jpg_dma_tail - zr->jpg_err_shift) & 1) * 2;
 
 		stat_com = le32_to_cpu(zr->stat_com[i]);
 		if ((stat_com & 1) == 0) {
@@ -826,6 +826,11 @@ static void zoran_reap_stat_com(struct zoran *zr)
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


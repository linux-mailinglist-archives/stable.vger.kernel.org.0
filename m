Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E0F4F2B73
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353551AbiDEKIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344366AbiDEJTe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:19:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4E22DB;
        Tue,  5 Apr 2022 02:08:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 627D561571;
        Tue,  5 Apr 2022 09:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78742C385A1;
        Tue,  5 Apr 2022 09:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149682;
        bh=1mzmburc3X+szuNAEo1tXUhYMeph1aGhucbEOTahC2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oyL2Z6FUb/5ZRfHUEy9GSzbcDp3pTa8WJKGcyL6k64sGXMAGpTPfKXPUl8OiHe245
         dxrjr0aXy69MHnd6mZOPD7SdvJyc8q9E6J5rQJazfsxgdzDPH4TnQ3KSEGsewjDK27
         UGTDbMFYwHyZvqx3EXmJ6nnBc4lR1ZIFUChyBagY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0804/1017] media: staging: media: zoran: calculate the right buffer number for zoran_reap_stat_com
Date:   Tue,  5 Apr 2022 09:28:37 +0200
Message-Id: <20220405070418.115025989@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




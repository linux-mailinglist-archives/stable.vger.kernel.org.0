Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB06E4F275D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbiDEIDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234235AbiDEH6F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:58:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD741E3F7;
        Tue,  5 Apr 2022 00:52:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2C02B81BB5;
        Tue,  5 Apr 2022 07:52:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3942AC3410F;
        Tue,  5 Apr 2022 07:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145124;
        bh=Ts1OsI3ZLCMyHQ1eqGV7NkwX+jLelzLpcnalARBhejs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4O0aUHkGLZA4jgM0V/3Hh/CQ8kobgJiQHaX+BWzbkxiG9WAAetriUprJhX60RR0K
         vM1HbcnV/Ze7OEGStJBDu7/ltPaKnQzrG/6Qpp4n5Wx7NYFJriWsN1ys4LU5+HoHSt
         sGsQClJumVuHPC6IuANphU3mR9fvl2iFvFXpYY/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0292/1126] media: staging: media: zoran: fix usage of vb2_dma_contig_set_max_seg_size
Date:   Tue,  5 Apr 2022 09:17:19 +0200
Message-Id: <20220405070416.185368002@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

[ Upstream commit 241f5b67fb48def58643f279dfb8468bdd54b443 ]

vb2_dma_contig_set_max_seg_size need to have a size in parameter and not
a DMA_BIT_MASK().
While fixing this issue, also fix error handling of all DMA size
setting.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: d4ae3689226e5 ("media: zoran: device support only 32bit DMA address")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/zoran/zoran_card.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/zoran/zoran_card.c b/drivers/staging/media/zoran/zoran_card.c
index f259585b0689..c578ef3c32f5 100644
--- a/drivers/staging/media/zoran/zoran_card.c
+++ b/drivers/staging/media/zoran/zoran_card.c
@@ -1069,8 +1069,10 @@ static int zoran_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (err)
-		return -ENODEV;
-	vb2_dma_contig_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
+		return err;
+	err = vb2_dma_contig_set_max_seg_size(&pdev->dev, U32_MAX);
+	if (err)
+		return err;
 
 	nr = zoran_num++;
 	if (nr >= BUZ_MAX) {
-- 
2.34.1




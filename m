Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13DD8574144
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 04:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiGNCHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 22:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiGNCHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 22:07:49 -0400
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14832317D;
        Wed, 13 Jul 2022 19:07:46 -0700 (PDT)
Received: by mail-qv1-f43.google.com with SMTP id m6so475390qvq.10;
        Wed, 13 Jul 2022 19:07:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vtnkEvi5Udxd5BmGMWeYsoH6oqCqsLmq/xNGp+XW7xg=;
        b=qtkSJIJBJD06rpW2rWyF9DJfHl0TgJK+0RLoawMCEfSf8OnZiUzAMyTgBqMmuSDseW
         ksjpxzhbcm9vuJJ/JU45qBozOU/t8qPDAAA6XrHEdlPnMNRru/Q309fGNX8jiTE+1KRc
         7C4l2p6jTFSDqtvNCBzzIYsKVjyFZQUWSF1QbBmk+Z1Mt4SvoGH+8aZ8Ccb/Ds36GuIp
         GjifFidBQx2XceB19UnGJEAHxBGFA4PW5N1WdDLpF3y92/vfEXpwuxzHTfn60QgfUboO
         +a5slkdLhfD9DS3Y8je+RVFiHS/IYoBxTfyTrfxRZ/OHPHwCTLc7vVx/Mn2BIJyJ9Svf
         6w1w==
X-Gm-Message-State: AJIora9LBbxDeeePw0jQ9TCVygjQqYk3iplKRLqCH8TG8nxMmndoZFKS
        m3JFI9uY9Z3oL/qvXYNQt1h+oYBRJ44=
X-Google-Smtp-Source: AGRyM1tCazHNvur5rHh8ujYARoZtxQC1HQ4MWJOSrle2hF2BraRfHeh6Yd3JzCfe0D37UB4VWVL8JA==
X-Received: by 2002:a05:6214:3002:b0:470:7273:bee5 with SMTP id ke2-20020a056214300200b004707273bee5mr5619185qvb.98.1657764465461;
        Wed, 13 Jul 2022 19:07:45 -0700 (PDT)
Received: from localhost.localdomain (107-199-63-251.lightspeed.sntcca.sbcglobal.net. [107.199.63.251])
        by smtp.gmail.com with ESMTPSA id d22-20020a05620a159600b006b5517da3casm308537qkk.22.2022.07.13.19.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 19:07:44 -0700 (PDT)
From:   sean.wang@kernel.org
To:     stable@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 5.15 1/5] Revert "mt76: mt7921: Fix the error handling path of mt7921_pci_probe()"
Date:   Wed, 13 Jul 2022 19:07:37 -0700
Message-Id: <4bdcd29552ba78c87d8799181b9acddec465ad3c.1657764335.git.sean.wang@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

This reverts commit 663457f421d41e9d2fcb1e84baf43d1433f80c08.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
There was mistaken in
649178c0493e ("mt76: mt7921e: fix possible probe failure after reboot")
that caused WiFi reset cannot work well as the reported issue
"PROBLEM: [Stable v5.15.42+] [mt7921] Wake after suspend locks up system
when mt7921-driver is used on a Lenovo ThinkPad E15 G3"
in http://lists.infradead.org/pipermail/linux-mediatek/2022-June/042668.html
So we need to revert the patch first. Will be applied again later.
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index 3d35838ef306..7d9b23a00238 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -254,10 +254,8 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 	dev->bus_ops = dev->mt76.bus;
 	bus_ops = devm_kmemdup(dev->mt76.dev, dev->bus_ops, sizeof(*bus_ops),
 			       GFP_KERNEL);
-	if (!bus_ops) {
-		ret = -ENOMEM;
-		goto err_free_dev;
-	}
+	if (!bus_ops)
+		return -ENOMEM;
 
 	bus_ops->rr = mt7921_rr;
 	bus_ops->wr = mt7921_wr;
@@ -266,7 +264,7 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 
 	ret = __mt7921_mcu_drv_pmctrl(dev);
 	if (ret)
-		goto err_free_dev;
+		return ret;
 
 	mdev->rev = (mt7921_l1_rr(dev, MT_HW_CHIPID) << 16) |
 		    (mt7921_l1_rr(dev, MT_HW_REV) & 0xff);
-- 
2.25.1


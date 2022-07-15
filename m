Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA2F5767E0
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 21:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiGOT7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 15:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiGOT7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 15:59:34 -0400
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D503866AD1;
        Fri, 15 Jul 2022 12:59:33 -0700 (PDT)
Received: by mail-pf1-f181.google.com with SMTP id b9so5489813pfp.10;
        Fri, 15 Jul 2022 12:59:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xahxNMPqfOKHyPoqRDBKi49wM50fDPhjt2s1BRD1Q24=;
        b=TFwiu8fORGVkfOV/T/4Fp29lSpj3ro7yx+7p2Gfa8aAB3i35kbaMS7NmCcGGMBdgUv
         bD10MJLc5mCXZCkNJXcVpoehqE1ny8QjX9l9C7UpghvMp51S1ym4eF/iB9qJ+/MHAySR
         GulB98qWeU7VxxpmNkQLvV3g96Mics1g0iibf/HEiqboA9d/tDNdJftw9VKxqzk5d4hu
         eXjx0Njy4Y3Kx93wMpWZKjEec6hCNQbIuKkcpWa7uLNF5cerioem07fv2fc/Ge/Eytg2
         NBVvPKHaJ6a1lrHDnzWDp8Gmh0cL2cpb8dmJj10t1prnNw89eEgf9Lc3T0lajygMbvqd
         BAMw==
X-Gm-Message-State: AJIora+gQcZqT53tDvZVgS+o99K75CIWhjlIH8aWpR4AM+BA+p5/eF5X
        3rhoqcKtqRGLvr7p0sRFco59FCSIXUk=
X-Google-Smtp-Source: AGRyM1uGmmDzLtiPfFgGlWXXd027UjjkTsg5pmXVIrXri+qBKN4v/5G55jMLM8lkTV8QayyFU9hqtw==
X-Received: by 2002:a65:6398:0:b0:415:7d00:c1de with SMTP id h24-20020a656398000000b004157d00c1demr13818142pgv.610.1657915173046;
        Fri, 15 Jul 2022 12:59:33 -0700 (PDT)
Received: from sean-ThinkPad-T450s.lan (c-73-71-21-1.hsd1.ca.comcast.net. [73.71.21.1])
        by smtp.gmail.com with ESMTPSA id y1-20020a62ce01000000b00528bc6d8939sm4224629pfg.157.2022.07.15.12.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 12:59:32 -0700 (PDT)
From:   sean.wang@kernel.org
To:     stable@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH v2 5.15 1/5] Revert "mt76: mt7921: Fix the error handling path of mt7921_pci_probe()"
Date:   Fri, 15 Jul 2022 12:59:22 -0700
Message-Id: <27b8ccd411f2c51e2b8193a4eb1fa7e6f416a2f0.1657915079.git.sean.wang@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

This reverts commit 663457f421d41e9d2fcb1e84baf43d1433f80c08 that is the
commit 44c4237cf3436bda2b185ff728123651ad133f69 upstream.

Because there was mistake in
'649178c0493e ("mt76: mt7921e: fix possible probe failure after reboot")'
that caused WiFi reset cannot work well as the reported issue
"PROBLEM: [Stable v5.15.42+] [mt7921] Wake after suspend locks up system
when mt7921-driver is used on a Lenovo ThinkPad E15 G3" described in
http://lists.infradead.org/pipermail/linux-mediatek/2022-June/042668.html
So we need to revert the patch first to avoid the conflict of reverting
'649178c0493e ("mt76: mt7921e: fix possible probe failure after reboot")'
and will be applied back later after fixing.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
v2: update changelog text
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


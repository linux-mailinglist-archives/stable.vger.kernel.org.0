Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9531757414E
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 04:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiGNCIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 22:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbiGNCHz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 22:07:55 -0400
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF84523BC2;
        Wed, 13 Jul 2022 19:07:53 -0700 (PDT)
Received: by mail-qk1-f177.google.com with SMTP id i2so305503qkm.8;
        Wed, 13 Jul 2022 19:07:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OuT/TzXEHGqXcCBqJIp1ffomEppPRJ8FgzCqXA5p/Mc=;
        b=6/4d0zA/k4usNAj/g9QCMVM/hwF6lpJoDi2U8UhoxUaaEQ+yHbypU1+lnDR3PCYIPy
         TmFK97OAOI1cjYeewoBOpdNNQarGxXs1bsipJYsL7SaQ7miNKEhdx00ptk4inqIjbOs8
         XpC9xVB/Yklf4L+dmPdNJwKa6KiS6W5OddrcAxMVv6UPcKJmFE0o/hOsjC6D1x/RYoHI
         DxxiFYPjHCfiEnUFFQoiWyRPYIaOGVqfoYSETRyZJCwRWNxb3HX15VsBSWc/FvQHfiAT
         mmlNjWwpUd/doCdBLOjwhdPyXFM74ecR+xZxjpXNpFQVeqD4UuWmP1EbEaspXrMYSlQI
         mTvA==
X-Gm-Message-State: AJIora+cPrO/g/SjAj/FuH9AhJeuq5hcc2OhCRe1XtL9dtJ0e7QaF3Qf
        5LCUtg0EyD6QAM08fZhu4cfEMPsAOgg=
X-Google-Smtp-Source: AGRyM1v40EVFxOH/18KPkHrl6v+EDr4c44EB4egdYc5BOeT5KKWmFHlwX713NTFf5nJ/HjMuaVf1fw==
X-Received: by 2002:a05:620a:269a:b0:6b5:b76c:11c9 with SMTP id c26-20020a05620a269a00b006b5b76c11c9mr4398861qkp.100.1657764472620;
        Wed, 13 Jul 2022 19:07:52 -0700 (PDT)
Received: from localhost.localdomain (107-199-63-251.lightspeed.sntcca.sbcglobal.net. [107.199.63.251])
        by smtp.gmail.com with ESMTPSA id d22-20020a05620a159600b006b5517da3casm308537qkk.22.2022.07.13.19.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 19:07:51 -0700 (PDT)
From:   sean.wang@kernel.org
To:     stable@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 5.15 5/5] mt76: mt7921: Fix the error handling path of mt7921_pci_probe()
Date:   Wed, 13 Jul 2022 19:07:41 -0700
Message-Id: <2632b391af6d3e268567c6931e49f3f4490ce502.1657764335.git.sean.wang@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <4bdcd29552ba78c87d8799181b9acddec465ad3c.1657764335.git.sean.wang@kernel.org>
References: <4bdcd29552ba78c87d8799181b9acddec465ad3c.1657764335.git.sean.wang@kernel.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 4e90db5e21eb3bb272fe47386dc3506755e209e9 upstream.

In case of error, some resources must be freed, as already done above and
below the devm_kmemdup() and __mt7921e_mcu_drv_pmctrl() calls added in the
commit in Fixes:.

Fixes: 602cc0c9618a ("mt76: mt7921e: fix possible probe failure after reboot")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index 815b926e52e9..36e6495ae658 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -254,8 +254,10 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 	dev->bus_ops = dev->mt76.bus;
 	bus_ops = devm_kmemdup(dev->mt76.dev, dev->bus_ops, sizeof(*bus_ops),
 			       GFP_KERNEL);
-	if (!bus_ops)
-		return -ENOMEM;
+	if (!bus_ops) {
+		ret = -ENOMEM;
+		goto err_free_dev;
+	}
 
 	bus_ops->rr = mt7921_rr;
 	bus_ops->wr = mt7921_wr;
@@ -264,7 +266,7 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 
 	ret = __mt7921e_mcu_drv_pmctrl(dev);
 	if (ret)
-		return ret;
+		goto err_free_dev;
 
 	mdev->rev = (mt7921_l1_rr(dev, MT_HW_CHIPID) << 16) |
 		    (mt7921_l1_rr(dev, MT_HW_REV) & 0xff);
-- 
2.25.1


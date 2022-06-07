Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71596541415
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358922AbiFGUMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359134AbiFGUJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:09:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E48F1C4F12;
        Tue,  7 Jun 2022 11:26:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F33D7B82340;
        Tue,  7 Jun 2022 18:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FF3C385A2;
        Tue,  7 Jun 2022 18:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626412;
        bh=JmSnWJRLpiOuRHOA+w8FNwqa7CahLCoSKiHjvYzbH7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s4K7bzs3PIt/U4sT2WX/EAkqwinxaS2iOtlnsfX/oiI1QvpBa/2BpIj23/0v+SRtT
         uHmeCPLc6EjE9dngcmj8csbFFrqffVU0xa/LrZk3xMcVPPf1XmrER5lN7Cr2FrWZh9
         sL7rgUw6dQg+BHcMFvkGdaZv/V4QSmgBIFL2olj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 368/772] mt76: mt7921: Fix the error handling path of mt7921_pci_probe()
Date:   Tue,  7 Jun 2022 18:59:20 +0200
Message-Id: <20220607164959.859976933@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 4e90db5e21eb3bb272fe47386dc3506755e209e9 ]

In case of error, some resources must be freed, as already done above and
below the devm_kmemdup() and __mt7921e_mcu_drv_pmctrl() calls added in the
commit in Fixes:.

Fixes: 602cc0c9618a ("mt76: mt7921e: fix possible probe failure after reboot")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index 9a71a5d86481..18c8f5cbd96c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -300,8 +300,10 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
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
@@ -310,7 +312,7 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 
 	ret = __mt7921e_mcu_drv_pmctrl(dev);
 	if (ret)
-		return ret;
+		goto err_free_dev;
 
 	mdev->rev = (mt7921_l1_rr(dev, MT_HW_CHIPID) << 16) |
 		    (mt7921_l1_rr(dev, MT_HW_REV) & 0xff);
-- 
2.35.1




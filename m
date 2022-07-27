Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A580582DBC
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241197AbiG0RCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241206AbiG0RBo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:01:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9395C6BC05;
        Wed, 27 Jul 2022 09:38:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEDCBB821B6;
        Wed, 27 Jul 2022 16:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506BFC433C1;
        Wed, 27 Jul 2022 16:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939847;
        bh=WujFwljSuwH2VXyG++3F5nOsrXX2VIrrQKO+07kLxmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ts46/PJ4ltL9VNnoQOreO0gmrtyv5NoT+HNZBH+CkHGNl5JsJgRkAeGWp/AfYf2sV
         +VrLQkrXjm8VilWKDujcSHKgg4zhDDbZmQqBT7hBMxo9oBWoNv/GTECiHkYGn5yXqF
         q3e0y4YAuu4XGBaqXNdbXBQ4muxzqHtML2Ja2Rr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 5.15 020/201] mt76: mt7921: Fix the error handling path of mt7921_pci_probe()
Date:   Wed, 27 Jul 2022 18:08:44 +0200
Message-Id: <20220727161027.748066262@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -254,8 +254,10 @@ static int mt7921_pci_probe(struct pci_d
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
@@ -264,7 +266,7 @@ static int mt7921_pci_probe(struct pci_d
 
 	ret = __mt7921e_mcu_drv_pmctrl(dev);
 	if (ret)
-		return ret;
+		goto err_free_dev;
 
 	mdev->rev = (mt7921_l1_rr(dev, MT_HW_CHIPID) << 16) |
 		    (mt7921_l1_rr(dev, MT_HW_REV) & 0xff);



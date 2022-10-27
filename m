Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41AD960FDED
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236768AbiJ0RAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236804AbiJ0RA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:00:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944DC993B1
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:00:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31F2D623EB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497CAC433C1;
        Thu, 27 Oct 2022 17:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890027;
        bh=g1/4mfnf7RxP3FOKWxmFgvoIwuFHMFUp1DbZtGox2QI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qip5fp/Lfkf8eKJiI8rmkQGXtAZsADS2gSrFqxUzXDdg5QrUKIVmi49SxN63NRVyv
         Ns9fhdpIbLfjOEaEN12fZ1M+Ij5WC8rOMYrf31WPU5u3hZHP0I3wvQJxY7uqZNEgQX
         rv0m3hwVIvi4MwUbXTZzKV1XSJDUy7D5D2xfLC0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Deren Wu <deren.wu@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 88/94] wifi: mt76: mt7921e: fix random fw download fail
Date:   Thu, 27 Oct 2022 18:55:30 +0200
Message-Id: <20221027165100.748202294@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit 29e247ece5d3edfa71495768a9ab5fc7bba76bd4 ]

In case of PCIe interoperability problem shows up, the firmware
payload may be corrupted in download stage. Turn off L0s to keep
fw download process accurately.

[ 1093.528363] mt7921e 0000:3b:00.0: Message 00000007 (seq 7) timeout
[ 1093.528414] mt7921e 0000:3b:00.0: Failed to start patch
[ 1096.600156] mt7921e 0000:3b:00.0: Message 00000010 (seq 8) timeout
[ 1096.600207] mt7921e 0000:3b:00.0: Failed to release patch semaphore
[ 1097.699031] mt7921e 0000:3b:00.0: Timeout for driver own
[ 1098.758427] mt7921e 0000:3b:00.0: Timeout for driver own
[ 1099.834408] mt7921e 0000:3b:00.0: Timeout for driver own
[ 1100.915264] mt7921e 0000:3b:00.0: Timeout for driver own
[ 1101.990625] mt7921e 0000:3b:00.0: Timeout for driver own
[ 1103.077587] mt7921e 0000:3b:00.0: Timeout for driver own
[ 1104.173258] mt7921e 0000:3b:00.0: Timeout for driver own
[ 1105.248466] mt7921e 0000:3b:00.0: Timeout for driver own
[ 1106.336969] mt7921e 0000:3b:00.0: Timeout for driver own
[ 1106.397542] mt7921e 0000:3b:00.0: hardware init failed

Cc: stable@vger.kernel.org
Fixes: bf3747ae2e25 ("mt76: mt7921: enable aspm by default")
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c     |    1 +
 drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c |    2 ++
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h    |    2 ++
 3 files changed, 5 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -152,6 +152,7 @@ static u32 __mt7921_reg_addr(struct mt79
 		{ 0x820c8000, 0x0c000, 0x2000 }, /* WF_UMAC_TOP (PSE) */
 		{ 0x820cc000, 0x0e000, 0x1000 }, /* WF_UMAC_TOP (PP) */
 		{ 0x820cd000, 0x0f000, 0x1000 }, /* WF_MDP_TOP */
+		{ 0x74030000, 0x10000, 0x10000 }, /* PCIE_MAC_IREG */
 		{ 0x820ce000, 0x21c00, 0x0200 }, /* WF_LMAC_TOP (WF_SEC) */
 		{ 0x820cf000, 0x22000, 0x1000 }, /* WF_LMAC_TOP (WF_PF) */
 		{ 0x820e0000, 0x20000, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_CFG) */
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c
@@ -59,6 +59,8 @@ int mt7921e_mcu_init(struct mt7921_dev *
 	if (err)
 		return err;
 
+	mt76_rmw_field(dev, MT_PCIE_MAC_PM, MT_PCIE_MAC_PM_L0S_DIS, 1);
+
 	err = mt7921_run_firmware(dev);
 
 	mt76_queue_tx_cleanup(dev, dev->mt76.q_mcu[MT_MCUQ_FWDL], false);
--- a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
@@ -440,6 +440,8 @@
 #define MT_PCIE_MAC_BASE		0x10000
 #define MT_PCIE_MAC(ofs)		(MT_PCIE_MAC_BASE + (ofs))
 #define MT_PCIE_MAC_INT_ENABLE		MT_PCIE_MAC(0x188)
+#define MT_PCIE_MAC_PM			MT_PCIE_MAC(0x194)
+#define MT_PCIE_MAC_PM_L0S_DIS		BIT(8)
 
 #define MT_DMA_SHDL(ofs)		(0x7c026000 + (ofs))
 #define MT_DMASHDL_SW_CONTROL		MT_DMA_SHDL(0x004)



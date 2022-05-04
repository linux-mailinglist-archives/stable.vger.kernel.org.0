Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F7051AA3D
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234512AbiEDRW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357058AbiEDROq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:14:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B207753E33
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20246B827A9
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A269C385A4;
        Wed,  4 May 2022 16:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683498;
        bh=jvetpaMO9Ho4Ae+NYXB0JK9vsbZBB/QjRNqwFM3B7d4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNvK9+o82lkic8+gdaeSNJh5hgBwSzxJnFHbtAUq9bi3g+Bio98nrUBwflIu4oq3d
         +VoO33fyHOWcphdDtsvx8DYLK1f3s9B2HHjI7/OAvceF1OV3d2WMj+thFdL/qTS+uW
         3q97M5K9rnq7I5lRfHwYTuJiFyTV1Ck8izyynCISzRvmjS3KD/19Ds/BrQlhUXpPnC
         p+R0gKqPreIoS+KAKwbNa3n23+NSN224kr9913KLnRDB9yIiq1euThvGrjneXfMBLl
         9+FkltKLN2P4Gtab/T3R09yePRkeCLy6T4H6SmSgScQazslErsb6d8Pj6QURPd/9Dv
         eFAi3kAGS8TVw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 12/30] PCI: aardvark: Replace custom PCIE_CORE_INT_* macros with PCI_INTERRUPT_*
Date:   Wed,  4 May 2022 18:57:37 +0200
Message-Id: <20220504165755.30002-13-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504165755.30002-1-kabel@kernel.org>
References: <20220504165755.30002-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 1d86abf1f89672a70f2ab65f6000299feb1f1781 upstream.

Header file linux/pci.h defines enum pci_interrupt_pin with corresponding
PCI_INTERRUPT_* values.

Link: https://lore.kernel.org/r/20220110015018.26359-2-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index ae0219ae730a..6076bb7b3ed3 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -38,10 +38,6 @@
 #define     PCIE_CORE_ERR_CAPCTL_ECRC_CHK_TX_EN			BIT(6)
 #define     PCIE_CORE_ERR_CAPCTL_ECRC_CHCK			BIT(7)
 #define     PCIE_CORE_ERR_CAPCTL_ECRC_CHCK_RCV			BIT(8)
-#define     PCIE_CORE_INT_A_ASSERT_ENABLE			1
-#define     PCIE_CORE_INT_B_ASSERT_ENABLE			2
-#define     PCIE_CORE_INT_C_ASSERT_ENABLE			3
-#define     PCIE_CORE_INT_D_ASSERT_ENABLE			4
 /* PIO registers base address and register offsets */
 #define PIO_BASE_ADDR				0x4000
 #define PIO_CTRL				(PIO_BASE_ADDR + 0x0)
@@ -961,7 +957,7 @@ static int advk_sw_pci_bridge_init(struct advk_pcie *pcie)
 	bridge->conf.pref_mem_limit = cpu_to_le16(PCI_PREF_RANGE_TYPE_64);
 
 	/* Support interrupt A for MSI feature */
-	bridge->conf.intpin = PCIE_CORE_INT_A_ASSERT_ENABLE;
+	bridge->conf.intpin = PCI_INTERRUPT_INTA;
 
 	/* Aardvark HW provides PCIe Capability structure in version 2 */
 	bridge->pcie_conf.cap = cpu_to_le16(2);
-- 
2.35.1


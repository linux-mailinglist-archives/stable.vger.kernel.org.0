Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571FD5219C4
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244699AbiEJNvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245031AbiEJNrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0816162208;
        Tue, 10 May 2022 06:33:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9436B615C8;
        Tue, 10 May 2022 13:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4ACC385A6;
        Tue, 10 May 2022 13:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189629;
        bh=GaadsnEVgOBwmSGgZMElmngR/kp17Tr9tsbHmaKPN6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QXXobOMDEMzlA72i9xJp+JvuCdbvgrh3GPH5vKA2NdScQJCGPL1FcUZqmxy+rRx+6
         sDAzZB346zs+tbkX7gUUuvAMy4QFYXgAKQ6y8OExBEgz5lT2IUmJRz1U1LI+uC3hHa
         vd+BDGr18/+aKDUs81TDXnmj8vjyAUMEE0yyRpFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=FAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.15 111/135] PCI: aardvark: Disable bus mastering when unbinding driver
Date:   Tue, 10 May 2022 15:08:13 +0200
Message-Id: <20220510130743.589769176@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit a46f2f6dd4093438d9615dfbf5c0fea2a9835dba upstream.

Ensure that after driver unbind PCIe cards are not able to forward
memory and I/O requests in the upstream direction.

Link: https://lore.kernel.org/r/20211130172913.9727-7-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1679,6 +1679,7 @@ static int advk_pcie_remove(struct platf
 {
 	struct advk_pcie *pcie = platform_get_drvdata(pdev);
 	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(pcie);
+	u32 val;
 	int i;
 
 	/* Remove PCI bus with all devices */
@@ -1687,6 +1688,11 @@ static int advk_pcie_remove(struct platf
 	pci_remove_root_bus(bridge->bus);
 	pci_unlock_rescan_remove();
 
+	/* Disable Root Bridge I/O space, memory space and bus mastering */
+	val = advk_readl(pcie, PCIE_CORE_CMD_STATUS_REG);
+	val &= ~(PCI_COMMAND_IO | PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER);
+	advk_writel(pcie, val, PCIE_CORE_CMD_STATUS_REG);
+
 	/* Remove IRQ domains */
 	advk_pcie_remove_msi_irq_domain(pcie);
 	advk_pcie_remove_irq_domain(pcie);



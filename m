Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B81462306
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 22:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhK2VPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 16:15:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbhK2VNs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 16:13:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56549C0E49B9;
        Mon, 29 Nov 2021 10:24:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2BD3B815BE;
        Mon, 29 Nov 2021 18:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDF2C53FAD;
        Mon, 29 Nov 2021 18:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210294;
        bh=PFbvj6Z3GHoMPkE14dmcjJUwr95SjqTEocZtFlnUrfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kw13aXqjWWCHOzc6MWKH6MrEVGKUqBhOxw8k8Em1dvo+yVrIq7V/LQguilX5DladS
         8nW9foGYncFlG/Ccroghs54FubIHGk88Yv3sh3QwJGcnpZi8cwlkze2GK68VaD3R7w
         ACJU6LPYw/eYzh+Jo0PKGUtpHPAX9srudMIYOMdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.4 36/92] PCI: aardvark: Fix PCIe Max Payload Size setting
Date:   Mon, 29 Nov 2021 19:18:05 +0100
Message-Id: <20211129181708.625794370@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit a4e17d65dafdd3513042d8f00404c9b6068a825c upstream.

Change PCIe Max Payload Size setting in PCIe Device Control register to 512
bytes to align with PCIe Link Initialization sequence as defined in Marvell
Armada 3700 Functional Specification. According to the specification,
maximal Max Payload Size supported by this device is 512 bytes.

Without this kernel prints suspicious line:

    pci 0000:01:00.0: Upstream bridge's Max Payload Size set to 256 (was 16384, max 512)

With this change it changes to:

    pci 0000:01:00.0: Upstream bridge's Max Payload Size set to 256 (was 512, max 512)

Link: https://lore.kernel.org/r/20211005180952.6812-3-kabel@kernel.org
Fixes: 8c39d710363c ("PCI: aardvark: Add Aardvark PCI host controller driver")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -565,8 +565,9 @@ static void advk_pcie_setup_hw(struct ad
 	reg = advk_readl(pcie, PCIE_CORE_PCIEXP_CAP + PCI_EXP_DEVCTL);
 	reg &= ~PCI_EXP_DEVCTL_RELAX_EN;
 	reg &= ~PCI_EXP_DEVCTL_NOSNOOP_EN;
+	reg &= ~PCI_EXP_DEVCTL_PAYLOAD;
 	reg &= ~PCI_EXP_DEVCTL_READRQ;
-	reg |= PCI_EXP_DEVCTL_PAYLOAD; /* Set max payload size */
+	reg |= PCI_EXP_DEVCTL_PAYLOAD_512B;
 	reg |= PCI_EXP_DEVCTL_READRQ_512B;
 	advk_writel(pcie, reg, PCIE_CORE_PCIEXP_CAP + PCI_EXP_DEVCTL);
 



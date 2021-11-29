Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8844625B5
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbhK2Wm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbhK2Wly (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:41:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03396C12A4C9;
        Mon, 29 Nov 2021 10:29:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 78157CE140D;
        Mon, 29 Nov 2021 18:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C23C53FC7;
        Mon, 29 Nov 2021 18:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210557;
        bh=CQOj+vOMTYkLjqAdBIyqI4itgv0PKptmXSlNeMkD3/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NYlU/vNPzJB2VTvHJzIud0953YFzByq3IkLf6xX9/dWb4gGaAFgP+4T5IdYh6yKhW
         bTx/KnQPmAITO2ZJs5eTyhxBiOP02FTnvdV6KuqJrTtfeVnL2Rf8EmeIUizGaoaLDG
         lkEyvKYsbV6iEuu/Wqjqz2Yn0pqGV6tCCNZDLezk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.10 036/121] PCI: aardvark: Update comment about disabling link training
Date:   Mon, 29 Nov 2021 19:17:47 +0100
Message-Id: <20211129181712.858405742@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 1d1cd163d0de22a4041a6f1aeabcf78f80076539 upstream.

According to PCI Express Base Specifications (rev 4.0, 6.6.1
"Conventional reset"), after fundamental reset a 100ms delay is needed
prior to enabling link training.

Update comment in code to reflect this requirement.

Link: https://lore.kernel.org/r/20201202184659.3795-1-pali@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -389,7 +389,14 @@ static void advk_pcie_issue_perst(struct
 	if (!pcie->reset_gpio)
 		return;
 
-	/* PERST does not work for some cards when link training is enabled */
+	/*
+	 * As required by PCI Express spec (PCI Express Base Specification, REV.
+	 * 4.0 PCI Express, February 19 2014, 6.6.1 Conventional Reset) a delay
+	 * for at least 100ms after de-asserting PERST# signal is needed before
+	 * link training is enabled. So ensure that link training is disabled
+	 * prior de-asserting PERST# signal to fulfill that PCI Express spec
+	 * requirement.
+	 */
 	reg = advk_readl(pcie, PCIE_CORE_CTRL0_REG);
 	reg &= ~LINK_TRAINING_EN;
 	advk_writel(pcie, reg, PCIE_CORE_CTRL0_REG);



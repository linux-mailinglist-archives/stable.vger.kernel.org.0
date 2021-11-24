Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2D945D06E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352193AbhKXWxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 17:53:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:47290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352221AbhKXWxT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 17:53:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A275F610A5;
        Wed, 24 Nov 2021 22:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637794208;
        bh=wy1zps5hF1c24DdsmUQj9vuQDJ/Tz0BODYkKPOpHmWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBGYV7nqo0lMe9h7rj0ZK38T6vgeU9s0P6yFEgHtPnYkUXygijmq6/WJTB/wPe2ID
         Hf78ntL6KOCuxj7x1wUony7ZE5ThwalcbwhUqz6eJxohH3vpvEC2n0D6Pu+KXFzAch
         xSQ+kWxaT4t452bXxlYNQTZWFn4jEp02Ej5BStQ5I/7i9Z37kBy5/LdhCGh16HtReh
         f9s/5vraL2vUwIGj068o/0VVHLxk2We9o7NfbOWyfQWwk9bdyJdEZ4kb5CfPMtKTM1
         hAROsZP3k0v/1meMWl/iSMSzhYMlM1lbcm8h/Ppav2XRTr0SZlRl5CHAXlDs9yp+lQ
         f8V637o5kNWtg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 13/24] PCI: aardvark: Update comment about disabling link training
Date:   Wed, 24 Nov 2021 23:49:22 +0100
Message-Id: <20211124224933.24275-14-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124224933.24275-1-kabel@kernel.org>
References: <20211124224933.24275-1-kabel@kernel.org>
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
---
 drivers/pci/host/pci-aardvark.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index 68ab3aef0e12..66c4b9282420 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -275,7 +275,14 @@ static void advk_pcie_issue_perst(struct advk_pcie *pcie)
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
-- 
2.32.0


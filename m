Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B9445D062
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352163AbhKXWxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 17:53:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:46972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345261AbhKXWxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 17:53:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FE8E6108B;
        Wed, 24 Nov 2021 22:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637794191;
        bh=m70WGdiifdQyBKJtB86Plw6bpK4MxbhciwkxGlCLR3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CXBwEQHuta9xets91tkC/gMzlASjnIu+cWghxG+ez180UsLSzT8mVU9f3srdCRYu/
         rKLDK60dRcqe4TyaMhe0fS5WhdFWN5ESOR7vWit2g+lmDhZXPxH47jH04F5lLFYTO5
         MganaO8RL8FxCE7SlZPpL+zGKIrhWfj6LOESkmuFQgc84Xec1Uhc6YpVkR9BZ8YIV0
         l7rwn6cGQs3P1SlRcBJqTl+W4Z3WcDm06aShA/kwAWx9JJ55sFPyMaqiVOaj1Nlogl
         PP+6lUMkCtvPttm3T5iFNi5DvrkDF7NjXOgSG4q46Ka4ZW41hiMEHrZEt4qJGLdm7L
         YZ/iy1dejUo8g==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Remi Pommarel <repk@triplefau.lt>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 03/24] PCI: aardvark: Wait for endpoint to be ready before training link
Date:   Wed, 24 Nov 2021 23:49:12 +0100
Message-Id: <20211124224933.24275-4-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124224933.24275-1-kabel@kernel.org>
References: <20211124224933.24275-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Remi Pommarel <repk@triplefau.lt>

commit f4c7d053d7f77cd5c1a1ba7c7ce085ddba13d1d7 upstream.

When configuring pcie reset pin from gpio (e.g. initially set by
u-boot) to pcie function this pin goes low for a brief moment
asserting the PERST# signal. Thus connected device enters fundamental
reset process and link configuration can only begin after a minimal
100ms delay (see [1]).

Because the pin configuration comes from the "default" pinctrl it is
implicitly configured before the probe callback is called:

driver_probe_device()
  really_probe()
    ...
    pinctrl_bind_pins() /* Here pin goes from gpio to PCIE reset
                           function and PERST# is asserted */
    ...
    drv->probe()

[1] "PCI Express Base Specification", REV. 4.0
    PCI Express, February 19 2014, 6.6.1 Conventional Reset

Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/host/pci-aardvark.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index 79cd11b1c89a..7ee5a91e5f7f 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -362,6 +362,14 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 	reg |= PIO_CTRL_ADDR_WIN_DISABLE;
 	advk_writel(pcie, reg, PIO_CTRL);
 
+	/*
+	 * PERST# signal could have been asserted by pinctrl subsystem before
+	 * probe() callback has been called, making the endpoint going into
+	 * fundamental reset. As required by PCI Express spec a delay for at
+	 * least 100ms after such a reset before link training is needed.
+	 */
+	msleep(PCI_PM_D3COLD_WAIT);
+
 	/* Start link training */
 	reg = advk_readl(pcie, PCIE_CORE_LINK_CTRL_STAT_REG);
 	reg |= PCIE_CORE_LINK_TRAINING;
-- 
2.32.0


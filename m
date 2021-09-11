Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 518754077D2
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236857AbhIKNUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:20:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236023AbhIKNSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:18:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BD1A6127A;
        Sat, 11 Sep 2021 13:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366035;
        bh=k4xCItJ5pECEhJfjhCMhf/rl6WSZmrlBpn+rSedCRu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D4LQ1gXFuKUX9KXxAKsFW4dZsFVMo+tVI1US1rBFHmyeWwoQ+9gCVisyBwI22G1PA
         pY56I7N+P7dGf2/dhfS27VsBaw/RLfC2spwXYRm/swM3Gdmdvww6BQQRgD+mk7I8Hy
         hZ9xJi7GAVJSpSIw4ZwPvFF3n0MmNf1rMKbAFrXd6yh0XM4iKxaYLEiulz9dcY2yvY
         UYEI3oOVIsLhMh5lty7QeJGAOFecek3R90eQHlciZoXL1mjVwe1BDUnNTAifVFl7Bu
         ZIyjC6F2CnGlKQGZDGN55TUoPF436V876DC9DN/5oL+LAs5zNY4Y5azSGURGANpetZ
         DohZXNWJGxJWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     George Cherian <george.cherian@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/14] PCI: Add ACS quirks for Cavium multi-function devices
Date:   Sat, 11 Sep 2021 09:13:38 -0400
Message-Id: <20210911131345.285564-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131345.285564-1-sashal@kernel.org>
References: <20210911131345.285564-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Cherian <george.cherian@marvell.com>

[ Upstream commit 32837d8a8f63eb95dcb9cd005524a27f06478832 ]

Some Cavium endpoints are implemented as multi-function devices without ACS
capability, but they actually don't support peer-to-peer transactions.

Add ACS quirks to declare DMA isolation for the following devices:

  - BGX device found on Octeon-TX (8xxx)
  - CGX device found on Octeon-TX2 (9xxx)
  - RPM device found on Octeon-TX3 (10xxx)

Link: https://lore.kernel.org/r/20210810122425.1115156-1-george.cherian@marvell.com
Signed-off-by: George Cherian <george.cherian@marvell.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index dea5ec5f4272..e3f3f2b158d3 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4921,6 +4921,10 @@ static const struct pci_dev_acs_enabled {
 	{ 0x10df, 0x720, pci_quirk_mf_endpoint_acs }, /* Emulex Skyhawk-R */
 	/* Cavium ThunderX */
 	{ PCI_VENDOR_ID_CAVIUM, PCI_ANY_ID, pci_quirk_cavium_acs },
+	/* Cavium multi-function devices */
+	{ PCI_VENDOR_ID_CAVIUM, 0xA026, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_CAVIUM, 0xA059, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_CAVIUM, 0xA060, pci_quirk_mf_endpoint_acs },
 	/* APM X-Gene */
 	{ PCI_VENDOR_ID_AMCC, 0xE004, pci_quirk_xgene_acs },
 	/* Ampere Computing */
-- 
2.30.2


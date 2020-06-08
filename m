Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111651F265A
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731363AbgFHXhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:37:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732226AbgFHX2f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:28:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3F9D20897;
        Mon,  8 Jun 2020 23:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658914;
        bh=VISYukPm7ye8bXDmblrcmepv+XIDapPrb/mUM23OnE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t9zeLKy/TRWBB2h5Y191VX5dMPOUwSTfRZ91WbdeE6vCpcGc/+gH2iScFDebRepuF
         EaoM9ZFzQVqUl6mW6aXkSXVnKyQeoYGo3iP2vZQfV82EQFVzyLG57O0C0g+FovMJMZ
         m3MrE2wMmp62NZmR2xtX4wRjBFrl62rVLpKakJLU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 31/37] PCI: Don't disable decoding when mmio_always_on is set
Date:   Mon,  8 Jun 2020 19:27:43 -0400
Message-Id: <20200608232750.3370747-31-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232750.3370747-1-sashal@kernel.org>
References: <20200608232750.3370747-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit b6caa1d8c80cb71b6162cb1f1ec13aa655026c9f ]

Don't disable MEM/IO decoding when a device have both non_compliant_bars
and mmio_always_on.

That would allow us quirk devices with junk in BARs but can't disable
their decoding.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Acked-by: Bjorn Helgaas <helgaas@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 5f040619393f..46656322d23e 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1226,7 +1226,7 @@ int pci_setup_device(struct pci_dev *dev)
 	/* device class may be changed after fixup */
 	class = dev->class >> 8;
 
-	if (dev->non_compliant_bars) {
+	if (dev->non_compliant_bars && !dev->mmio_always_on) {
 		pci_read_config_word(dev, PCI_COMMAND, &cmd);
 		if (cmd & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY)) {
 			dev_info(&dev->dev, "device has non-compliant BARs; disabling IO/MEM decoding\n");
-- 
2.25.1


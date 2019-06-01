Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9C8F31D89
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbfFAN3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:29:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729862AbfFAN0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:26:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC104273BD;
        Sat,  1 Jun 2019 13:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395608;
        bh=uAAi8CTOOnASvru0RtQIRJjMPSSGzCt7X5cKVXUegXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0X6bZYzNlH2LNW9OADR0SfFv+ow24fTjluDq0pLl1uezuEeBwDiANuq5WtuJybirJ
         7FZ0hKLsLWDFZ4foNPijiNcvNjNky5FfLvI8JnZ1Ek1tJMTkO51u5gCsLyDEuNwSq5
         og94ilhTrK0CtUn8fZTq9kZrTgqgxWzZIWbLDHBs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Prestwood <james.prestwood@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 27/56] PCI: Mark Atheros AR9462 to avoid bus reset
Date:   Sat,  1 Jun 2019 09:25:31 -0400
Message-Id: <20190601132600.27427-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132600.27427-1-sashal@kernel.org>
References: <20190601132600.27427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Prestwood <james.prestwood@linux.intel.com>

[ Upstream commit 6afb7e26978da5e86e57e540fdce65c8b04f398a ]

When using PCI passthrough with this device, the host machine locks up
completely when starting the VM, requiring a hard reboot.  Add a quirk to
avoid bus resets on this device.

Fixes: c3e59ee4e766 ("PCI: Mark Atheros AR93xx to avoid bus reset")
Link: https://lore.kernel.org/linux-pci/20190107213248.3034-1-james.prestwood@linux.intel.com
Signed-off-by: James Prestwood <james.prestwood@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: stable@vger.kernel.org	# v3.14+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index d85010ebac5aa..36c6f3702167c 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3141,6 +3141,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0030, quirk_no_bus_reset);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0032, quirk_no_bus_reset);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003c, quirk_no_bus_reset);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0033, quirk_no_bus_reset);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0034, quirk_no_bus_reset);
 
 static void quirk_no_pm_reset(struct pci_dev *dev)
 {
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15AFDDD428
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfJRWWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730173AbfJRWFt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:05:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FC4E222C2;
        Fri, 18 Oct 2019 22:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436349;
        bh=0gUaHbmUNWSuBhVlbrDOsK+zcamryfNCf/wCRKeD/t8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AxgC6pSAKzvDghxnrySDCuCHNivuNPikBsS8SXr71GqI1LpNkgPJGXg1UJZQAVT6v
         Pz75PMbdEq5PkpItrAFO8VKxGvMdlZ09Ht6d3RiclWab5Hl6F2184KXbX54tI/d5tj
         s1ruE018QY5dEbad5hpcxWyq1EI8G1M27kuRbp3w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        Stephen Bates <sbates@raithlin.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Doug Meyer <dmeyer@gigaio.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 014/100] PCI: Fix Switchtec DMA aliasing quirk dmesg noise
Date:   Fri, 18 Oct 2019 18:03:59 -0400
Message-Id: <20191018220525.9042-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 742bbe1ee35b5699c092541f97c7cec326556bb1 ]

Currently the Switchtec quirk runs on all endpoints in the switch,
including all the upstream and downstream ports.  These other functions do
not contain BARs, so the quirk fails when trying to map the BAR and prints
the error "Cannot iomap Switchtec device".  The user will see a few of
these useless and scary errors, one for each port in the switch.

At most, the quirk should only run on either a management endpoint
(PCI_CLASS_MEMORY_OTHER) or an NTB endpoint (PCI_CLASS_BRIDGE_OTHER).
However, the quirk is useless except in NTB applications, so we will
only run it when the class is PCI_CLASS_BRIDGE_OTHER.

Switch to using DECLARE_PCI_FIXUP_CLASS_FINAL and only match
PCI_CLASS_BRIDGE_OTHER.

Reported-by: Stephen Bates <sbates@raithlin.com>
Fixes: ad281ecf1c7d ("PCI: Add DMA alias quirk for Microsemi Switchtec NTB")
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
[bhelgaas: split SWITCHTEC_QUIRK() introduction to separate patch]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Doug Meyer <dmeyer@gigaio.com>
Cc: Kurt Schwemmer <kurt.schwemmer@microsemi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 06be52912dcdb..64933994f7722 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5083,8 +5083,8 @@ static void quirk_switchtec_ntb_dma_alias(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 #define SWITCHTEC_QUIRK(vid) \
-	DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, vid, \
-				quirk_switchtec_ntb_dma_alias)
+	DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_MICROSEMI, vid, \
+		PCI_CLASS_BRIDGE_OTHER, 8, quirk_switchtec_ntb_dma_alias)
 
 SWITCHTEC_QUIRK(0x8531);  /* PFX 24xG3 */
 SWITCHTEC_QUIRK(0x8532);  /* PFX 32xG3 */
-- 
2.20.1


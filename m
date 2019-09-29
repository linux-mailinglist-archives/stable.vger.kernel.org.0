Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E13EEC1808
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbfI2Rdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:33:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730158AbfI2Rdo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:33:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF84E2196E;
        Sun, 29 Sep 2019 17:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778423;
        bh=aZliCapHq0JTn6jAEA0jo5fj/W6N/vFQStGVfGggpZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o0yRDewAoSMcalus0QJ7xEAUm25cNg08pBAza03Zl4KHEZLKPOMtjtAgNnQxS+KYG
         KDdOfR9JrUO9CSP0DirRACxmotdsSQttV8T9FlOXnGAdghcJ557jrisCYEY3ULK8o8
         vRXJeXMI8wRbMBX0vWZCyLygXuQyOtApvTYORzag=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Wilczynski <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 29/42] PCI: Use static const struct, not const static struct
Date:   Sun, 29 Sep 2019 13:32:28 -0400
Message-Id: <20190929173244.8918-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173244.8918-1-sashal@kernel.org>
References: <20190929173244.8918-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Wilczynski <kw@linux.com>

[ Upstream commit 8050f3f6645ae0f7e4c1304593f6f7eb2ee7d85c ]

Move the static keyword to the front of declarations of pci_regs_behavior[]
and pcie_cap_regs_behavior[], which resolves compiler warnings when
building with "W=1":

  drivers/pci/pci-bridge-emul.c:41:1: warning: ‘static’ is not at beginning of
  declaration [-Wold-style-declaration]
   const static struct pci_bridge_reg_behavior pci_regs_behavior[] = {
   ^
  drivers/pci/pci-bridge-emul.c:176:1: warning: ‘static’ is not at beginning of
  declaration [-Wold-style-declaration]
   const static struct pci_bridge_reg_behavior pcie_cap_regs_behavior[] = {
   ^

Link: https://lore.kernel.org/r/20190826151436.4672-1-kw@linux.com
Link: https://lore.kernel.org/r/20190828131733.5817-1-kw@linux.com
Signed-off-by: Krzysztof Wilczynski <kw@linux.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-bridge-emul.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci-bridge-emul.c b/drivers/pci/pci-bridge-emul.c
index 83fb077d0b41f..702966e4fcaa4 100644
--- a/drivers/pci/pci-bridge-emul.c
+++ b/drivers/pci/pci-bridge-emul.c
@@ -38,7 +38,7 @@ struct pci_bridge_reg_behavior {
 	u32 rsvd;
 };
 
-const static struct pci_bridge_reg_behavior pci_regs_behavior[] = {
+static const struct pci_bridge_reg_behavior pci_regs_behavior[] = {
 	[PCI_VENDOR_ID / 4] = { .ro = ~0 },
 	[PCI_COMMAND / 4] = {
 		.rw = (PCI_COMMAND_IO | PCI_COMMAND_MEMORY |
@@ -173,7 +173,7 @@ const static struct pci_bridge_reg_behavior pci_regs_behavior[] = {
 	},
 };
 
-const static struct pci_bridge_reg_behavior pcie_cap_regs_behavior[] = {
+static const struct pci_bridge_reg_behavior pcie_cap_regs_behavior[] = {
 	[PCI_CAP_LIST_ID / 4] = {
 		/*
 		 * Capability ID, Next Capability Pointer and
-- 
2.20.1


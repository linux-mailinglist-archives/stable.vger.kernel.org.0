Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8E32CD6F8
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbfJFRhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:37:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730496AbfJFRhv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:37:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E0B72053B;
        Sun,  6 Oct 2019 17:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383470;
        bh=aZliCapHq0JTn6jAEA0jo5fj/W6N/vFQStGVfGggpZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fj27/mijGtf3SPkzhnC7wKDIkZK1D240Mm3TFi+Di97s7Dqo0hMI+X6zkq2A/HrhH
         UHjeJJuo+Qf7onP2bAOYCoOoI6BwzR+TX8ExCmzeAi77Z3vqkv35dJLGS1WfKBbLLq
         nU5arr9kksfKZytrWbfR6dVEtHFKiuUftniJncfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Wilczynski <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 115/137] PCI: Use static const struct, not const static struct
Date:   Sun,  6 Oct 2019 19:21:39 +0200
Message-Id: <20191006171218.741239098@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




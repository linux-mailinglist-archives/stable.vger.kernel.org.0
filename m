Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C663F5637
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 04:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhHXC76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 22:59:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234538AbhHXC7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 22:59:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FAAC61184;
        Tue, 24 Aug 2021 02:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629773927;
        bh=UyRARlJweOkjHxvoPTWAcnu50Xk5rdFv0q+RuWUBlWM=;
        h=From:To:Cc:Subject:Date:From;
        b=hWWGpVynmx5vk5BzTVoT63pbrxXOXp+mbniY7aSnGf/NUk0zDIEFsH3AKqyyEcbqv
         PznIVwcGQviBqF2bZA/GZE1KPRH+5yZCw9y8MZ57zy3Z4UQuF0cyn1qF+un9BxTHtp
         L9bxQK7n09iiiQFR2XdMSG0RzojhWkE5HG0GBOWPwitSvcDwI1P2WiZrDK59s8ym9i
         QbcYF7EBmQG6iWXlFhy1rLJJ4SzjfFYog3x93aPXKyUnn5Jehf3BAfntH7qWNzNjEi
         GBvjQu26IrgGbyW+Iy15EV2lTK0D3RgMdENkoo7M1IvTN/8kN1rpQhQEl7x8B2XsPz
         CFVrNlOW1agnw==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, hegel666@gmail.com
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Prike Liang <prike.liang@amd.com>,
        Shyam Sundar S K <shyam-sundar.s-k@amd.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: FAILED: Patch "PCI: Increase D3 delay for AMD Renoir/Cezanne XHCI" failed to apply to 4.9-stable tree
Date:   Mon, 23 Aug 2021 22:58:45 -0400
Message-Id: <20210824025845.659872-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From e0bff43220925b7e527f9d3bc9f5c624177c959e Mon Sep 17 00:00:00 2001
From: Marcin Bachry <hegel666@gmail.com>
Date: Wed, 21 Jul 2021 22:58:58 -0400
Subject: [PATCH] PCI: Increase D3 delay for AMD Renoir/Cezanne XHCI

The Renoir XHCI controller apparently doesn't resume reliably with the
standard D3hot-to-D0 delay.  Increase it to 20ms.

[Alex: I talked to the AMD USB hardware team and the AMD Windows team and
they are not aware of any HW errata or specific issues.  The HW works fine
in Windows.  I was told Windows uses a rather generous default delay of
100ms for PCI state transitions.]

Link: https://lore.kernel.org/r/20210722025858.220064-1-alexander.deucher@amd.com
Signed-off-by: Marcin Bachry <hegel666@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Prike Liang <prike.liang@amd.com>
Cc: Shyam Sundar S K <shyam-sundar.s-k@amd.com>
---
 drivers/pci/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6d74386eadc2..ab3de1551b50 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1900,6 +1900,7 @@ static void quirk_ryzen_xhci_d3hot(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x15e0, quirk_ryzen_xhci_d3hot);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x15e1, quirk_ryzen_xhci_d3hot);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x1639, quirk_ryzen_xhci_d3hot);
 
 #ifdef CONFIG_X86_IO_APIC
 static int dmi_disable_ioapicreroute(const struct dmi_system_id *d)
-- 
2.30.2





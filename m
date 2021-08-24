Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793653F5649
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 04:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbhHXDAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 23:00:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234670AbhHXC7q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 22:59:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3DC461374;
        Tue, 24 Aug 2021 02:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629773939;
        bh=tRC4juD7LpcM0Z2v2il38aGfFxTCi1kq0ldE/bmXuBc=;
        h=From:To:Cc:Subject:Date:From;
        b=t0vegZ+D4SvwsWy7w31/eYvNZyhDuas337Up9VsGVchQWJvPcqcNG5E0/rIcaLjXP
         GI7sr64s88HR3ghBAWkWswPfc+ivuRpIJPvlPk85sfJFJltaKDbLGp+AcGj6PT1Go/
         +35f7NMC86wrSMeelMd2SJhoGBP2HM1nW9AwCs6CjDk1A70HhkErRF2pZvX1BuY/kH
         /jo3hCSGSlttFNpb6lBVW7mbQZ26w3+viTnU3B31s55qS8PWO9G53Foy7LLqf/e7Wf
         v0JGtBhdXSQNGvZuhh/rHwJUasPm5rvIsbtN/Xd1iIM2uP/BHb80FF6zPe2y+KlyTK
         I2x3WFemyaX5g==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, hegel666@gmail.com
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Prike Liang <prike.liang@amd.com>,
        Shyam Sundar S K <shyam-sundar.s-k@amd.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: FAILED: Patch "PCI: Increase D3 delay for AMD Renoir/Cezanne XHCI" failed to apply to 4.4-stable tree
Date:   Mon, 23 Aug 2021 22:58:57 -0400
Message-Id: <20210824025857.660233-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.4-stable tree.
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





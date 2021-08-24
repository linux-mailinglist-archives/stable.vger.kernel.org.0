Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1DA13F5627
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 04:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbhHXC70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 22:59:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234532AbhHXC7S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 22:59:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95852611C9;
        Tue, 24 Aug 2021 02:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629773914;
        bh=xrjxTxiP47ktHwX88wT7l7gjm0bbjdMe5v6kL5mz/sU=;
        h=From:To:Cc:Subject:Date:From;
        b=ufWEMmHPa5PjwKXkQNw4c8WJOqPcQ4ZtpQcw8pTP69IOPpCGOGaQizEitqQrxjzl7
         C3BoyzsP7Gr9v12uJWh962UqGA4DMUDXtUA2CZcU3JBzOdzh6l6VmYKgfKRjZ1LySs
         MPb3FtzwkHX1/YQYv5knRi9I9VjD+2dNhmjyHkH1QKZkMw0qO4tdd2M6GIVjI/xnRn
         nLGTf+GSU1zxaq0qJeR0pOaUqxs+j7K9KfEwAW5IkMekKdcjC748zJnU0xS9KSoh+T
         eIlnKeCWUVu+bW1b6s4Bmj30JcwHqbCYE65Pty1LO/D8eyamgGeQobvehzYcZTGKI2
         uDNWnhGqm5v6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, hegel666@gmail.com
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Prike Liang <prike.liang@amd.com>,
        Shyam Sundar S K <shyam-sundar.s-k@amd.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: FAILED: Patch "PCI: Increase D3 delay for AMD Renoir/Cezanne XHCI" failed to apply to 4.14-stable tree
Date:   Mon, 23 Aug 2021 22:58:32 -0400
Message-Id: <20210824025832.659510-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.14-stable tree.
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





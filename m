Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455B23F645F
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238922AbhHXRDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:03:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233901AbhHXRBc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:01:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B5FF61373;
        Tue, 24 Aug 2021 16:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824281;
        bh=uPSK5cAg2dn8qjPBEuP++tJA9KcCWwUiyjEAwDzOVTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZO0VLNu+xTe602vC9QXkRq2y6+DkdyEKp0//oJlihswZR9y1KWRaNi8//xNnUOrQ
         TN/PLQ/UqZg1SCgk3/CrVd99XMcgiTeVC9ZA6bGR4xMulpIJgSTugpm0vGSOWDLALD
         TGbo37O5qtKD0j2mEu57s71RUoerfZ+MEMz3P49VE06mxVHVm1ZF0aEFii+dudOC/l
         UwUAkacH3T/zcgjm9u5QHGp0Fp5tghUKjaWnebf3Qoss1JfEvqhGg7uGW2TkgORGNp
         b5BCGWPAG9eD9qH7Iu0c54aVz+XwnQ1P2Lm2yb3YWGJBHsl24gE/EEu8xDyv+nAEsT
         3QSOV6LbtV72A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcin Bachry <hegel666@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Prike Liang <prike.liang@amd.com>,
        Shyam Sundar S K <shyam-sundar.s-k@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 116/127] PCI: Increase D3 delay for AMD Renoir/Cezanne XHCI
Date:   Tue, 24 Aug 2021 12:55:56 -0400
Message-Id: <20210824165607.709387-117-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcin Bachry <hegel666@gmail.com>

[ Upstream commit e0bff43220925b7e527f9d3bc9f5c624177c959e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7094432AF31
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbhCCAP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:15:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:42428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1441796AbhCBMLd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:11:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C402964F53;
        Tue,  2 Mar 2021 11:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686223;
        bh=BgcOHfwvydH1yXWb/ipxKMGonTpJkoG8DBfuIUv7qXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jKxlK8uJ9HgboP5Rv/+BYoVh+ftans1Gcnr1UrVETccVniqawznVrF/H7tMwQhFSY
         YXDgpUwI49+sT0SBH2ILagk/tsV2FwgmBQhuYjqTkSoZwTXgnAlLfllUnnxKcUWhwQ
         9iQghfFCQVZ9i40jyrAGHH5m2qMzdJkOHZI7s4r8pdAAnXPH0mPzEsUKztW6tYg2Xm
         udzm1RlG9ZjpIFv0FsIlp23cIdH6bEzrhZ7leRDrd0F0ci6+4SiAIlGSkyDljcRvEr
         +YkJHEi/qVnUMfsamtO5TWHMPRbSjZ7Nlj2rFqj/dqIy0nSE5Vg3hAmkXPuXW8vJTB
         71VN8o24qpC7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver O'Halloran <oohall@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 13/47] powerpc/pci: Add ppc_md.discover_phbs()
Date:   Tue,  2 Mar 2021 06:56:12 -0500
Message-Id: <20210302115646.62291-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver O'Halloran <oohall@gmail.com>

[ Upstream commit 5537fcb319d016ce387f818dd774179bc03217f5 ]

On many powerpc platforms the discovery and initalisation of
pci_controllers (PHBs) happens inside of setup_arch(). This is very early
in boot (pre-initcalls) and means that we're initialising the PHB long
before many basic kernel services (slab allocator, debugfs, a real ioremap)
are available.

On PowerNV this causes an additional problem since we map the PHB registers
with ioremap(). As of commit d538aadc2718 ("powerpc/ioremap: warn on early
use of ioremap()") a warning is printed because we're using the "incorrect"
API to setup and MMIO mapping in searly boot. The kernel does provide
early_ioremap(), but that is not intended to create long-lived MMIO
mappings and a seperate warning is printed by generic code if
early_ioremap() mappings are "leaked."

This is all fixable with dumb hacks like using early_ioremap() to setup
the initial mapping then replacing it with a real ioremap later on in
boot, but it does raise the question: Why the hell are we setting up the
PHB's this early in boot?

The old and wise claim it's due to "hysterical rasins." Aside from amused
grapes there doesn't appear to be any real reason to maintain the current
behaviour. Already most of the newer embedded platforms perform PHB
discovery in an arch_initcall and between the end of setup_arch() and the
start of initcalls none of the generic kernel code does anything PCI
related. On powerpc scanning PHBs occurs in a subsys_initcall so it should
be possible to move the PHB discovery to a core, postcore or arch initcall.

This patch adds the ppc_md.discover_phbs hook and a core_initcall stub that
calls it. The core_initcalls are the earliest to be called so this will
any possibly issues with dependency between initcalls. This isn't just an
academic issue either since on pseries and PowerNV EEH init occurs in an
arch_initcall and depends on the pci_controllers being available, similarly
the creation of pci_dns occurs at core_initcall_sync (i.e. between core and
postcore initcalls). These problems need to be addressed seperately.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
[mpe: Make discover_phbs() static]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201103043523.916109-1-oohall@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/machdep.h |  3 +++
 arch/powerpc/kernel/pci-common.c   | 10 ++++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index 475687f24f4a..d319160d790c 100644
--- a/arch/powerpc/include/asm/machdep.h
+++ b/arch/powerpc/include/asm/machdep.h
@@ -59,6 +59,9 @@ struct machdep_calls {
 	int		(*pcibios_root_bridge_prepare)(struct pci_host_bridge
 				*bridge);
 
+	/* finds all the pci_controllers present at boot */
+	void 		(*discover_phbs)(void);
+
 	/* To setup PHBs when using automatic OF platform driver for PCI */
 	int		(*pci_setup_phb)(struct pci_controller *host);
 
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index be108616a721..7920559a1ca8 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1625,3 +1625,13 @@ static void fixup_hide_host_resource_fsl(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MOTOROLA, PCI_ANY_ID, fixup_hide_host_resource_fsl);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_FREESCALE, PCI_ANY_ID, fixup_hide_host_resource_fsl);
+
+
+static int __init discover_phbs(void)
+{
+	if (ppc_md.discover_phbs)
+		ppc_md.discover_phbs();
+
+	return 0;
+}
+core_initcall(discover_phbs);
-- 
2.30.1


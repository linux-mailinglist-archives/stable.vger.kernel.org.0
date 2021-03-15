Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDD733B930
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbhCOOFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233163AbhCOOA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FF4A64F2A;
        Mon, 15 Mar 2021 14:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816833;
        bh=9bj6SCD5EJuiL7/Owysds0FsYr2HYAQQYLveL93WhDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EIUrx9dcyn5NsNjJPXL+6lU5qFLziz9Cag9MfoFo3cT2Ws0rUJo5k53LbaRIo+X3/
         Fjk7bzripak++KqaeFCC1zK1VrMHRzsfwS0YfJ4zA/LTZc/PMtJ77ccnLEocwp4C8e
         rimiHreMTC4kf788NwmyxzJUcGXbq/eE7Yl4AKNA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Oliver OHalloran <oohall@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/290] powerpc/pci: Add ppc_md.discover_phbs()
Date:   Mon, 15 Mar 2021 14:53:53 +0100
Message-Id: <20210315135546.648228562@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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




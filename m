Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5099A3CE4D8
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236678AbhGSPqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:46:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349059AbhGSPom (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:44:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D10F8611ED;
        Mon, 19 Jul 2021 16:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711823;
        bh=Uy2w6FbZRCR+yDAAarJQObrAw8O6iiCpycv6FkGX1BQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKFt4cIpahxJylO8ZxY9nE46JueepMypQuChd6cP0wk341ws7FN4EuCSmk6GKJY0y
         DCne2TTxPMvKGwsN63eLc86IzyLPR2GcPS0xRN6UDQ1ZYkZ+W/8d4nuUQC8bdfuwFh
         HWR2A90kR1jAWsKWTETr9JQWRIb0Xgv1vR1cmXJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 144/292] PCI: Dynamically map ECAM regions
Date:   Mon, 19 Jul 2021 16:53:26 +0200
Message-Id: <20210719144947.217081067@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 8fe55ef23387ce3c7488375b1fd539420d7654bb ]

Attempting to boot 32-bit ARM kernels under QEMU's 3.x virt models fails
when we have more than 512M of RAM in the model as we run out of vmalloc
space for the PCI ECAM regions. This failure will be silent when running
libvirt, as the console in that situation is a PCI device.

In this configuration, the kernel maps the whole ECAM, which QEMU sets up
for 256 buses, even when maybe only seven buses are in use.  Each bus uses
1M of ECAM space, and ioremap() adds an additional guard page between
allocations. The kernel vmap allocator will align these regions to 512K,
resulting in each mapping eating 1.5M of vmalloc space. This means we need
384M of vmalloc space just to map all of these, which is very wasteful of
resources.

Fix this by only mapping the ECAM for buses we are going to be using.  In
my setups, this is around seven buses in most guests, which is 10.5M of
vmalloc space - way smaller than the 384M that would otherwise be required.
This also means that the kernel can boot without forcing extra RAM into
highmem with the vmalloc= argument, or decreasing the virtual RAM available
to the guest.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/E1lhCAV-0002yb-50@rmk-PC.armlinux.org.uk
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/ecam.c       | 54 ++++++++++++++++++++++++++++++++++------
 include/linux/pci-ecam.h |  1 +
 2 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/ecam.c b/drivers/pci/ecam.c
index d2a1920bb055..1c40d2506aef 100644
--- a/drivers/pci/ecam.c
+++ b/drivers/pci/ecam.c
@@ -32,7 +32,7 @@ struct pci_config_window *pci_ecam_create(struct device *dev,
 	struct pci_config_window *cfg;
 	unsigned int bus_range, bus_range_max, bsz;
 	struct resource *conflict;
-	int i, err;
+	int err;
 
 	if (busr->start > busr->end)
 		return ERR_PTR(-EINVAL);
@@ -50,6 +50,7 @@ struct pci_config_window *pci_ecam_create(struct device *dev,
 	cfg->busr.start = busr->start;
 	cfg->busr.end = busr->end;
 	cfg->busr.flags = IORESOURCE_BUS;
+	cfg->bus_shift = bus_shift;
 	bus_range = resource_size(&cfg->busr);
 	bus_range_max = resource_size(cfgres) >> bus_shift;
 	if (bus_range > bus_range_max) {
@@ -77,13 +78,6 @@ struct pci_config_window *pci_ecam_create(struct device *dev,
 		cfg->winp = kcalloc(bus_range, sizeof(*cfg->winp), GFP_KERNEL);
 		if (!cfg->winp)
 			goto err_exit_malloc;
-		for (i = 0; i < bus_range; i++) {
-			cfg->winp[i] =
-				pci_remap_cfgspace(cfgres->start + i * bsz,
-						   bsz);
-			if (!cfg->winp[i])
-				goto err_exit_iomap;
-		}
 	} else {
 		cfg->win = pci_remap_cfgspace(cfgres->start, bus_range * bsz);
 		if (!cfg->win)
@@ -129,6 +123,44 @@ void pci_ecam_free(struct pci_config_window *cfg)
 }
 EXPORT_SYMBOL_GPL(pci_ecam_free);
 
+static int pci_ecam_add_bus(struct pci_bus *bus)
+{
+	struct pci_config_window *cfg = bus->sysdata;
+	unsigned int bsz = 1 << cfg->bus_shift;
+	unsigned int busn = bus->number;
+	phys_addr_t start;
+
+	if (!per_bus_mapping)
+		return 0;
+
+	if (busn < cfg->busr.start || busn > cfg->busr.end)
+		return -EINVAL;
+
+	busn -= cfg->busr.start;
+	start = cfg->res.start + busn * bsz;
+
+	cfg->winp[busn] = pci_remap_cfgspace(start, bsz);
+	if (!cfg->winp[busn])
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void pci_ecam_remove_bus(struct pci_bus *bus)
+{
+	struct pci_config_window *cfg = bus->sysdata;
+	unsigned int busn = bus->number;
+
+	if (!per_bus_mapping || busn < cfg->busr.start || busn > cfg->busr.end)
+		return;
+
+	busn -= cfg->busr.start;
+	if (cfg->winp[busn]) {
+		iounmap(cfg->winp[busn]);
+		cfg->winp[busn] = NULL;
+	}
+}
+
 /*
  * Function to implement the pci_ops ->map_bus method
  */
@@ -167,6 +199,8 @@ EXPORT_SYMBOL_GPL(pci_ecam_map_bus);
 /* ECAM ops */
 const struct pci_ecam_ops pci_generic_ecam_ops = {
 	.pci_ops	= {
+		.add_bus	= pci_ecam_add_bus,
+		.remove_bus	= pci_ecam_remove_bus,
 		.map_bus	= pci_ecam_map_bus,
 		.read		= pci_generic_config_read,
 		.write		= pci_generic_config_write,
@@ -178,6 +212,8 @@ EXPORT_SYMBOL_GPL(pci_generic_ecam_ops);
 /* ECAM ops for 32-bit access only (non-compliant) */
 const struct pci_ecam_ops pci_32b_ops = {
 	.pci_ops	= {
+		.add_bus	= pci_ecam_add_bus,
+		.remove_bus	= pci_ecam_remove_bus,
 		.map_bus	= pci_ecam_map_bus,
 		.read		= pci_generic_config_read32,
 		.write		= pci_generic_config_write32,
@@ -187,6 +223,8 @@ const struct pci_ecam_ops pci_32b_ops = {
 /* ECAM ops for 32-bit read only (non-compliant) */
 const struct pci_ecam_ops pci_32b_read_ops = {
 	.pci_ops	= {
+		.add_bus	= pci_ecam_add_bus,
+		.remove_bus	= pci_ecam_remove_bus,
 		.map_bus	= pci_ecam_map_bus,
 		.read		= pci_generic_config_read32,
 		.write		= pci_generic_config_write,
diff --git a/include/linux/pci-ecam.h b/include/linux/pci-ecam.h
index 65d3d83015c3..944da75ff25c 100644
--- a/include/linux/pci-ecam.h
+++ b/include/linux/pci-ecam.h
@@ -55,6 +55,7 @@ struct pci_ecam_ops {
 struct pci_config_window {
 	struct resource			res;
 	struct resource			busr;
+	unsigned int			bus_shift;
 	void				*priv;
 	const struct pci_ecam_ops	*ops;
 	union {
-- 
2.30.2




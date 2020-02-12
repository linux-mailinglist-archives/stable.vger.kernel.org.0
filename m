Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 384EF15AF10
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 18:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgBLRvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 12:51:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:43084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727231AbgBLRvf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Feb 2020 12:51:35 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 157C02073C;
        Wed, 12 Feb 2020 17:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581529892;
        bh=WAGy0iCOniWJBUK/j/VnWuYOxju/nwNo+oB/p/8Wo1Q=;
        h=Subject:To:From:Date:From;
        b=1xrs2fDN2kqsBkXvWfi7TDs0WpToK06V1n2y1mNIbCxAfPxQOy1Megvo9GnnnMiK5
         yW2PpG3r7ARh9axcmzvM4Dxr3JdKNMaQA+H6kmfdwbN26JJIgR4rO36AwWDncqdh/3
         vl7qBJZlbIcpiDcSULFmEST+FzafrcDIkCYK2aQs=
Subject: patch "Revert "xhci: Fix memory leak when caching protocol extended" added to usb-linus
To:     gregkh@linuxfoundation.org, VenkateswaraRao.Sajja@amd.com,
        m.szyprowski@samsung.com, mathias.nyman@linux.intel.com,
        pmenzel@molgen.mpg.de, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 Feb 2020 09:51:31 -0800
Message-ID: <158152989115998@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "xhci: Fix memory leak when caching protocol extended

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 67f68f977a12657028e866c013d43dd87320d210 Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 12 Feb 2020 09:48:57 -0800
Subject: Revert "xhci: Fix memory leak when caching protocol extended
 capability PSI tables"

This reverts commit fc57313d1017dd6b6f37a94e88daa8df54368ecc.

Marek reports that it breaks things:
	This patch landed in today's linux-next (20200211) and causes
	NULL pointer dereference during second suspend/resume cycle on
	Samsung Exynos5422-based (arm 32bit) Odroid XU3lite board:

A more complete fix will be added soon.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: fc57313d1017 ("xhci: Fix memory leak when caching protocol extended capability PSI tables")
Cc: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Sajja Venkateswara Rao <VenkateswaraRao.Sajja@amd.com>
Cc: stable <stable@vger.kernel.org> # v4.4+
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-hub.c | 25 +++++-----------
 drivers/usb/host/xhci-mem.c | 58 ++++++++++++++-----------------------
 drivers/usb/host/xhci.h     | 14 ++-------
 3 files changed, 33 insertions(+), 64 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index af92b2576fe9..7a3a29e5e9d2 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -55,7 +55,6 @@ static u8 usb_bos_descriptor [] = {
 static int xhci_create_usb3_bos_desc(struct xhci_hcd *xhci, char *buf,
 				     u16 wLength)
 {
-	struct xhci_port_cap *port_cap = NULL;
 	int i, ssa_count;
 	u32 temp;
 	u16 desc_size, ssp_cap_size, ssa_size = 0;
@@ -65,24 +64,16 @@ static int xhci_create_usb3_bos_desc(struct xhci_hcd *xhci, char *buf,
 	ssp_cap_size = sizeof(usb_bos_descriptor) - desc_size;
 
 	/* does xhci support USB 3.1 Enhanced SuperSpeed */
-	for (i = 0; i < xhci->num_port_caps; i++) {
-		if (xhci->port_caps[i].maj_rev == 0x03 &&
-		    xhci->port_caps[i].min_rev >= 0x01) {
-			usb3_1 = true;
-			port_cap = &xhci->port_caps[i];
-			break;
-		}
-	}
-
-	if (usb3_1) {
+	if (xhci->usb3_rhub.min_rev >= 0x01) {
 		/* does xhci provide a PSI table for SSA speed attributes? */
-		if (port_cap->psi_count) {
+		if (xhci->usb3_rhub.psi_count) {
 			/* two SSA entries for each unique PSI ID, RX and TX */
-			ssa_count = port_cap->psi_uid_count * 2;
+			ssa_count = xhci->usb3_rhub.psi_uid_count * 2;
 			ssa_size = ssa_count * sizeof(u32);
 			ssp_cap_size -= 16; /* skip copying the default SSA */
 		}
 		desc_size += ssp_cap_size;
+		usb3_1 = true;
 	}
 	memcpy(buf, &usb_bos_descriptor, min(desc_size, wLength));
 
@@ -108,7 +99,7 @@ static int xhci_create_usb3_bos_desc(struct xhci_hcd *xhci, char *buf,
 	}
 
 	/* If PSI table exists, add the custom speed attributes from it */
-	if (usb3_1 && port_cap->psi_count) {
+	if (usb3_1 && xhci->usb3_rhub.psi_count) {
 		u32 ssp_cap_base, bm_attrib, psi, psi_mant, psi_exp;
 		int offset;
 
@@ -120,7 +111,7 @@ static int xhci_create_usb3_bos_desc(struct xhci_hcd *xhci, char *buf,
 
 		/* attribute count SSAC bits 4:0 and ID count SSIC bits 8:5 */
 		bm_attrib = (ssa_count - 1) & 0x1f;
-		bm_attrib |= (port_cap->psi_uid_count - 1) << 5;
+		bm_attrib |= (xhci->usb3_rhub.psi_uid_count - 1) << 5;
 		put_unaligned_le32(bm_attrib, &buf[ssp_cap_base + 4]);
 
 		if (wLength < desc_size + ssa_size)
@@ -133,8 +124,8 @@ static int xhci_create_usb3_bos_desc(struct xhci_hcd *xhci, char *buf,
 		 * USB 3.1 requires two SSA entries (RX and TX) for every link
 		 */
 		offset = desc_size;
-		for (i = 0; i < port_cap->psi_count; i++) {
-			psi = port_cap->psi[i];
+		for (i = 0; i < xhci->usb3_rhub.psi_count; i++) {
+			psi = xhci->usb3_rhub.psi[i];
 			psi &= ~USB_SSP_SUBLINK_SPEED_RSVD;
 			psi_exp = XHCI_EXT_PORT_PSIE(psi);
 			psi_mant = XHCI_EXT_PORT_PSIM(psi);
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index bd5b152df6c0..0e2701649369 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1915,16 +1915,17 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	xhci->usb3_rhub.num_ports = 0;
 	xhci->num_active_eps = 0;
 	kfree(xhci->usb2_rhub.ports);
+	kfree(xhci->usb2_rhub.psi);
 	kfree(xhci->usb3_rhub.ports);
+	kfree(xhci->usb3_rhub.psi);
 	kfree(xhci->hw_ports);
 	kfree(xhci->rh_bw);
 	kfree(xhci->ext_caps);
-	for (i = 0; i < xhci->num_port_caps; i++)
-		kfree(xhci->port_caps[i].psi);
-	kfree(xhci->port_caps);
 
 	xhci->usb2_rhub.ports = NULL;
+	xhci->usb2_rhub.psi = NULL;
 	xhci->usb3_rhub.ports = NULL;
+	xhci->usb3_rhub.psi = NULL;
 	xhci->hw_ports = NULL;
 	xhci->rh_bw = NULL;
 	xhci->ext_caps = NULL;
@@ -2125,7 +2126,6 @@ static void xhci_add_in_port(struct xhci_hcd *xhci, unsigned int num_ports,
 	u8 major_revision, minor_revision;
 	struct xhci_hub *rhub;
 	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
-	struct xhci_port_cap *port_cap;
 
 	temp = readl(addr);
 	major_revision = XHCI_EXT_PORT_MAJOR(temp);
@@ -2160,39 +2160,31 @@ static void xhci_add_in_port(struct xhci_hcd *xhci, unsigned int num_ports,
 		/* WTF? "Valid values are ‘1’ to MaxPorts" */
 		return;
 
-	port_cap = &xhci->port_caps[xhci->num_port_caps++];
-	if (xhci->num_port_caps > max_caps)
-		return;
-
-	port_cap->maj_rev = major_revision;
-	port_cap->min_rev = minor_revision;
-	port_cap->psi_count = XHCI_EXT_PORT_PSIC(temp);
-
-	if (port_cap->psi_count) {
-		port_cap->psi = kcalloc_node(port_cap->psi_count,
-					     sizeof(*port_cap->psi),
-					     GFP_KERNEL, dev_to_node(dev));
-		if (!port_cap->psi)
-			port_cap->psi_count = 0;
+	rhub->psi_count = XHCI_EXT_PORT_PSIC(temp);
+	if (rhub->psi_count) {
+		rhub->psi = kcalloc_node(rhub->psi_count, sizeof(*rhub->psi),
+				    GFP_KERNEL, dev_to_node(dev));
+		if (!rhub->psi)
+			rhub->psi_count = 0;
 
-		port_cap->psi_uid_count++;
-		for (i = 0; i < port_cap->psi_count; i++) {
-			port_cap->psi[i] = readl(addr + 4 + i);
+		rhub->psi_uid_count++;
+		for (i = 0; i < rhub->psi_count; i++) {
+			rhub->psi[i] = readl(addr + 4 + i);
 
 			/* count unique ID values, two consecutive entries can
 			 * have the same ID if link is assymetric
 			 */
-			if (i && (XHCI_EXT_PORT_PSIV(port_cap->psi[i]) !=
-				  XHCI_EXT_PORT_PSIV(port_cap->psi[i - 1])))
-				port_cap->psi_uid_count++;
+			if (i && (XHCI_EXT_PORT_PSIV(rhub->psi[i]) !=
+				  XHCI_EXT_PORT_PSIV(rhub->psi[i - 1])))
+				rhub->psi_uid_count++;
 
 			xhci_dbg(xhci, "PSIV:%d PSIE:%d PLT:%d PFD:%d LP:%d PSIM:%d\n",
-				  XHCI_EXT_PORT_PSIV(port_cap->psi[i]),
-				  XHCI_EXT_PORT_PSIE(port_cap->psi[i]),
-				  XHCI_EXT_PORT_PLT(port_cap->psi[i]),
-				  XHCI_EXT_PORT_PFD(port_cap->psi[i]),
-				  XHCI_EXT_PORT_LP(port_cap->psi[i]),
-				  XHCI_EXT_PORT_PSIM(port_cap->psi[i]));
+				  XHCI_EXT_PORT_PSIV(rhub->psi[i]),
+				  XHCI_EXT_PORT_PSIE(rhub->psi[i]),
+				  XHCI_EXT_PORT_PLT(rhub->psi[i]),
+				  XHCI_EXT_PORT_PFD(rhub->psi[i]),
+				  XHCI_EXT_PORT_LP(rhub->psi[i]),
+				  XHCI_EXT_PORT_PSIM(rhub->psi[i]));
 		}
 	}
 	/* cache usb2 port capabilities */
@@ -2227,7 +2219,6 @@ static void xhci_add_in_port(struct xhci_hcd *xhci, unsigned int num_ports,
 			continue;
 		}
 		hw_port->rhub = rhub;
-		hw_port->port_cap = port_cap;
 		rhub->num_ports++;
 	}
 	/* FIXME: Should we disable ports not in the Extended Capabilities? */
@@ -2318,11 +2309,6 @@ static int xhci_setup_port_arrays(struct xhci_hcd *xhci, gfp_t flags)
 	if (!xhci->ext_caps)
 		return -ENOMEM;
 
-	xhci->port_caps = kcalloc_node(cap_count, sizeof(*xhci->port_caps),
-				flags, dev_to_node(dev));
-	if (!xhci->port_caps)
-		return -ENOMEM;
-
 	offset = cap_start;
 
 	while (offset) {
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 3ecee10fdcdc..13d8838cd552 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1702,20 +1702,12 @@ struct xhci_bus_state {
  * Intel Lynx Point LP xHCI host.
  */
 #define	XHCI_MAX_REXIT_TIMEOUT_MS	20
-struct xhci_port_cap {
-	u32			*psi;	/* array of protocol speed ID entries */
-	u8			psi_count;
-	u8			psi_uid_count;
-	u8			maj_rev;
-	u8			min_rev;
-};
 
 struct xhci_port {
 	__le32 __iomem		*addr;
 	int			hw_portnum;
 	int			hcd_portnum;
 	struct xhci_hub		*rhub;
-	struct xhci_port_cap	*port_cap;
 };
 
 struct xhci_hub {
@@ -1727,6 +1719,9 @@ struct xhci_hub {
 	/* supported prococol extended capabiliy values */
 	u8			maj_rev;
 	u8			min_rev;
+	u32			*psi;	/* array of protocol speed ID entries */
+	u8			psi_count;
+	u8			psi_uid_count;
 };
 
 /* There is one xhci_hcd structure per controller */
@@ -1885,9 +1880,6 @@ struct xhci_hcd {
 	/* cached usb2 extened protocol capabilites */
 	u32                     *ext_caps;
 	unsigned int            num_ext_caps;
-	/* cached extended protocol port capabilities */
-	struct xhci_port_cap	*port_caps;
-	unsigned int		num_port_caps;
 	/* Compliance Mode Recovery Data */
 	struct timer_list	comp_mode_recovery_timer;
 	u32			port_status_u0;
-- 
2.25.0



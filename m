Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18DB2171B9C
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387509AbgB0OEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:04:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:39838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387505AbgB0OEA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:04:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C4D424697;
        Thu, 27 Feb 2020 14:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812239;
        bh=js235RE7WI6e08dufc3ksZS1E1vA2bveKpuy4WfdAZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GawC/qhQP7TiqHcOaBmn0owElLGMyBSQNiAtm8zhnw6YCX8+DAA2vaBhTPL6uwoRt
         Wxpg+gH5m6kmY5ei6pwkk6pARbiBZvwRn9gWxCPkHxcmsYnPKVsNr+uvVq+9JkM6q9
         UbKLzU3wCneU++O0/2rchL5iGKy/4cq2qBPS0QlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        Sajja Venkateswara Rao <VenkateswaraRao.Sajja@amd.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 4.19 21/97] xhci: Fix memory leak when caching protocol extended capability PSI tables - take 2
Date:   Thu, 27 Feb 2020 14:36:29 +0100
Message-Id: <20200227132218.091304533@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit cf0ee7c60c89641f6e4d1d3c7867fe32b9e30300 upstream.

xhci driver assumed that xHC controllers have at most one custom
supported speed table (PSI) for all usb 3.x ports.
Memory was allocated for one PSI table under the xhci hub structure.

Turns out this is not the case, some controllers have a separate
"supported protocol capability" entry with a PSI table for each port.
This means each usb3 roothub port can in theory support different custom
speeds.

To solve this, cache all supported protocol capabilities with their PSI
tables in an array, and add pointers to the xhci port structure so that
every port points to its capability entry in the array.

When creating the SuperSpeedPlus USB Device Capability BOS descriptor
for the xhci USB 3.1 roothub we for now will use only data from the
first USB 3.1 capable protocol capability entry in the array.
This could be improved later, this patch focuses resolving
the memory leak.

Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reported-by: Sajja Venkateswara Rao <VenkateswaraRao.Sajja@amd.com>
Fixes: 47189098f8be ("xhci: parse xhci protocol speed ID list for usb 3.1 usage")
Cc: stable <stable@vger.kernel.org> # v4.4+
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20200211150158.14475-1-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-hub.c |   25 ++++++++++++------
 drivers/usb/host/xhci-mem.c |   61 +++++++++++++++++++++++++++-----------------
 drivers/usb/host/xhci.h     |   16 +++++++++--
 3 files changed, 68 insertions(+), 34 deletions(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -55,6 +55,7 @@ static u8 usb_bos_descriptor [] = {
 static int xhci_create_usb3_bos_desc(struct xhci_hcd *xhci, char *buf,
 				     u16 wLength)
 {
+	struct xhci_port_cap *port_cap = NULL;
 	int i, ssa_count;
 	u32 temp;
 	u16 desc_size, ssp_cap_size, ssa_size = 0;
@@ -64,16 +65,24 @@ static int xhci_create_usb3_bos_desc(str
 	ssp_cap_size = sizeof(usb_bos_descriptor) - desc_size;
 
 	/* does xhci support USB 3.1 Enhanced SuperSpeed */
-	if (xhci->usb3_rhub.min_rev >= 0x01) {
+	for (i = 0; i < xhci->num_port_caps; i++) {
+		if (xhci->port_caps[i].maj_rev == 0x03 &&
+		    xhci->port_caps[i].min_rev >= 0x01) {
+			usb3_1 = true;
+			port_cap = &xhci->port_caps[i];
+			break;
+		}
+	}
+
+	if (usb3_1) {
 		/* does xhci provide a PSI table for SSA speed attributes? */
-		if (xhci->usb3_rhub.psi_count) {
+		if (port_cap->psi_count) {
 			/* two SSA entries for each unique PSI ID, RX and TX */
-			ssa_count = xhci->usb3_rhub.psi_uid_count * 2;
+			ssa_count = port_cap->psi_uid_count * 2;
 			ssa_size = ssa_count * sizeof(u32);
 			ssp_cap_size -= 16; /* skip copying the default SSA */
 		}
 		desc_size += ssp_cap_size;
-		usb3_1 = true;
 	}
 	memcpy(buf, &usb_bos_descriptor, min(desc_size, wLength));
 
@@ -99,7 +108,7 @@ static int xhci_create_usb3_bos_desc(str
 	}
 
 	/* If PSI table exists, add the custom speed attributes from it */
-	if (usb3_1 && xhci->usb3_rhub.psi_count) {
+	if (usb3_1 && port_cap->psi_count) {
 		u32 ssp_cap_base, bm_attrib, psi, psi_mant, psi_exp;
 		int offset;
 
@@ -111,7 +120,7 @@ static int xhci_create_usb3_bos_desc(str
 
 		/* attribute count SSAC bits 4:0 and ID count SSIC bits 8:5 */
 		bm_attrib = (ssa_count - 1) & 0x1f;
-		bm_attrib |= (xhci->usb3_rhub.psi_uid_count - 1) << 5;
+		bm_attrib |= (port_cap->psi_uid_count - 1) << 5;
 		put_unaligned_le32(bm_attrib, &buf[ssp_cap_base + 4]);
 
 		if (wLength < desc_size + ssa_size)
@@ -124,8 +133,8 @@ static int xhci_create_usb3_bos_desc(str
 		 * USB 3.1 requires two SSA entries (RX and TX) for every link
 		 */
 		offset = desc_size;
-		for (i = 0; i < xhci->usb3_rhub.psi_count; i++) {
-			psi = xhci->usb3_rhub.psi[i];
+		for (i = 0; i < port_cap->psi_count; i++) {
+			psi = port_cap->psi[i];
 			psi &= ~USB_SSP_SUBLINK_SPEED_RSVD;
 			psi_exp = XHCI_EXT_PORT_PSIE(psi);
 			psi_mant = XHCI_EXT_PORT_PSIM(psi);
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1915,17 +1915,17 @@ no_bw:
 	xhci->usb3_rhub.num_ports = 0;
 	xhci->num_active_eps = 0;
 	kfree(xhci->usb2_rhub.ports);
-	kfree(xhci->usb2_rhub.psi);
 	kfree(xhci->usb3_rhub.ports);
-	kfree(xhci->usb3_rhub.psi);
 	kfree(xhci->hw_ports);
 	kfree(xhci->rh_bw);
 	kfree(xhci->ext_caps);
+	for (i = 0; i < xhci->num_port_caps; i++)
+		kfree(xhci->port_caps[i].psi);
+	kfree(xhci->port_caps);
+	xhci->num_port_caps = 0;
 
 	xhci->usb2_rhub.ports = NULL;
-	xhci->usb2_rhub.psi = NULL;
 	xhci->usb3_rhub.ports = NULL;
-	xhci->usb3_rhub.psi = NULL;
 	xhci->hw_ports = NULL;
 	xhci->rh_bw = NULL;
 	xhci->ext_caps = NULL;
@@ -2126,6 +2126,7 @@ static void xhci_add_in_port(struct xhci
 	u8 major_revision, minor_revision;
 	struct xhci_hub *rhub;
 	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
+	struct xhci_port_cap *port_cap;
 
 	temp = readl(addr);
 	major_revision = XHCI_EXT_PORT_MAJOR(temp);
@@ -2160,31 +2161,39 @@ static void xhci_add_in_port(struct xhci
 		/* WTF? "Valid values are ‘1’ to MaxPorts" */
 		return;
 
-	rhub->psi_count = XHCI_EXT_PORT_PSIC(temp);
-	if (rhub->psi_count) {
-		rhub->psi = kcalloc_node(rhub->psi_count, sizeof(*rhub->psi),
-				    GFP_KERNEL, dev_to_node(dev));
-		if (!rhub->psi)
-			rhub->psi_count = 0;
-
-		rhub->psi_uid_count++;
-		for (i = 0; i < rhub->psi_count; i++) {
-			rhub->psi[i] = readl(addr + 4 + i);
+	port_cap = &xhci->port_caps[xhci->num_port_caps++];
+	if (xhci->num_port_caps > max_caps)
+		return;
+
+	port_cap->maj_rev = major_revision;
+	port_cap->min_rev = minor_revision;
+	port_cap->psi_count = XHCI_EXT_PORT_PSIC(temp);
+
+	if (port_cap->psi_count) {
+		port_cap->psi = kcalloc_node(port_cap->psi_count,
+					     sizeof(*port_cap->psi),
+					     GFP_KERNEL, dev_to_node(dev));
+		if (!port_cap->psi)
+			port_cap->psi_count = 0;
+
+		port_cap->psi_uid_count++;
+		for (i = 0; i < port_cap->psi_count; i++) {
+			port_cap->psi[i] = readl(addr + 4 + i);
 
 			/* count unique ID values, two consecutive entries can
 			 * have the same ID if link is assymetric
 			 */
-			if (i && (XHCI_EXT_PORT_PSIV(rhub->psi[i]) !=
-				  XHCI_EXT_PORT_PSIV(rhub->psi[i - 1])))
-				rhub->psi_uid_count++;
+			if (i && (XHCI_EXT_PORT_PSIV(port_cap->psi[i]) !=
+				  XHCI_EXT_PORT_PSIV(port_cap->psi[i - 1])))
+				port_cap->psi_uid_count++;
 
 			xhci_dbg(xhci, "PSIV:%d PSIE:%d PLT:%d PFD:%d LP:%d PSIM:%d\n",
-				  XHCI_EXT_PORT_PSIV(rhub->psi[i]),
-				  XHCI_EXT_PORT_PSIE(rhub->psi[i]),
-				  XHCI_EXT_PORT_PLT(rhub->psi[i]),
-				  XHCI_EXT_PORT_PFD(rhub->psi[i]),
-				  XHCI_EXT_PORT_LP(rhub->psi[i]),
-				  XHCI_EXT_PORT_PSIM(rhub->psi[i]));
+				  XHCI_EXT_PORT_PSIV(port_cap->psi[i]),
+				  XHCI_EXT_PORT_PSIE(port_cap->psi[i]),
+				  XHCI_EXT_PORT_PLT(port_cap->psi[i]),
+				  XHCI_EXT_PORT_PFD(port_cap->psi[i]),
+				  XHCI_EXT_PORT_LP(port_cap->psi[i]),
+				  XHCI_EXT_PORT_PSIM(port_cap->psi[i]));
 		}
 	}
 	/* cache usb2 port capabilities */
@@ -2231,6 +2240,7 @@ static void xhci_add_in_port(struct xhci
 			continue;
 		}
 		hw_port->rhub = rhub;
+		hw_port->port_cap = port_cap;
 		rhub->num_ports++;
 	}
 	/* FIXME: Should we disable ports not in the Extended Capabilities? */
@@ -2321,6 +2331,11 @@ static int xhci_setup_port_arrays(struct
 	if (!xhci->ext_caps)
 		return -ENOMEM;
 
+	xhci->port_caps = kcalloc_node(cap_count, sizeof(*xhci->port_caps),
+				flags, dev_to_node(dev));
+	if (!xhci->port_caps)
+		return -ENOMEM;
+
 	offset = cap_start;
 
 	while (offset) {
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1704,11 +1704,21 @@ static inline unsigned int hcd_index(str
 	else
 		return 1;
 }
+
+struct xhci_port_cap {
+	u32			*psi;	/* array of protocol speed ID entries */
+	u8			psi_count;
+	u8			psi_uid_count;
+	u8			maj_rev;
+	u8			min_rev;
+};
+
 struct xhci_port {
 	__le32 __iomem		*addr;
 	int			hw_portnum;
 	int			hcd_portnum;
 	struct xhci_hub		*rhub;
+	struct xhci_port_cap	*port_cap;
 };
 
 struct xhci_hub {
@@ -1718,9 +1728,6 @@ struct xhci_hub {
 	/* supported prococol extended capabiliy values */
 	u8			maj_rev;
 	u8			min_rev;
-	u32			*psi;	/* array of protocol speed ID entries */
-	u8			psi_count;
-	u8			psi_uid_count;
 };
 
 /* There is one xhci_hcd structure per controller */
@@ -1882,6 +1889,9 @@ struct xhci_hcd {
 	/* cached usb2 extened protocol capabilites */
 	u32                     *ext_caps;
 	unsigned int            num_ext_caps;
+	/* cached extended protocol port capabilities */
+	struct xhci_port_cap	*port_caps;
+	unsigned int		num_port_caps;
 	/* Compliance Mode Recovery Data */
 	struct timer_list	comp_mode_recovery_timer;
 	u32			port_status_u0;



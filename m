Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D836637C722
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbhELP61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:58:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233811AbhELPx4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:53:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E31C761A2B;
        Wed, 12 May 2021 15:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833236;
        bh=T5rSBJd4plAcNx/h6/w8lHfaDh9/GyQPgP4Zl6nEL+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ol+HQyOrQZtH79eOOX2WkHEJ+xF5ue8Z+6BYVntHZl1cgQH7FIfpkc2lN2LCSmm+3
         Mt9DmjXUHWg+vit22C+bLJXS1xvVzxQf0GUbaPiNTDrFU4zgMWyfWJ9PQOXit2K4GK
         NET2jjQIMhJI+jygJKTW9zOskexfzffVtViCBLrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 027/601] FDDI: defxx: Bail out gracefully with unassigned PCI resource for CSR
Date:   Wed, 12 May 2021 16:41:44 +0200
Message-Id: <20210512144828.712953848@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit f626ca682912fab55dff15469ce893ae16b65c7e upstream.

Recent versions of the PCI Express specification have deprecated support
for I/O transactions and actually some PCIe host bridges, such as Power
Systems Host Bridge 4 (PHB4), do not implement them.

For those systems the PCI BARs that request a mapping in the I/O space
have the length recorded in the corresponding PCI resource set to zero,
which makes it unassigned:

# lspci -s 0031:02:04.0 -v
0031:02:04.0 FDDI network controller: Digital Equipment Corporation PCI-to-PDQ Interface Chip [PFI] FDDI (DEFPA) (rev 02)
	Subsystem: Digital Equipment Corporation FDDIcontroller/PCI (DEFPA)
	Flags: bus master, medium devsel, latency 136, IRQ 57, NUMA node 8
	Memory at 620c080020000 (32-bit, non-prefetchable) [size=128]
	I/O ports at <unassigned> [disabled]
	Memory at 620c080030000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [50] Power Management version 2
	Kernel driver in use: defxx
	Kernel modules: defxx

#

Regardless the driver goes ahead and requests it (here observed with a
Raptor Talos II POWER9 system), resulting in an odd /proc/ioport entry:

# cat /proc/ioports
00000000-ffffffffffffffff : 0031:02:04.0
#

Furthermore, the system gets confused as the driver actually continues
and pokes at those locations, causing a flood of messages being output
to the system console by the underlying system firmware, like:

defxx: v1.11 2014/07/01  Lawrence V. Stefani and others
defxx 0031:02:04.0: enabling device (0140 -> 0142)
LPC[000]: Got SYNC no-response error. Error address reg: 0xd0010000
IPMI: dropping non severe PEL event
LPC[000]: Got SYNC no-response error. Error address reg: 0xd0010014
IPMI: dropping non severe PEL event
LPC[000]: Got SYNC no-response error. Error address reg: 0xd0010014
IPMI: dropping non severe PEL event

and so on and so on (possibly intermixed actually, as there's no locking
between the kernel and the firmware in console port access with this
particular system, but cleaned up above for clarity), and once some 10k
of such pairs of the latter two messages have been produced an interace
eventually shows up in a useless state:

0031:02:04.0: DEFPA at I/O addr = 0x0, IRQ = 57, Hardware addr = 00-00-00-00-00-00

This was not expected to happen as resource handling was added to the
driver a while ago, because it was not known at that time that a PCI
system would be possible that cannot assign port I/O resources, and
oddly enough `request_region' does not fail, which would have caught it.

Correct the problem then by checking for the length of zero for the CSR
resource and bail out gracefully refusing to register an interface if
that turns out to be the case, producing messages like:

defxx: v1.11 2014/07/01  Lawrence V. Stefani and others
0031:02:04.0: Cannot use I/O, no address set, aborting
0031:02:04.0: Recompile driver with "CONFIG_DEFXX_MMIO=y"

Keep the original check for the EISA MMIO resource as implemented,
because in that case the length is hardwired to 0x400 as a consequence
of how the compare/mask address decoding works in the ESIC chip and it
is only the base address that is set to zero if MMIO has been disabled
for the adapter in EISA configuration, which in turn could be a valid
bus address in a legacy-free system implementing PCI, especially for
port I/O.

Where the EISA MMIO resource has been disabled for the adapter in EISA
configuration this arrangement keeps producing messages like:

eisa 00:05: EISA: slot 5: DEC3002 detected
defxx: v1.11 2014/07/01  Lawrence V. Stefani and others
00:05: Cannot use MMIO, no address set, aborting
00:05: Recompile driver with "CONFIG_DEFXX_MMIO=n"
00:05: Or run ECU and set adapter's MMIO location

with the last two lines now swapped for easier handling in the driver.

There is no need to check for and catch the case of a port I/O resource
not having been assigned for EISA as the adapter uses the slot-specific
I/O space, which gets assigned by how EISA has been specified and maps
directly to the particular slot an option card has been placed in.  And
the EISA variant of the adapter has additional registers that are only
accessible via the port I/O space anyway.

While at it factor out the error message calls into helpers and fix an
argument order bug with the `pr_err' call now in `dfx_register_res_err'.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: 4d0438e56a8f ("defxx: Clean up DEFEA resource management")
Cc: stable@vger.kernel.org # v3.19+
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/fddi/defxx.c |   47 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

--- a/drivers/net/fddi/defxx.c
+++ b/drivers/net/fddi/defxx.c
@@ -495,6 +495,25 @@ static const struct net_device_ops dfx_n
 	.ndo_set_mac_address	= dfx_ctl_set_mac_address,
 };
 
+static void dfx_register_res_alloc_err(const char *print_name, bool mmio,
+				       bool eisa)
+{
+	pr_err("%s: Cannot use %s, no address set, aborting\n",
+	       print_name, mmio ? "MMIO" : "I/O");
+	pr_err("%s: Recompile driver with \"CONFIG_DEFXX_MMIO=%c\"\n",
+	       print_name, mmio ? 'n' : 'y');
+	if (eisa && mmio)
+		pr_err("%s: Or run ECU and set adapter's MMIO location\n",
+		       print_name);
+}
+
+static void dfx_register_res_err(const char *print_name, bool mmio,
+				 unsigned long start, unsigned long len)
+{
+	pr_err("%s: Cannot reserve %s resource 0x%lx @ 0x%lx, aborting\n",
+	       print_name, mmio ? "MMIO" : "I/O", len, start);
+}
+
 /*
  * ================
  * = dfx_register =
@@ -568,15 +587,12 @@ static int dfx_register(struct device *b
 	dev_set_drvdata(bdev, dev);
 
 	dfx_get_bars(bdev, bar_start, bar_len);
-	if (dfx_bus_eisa && dfx_use_mmio && bar_start[0] == 0) {
-		pr_err("%s: Cannot use MMIO, no address set, aborting\n",
-		       print_name);
-		pr_err("%s: Run ECU and set adapter's MMIO location\n",
-		       print_name);
-		pr_err("%s: Or recompile driver with \"CONFIG_DEFXX_MMIO=n\""
-		       "\n", print_name);
+	if (bar_len[0] == 0 ||
+	    (dfx_bus_eisa && dfx_use_mmio && bar_start[0] == 0)) {
+		dfx_register_res_alloc_err(print_name, dfx_use_mmio,
+					   dfx_bus_eisa);
 		err = -ENXIO;
-		goto err_out;
+		goto err_out_disable;
 	}
 
 	if (dfx_use_mmio)
@@ -585,18 +601,16 @@ static int dfx_register(struct device *b
 	else
 		region = request_region(bar_start[0], bar_len[0], print_name);
 	if (!region) {
-		pr_err("%s: Cannot reserve %s resource 0x%lx @ 0x%lx, "
-		       "aborting\n", dfx_use_mmio ? "MMIO" : "I/O", print_name,
-		       (long)bar_len[0], (long)bar_start[0]);
+		dfx_register_res_err(print_name, dfx_use_mmio,
+				     bar_start[0], bar_len[0]);
 		err = -EBUSY;
 		goto err_out_disable;
 	}
 	if (bar_start[1] != 0) {
 		region = request_region(bar_start[1], bar_len[1], print_name);
 		if (!region) {
-			pr_err("%s: Cannot reserve I/O resource "
-			       "0x%lx @ 0x%lx, aborting\n", print_name,
-			       (long)bar_len[1], (long)bar_start[1]);
+			dfx_register_res_err(print_name, 0,
+					     bar_start[1], bar_len[1]);
 			err = -EBUSY;
 			goto err_out_csr_region;
 		}
@@ -604,9 +618,8 @@ static int dfx_register(struct device *b
 	if (bar_start[2] != 0) {
 		region = request_region(bar_start[2], bar_len[2], print_name);
 		if (!region) {
-			pr_err("%s: Cannot reserve I/O resource "
-			       "0x%lx @ 0x%lx, aborting\n", print_name,
-			       (long)bar_len[2], (long)bar_start[2]);
+			dfx_register_res_err(print_name, 0,
+					     bar_start[2], bar_len[2]);
 			err = -EBUSY;
 			goto err_out_bh_region;
 		}



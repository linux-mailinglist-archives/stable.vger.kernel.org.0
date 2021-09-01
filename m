Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3BE3FDEAF
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 17:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244357AbhIAPcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 11:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbhIAPcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 11:32:10 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B1BC061575;
        Wed,  1 Sep 2021 08:31:13 -0700 (PDT)
Received: from miraculix.mork.no ([IPv6:2a01:799:95f:ef0a:7f0c:624e:2eac:9b4])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 181FUrwF231747
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 1 Sep 2021 17:30:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1630510254; bh=kB8uHPcQYTLKNgH1hQavhsoLfyF0XlgJ1dauCZyeMeM=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=W6sRTMYq6hTzsg0liRbrzi/OV2oix8EDW7HxdnLjQRues32IxAwZLRcaSzItcBONW
         u9XPvdFBi4JmhLdlNBQiy6mvzxK2RiLTcxFJwKVUvGmN6ExWsAt/xa+PmjcX7h+BqT
         EL2Z+IMfAeGrOcpDYRG0hdjZvv6s5P4z/IT4HPnc=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1mLSCO-000aHE-AC; Wed, 01 Sep 2021 17:30:48 +0200
From:   =?utf-8?Q?Bj=C3=B8rn?= Mork <bjorn@mork.no>
To:     Mathias Nyman <mathias.nyman@intel.com>
Cc:     linux-usb@vger.kernel.org,
        Jonathan Bell <jonathan@raspberrypi.org>,
        stable@vger.kernel.org, =?utf-8?Q?Bj=C3=B8rn?= Mork <bjorn@mork.no>
Subject: [PATCH v2 RESEND] xhci: add quirk for host controllers that don't
 update endpoint DCS
References: <87h7hdf5dy.fsf@miraculix.mork.no>
Date:   Wed, 01 Sep 2021 17:30:48 +0200
Message-ID: <87tuj4jot3.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.2 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Bell <jonathan@raspberrypi.org>

Seen on a VLI VL805 PCIe to USB controller. For non-stream endpoints
at least, if the xHC halts on a particular TRB due to an error then
the DCS field in the Out Endpoint Context maintained by the hardware
is not updated with the current cycle state.

Using the quirk XHCI_EP_CTX_BROKEN_DCS and instead fetch the DCS bit
from the TRB that the xHC stopped on.

[ bjorn: rebased to v5.14-rc2 ]
Cc: stable@vger.kernel.org
Link: https://github.com/raspberrypi/linux/issues/3060
Signed-off-by: Jonathan Bell <jonathan@raspberrypi.org>
Signed-off-by: Bj=C3=B8rn Mork <bjorn@mork.no>
---
[ resending this as I haven't seen any ack/nak and wonder if it might
  have gotten lost in a large pile of vacation backlog ]


This took some time...

But now it is at least build and runtime tested on top of v5.14-rc2,
using an RPi4 and a generic RTL2838 DVB-T radio.  Running rtl_test
from rtl-sdr on an unpatched v5.14-rc2:


root@idefix:/home/bjorn#  rtl_test
Found 1 device(s):
  0:  Realtek, RTL2838UHIDIR, SN: 00000001

Using device 0: Generic RTL2832U OEM
rtlsdr_read_reg failed with -7
rtlsdr_write_reg failed with -7
rtlsdr_read_reg failed with -7
rtlsdr_write_reg failed with -7
rtlsdr_read_reg failed with -7
rtlsdr_write_reg failed with -7
rtlsdr_read_reg failed with -7
rtlsdr_write_reg failed with -7
No supported tuner found
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
Enabled direct sampling mode, input 1
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
Supported gain values (1): 0.0=20
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
WARNING: Failed to set sample rate.
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_write_reg failed with -7
rtlsdr_write_reg failed with -7

Info: This tool will continuously read from the device, and report if
samples get lost. If you observe no further output, everything is fine.

Reading samples in async mode...
Allocating 15 zero-copy buffers



And with this fix in place:



root@idefix:/home/bjorn# rtl_test
Found 1 device(s):
  0:  Realtek, RTL2838UHIDIR, SN: 00000001

Using device 0: Generic RTL2832U OEM
Detached kernel driver
Found Fitipower FC0012 tuner
Supported gain values (5): -9.9 -4.0 7.1 17.9 19.2=20
Sampling at 2048000 S/s.

Info: This tool will continuously read from the device, and report if
samples get lost. If you observe no further output, everything is fine.

Reading samples in async mode...
Allocating 15 zero-copy buffers
lost at least 88 bytes



Please apply to stable as well. I'd really like to see this fixed in
my favourite distro kernel.  You'll probably want Jonathans original
patch, as posted in <20210702071338.42777-1-bjorn@mork.no>, for
anything older than v5.12.  I'll resend that for stable once/if this
is accepted in mainline.



Bj=C3=B8rn


 drivers/usb/host/xhci-pci.c  |  4 +++-
 drivers/usb/host/xhci-ring.c | 25 ++++++++++++++++++++++++-
 drivers/usb/host/xhci.h      |  1 +
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 18c2bbddf080..6f3bed09028c 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -279,8 +279,10 @@ static void xhci_pci_quirks(struct device *dev, struct=
 xhci_hcd *xhci)
 			pdev->device =3D=3D 0x3432)
 		xhci->quirks |=3D XHCI_BROKEN_STREAMS;
=20
-	if (pdev->vendor =3D=3D PCI_VENDOR_ID_VIA && pdev->device =3D=3D 0x3483)
+	if (pdev->vendor =3D=3D PCI_VENDOR_ID_VIA && pdev->device =3D=3D 0x3483) {
 		xhci->quirks |=3D XHCI_LPM_SUPPORT;
+		xhci->quirks |=3D XHCI_EP_CTX_BROKEN_DCS;
+	}
=20
 	if (pdev->vendor =3D=3D PCI_VENDOR_ID_ASMEDIA &&
 		pdev->device =3D=3D PCI_DEVICE_ID_ASMEDIA_1042_XHCI)
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 8fea44bbc266..ba978a8fa414 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -559,8 +559,11 @@ static int xhci_move_dequeue_past_td(struct xhci_hcd *=
xhci,
 	struct xhci_ring *ep_ring;
 	struct xhci_command *cmd;
 	struct xhci_segment *new_seg;
+	struct xhci_segment *halted_seg =3D NULL;
 	union xhci_trb *new_deq;
 	int new_cycle;
+	union xhci_trb *halted_trb;
+	int index =3D 0;
 	dma_addr_t addr;
 	u64 hw_dequeue;
 	bool cycle_found =3D false;
@@ -598,7 +601,27 @@ static int xhci_move_dequeue_past_td(struct xhci_hcd *=
xhci,
 	hw_dequeue =3D xhci_get_hw_deq(xhci, dev, ep_index, stream_id);
 	new_seg =3D ep_ring->deq_seg;
 	new_deq =3D ep_ring->dequeue;
-	new_cycle =3D hw_dequeue & 0x1;
+
+	/*
+	 * Quirk: xHC write-back of the DCS field in the hardware dequeue
+	 * pointer is wrong - use the cycle state of the TRB pointed to by
+	 * the dequeue pointer.
+	 */
+	if (xhci->quirks & XHCI_EP_CTX_BROKEN_DCS &&
+	    !(ep->ep_state & EP_HAS_STREAMS))
+		halted_seg =3D trb_in_td(xhci, td->start_seg,
+				       td->first_trb, td->last_trb,
+				       hw_dequeue & ~0xf, false);
+	if (halted_seg) {
+		index =3D ((dma_addr_t)(hw_dequeue & ~0xf) - halted_seg->dma) /
+			 sizeof(*halted_trb);
+		halted_trb =3D &halted_seg->trbs[index];
+		new_cycle =3D halted_trb->generic.field[3] & 0x1;
+		xhci_dbg(xhci, "Endpoint DCS =3D %d TRB index =3D %d cycle =3D %d\n",
+			 (u8)(hw_dequeue & 0x1), index, new_cycle);
+	} else {
+		new_cycle =3D hw_dequeue & 0x1;
+	}
=20
 	/*
 	 * We want to find the pointer, segment and cycle state of the new trb
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 3c7d281672ae..911aeb7d8a19 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1896,6 +1896,7 @@ struct xhci_hcd {
 #define XHCI_SG_TRB_CACHE_SIZE_QUIRK	BIT_ULL(39)
 #define XHCI_NO_SOFT_RETRY	BIT_ULL(40)
 #define XHCI_BROKEN_D3COLD	BIT_ULL(41)
+#define XHCI_EP_CTX_BROKEN_DCS	BIT_ULL(42)
=20
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
--=20
2.20.1


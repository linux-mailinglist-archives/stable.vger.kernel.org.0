Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07A7273086
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgIURFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 13:05:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726886AbgIUQdf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:33:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE0C12396F;
        Mon, 21 Sep 2020 16:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706014;
        bh=WDhNPPEYNtmQ25KI64ic4H434rTkrIJzlLjK2327UWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cr/sn+6WZrYD5T63nXxVvAmGLlgAz9ggHPynb0Fcb9lySnwt+aYFcCT2fTecOoYoP
         jfGz7cZR2oc1GMfe0SG2D65chx3ph8ogBaNyqvZdIM/QAnYolHPWYL0IwND8Wp1dRw
         zQy2UU+TGSjd6Tu50WA0zM3sv+/uI2LTsNEce21c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Diedrich <tobiasdiedrich@gmail.com>
Subject: [PATCH 4.4 43/46] serial: 8250_pci: Add Realtek 816a and 816b
Date:   Mon, 21 Sep 2020 18:27:59 +0200
Message-Id: <20200921162035.255862443@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162033.346434578@linuxfoundation.org>
References: <20200921162033.346434578@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Diedrich <tobiasdiedrich@gmail.com>

commit 3c5a87be170aba8ac40982182f812dcff6ed1ad1 upstream.

These serial ports are exposed by the OOB-management-engine on
RealManage-enabled network cards (e.g. AMD DASH enabled systems using
Realtek cards).

Because these have 3 BARs, they fail the "num_iomem <= 1" check in
serial_pci_guess_board.

I've manually checked the two IOMEM regions and BAR 2 doesn't seem to
respond to reads, but BAR 4 seems to be an MMIO version of the IO ports
(untested).

With this change, the ports are detected:
0000:02:00.1: ttyS0 at I/O 0x2200 (irq = 82, base_baud = 115200) is a 16550A
0000:02:00.2: ttyS1 at I/O 0x2100 (irq = 55, base_baud = 115200) is a 16550A

lspci output:
02:00.1 0700: 10ec:816a (rev 0e) (prog-if 02 [16550])
        Subsystem: 17aa:5082
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort+ <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin B routed to IRQ 82
        IOMMU group: 11
        Region 0: I/O ports at 2200 [size=256]
        Region 2: Memory at fd715000 (64-bit, non-prefetchable) [size=4K]
        Region 4: Memory at fd704000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express (v2) Endpoint, MSI 01
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- SlotPowerLimit 0.000W
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s unlimited, L1 <64us
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes, Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s (ok), Width x1 (ok)
                        TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ NROPrPrP- LTR+
                         10BitTagComp- 10BitTagReq- OBFF Via message/WAKE#, ExtFmt- EETLPPrefix-
                         EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
                         FRS- TPHComp- ExtTPHComp-
                         AtomicOpsCap: 32bit- 64bit- 128bitCAS-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- LTR- OBFF Disabled,
                         AtomicOpsCtl: ReqEn-
                LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete- EqualizationPhase1-
                         EqualizationPhase2- EqualizationPhase3- LinkEqualizationRequest-
                         Retimer- 2Retimers- CrosslinkRes: unsupported
        Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
                Vector table: BAR=4 offset=00000000
                PBA: BAR=4 offset=00000800
        Capabilities: [d0] Vital Product Data
                Not readable
        Capabilities: [100 v2] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
                AERCap: First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
                        MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                HeaderLog: 00000000 00000000 00000000 00000000
        Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
        Capabilities: [170 v1] Latency Tolerance Reporting
                Max snoop latency: 0ns
                Max no snoop latency: 0ns
        Capabilities: [178 v1] L1 PM Substates
                L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
                          PortCommonModeRestoreTime=150us PortTPowerOnTime=150us
                L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
                           T_CommonMode=0us LTR1.2_Threshold=0ns
                L1SubCtl2: T_PwrOn=10us
02:00.2 0700: 10ec:816b (rev 0e)
[...same...]

Signed-off-by: Tobias Diedrich <tobiasdiedrich@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200914173628.GA22508@yamamaya.is-a-geek.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250_pci.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -5904,6 +5904,17 @@ static struct pci_device_id serial_pci_t
 		0,
 		0, pbn_exar_XR17V358 },
 
+	/*
+	 * Realtek RealManage
+	 */
+	{	PCI_VENDOR_ID_REALTEK, 0x816a,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0, pbn_b0_1_115200 },
+
+	{	PCI_VENDOR_ID_REALTEK, 0x816b,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0, pbn_b0_1_115200 },
+
 	/* Fintek PCI serial cards */
 	{ PCI_DEVICE(0x1c29, 0x1104), .driver_data = pbn_fintek_4 },
 	{ PCI_DEVICE(0x1c29, 0x1108), .driver_data = pbn_fintek_8 },



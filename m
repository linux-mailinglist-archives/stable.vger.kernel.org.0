Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5965F6AA342
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbjCCV4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233405AbjCCVz3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:55:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFEB74A5F;
        Fri,  3 Mar 2023 13:49:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC5DD618F1;
        Fri,  3 Mar 2023 21:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC0EC433D2;
        Fri,  3 Mar 2023 21:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677880145;
        bh=G8sIEVkx4Mtn6htfaruerLL/UggeVQ7DBwczQQKcCII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dUb+7ADjzKb+c9hfjzg5EFr7+2ViLIdgZqgY6GLWvGtcSibQB4CX4FIVTLXL6mA6o
         86cFPaavkwlD6k1rmqdUqOP92ARhA7VwdkoI3nuGsSfk9bMxkH/hfkmmTn/JZKqlO1
         6gMFv/ZfXdD5vBMFYiC+3A1DpR+12JcYyBa//5tnEKD9B6mO4f7V4jTEPiHaPMu3gl
         hfQQbpTolASPm4kXzWBogd8SwA4cF1f+tnrhNyv5KqzS8RrB5DSqwqWERXQ7yqBDWD
         DySC1j1flvUYGqxmJGHpDGz6Zn91oZtHZzX+EdGwOHZbv71YZfknhVV4OD2lpxw62a
         EVl5SlXY4TeBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 08/16] parport_pc: Set up mode and ECR masks for Oxford Semiconductor devices
Date:   Fri,  3 Mar 2023 16:48:41 -0500
Message-Id: <20230303214849.1454002-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214849.1454002-1-sashal@kernel.org>
References: <20230303214849.1454002-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Maciej W. Rozycki" <macro@orcam.me.uk>

[ Upstream commit c087df8d1e7dc2e764d11234d84b5af46d500f16 ]

No Oxford Semiconductor PCI or PCIe parallel port device supports the
Parallel Port FIFO mode.  All support the PS/2 Parallel Port mode and
the Enhanced Parallel Port mode via the ECR register.  The original 5V
PCI OX16PCI954 device does not support the Extended Capabilities Port
mode, the Test mode or the Configuration mode, but all the other OxSemi
devices do, including in particular the 3.3V PCI OXmPCI954 device and
the universal voltage PCI OXuPCI954 device.  All the unsupported modes
are marked reserved in the relevant datasheets.

Accordingly enable the `base_hi' BAR for the 954 devices to enable PS2
and EPP mode support via the ECR register, however mask the COMPAT mode
and, until we have a way to determine what chip variant it is that we
poke at, also the ECP mode, and mask the COMPAT mode only for all the
remaining OxSemi devices, fixing errors like:

parport0: FIFO is stuck
FIFO write timed out

and a non-functional port when the Parallel Port FIFO mode is selected.

Complementing the fix apply an ECR mask for all these devices, which are
documented to only permit writing to the mode field of the ECR register
with a bit pattern of 00001 required to be written to bits 4:0 on mode
field writes.  No nFault or service interrupts are implemented, which
will therefore never have to be enabled, though bit 2 does report the
FIFO threshold status to be polled for in the ECP mode where supported.

We have a documented case of writing 1 to bit 2 causing a lock-up with
at least one OX12PCI840 device (from old drivers/parport/ChangeLog):

2001-10-10  Tim Waugh  <twaugh@redhat.com>

	* parport_pc.c: Support for OX12PCI840 PCI card (reported by
	mk@daveg.com).  Lock-ups diagnosed by Ronnie Arosa (and now we
	just don't trust its ECR).

which commit adbd321a17cc ("parport_pc: add base_hi BAR for oxsemi_840")
must have broken and by applying an ECR mask here we prevent the lock-up
from triggering.  This could have been the reason for requiring 00001 to
be written to bits 4:0 of ECR.

Update the inline comment accordingly; it has come from Linux 2.4.12
back in 2001 and predates the introduction of OXmPCI954 and OXuPCI954
devices that do support ECP.

References:

[1] "OX16PCI954 Integrated Quad UART and PCI interface", Oxford
    Semiconductor Ltd., Data Sheet Revision 1.3, Feb. 1999, Chapter 9
    "Bidirectional Parallel Port", pp. 53-55

[2] "OX16PCI952 Data Sheet, Integrated High Performance Dual UARTs,
    Parallel Port and 5.0v PCI interface", Oxford Semiconductor Ltd.,
    DS_B008A_00, Datasheet rev 1.1, June 2001, Chapter 8 "Bi-directional
    Parallel Port", pp. 52-56

[3] "OXmPCI954 DATA SHEET Integrated High Performance Quad UARTs, 8-bit
    Local Bus/Parallel Port. 3.3v PCI/miniPCI interface.", Oxford
    Semiconductor Ltd., DS-0019, June 2005, Chapter 10 "Bidirectional
    Parallel Port", pp. 86-90

[4] "OXmPCI952 Data Sheet, Integrated High Performance Dual UARTs, 8-bit
    Local Bus/Parallel Port. 3.3v PCI/miniPCI interface.", Oxford
    Semiconductor Ltd., DS-0020, June 2005, Chapter 8 "Bidirectional
    Parallel Port", pp. 73-77

[5] "OX12PCI840 Integrated Parallel Port and PCI interface", Oxford
    Semiconductor Ltd., DS-0021, Jun 2005, Chapter 5 "Bi-directional
    Parallel Port", pp. 18-21

[6] "OXPCIe952 PCI Express Bridge to Dual Serial & Parallel Port",
    Oxford Semiconductor, Inc., DS-0046, Mar 06 08, Chapter "Parallel
    Port Function", pp. 59-62

[7] "OXPCIe840 PCI Express Bridge to Parallel Port", Oxford
    Semiconductor, Inc., DS-0049, Mar 06 08, Chapter "Parallel Port
    Function", pp. 15-18

[8] "OXuPCI954 Data Sheet, Integrated High Performance Quad UARTs, 8-bit
    Local Bus/Parallel Port, 3.3 V and 5 V (Universal Voltage) PCI
    Interface.", Oxford Semiconductor, Inc., DS-0058, 26 Jan 2009,
    Chapter 8 "Bidirectional Parallel Port", pp. 62-65

[9] "OXuPCI952 Data Sheet, Integrated High Performance Dual UARTs, 8-bit
    Local Bus/Parallel Port, 3.3 V and 5.0 V Universal Voltage PCI
    Interface.", Oxford Semiconductor, Inc., DS-0059, Sep 2007, Chapter
    8 "Bidirectional Parallel Port", pp. 61-64

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Link: https://lore.kernel.org/r/20230108215656.6433-6-sudipm.mukherjee@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/parport/parport_pc.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index d99ac73a1d89e..40c29e19f8647 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2691,12 +2691,19 @@ static struct parport_pc_pci {
 	/* titan_010l */		{ 1, { { 3, -1 }, } },
 	/* avlab_1p		*/	{ 1, { { 0, 1}, } },
 	/* avlab_2p		*/	{ 2, { { 0, 1}, { 2, 3 },} },
-	/* The Oxford Semi cards are unusual: 954 doesn't support ECP,
-	 * and 840 locks up if you write 1 to bit 2! */
-	/* oxsemi_952 */		{ 1, { { 0, 1 }, } },
-	/* oxsemi_954 */		{ 1, { { 0, -1 }, } },
-	/* oxsemi_840 */		{ 1, { { 0, 1 }, } },
-	/* oxsemi_pcie_pport */		{ 1, { { 0, 1 }, } },
+	/* The Oxford Semi cards are unusual: older variants of 954 don't
+	 * support ECP, and 840 locks up if you write 1 to bit 2!  None
+	 * implement nFault or service interrupts and all require 00001
+	 * bit pattern to be used for bits 4:0 with ECR writes. */
+	/* oxsemi_952 */		{ 1, { { 0, 1 }, },
+					  PARPORT_MODE_COMPAT, ECR_MODE_MASK },
+	/* oxsemi_954 */		{ 1, { { 0, 1 }, },
+					  PARPORT_MODE_ECP |
+					  PARPORT_MODE_COMPAT, ECR_MODE_MASK },
+	/* oxsemi_840 */		{ 1, { { 0, 1 }, },
+					  PARPORT_MODE_COMPAT, ECR_MODE_MASK },
+	/* oxsemi_pcie_pport */		{ 1, { { 0, 1 }, },
+					  PARPORT_MODE_COMPAT, ECR_MODE_MASK },
 	/* aks_0100 */                  { 1, { { 0, -1 }, } },
 	/* mobility_pp */		{ 1, { { 0, 1 }, } },
 
-- 
2.39.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099F035FDEB
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 00:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbhDNWjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 18:39:32 -0400
Received: from angie.orcam.me.uk ([157.25.102.26]:38926 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234218AbhDNWja (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 18:39:30 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 3C7FC9200B3; Thu, 15 Apr 2021 00:39:07 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 39DE492009E;
        Thu, 15 Apr 2021 00:39:07 +0200 (CEST)
Date:   Thu, 15 Apr 2021 00:39:07 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/5] scsi: BusLogic: Fix missing `pr_cont' use
In-Reply-To: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2104141419040.44318@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Update BusLogic driver's messaging system to use `pr_cont' for 
continuation lines, bringing messy output:

pci 0000:00:13.0: PCI->APIC IRQ transform: INT A -> IRQ 17
scsi: ***** BusLogic SCSI Driver Version 2.1.17 of 12 September 2013 *****
scsi: Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>
scsi0: Configuring BusLogic Model BT-958 PCI Wide Ultra SCSI Host Adapter
scsi0:   Firmware Version: 5.07B, I/O Address: 0x7000, IRQ Channel: 17/Level
scsi0:   PCI Bus: 0, Device: 19, Address:
0xE0012000,
Host Adapter SCSI ID: 7
scsi0:   Parity Checking: Enabled, Extended Translation: Enabled
scsi0:   Synchronous Negotiation: Ultra, Wide Negotiation: Enabled
scsi0:   Disconnect/Reconnect: Enabled, Tagged Queuing: Enabled
scsi0:   Scatter/Gather Limit: 128 of 8192 segments, Mailboxes: 211
scsi0:   Driver Queue Depth: 211, Host Adapter Queue Depth: 192
scsi0:   Tagged Queue Depth:
Automatic
, Untagged Queue Depth: 3
scsi0:   SCSI Bus Termination: Both Enabled
, SCAM: Disabled

scsi0: *** BusLogic BT-958 Initialized Successfully ***
scsi host0: BusLogic BT-958

back to order:

pci 0000:00:13.0: PCI->APIC IRQ transform: INT A -> IRQ 17
scsi: ***** BusLogic SCSI Driver Version 2.1.17 of 12 September 2013 *****
scsi: Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>
scsi0: Configuring BusLogic Model BT-958 PCI Wide Ultra SCSI Host Adapter
scsi0:   Firmware Version: 5.07B, I/O Address: 0x7000, IRQ Channel: 17/Level
scsi0:   PCI Bus: 0, Device: 19, Address: 0xE0012000, Host Adapter SCSI ID: 7
scsi0:   Parity Checking: Enabled, Extended Translation: Enabled
scsi0:   Synchronous Negotiation: Ultra, Wide Negotiation: Enabled
scsi0:   Disconnect/Reconnect: Enabled, Tagged Queuing: Enabled
scsi0:   Scatter/Gather Limit: 128 of 8192 segments, Mailboxes: 211
scsi0:   Driver Queue Depth: 211, Host Adapter Queue Depth: 192
scsi0:   Tagged Queue Depth: Automatic, Untagged Queue Depth: 3
scsi0:   SCSI Bus Termination: Both Enabled, SCAM: Disabled
scsi0: *** BusLogic BT-958 Initialized Successfully ***
scsi host0: BusLogic BT-958

Also diagnostic output such as with the `BusLogic=TraceConfiguration' 
parameter is affected and becomes vertical and therefore hard to read.  
This has now been corrected, e.g.:

pci 0000:00:13.0: PCI->APIC IRQ transform: INT A -> IRQ 17
blogic_cmd(86) Status = 30:  4 ==>  4: FF 05 93 00
blogic_cmd(95) Status = 28: (Modify I/O Address)
blogic_cmd(91) Status = 30:  1 ==>  1: 01
blogic_cmd(04) Status = 30:  4 ==>  4: 41 41 35 30
blogic_cmd(8D) Status = 30: 14 ==> 14: 45 DC 00 20 00 00 00 00 00 40 30 37 42 1D
scsi: ***** BusLogic SCSI Driver Version 2.1.17 of 12 September 2013 *****
scsi: Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>
blogic_cmd(04) Status = 30:  4 ==>  4: 41 41 35 30
blogic_cmd(0B) Status = 30:  3 ==>  3: 00 08 07
blogic_cmd(0D) Status = 30: 34 ==> 34: 03 01 07 04 00 00 00 00 00 00 00 00 00 00 00 00 FF 42 44 46 FF 00 00 00 00 00 00 00 00 00 FF 00 FF 00
blogic_cmd(8D) Status = 30: 14 ==> 14: 45 DC 00 20 00 00 00 00 00 40 30 37 42 1D
blogic_cmd(84) Status = 30:  1 ==>  1: 37
blogic_cmd(8B) Status = 30:  5 ==>  5: 39 35 38 20 20
blogic_cmd(85) Status = 30:  1 ==>  1: 42
blogic_cmd(86) Status = 30:  4 ==>  4: FF 05 93 00
blogic_cmd(91) Status = 30: 64 ==> 64: 41 46 3E 20 39 35 38 20 20 00 C4 00 04 01 07 2F 07 04 35 FF FF FF FF FF FF FF FF FF FF 01 00 FE FF 08 FF FF 00 00 00 00 00 00 00 01 00 01 00 00 FF FF 00 00 00 00 00 00 00 00 00 00 00 00 00 FC
scsi0: Configuring BusLogic Model BT-958 PCI Wide Ultra SCSI Host Adapter

etc.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: 4bcc595ccd80 ("printk: reinstate KERN_CONT for printing continuation lines")
Cc: stable@vger.kernel.org # v4.9+
---
 drivers/scsi/BusLogic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

linux-buslogic-pr-cont.diff
Index: linux-macro-ide/drivers/scsi/BusLogic.c
===================================================================
--- linux-macro-ide.orig/drivers/scsi/BusLogic.c
+++ linux-macro-ide/drivers/scsi/BusLogic.c
@@ -3603,7 +3603,7 @@ static void blogic_msg(enum blogic_msgle
 			if (buf[0] != '\n' || len > 1)
 				printk("%sscsi%d: %s", blogic_msglevelmap[msglevel], adapter->host_no, buf);
 		} else
-			printk("%s", buf);
+			pr_cont("%s", buf);
 	} else {
 		if (begin) {
 			if (adapter != NULL && adapter->adapter_initd)
@@ -3611,7 +3611,7 @@ static void blogic_msg(enum blogic_msgle
 			else
 				printk("%s%s", blogic_msglevelmap[msglevel], buf);
 		} else
-			printk("%s", buf);
+			pr_cont("%s", buf);
 	}
 	begin = (buf[len - 1] == '\n');
 }

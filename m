Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003024122A7
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351299AbhITSQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:16:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376695AbhITSOP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:14:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9607E6328D;
        Mon, 20 Sep 2021 17:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158482;
        bh=HLzcz2TEmRep3BzxUNjExyMyIAWZcVxLf5FnBbgQjYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y2Q+foer2sSffsvoA6gdUnAERaFw8EDZ7jUQZb/Ma7+MjGBY4kLTIfsuI0Otv7Xi5
         GErbW/tP1meGo7gXRTjvPo1t+USSuQYV00c1N8QNjCK1mI0jQKCrldM5YwROrgYX0r
         e3dJErpZjM6m9wPZmaEQepPf4YjOQu+DxwUSXZ+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Khalid Aziz <khalid@gonehiking.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 176/260] scsi: BusLogic: Fix missing pr_cont() use
Date:   Mon, 20 Sep 2021 18:43:14 +0200
Message-Id: <20210920163937.065149941@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 44d01fc86d952f5a8b8b32bdb4841504d5833d95 upstream.

Update BusLogic driver's messaging system to use pr_cont() for continuation
lines, bringing messy output:

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

Also diagnostic output such as with the BusLogic=TraceConfiguration
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

Link: https://lore.kernel.org/r/alpine.DEB.2.21.2104201940430.44318@angie.orcam.me.uk
Fixes: 4bcc595ccd80 ("printk: reinstate KERN_CONT for printing continuation lines")
Cc: stable@vger.kernel.org # v4.9+
Acked-by: Khalid Aziz <khalid@gonehiking.org>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/BusLogic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3601,7 +3601,7 @@ static void blogic_msg(enum blogic_msgle
 			if (buf[0] != '\n' || len > 1)
 				printk("%sscsi%d: %s", blogic_msglevelmap[msglevel], adapter->host_no, buf);
 		} else
-			printk("%s", buf);
+			pr_cont("%s", buf);
 	} else {
 		if (begin) {
 			if (adapter != NULL && adapter->adapter_initd)
@@ -3609,7 +3609,7 @@ static void blogic_msg(enum blogic_msgle
 			else
 				printk("%s%s", blogic_msglevelmap[msglevel], buf);
 		} else
-			printk("%s", buf);
+			pr_cont("%s", buf);
 	}
 	begin = (buf[len - 1] == '\n');
 }



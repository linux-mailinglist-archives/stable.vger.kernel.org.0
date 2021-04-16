Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D333D3628D8
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 21:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242760AbhDPTpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 15:45:09 -0400
Received: from mailout.easymail.ca ([64.68.200.34]:55850 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235907AbhDPTpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 15:45:09 -0400
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Apr 2021 15:45:08 EDT
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id BDED6C0DBE;
        Fri, 16 Apr 2021 19:34:46 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo04-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo04-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id I4-BX4Tq3JuR; Fri, 16 Apr 2021 19:34:46 +0000 (UTC)
Received: from mail.gonehiking.org (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        by mailout.easymail.ca (Postfix) with ESMTPA id 1B44BC270A;
        Fri, 16 Apr 2021 19:34:37 +0000 (UTC)
Received: from [192.168.1.4] (internal [192.168.1.4])
        by mail.gonehiking.org (Postfix) with ESMTP id C5BE23EE4F;
        Fri, 16 Apr 2021 13:34:36 -0600 (MDT)
Subject: Re: [PATCH 1/5] scsi: BusLogic: Fix missing `pr_cont' use
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
 <alpine.DEB.2.21.2104141419040.44318@angie.orcam.me.uk>
From:   Khalid Aziz <khalid@gonehiking.org>
Message-ID: <98a2ab05-e566-41f3-74b4-8b54563f4ae3@gonehiking.org>
Date:   Fri, 16 Apr 2021 13:34:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.2104141419040.44318@angie.orcam.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/14/21 4:39 PM, Maciej W. Rozycki wrote:
> Update BusLogic driver's messaging system to use `pr_cont' for 
> continuation lines, bringing messy output:
> 
> pci 0000:00:13.0: PCI->APIC IRQ transform: INT A -> IRQ 17
> scsi: ***** BusLogic SCSI Driver Version 2.1.17 of 12 September 2013 *****
> scsi: Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>
> scsi0: Configuring BusLogic Model BT-958 PCI Wide Ultra SCSI Host Adapter
> scsi0:   Firmware Version: 5.07B, I/O Address: 0x7000, IRQ Channel: 17/Level
> scsi0:   PCI Bus: 0, Device: 19, Address:
> 0xE0012000,
> Host Adapter SCSI ID: 7
> scsi0:   Parity Checking: Enabled, Extended Translation: Enabled
> scsi0:   Synchronous Negotiation: Ultra, Wide Negotiation: Enabled
> scsi0:   Disconnect/Reconnect: Enabled, Tagged Queuing: Enabled
> scsi0:   Scatter/Gather Limit: 128 of 8192 segments, Mailboxes: 211
> scsi0:   Driver Queue Depth: 211, Host Adapter Queue Depth: 192
> scsi0:   Tagged Queue Depth:
> Automatic
> , Untagged Queue Depth: 3
> scsi0:   SCSI Bus Termination: Both Enabled
> , SCAM: Disabled
> 
> scsi0: *** BusLogic BT-958 Initialized Successfully ***
> scsi host0: BusLogic BT-958
> 
> back to order:
> 
> pci 0000:00:13.0: PCI->APIC IRQ transform: INT A -> IRQ 17
> scsi: ***** BusLogic SCSI Driver Version 2.1.17 of 12 September 2013 *****
> scsi: Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>
> scsi0: Configuring BusLogic Model BT-958 PCI Wide Ultra SCSI Host Adapter
> scsi0:   Firmware Version: 5.07B, I/O Address: 0x7000, IRQ Channel: 17/Level
> scsi0:   PCI Bus: 0, Device: 19, Address: 0xE0012000, Host Adapter SCSI ID: 7
> scsi0:   Parity Checking: Enabled, Extended Translation: Enabled
> scsi0:   Synchronous Negotiation: Ultra, Wide Negotiation: Enabled
> scsi0:   Disconnect/Reconnect: Enabled, Tagged Queuing: Enabled
> scsi0:   Scatter/Gather Limit: 128 of 8192 segments, Mailboxes: 211
> scsi0:   Driver Queue Depth: 211, Host Adapter Queue Depth: 192
> scsi0:   Tagged Queue Depth: Automatic, Untagged Queue Depth: 3
> scsi0:   SCSI Bus Termination: Both Enabled, SCAM: Disabled
> scsi0: *** BusLogic BT-958 Initialized Successfully ***
> scsi host0: BusLogic BT-958
> 
> Also diagnostic output such as with the `BusLogic=TraceConfiguration' 
> parameter is affected and becomes vertical and therefore hard to read.  
> This has now been corrected, e.g.:
> 
> pci 0000:00:13.0: PCI->APIC IRQ transform: INT A -> IRQ 17
> blogic_cmd(86) Status = 30:  4 ==>  4: FF 05 93 00
> blogic_cmd(95) Status = 28: (Modify I/O Address)
> blogic_cmd(91) Status = 30:  1 ==>  1: 01
> blogic_cmd(04) Status = 30:  4 ==>  4: 41 41 35 30
> blogic_cmd(8D) Status = 30: 14 ==> 14: 45 DC 00 20 00 00 00 00 00 40 30 37 42 1D
> scsi: ***** BusLogic SCSI Driver Version 2.1.17 of 12 September 2013 *****
> scsi: Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>
> blogic_cmd(04) Status = 30:  4 ==>  4: 41 41 35 30
> blogic_cmd(0B) Status = 30:  3 ==>  3: 00 08 07
> blogic_cmd(0D) Status = 30: 34 ==> 34: 03 01 07 04 00 00 00 00 00 00 00 00 00 00 00 00 FF 42 44 46 FF 00 00 00 00 00 00 00 00 00 FF 00 FF 00
> blogic_cmd(8D) Status = 30: 14 ==> 14: 45 DC 00 20 00 00 00 00 00 40 30 37 42 1D
> blogic_cmd(84) Status = 30:  1 ==>  1: 37
> blogic_cmd(8B) Status = 30:  5 ==>  5: 39 35 38 20 20
> blogic_cmd(85) Status = 30:  1 ==>  1: 42
> blogic_cmd(86) Status = 30:  4 ==>  4: FF 05 93 00
> blogic_cmd(91) Status = 30: 64 ==> 64: 41 46 3E 20 39 35 38 20 20 00 C4 00 04 01 07 2F 07 04 35 FF FF FF FF FF FF FF FF FF FF 01 00 FE FF 08 FF FF 00 00 00 00 00 00 00 01 00 01 00 00 FF FF 00 00 00 00 00 00 00 00 00 00 00 00 00 FC
> scsi0: Configuring BusLogic Model BT-958 PCI Wide Ultra SCSI Host Adapter
> 
> etc.
> 
> Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
> Fixes: 4bcc595ccd80 ("printk: reinstate KERN_CONT for printing continuation lines")
> Cc: stable@vger.kernel.org # v4.9+
> ---
>  drivers/scsi/BusLogic.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> linux-buslogic-pr-cont.diff
> Index: linux-macro-ide/drivers/scsi/BusLogic.c
> ===================================================================
> --- linux-macro-ide.orig/drivers/scsi/BusLogic.c
> +++ linux-macro-ide/drivers/scsi/BusLogic.c
> @@ -3603,7 +3603,7 @@ static void blogic_msg(enum blogic_msgle
>  			if (buf[0] != '\n' || len > 1)
>  				printk("%sscsi%d: %s", blogic_msglevelmap[msglevel], adapter->host_no, buf);
>  		} else
> -			printk("%s", buf);
> +			pr_cont("%s", buf);
>  	} else {
>  		if (begin) {
>  			if (adapter != NULL && adapter->adapter_initd)
> @@ -3611,7 +3611,7 @@ static void blogic_msg(enum blogic_msgle
>  			else
>  				printk("%s%s", blogic_msglevelmap[msglevel], buf);
>  		} else
> -			printk("%s", buf);
> +			pr_cont("%s", buf);
>  	}
>  	begin = (buf[len - 1] == '\n');
>  }
> 

Looks good.

Acked-by: Khalid Aziz <khalid@gonehiking.org>

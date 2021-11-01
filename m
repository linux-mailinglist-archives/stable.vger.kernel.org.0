Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A385441265
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 04:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhKADeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Oct 2021 23:34:36 -0400
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:56551 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230222AbhKADef (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Oct 2021 23:34:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1635737522; x=1667273522;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ETfMPM1juLpBJqaaEVCjIYmhWTdj7WsFNBaq0G+XEeE=;
  b=iNww5c2huLVDRlnpwtLxoCY3LqKtE8hORHzRPjJqyVFIE9FIoZCMN+p4
   Tfs1NfhyWYzE66iUP4EAFFQbCghaCvIoXuMUZvL+AN7jQifqhXwvGwzpl
   gVz2QZJrQn79Fpil4EkXtqZytzrw0OsWq4Oo+5iNgAToGOSoERaaX/IGQ
   E=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 31 Oct 2021 20:32:02 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2021 20:32:01 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7;
 Sun, 31 Oct 2021 20:32:01 -0700
Received: from hu-pkondeti-hyd.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7;
 Sun, 31 Oct 2021 20:31:58 -0700
Date:   Mon, 1 Nov 2021 09:01:54 +0530
From:   Pavan Kondeti <quic_pkondeti@quicinc.com>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
CC:     <quic_pkondeti@quicinc.com>, <youling257@gmail.com>,
        <pkondeti@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [RFT PATCH] xhci: Fix commad ring abort, write all 64 bits to
 CRCR register.
Message-ID: <20211101033154.GA28038@hu-pkondeti-hyd.qualcomm.com>
References: <e96e2a96-00c4-6e6b-fc5a-e4a881325dc0@linux.intel.com>
 <20211029125154.438152-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211029125154.438152-1-mathias.nyman@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mathias,

On Fri, Oct 29, 2021 at 03:51:54PM +0300, Mathias Nyman wrote:
> Turns out some xHC controllers require all 64 bits in the CRCR register
> to be written to execute a command abort.
> 
> The lower 32 bits containing the command abort bit is written first.
> In case the command ring stops before we write the upper 32 bits then
> hardware may use these upper bits to set the commnd ring dequeue pointer.
> 
> Solve this by making sure the upper 32 bits contain a valid command
> ring dequeue pointer.
> 
> The original patch that only wrote the first 32 to stop the ring went
> to stable, so this fix should go there as well.
> 
> Fixes: ff0e50d3564f ("xhci: Fix command ring pointer corruption while aborting a command")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/usb/host/xhci-ring.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index 311597bba80e..eaa49aef2935 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -366,7 +366,9 @@ static void xhci_handle_stopped_cmd_ring(struct xhci_hcd *xhci,
>  /* Must be called with xhci->lock held, releases and aquires lock back */
>  static int xhci_abort_cmd_ring(struct xhci_hcd *xhci, unsigned long flags)
>  {
> -	u32 temp_32;
> +	struct xhci_segment *new_seg	= xhci->cmd_ring->deq_seg;
> +	union xhci_trb *new_deq		= xhci->cmd_ring->dequeue;
> +	u64 crcr;
>  	int ret;
>  
>  	xhci_dbg(xhci, "Abort command ring\n");
> @@ -375,13 +377,18 @@ static int xhci_abort_cmd_ring(struct xhci_hcd *xhci, unsigned long flags)
>  
>  	/*
>  	 * The control bits like command stop, abort are located in lower
> -	 * dword of the command ring control register. Limit the write
> -	 * to the lower dword to avoid corrupting the command ring pointer
> -	 * in case if the command ring is stopped by the time upper dword
> -	 * is written.
> +	 * dword of the command ring control register.
> +	 * Some controllers require all 64 bits to be written to abort the ring.
> +	 * Make sure the upper dword is valid, pointing to the next command,
> +	 * avoiding corrupting the command ring pointer in case the command ring
> +	 * is stopped by the time the upper dword is written.
>  	 */
> -	temp_32 = readl(&xhci->op_regs->cmd_ring);
> -	writel(temp_32 | CMD_RING_ABORT, &xhci->op_regs->cmd_ring);
> +	next_trb(xhci, NULL, &new_seg, &new_deq);
> +	if (trb_is_link(new_deq))
> +		next_trb(xhci, NULL, &new_seg, &new_deq);
> +
> +	crcr = xhci_trb_virt_to_dma(new_seg, new_deq);
> +	xhci_write_64(xhci, crcr | CMD_RING_ABORT, &xhci->op_regs->cmd_ring);
>  
>  	/* Section 4.6.1.2 of xHCI 1.0 spec says software should also time the
>  	 * completion of the Command Abort operation. If CRR is not negated in 5

Thanks for the patch. I don't see any issues with this patch.

Feel free to add

Tested-by: Pavankumar Kondeti <quic_pkondeti@quicinc.com>

Thanks,
Pavan

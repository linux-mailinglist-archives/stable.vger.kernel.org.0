Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B1443FFAB
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 17:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhJ2PiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 11:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhJ2PiB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 11:38:01 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF4CC061570;
        Fri, 29 Oct 2021 08:35:32 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id n13-20020a9d710d000000b005558709b70fso7619486otj.10;
        Fri, 29 Oct 2021 08:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=wNuRdC2mdLygZCMwhJqb7d7w6iHdnqtIG+Bm+HZCIWI=;
        b=ELZyWqMWQNbxUlKf+BWPp1w58oWcH1XEfiWYAVELBOukOq9JADKT2N2UFJIjdDdG1U
         HbxLbqHSG2ixchOgXxxA9HfrhYZ3AzVvxWo6tDL5flsLV6H/++SNZ41+AdSIvRxtk7h1
         pHfyHJtBS7/BVcXtLl1HRlKwJkG+5k2bjaKFdbW0mIXtjk5Sd7IZmYTlzq/VFhyNbPLL
         OQAtow2JklUUcsEoegCkXmKMUToYmWv//AS+djoPFqyTXfzKNRTCPiLbsFkXcJNT9CJ+
         7saxsFX0c/l5F1yCb9E7IzBagPPBrx3EwPATkzFYkiP1OydX1rgoF7kFZIVRm/80rWWK
         GYAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=wNuRdC2mdLygZCMwhJqb7d7w6iHdnqtIG+Bm+HZCIWI=;
        b=nUDm6HDIy1lhhhBdV5Tdpf47sZWTri81DSa0nKpjgDmQuOJXKPOlErQBQhkHwrFaay
         O4X7wqh6JRf7LMeBfR/TsO5o/fn6ErcYK8sDHzWNzwAmigfm5eMW4XYty+DgF4iZFqxo
         TV79QuOITMMKw5vC8X8JTAWDnIUomSBoYZRb+FxpN9JWFXZOp/bIJMYdINggtrcxlAm8
         juqfJzAc9tlpygJxsM9DwVk+x47ohl/bF7Y0yHuj08CH3BeL2VygPDLBGiFZ+LHSz+sQ
         WeeYWs+qJjddQwHrW4qHUlt08BogXRiObLS91P9Po4cBgQ/51FZj2IrM7q3qj0HQBPzF
         lcRQ==
X-Gm-Message-State: AOAM530ANSmmRWp4uWEPnOXMyAg6iY0fSOwyT83wBlPKUtCrStkxz80O
        VXJSo0YmyvSKEua0pp+mLTXr5GmH+lx4XZJsK88=
X-Google-Smtp-Source: ABdhPJyQVFX0+CT3Hm73YhN/eQeIgpdAXF3BO5iZqskfTUOn52o44O6cS6YZlA4+/wzLCwjfvgHegSQKEPeAj82Csxw=
X-Received: by 2002:a9d:480b:: with SMTP id c11mr9510283otf.74.1635521732212;
 Fri, 29 Oct 2021 08:35:32 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6830:158:0:0:0:0 with HTTP; Fri, 29 Oct 2021 08:35:31
 -0700 (PDT)
In-Reply-To: <20211029125154.438152-1-mathias.nyman@linux.intel.com>
References: <e96e2a96-00c4-6e6b-fc5a-e4a881325dc0@linux.intel.com> <20211029125154.438152-1-mathias.nyman@linux.intel.com>
From:   youling 257 <youling257@gmail.com>
Date:   Fri, 29 Oct 2021 23:35:31 +0800
Message-ID: <CAOzgRdb4TRUxbKUcfLD6qPVw866BCHar2O0TiiEta7AFzW6T1Q@mail.gmail.com>
Subject: Re: [RFT PATCH] xhci: Fix commad ring abort, write all 64 bits to
 CRCR register.
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     quic_pkondeti@quicinc.com, pkondeti@codeaurora.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

test it can work for me.

2021-10-29 20:51 GMT+08:00, Mathias Nyman <mathias.nyman@linux.intel.com>:
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
> Fixes: ff0e50d3564f ("xhci: Fix command ring pointer corruption while
> aborting a command")
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
> @@ -366,7 +366,9 @@ static void xhci_handle_stopped_cmd_ring(struct xhci_hcd
> *xhci,
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
> @@ -375,13 +377,18 @@ static int xhci_abort_cmd_ring(struct xhci_hcd *xhci,
> unsigned long flags)
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
> --
> 2.25.1
>
>

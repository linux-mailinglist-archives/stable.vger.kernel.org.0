Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2083439986
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 17:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbhJYPD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 11:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233723AbhJYPDy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 11:03:54 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63343C061745;
        Mon, 25 Oct 2021 08:01:32 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id e59-20020a9d01c1000000b00552c91a99f7so15358528ote.6;
        Mon, 25 Oct 2021 08:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=A+S3HWQ2cNdNT0gvOR7pkAfIyvaWrJTHlMu3SNcQ49M=;
        b=eL5A9ckMmevcxpm0fssgqeCaYIczduVUZdVHZroOjCafLyKFo8dawBJXm4JdkwAcOj
         +VfO8SkAERS5rr7b8zsOKUonnAi/2ov+/bIZ2AeIEtCIYqN2Vf/+DROKQdNQhotwcXX/
         aMowPnoeJT/g7bYOla+kQMWih8p3h2lU00o43ZsSliRsRBCoxrDwcujryOAcpU61iY4Y
         xXBiCPgByYZU83Q/S5frJbiY9npvI8UbVlJu1XpNwdwGZCc9kpr0sktCVbE8XNH+QANx
         FYVJ1nPUuEJfj7fpyrrkIndOL5y/yYUqaY+C5g2ILhJNY19XfFWS1yhpB+jWrI+AxRza
         WUfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=A+S3HWQ2cNdNT0gvOR7pkAfIyvaWrJTHlMu3SNcQ49M=;
        b=kF1j1Rb9OpdAY4si8/ojQqyB3wEvxIofW6aVOGou+z6zlnc7GFOoTRTXWwFhUbTV+s
         OCvy8S/khH+dwsdxBV8jwZpLW7WaeRnjkghQeOrBFTz43bJTaFbOZsPGi2BNEtKh8kuA
         KuxZlM5uV4FLBN+b4YAhXeSHIaZs6SUXH6WIe2HBRQlxv/JwM87xOPHokQLkp2y+CddQ
         +OllrwL00pxCp6a+ZAar3fKejTvS2ohbC8VxJjo7CmzFCbqpVDnjTNutOQXvPfkrFhvf
         Ku+gNZEXglhlRtx+5AaDYvwJeCrNBC/zORQjLLq0d7xa1k5hvCxe47pFDxiL/Svu67Fu
         mGyA==
X-Gm-Message-State: AOAM531nx/OysbODs2CYtkV1dm/NVFcQshdbKiRUEyCJnYihy7unFbXe
        Tn5g+6czlOOe9B1Re1yiNNlbTx6oOwyUQW4qJSA=
X-Google-Smtp-Source: ABdhPJz5eN6QcT3GBTj2brE49su666LdeEUlL09hFdmLlFt8g5OXuYW5ycMDZcMOcStrzrL23zF73DIKaykQbgspG7c=
X-Received: by 2002:a9d:70c4:: with SMTP id w4mr13843313otj.170.1635174090284;
 Mon, 25 Oct 2021 08:01:30 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:4b15:0:0:0:0:0 with HTTP; Mon, 25 Oct 2021 08:01:29
 -0700 (PDT)
In-Reply-To: <8c3cd8f7-0bd1-0ec4-2f58-6122ae7ef270@linux.intel.com>
References: <20211008092547.3996295-5-mathias.nyman@linux.intel.com>
 <20211022105913.7671-1-youling257@gmail.com> <CAOzgRdY8+Wm-Ane==RQTvEe4aKa40+h1VF9JSg8WQsm-XH0ZCw@mail.gmail.com>
 <8c3cd8f7-0bd1-0ec4-2f58-6122ae7ef270@linux.intel.com>
From:   youling 257 <youling257@gmail.com>
Date:   Mon, 25 Oct 2021 23:01:29 +0800
Message-ID: <CAOzgRdb2MK5mVonatO7t9DcXwtK=MbDwdWreR+6dpqvEv7R0Fw@mail.gmail.com>
Subject: Re: [PATCH 4/5] xhci: Fix command ring pointer corruption while
 aborting a command
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        pkondeti@codeaurora.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

test this patch suspend resume usb can work.

2021-10-25 19:21 GMT+08:00, Mathias Nyman <mathias.nyman@linux.intel.com>:
> Hi
>
>>> This patch cause suspend to disk resume usb not work, xhci_hcd
>>> 0000:00:14.0:
>>> Abort failed to stop command ring: -110.
>
> Thanks for the report, this is odd.
>
> Could you double check that by reverting this patch resume start working
> again.
>
> If this is the case maybe we need to write all 64bits before this xHC
> hardware reacts to
> CRCR register changes.
>
> Maybe following changes on top of current patch could help:
>
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index 311597bba80e..32665637d5e5 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -366,7 +366,7 @@ static void xhci_handle_stopped_cmd_ring(struct xhci_hcd
> *xhci,
>  /* Must be called with xhci->lock held, releases and aquires lock back */
>  static int xhci_abort_cmd_ring(struct xhci_hcd *xhci, unsigned long flags)
>  {
> -	u32 temp_32;
> +	u64 crcr;
> 	int ret;
>
> 	xhci_dbg(xhci, "Abort command ring\n");
> @@ -375,13 +375,15 @@ static int xhci_abort_cmd_ring(struct xhci_hcd *xhci,
> unsigned long flags)
>
> 	/*
> 	 * The control bits like command stop, abort are located in lower
> -	 * dword of the command ring control register. Limit the write
> -	 * to the lower dword to avoid corrupting the command ring pointer
> -        * in case if the command ring is stopped by the time upper dword
> -	 * is written.
> +	 * dword of the command ring control register. Some hw require all
> +	 * 64 bits to be written, starting with lower dword.
> +	 * Make sure the upper dword is valid to avoid corrupting the command
> +	 * ring pointer in case if the command ring is stopped by the time upper
> +	 * dword is written.
> 	 */
> -	temp_32 = readl(&xhci->op_regs->cmd_ring);
> -	writel(temp_32 | CMD_RING_ABORT, &xhci->op_regs->cmd_ring);
> +	crcr = xhci_trb_virt_to_dma(xhci->cmd_ring->deq_seg,
> +				    xhci->cmd_ring->dequeue);
> +	xhci_write_64(xhci, crcr | CMD_RING_ABORT, &xhci->op_regs->cmd_ring);
>
> 	/* Section 4.6.1.2 of xHCI 1.0 spec says software should also time the
> 	 * completion of the Command Abort operation. If CRR is not negated in 5
>
> -Mathias
>

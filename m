Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591D048ACD7
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 12:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238840AbiAKLnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 06:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238505AbiAKLnR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 06:43:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A92C06173F;
        Tue, 11 Jan 2022 03:43:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ABA5615DC;
        Tue, 11 Jan 2022 11:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D113BC36AE3;
        Tue, 11 Jan 2022 11:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641901395;
        bh=9uyU6D52eqfoTsVr5gmME/6eiaArQyJc5nNnkFnGOz4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2rBsBBij62ZB6NYAvc3wG2R1APyUkNHWblCeKYCmDjqvtTPAjgMoTf5ppwpaV88Ih
         5fOoVtyTvSVW0QtCBDvKtwQEJLczko9kkGEHCAm0LhCMu/XyKJNEWNUWNCI8n57Bwk
         PL2xejwKXkw0q1KUkjb122Wbs0azr0mOvl5qfrsg=
Date:   Tue, 11 Jan 2022 12:43:12 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Puma Hsu <pumahsu@google.com>
Cc:     mathias.nyman@intel.com, s.shtylyov@omp.ru,
        albertccwang@google.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] xhci: re-initialize the HC during resume if HCE was
 set
Message-ID: <Yd1tUKhyZf26OVNQ@kroah.com>
References: <20211229112551.3483931-1-pumahsu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211229112551.3483931-1-pumahsu@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 29, 2021 at 07:25:51PM +0800, Puma Hsu wrote:
> When HCE(Host Controller Error) is set, it means an internal
> error condition has been detected. It needs to re-initialize
> the HC too.

What is "It" in the last sentence?

> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Puma Hsu <pumahsu@google.com>

What commit id does this fix?

> ---
> v2: Follow Sergey Shtylyov <s.shtylyov@omp.ru>'s comment.
> v3: Add stable@vger.kernel.org for stable release.
> 
>  drivers/usb/host/xhci.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index dc357cabb265..ab440ce8420f 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -1146,8 +1146,8 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
>  		temp = readl(&xhci->op_regs->status);
>  	}
>  
> -	/* If restore operation fails, re-initialize the HC during resume */
> -	if ((temp & STS_SRE) || hibernated) {
> +	/* If restore operation fails or HC error is detected, re-initialize the HC during resume */
> +	if ((temp & (STS_SRE | STS_HCE)) || hibernated) {

But if STS_HCE is set on suspend, that means the suspend was broken so
you wouldn't get here, right?

Or can the error happen between suspend and resume?

This seems like a big hammer for when the host controller throws an
error.  Why is this the only place that it should be checked for?  What
caused the error that can now allow it to be fixed?

thanks,

greg k-h

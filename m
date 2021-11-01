Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E814422EC
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 22:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhKAV5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 17:57:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230460AbhKAV5v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 17:57:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FFF060F56;
        Mon,  1 Nov 2021 21:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635803717;
        bh=IttxJbjqSqQ4EjhYacqo1cMnhiWRDiqyUoAeG7/SA7k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=fsebMmK2RiOL7K8GFQu1Ydapsfqor/akbI2z1+E8l3gwUdIurAYuLo/+sR2YyMYRN
         Sx0r7wQQs0AdyUzQutZNHYyGBKuKQqoYF8g6UABGM3hh0saO8d1ivGDhJXSiDuEUn+
         IBEeC0WR3rj6XH5Tzg3XPryPAxRiZJUwl7oLtIw6M0IHMVurChUMd4WAv17pnw1Yzg
         pmV3DTygBhgDEDuS1Y476YditYFD2NnlywIaqqavP2uY/tKKVjstlf7buB2QaYAFiZ
         zsFB9Ed8ZycualrwB30B9L8Snqv3TnxJjDiOMQ1I4XmPkzI8ng+hwSDEqB+auBq9Yv
         F+hRRBh9tdnVQ==
Date:   Mon, 1 Nov 2021 16:55:16 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Robin McCorkell <robin@mccorkell.me.uk>
Cc:     linux-pci@vger.kernel.org, stable@vger.kernel.org,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Nirmoy Das <nirmoy.das@amd.com>
Subject: Re: [PATCH v2] PCI: Limit REBAR quirk to just Sapphire RX 5600 XT
 Pulse
Message-ID: <20211101215516.GA554197@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026214513.25986-1-robin@mccorkell.me.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[+cc Christian, Nirmoy]

On Tue, Oct 26, 2021 at 10:44:59PM +0100, Robin McCorkell wrote:
> A particular RX 5600 device requires a hack in the rebar logic, but the
> current branch is too general and catches other devices too, breaking
> them. This patch changes the branch to be more selective on the
> particular revision.
> 
> This patch fixes intermittent freezes on other RX 5600 devices where the
> hack is unnecessary. Credit to all contributors in the linked issue on
> the AMD bug tracker.
> 
> See also: https://gitlab.freedesktop.org/drm/amd/-/issues/1707
> 
> Fixes: 907830b0fc9e ("PCI: Add a REBAR size quirk for Sapphire RX 5600 XT Pulse")
> Cc: stable@vger.kernel.org    # v5.12+
> Signed-off-by: Robin McCorkell <robin@mccorkell.me.uk>
> Reported-by: Simon May <@Socob on gitlab.freedesktop.com>
> Tested-by: Kain Centeno <@kaincenteno on gitlab.freedesktop.com>
> Tested-by: Tobias Jakobi <@tobiasjakobi on gitlab.freedesktop.com>
> Suggested-by: lijo lazar <@lijo on gitlab.freedesktop.com>

I'll wait for an ack from Christian on this one, since it doesn't seem
to make sense to him.

> ---
>  drivers/pci/pci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index ce2ab62b64cf..1fe75243019e 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -3647,7 +3647,7 @@ u32 pci_rebar_get_possible_sizes(struct pci_dev *pdev, int bar)
>  
>  	/* Sapphire RX 5600 XT Pulse has an invalid cap dword for BAR 0 */
>  	if (pdev->vendor == PCI_VENDOR_ID_ATI && pdev->device == 0x731f &&
> -	    bar == 0 && cap == 0x7000)
> +	    pdev->revision == 0xC1 && bar == 0 && cap == 0x7000)
>  		cap = 0x3f000;
>  
>  	return cap >> 4;
> -- 
> 2.31.1
> 

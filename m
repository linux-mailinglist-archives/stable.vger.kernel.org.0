Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0D3ED2535
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387963AbfJJIzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:55:33 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:41200 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387593AbfJJItY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 04:49:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Yxy1NmL9jhb0kt0QSZLJCKp5cELj9G+8v2WXfMq0H64=; b=GtwMhN2KWEOuKTLuMv0tQQwDZ
        GaQnKrfLTi05KNPd6OAnJGQZWnOP2QhIAqO7XRc0cwP/9YJ1DKXGvGESop7J+H6aBG9kmGPnbEbDl
        lZrFsgsD8ag/KTUu2fuhhW6jx15baV8Ym5X3B4roe9xDP5G32+ax4Ow9iPw6+wRDtMsRhGLgjqzvM
        +Jmo0B6F6TnxGgJsgv+czSv+hr3ZVl3QAl+JrXv0KCboRhrTDOcWFr60d3EszyDAxUMpNub62Hob/
        /qTiBSBTUyxhlxvOIhcI2jACLIGfusHy+vCZY1/oKJDg8BKkOkpd5flBFRoc+uHBaeUL58my10RYO
        d7HmdrjRA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:42302)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iIU8I-0006Yw-RN; Thu, 10 Oct 2019 09:49:15 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iIU8G-00006h-9b; Thu, 10 Oct 2019 09:49:12 +0100
Date:   Thu, 10 Oct 2019 09:49:12 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 5.3 076/148] mmc: sdhci-of-esdhc: set DMA snooping based
 on DMA coherence
Message-ID: <20191010084912.GI25745@shell.armlinux.org.uk>
References: <20191010083609.660878383@linuxfoundation.org>
 <20191010083615.965680999@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010083615.965680999@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 5th October, Christian Zigotzky <chzigotzky@xenosoft.de> reported a
problem with this on PowerPC (at a guess, it looks like there's a
PowerPC user of this where the DT does not mark the device as
dma-coherent, but the hardware requires it to be DMA coherent.)

However, despite sending a reply to him within minutes of his email
arriving, I've heard nothing since, so there's been no progress on
working out what is really going on.

Given that the reporter hasn't responded to my reply, I'm not sure
what we should be doing with this... maybe the reporter has solved
his problem, maybe he was using an incorrect DT, we just don't know.

On Thu, Oct 10, 2019 at 10:35:37AM +0200, Greg Kroah-Hartman wrote:
> From: Russell King <rmk+kernel@armlinux.org.uk>
> 
> commit 121bd08b029e03404c451bb237729cdff76eafed upstream.
> 
> We must not unconditionally set the DMA snoop bit; if the DMA API is
> assuming that the device is not DMA coherent, and the device snoops the
> CPU caches, the device can see stale cache lines brought in by
> speculative prefetch.
> 
> This leads to the device seeing stale data, potentially resulting in
> corrupted data transfers.  Commonly, this results in a descriptor fetch
> error such as:
> 
> mmc0: ADMA error
> mmc0: sdhci: ============ SDHCI REGISTER DUMP ===========
> mmc0: sdhci: Sys addr:  0x00000000 | Version:  0x00002202
> mmc0: sdhci: Blk size:  0x00000008 | Blk cnt:  0x00000001
> mmc0: sdhci: Argument:  0x00000000 | Trn mode: 0x00000013
> mmc0: sdhci: Present:   0x01f50008 | Host ctl: 0x00000038
> mmc0: sdhci: Power:     0x00000003 | Blk gap:  0x00000000
> mmc0: sdhci: Wake-up:   0x00000000 | Clock:    0x000040d8
> mmc0: sdhci: Timeout:   0x00000003 | Int stat: 0x00000001
> mmc0: sdhci: Int enab:  0x037f108f | Sig enab: 0x037f108b
> mmc0: sdhci: ACmd stat: 0x00000000 | Slot int: 0x00002202
> mmc0: sdhci: Caps:      0x35fa0000 | Caps_1:   0x0000af00
> mmc0: sdhci: Cmd:       0x0000333a | Max curr: 0x00000000
> mmc0: sdhci: Resp[0]:   0x00000920 | Resp[1]:  0x001d8a33
> mmc0: sdhci: Resp[2]:   0x325b5900 | Resp[3]:  0x3f400e00
> mmc0: sdhci: Host ctl2: 0x00000000
> mmc0: sdhci: ADMA Err:  0x00000009 | ADMA Ptr: 0x000000236d43820c
> mmc0: sdhci: ============================================
> mmc0: error -5 whilst initialising SD card
> 
> but can lead to other errors, and potentially direct the SDHCI
> controller to read/write data to other memory locations (e.g. if a valid
> descriptor is visible to the device in a stale cache line.)
> 
> Fix this by ensuring that the DMA snoop bit corresponds with the
> behaviour of the DMA API.  Since the driver currently only supports DT,
> use of_dma_is_coherent().  Note that device_get_dma_attr() can not be
> used as that risks re-introducing this bug if/when the driver is
> converted to ACPI.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/mmc/host/sdhci-of-esdhc.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> --- a/drivers/mmc/host/sdhci-of-esdhc.c
> +++ b/drivers/mmc/host/sdhci-of-esdhc.c
> @@ -495,7 +495,12 @@ static int esdhc_of_enable_dma(struct sd
>  		dma_set_mask_and_coherent(dev, DMA_BIT_MASK(40));
>  
>  	value = sdhci_readl(host, ESDHC_DMA_SYSCTL);
> -	value |= ESDHC_DMA_SNOOP;
> +
> +	if (of_dma_is_coherent(dev->of_node))
> +		value |= ESDHC_DMA_SNOOP;
> +	else
> +		value &= ~ESDHC_DMA_SNOOP;
> +
>  	sdhci_writel(host, value, ESDHC_DMA_SYSCTL);
>  	return 0;
>  }
> 
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up

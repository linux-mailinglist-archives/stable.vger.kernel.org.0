Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C46C3DFF61
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 10:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388225AbfJVI1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Oct 2019 04:27:10 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39896 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388155AbfJVI1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Oct 2019 04:27:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5NbtpQgTT3ENpHphUcwdOH97IrHrqerBCMB0wEN3nMk=; b=pbduPVqdXXEf/nzVVbslGra/k
        BxRhBecen5uPmXgQryPOFBlmOCcggPUfOYxHy8O8WvP5Hnb2Iwqm1BcBw+DFGMY1Od0XxLP+UHOb/
        pevLZaAB7MrMzzvmUdW3G6mJytz+sqcpNPnrhReSbNrAmQDOaV3rQxp5fOVvRBi1VST/JHnlyVwsA
        8WUghEu54Q0gpHJpleUalrUfJWM2fwiV9C4mieJElUlSaZcLZFepNTjSFPom/ReqyJXoQfRrlbLN6
        E05Tl1r5uKfJqtL8gPohtXgSiprme5nNjzedBHlmht/L3n6RAUi8y6rPgq0I689S1A9saT/MyxhY8
        qONVZyGPA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57534)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iMpV9-0005zQ-Is; Tue, 22 Oct 2019 09:26:47 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iMpV5-0004ON-Kj; Tue, 22 Oct 2019 09:26:43 +0100
Date:   Tue, 22 Oct 2019 09:26:43 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Richard Weinberger <richard@nod.at>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        Vignesh Raghavendra <vigneshr@ti.com>, stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        linux-mtd@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mtd: spear_smi: Fix nonalignment not handled in
 memcpy_toio
Message-ID: <20191022082643.GO25745@shell.armlinux.org.uk>
References: <20191018143643.29676-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191018143643.29676-1-miquel.raynal@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 18, 2019 at 04:36:43PM +0200, Miquel Raynal wrote:
> Any write with either dd or flashcp to a device driven by the
> spear_smi.c driver will pass through the spear_smi_cpy_toio()
> function. This function will get called for chunks of up to 256 bytes.
> If the amount of data is smaller, we may have a problem if the data
> length is not 4-byte aligned. In this situation, the kernel panics
> during the memcpy:
> 
>     # dd if=/dev/urandom bs=1001 count=1 of=/dev/mtd6
>     spear_smi_cpy_toio [620] dest c9070000, src c7be8800, len 256
>     spear_smi_cpy_toio [620] dest c9070100, src c7be8900, len 256
>     spear_smi_cpy_toio [620] dest c9070200, src c7be8a00, len 256
>     spear_smi_cpy_toio [620] dest c9070300, src c7be8b00, len 233
>     Unhandled fault: external abort on non-linefetch (0x808) at 0xc90703e8
>     [...]
>     PC is at memcpy+0xcc/0x330

I need the full oops if you want me to comment on this.

> 
> Workaround this issue by using the alternate _memcpy_toio() method
> which at least does not present the same problem.
> 
> Fixes: f18dbbb1bfe0 ("mtd: ST SPEAr: Add SMI driver for serial NOR flash")
> Cc: stable@vger.kernel.org
> Suggested-by: Boris Brezillon <boris.brezillon@collabora.com>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
> 
> Hello,
> 
> This patch could not be tested with a mainline kernel (only compiled)
> but was tested with a stable 4.14.x kernel. I have really no idea why
> memcpy fails in this situation that's why I propose this workaround
> but I bet there is something deeper not working.
> 
> Thanks,
> Miquèl
> 
>  drivers/mtd/devices/spear_smi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/devices/spear_smi.c b/drivers/mtd/devices/spear_smi.c
> index 986f81d2f93e..d888625a3244 100644
> --- a/drivers/mtd/devices/spear_smi.c
> +++ b/drivers/mtd/devices/spear_smi.c
> @@ -614,7 +614,7 @@ static inline int spear_smi_cpy_toio(struct spear_smi *dev, u32 bank,
>  	ctrlreg1 = readl(dev->io_base + SMI_CR1);
>  	writel((ctrlreg1 | WB_MODE) & ~SW_MODE, dev->io_base + SMI_CR1);
>  
> -	memcpy_toio(dest, src, len);
> +	_memcpy_toio(dest, src, len);
>  
>  	writel(ctrlreg1, dev->io_base + SMI_CR1);
>  
> -- 
> 2.20.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up

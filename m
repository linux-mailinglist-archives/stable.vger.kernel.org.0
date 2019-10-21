Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35CC8DE5B7
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 10:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfJUIBQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 21 Oct 2019 04:01:16 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59992 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbfJUIBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 04:01:16 -0400
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id F298A2808D3;
        Mon, 21 Oct 2019 09:01:13 +0100 (BST)
Date:   Mon, 21 Oct 2019 10:01:05 +0200
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Richard Weinberger <richard@nod.at>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <linux-mtd@lists.infradead.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mtd: spear_smi: Fix nonalignment not handled in
 memcpy_toio
Message-ID: <20191021100105.0f06b212@collabora.com>
In-Reply-To: <20191018143643.29676-1-miquel.raynal@bootlin.com>
References: <20191018143643.29676-1-miquel.raynal@bootlin.com>
Organization: Collabora
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 18 Oct 2019 16:36:43 +0200
Miquel Raynal <miquel.raynal@bootlin.com> wrote:

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

Can you find out which instruction is at memcpy+0xcc/0x330? For the
record, the assembly is here [1].

> 
> Workaround this issue by using the alternate _memcpy_toio() method
> which at least does not present the same problem.
> 
> Fixes: f18dbbb1bfe0 ("mtd: ST SPEAr: Add SMI driver for serial NOR flash")
> Cc: stable@vger.kernel.org
> Suggested-by: Boris Brezillon <boris.brezillon@collabora.com>

I don't remember suggesting that as a final solution. I probably
suggested to test with _memcpy_toio() to see if using a byte accessor
was fixing the problem, but it's definitely not the right solution
(using byte access with a memory barrier for 256 bytes buffers is likely
to cause a huge perf penalty).

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

[1]https://elixir.bootlin.com/linux/v5.4-rc2/source/arch/arm/lib/memcpy.S

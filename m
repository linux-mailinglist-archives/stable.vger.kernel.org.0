Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18B12A0CC6
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 18:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgJ3Rrk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 30 Oct 2020 13:47:40 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:44405 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgJ3Rrk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 13:47:40 -0400
X-Greylist: delayed 1222 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Oct 2020 13:47:39 EDT
X-Originating-IP: 91.224.148.103
Received: from xps13 (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id B88B1C000A;
        Fri, 30 Oct 2020 17:47:37 +0000 (UTC)
Date:   Fri, 30 Oct 2020 18:47:36 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Joakim Tjernlund <joakim.tjernlund@infinera.com>
Cc:     "linux-mtd @ lists . infradead . org" <linux-mtd@lists.infradead.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] mtd: cfi_cmdset_0002: Use status register where
 possible
Message-ID: <20201030184736.4ec434f5@xps13>
In-Reply-To: <20201022154506.17639-1-joakim.tjernlund@infinera.com>
References: <20201022154506.17639-1-joakim.tjernlund@infinera.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Joakim,

Please Cc the MTD maintainers, not only the list (get_maintainers.pl).

Joakim Tjernlund <joakim.tjernlund@infinera.com> wrote on Thu, 22 Oct
2020 17:45:06 +0200:

> Commit "mtd: cfi_cmdset_0002: Add support for polling status register"
> added support for polling the status rather than using DQ polling.
> However, status register is used only when DQ polling is missing.
> Lets use status register when available as it is superior to DQ polling.
> 

I will let vignesh comment about the content (looks fine by me) but you will
need a Fixes tag here.

> Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/mtd/chips/cfi_cmdset_0002.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
> index a1f3e1031c3d..ee9b322e63bb 100644
> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
> @@ -117,7 +117,7 @@ static struct mtd_chip_driver cfi_amdstd_chipdrv = {
>  static int cfi_use_status_reg(struct cfi_private *cfi)
>  {
>  	struct cfi_pri_amdstd *extp = cfi->cmdset_priv;
> -	u8 poll_mask = CFI_POLL_STATUS_REG | CFI_POLL_DQ;
> +	u8 poll_mask = CFI_POLL_STATUS_REG;
>  
>  	return extp->MinorVersion >= '5' &&
>  		(extp->SoftwareFeatures & poll_mask) == CFI_POLL_STATUS_REG;

Thanks,
Miquèl

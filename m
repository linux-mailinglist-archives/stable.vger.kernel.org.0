Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1AF28A462
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 01:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgJJX2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Oct 2020 19:28:45 -0400
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:40610 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgJJX2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Oct 2020 19:28:45 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id 09ANSamh008228; Sun, 11 Oct 2020 08:28:36 +0900
X-Iguazu-Qid: 34trjq6AIaG7V6dOdc
X-Iguazu-QSIG: v=2; s=0; t=1602372515; q=34trjq6AIaG7V6dOdc; m=aN6BP32rPMlJ8ikEwoDQ0AluAJjhGOtgWGn4CQvrcOY=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1512) id 09ANSYKq003613;
        Sun, 11 Oct 2020 08:28:35 +0900
Received: from enc01.toshiba.co.jp ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 09ANSYKF028723;
        Sun, 11 Oct 2020 08:28:34 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 09ANSYGo014385;
        Sun, 11 Oct 2020 08:28:34 +0900
Date:   Sun, 11 Oct 2020 08:28:33 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     gregkh@linuxfoundation.org
Cc:     miquel.raynal@bootlin.com, stable-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Patch "mtd: rawnand: sunxi: Fix the probe error path" has been
 added to the 4.4-stable tree
X-TSB-HOP: ON
Message-ID: <20201010232833.kiboif4q6gi7ynwg@toshiba.co.jp>
References: <1602252149123251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602252149123251@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, Oct 09, 2020 at 04:02:29PM +0200, gregkh@linuxfoundation.org wrote:
> 
> This is a note to let you know that I've just added the patch titled
> 
>     mtd: rawnand: sunxi: Fix the probe error path
> 
> to the 4.4-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      mtd-rawnand-sunxi-fix-the-probe-error-path.patch
> and it can be found in the queue-4.4 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.


This patch content is not sufficient for 4.4.y.
4.4.y does not provide nand_cleanup(), which results in a build error.

Please drop this from 4.4.y queue.

Best regards,
  Nobuhiro

> 
> 
> >From 3d84515ffd8fb657e10fa5b1215e9f095fa7efca Mon Sep 17 00:00:00 2001
> From: Miquel Raynal <miquel.raynal@bootlin.com>
> Date: Tue, 19 May 2020 15:00:26 +0200
> Subject: mtd: rawnand: sunxi: Fix the probe error path
> 
> From: Miquel Raynal <miquel.raynal@bootlin.com>
> 
> commit 3d84515ffd8fb657e10fa5b1215e9f095fa7efca upstream.
> 
> nand_release() is supposed be called after MTD device registration.
> Here, only nand_scan() happened, so use nand_cleanup() instead.
> 
> Fixes: 1fef62c1423b ("mtd: nand: add sunxi NAND flash controller support")
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-54-miquel.raynal@bootlin.com
> [iwamatsu: adjust filename]
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/mtd/nand/sunxi_nand.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/mtd/nand/sunxi_nand.c
> +++ b/drivers/mtd/nand/sunxi_nand.c
> @@ -1376,7 +1376,7 @@ static int sunxi_nand_chip_init(struct d
>  	ret = mtd_device_parse_register(mtd, NULL, &ppdata, NULL, 0);
>  	if (ret) {
>  		dev_err(dev, "failed to register mtd device: %d\n", ret);
> -		nand_release(mtd);
> +		nand_cleanup(mtd);
>  		return ret;
>  	}
>  
> 
> 
> Patches currently in stable-queue which might be from miquel.raynal@bootlin.com are
> 
> queue-4.4/mtd-rawnand-sunxi-fix-the-probe-error-path.patch
> 

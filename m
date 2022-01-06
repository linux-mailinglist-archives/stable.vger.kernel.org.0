Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507294868FE
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 18:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242260AbiAFRo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 12:44:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37844 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242273AbiAFRoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 12:44:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9BBEB822A4;
        Thu,  6 Jan 2022 17:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C65C36AE3;
        Thu,  6 Jan 2022 17:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641491058;
        bh=/Z4tijhHD0ZDCKofZQW7TfrtBbAeXpE5PX0D7zD/CDI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aBsbboTj1VwKriWPj1sG2XWXlE6tHxKTcO0Dvrt/tOsoWkn6PJqmIu4KRgNu4APOt
         OtDeVRlE1mZpwbJypjWOfNc6PXxjhiF782dS+GQHyiuj34Wv/F6y3eKyRp3MLouAWP
         3FZmTQKb9kIyWxKj/I9wJD8ySc3HJksyTHSzJWK0=
Date:   Thu, 6 Jan 2022 18:44:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc:     Manivannan Sadhasivam <mani@kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-mtd@lists.infradead.org,
        miquel.raynal@bootlin.com, architt@codeaurora.org,
        bbrezillon@kernel.org, absahu@codeaurora.org, baruch@tkos.co.il,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] mtd: rawnand: qcom: Fix clock sequencing in
 qcom_nandc_probe()
Message-ID: <Ydcqb5k8EcDqPJLD@kroah.com>
References: <20220103030316.58301-1-bryan.odonoghue@linaro.org>
 <20220103030316.58301-2-bryan.odonoghue@linaro.org>
 <20220103055152.GA3581@thinkpad>
 <edcd752d-37a5-2004-3508-01efcfa571ba@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <edcd752d-37a5-2004-3508-01efcfa571ba@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 06, 2022 at 05:24:27PM +0000, Bryan O'Donoghue wrote:
> On 03/01/2022 05:51, Manivannan Sadhasivam wrote:
> > On Mon, Jan 03, 2022 at 03:03:15AM +0000, Bryan O'Donoghue wrote:
> > > Interacting with a NAND chip on an IPQ6018 I found that the qcomsmem NAND
> > > partition parser was returning -EPROBE_DEFER waiting for the main smem
> > > driver to load.
> > > 
> > > This caused the board to reset. Playing about with the probe() function
> > > shows that the problem lies in the core clock being switched off before the
> > > nandc_unalloc() routine has completed.
> > > 
> > > If we look at how qcom_nandc_remove() tears down allocated resources we see
> > > the expected order is
> > > 
> > > qcom_nandc_unalloc(nandc);
> > > 
> > > clk_disable_unprepare(nandc->aon_clk);
> > > clk_disable_unprepare(nandc->core_clk);
> > > 
> > > dma_unmap_resource(&pdev->dev, nandc->base_dma, resource_size(res),
> > > 		   DMA_BIDIRECTIONAL, 0);
> > > 
> > > Tweaking probe() to both bring up and tear-down in that order removes the
> > > reset if we end up deferring elsewhere.
> > > 
> > > Fixes: c76b78d8ec05 ("mtd: nand: Qualcomm NAND controller driver")
> > > Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
> > 
> > Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> > 
> > Can you please CC stable list for backporting?
> > 
> > Thanks,
> > Mani
> > 
> 
> NP.
> 
> + cc stable
> 
> FWIW I believe Greg's scripts will pick up on Fixes: tags automatically

No, that is NOT the way to ensure that a patch will get picked up, that
is a "this might eventually get there".

Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

thanks,

greg k-h

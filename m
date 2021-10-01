Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9B941E83A
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 09:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhJAHWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 03:22:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231164AbhJAHWz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Oct 2021 03:22:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6323613A0;
        Fri,  1 Oct 2021 07:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633072871;
        bh=P+Qe5wC7Wej8NovvvGOgOry6hwfzJdM/EQObhQn4QBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FeGG5CB0OZCRQlSNfAaoS2dN+f6UTWloeVgkff3TFmdEMCJqcoiz5bJvfsHhPZzrM
         5OOkrY/CkX6qVlJUxofAaaoRqIcCeplhU+fCyGBvotkqJQMxlqhJJcDytO9XpRxJ+v
         +5lNht7u6+gGu0O3m+SNhGbqMh0snOlF9hpBFNlFvW89qCEfF3JEFNkyVRg3pyys9p
         bh2Qw6ibzWLIsYWVD0/wXtFb3TkmchWG4bFLH0IQjAaQsIk1oFbBNUkksGS0hT2J/u
         pQPySal2BhlwXePbIg3xKO9Z2DnvJxYzWovTbxLtxThuiegPlB3aogJ1ZTRAcb+XPz
         i2Gmk2XLFjbmw==
Date:   Fri, 1 Oct 2021 15:21:06 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     Fabio Estevam <festevam@gmail.com>, shawnguo@kernel.org,
        marex@denx.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, heiko.thiery@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] usb: chipidea: ci_hdrc_imx: Also search for 'phys'
 phandle
Message-ID: <20211001072106.GA5555@Peter>
References: <20210921113754.767631-1-festevam@gmail.com>
 <7f3b82ad-ff12-ce23-12a3-25b09c767759@kontron.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f3b82ad-ff12-ce23-12a3-25b09c767759@kontron.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-09-30 16:36:51, Frieder Schrempf wrote:
> On 21.09.21 13:37, Fabio Estevam wrote:
> > When passing 'phys' in the devicetree to describe the USB PHY phandle
> > (which is the recommended way according to
> > Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt) the
> > following NULL pointer dereference is observed on i.MX7 and i.MX8MM:
> > 
> > [    1.489344] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000098
> > [    1.498170] Mem abort info:
> > [    1.500966]   ESR = 0x96000044
> > [    1.504030]   EC = 0x25: DABT (current EL), IL = 32 bits
> > [    1.509356]   SET = 0, FnV = 0
> > [    1.512416]   EA = 0, S1PTW = 0
> > [    1.515569]   FSC = 0x04: level 0 translation fault
> > [    1.520458] Data abort info:
> > [    1.523349]   ISV = 0, ISS = 0x00000044
> > [    1.527196]   CM = 0, WnR = 1
> > [    1.530176] [0000000000000098] user address but active_mm is swapper
> > [    1.536544] Internal error: Oops: 96000044 [#1] PREEMPT SMP
> > [    1.542125] Modules linked in:
> > [    1.545190] CPU: 3 PID: 7 Comm: kworker/u8:0 Not tainted 5.14.0-dirty #3
> > [    1.551901] Hardware name: Kontron i.MX8MM N801X S (DT)
> > [    1.557133] Workqueue: events_unbound deferred_probe_work_func
> > [    1.562984] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
> > [    1.568998] pc : imx7d_charger_detection+0x3f0/0x510
> > [    1.573973] lr : imx7d_charger_detection+0x22c/0x510
> > 
> > This happens because the charger functions check for the phy presence
> > inside the imx_usbmisc_data structure (data->usb_phy), but the chipidea
> > core populates the usb_phy passed via 'phys' inside 'struct ci_hdrc'
> > (ci->usb_phy) instead.
> > 
> > This causes the NULL pointer dereference inside imx7d_charger_detection().
> > 
> > Fix it by also searching for 'phys' in case 'fsl,usbphy' is not found.
> > 
> > Tested on a imx7s-warp board.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 746f316b753a ("usb: chipidea: introduce imx7d USB charger detection")
> > Reported-by: Heiko Thiery <heiko.thiery@gmail.com>
> > Signed-off-by: Fabio Estevam <festevam@gmail.com>
> > Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> 
> Tested-by: Frieder Schrempf <frieder.schrempf@kontron.de>

Applied, thanks.

Peter
> 
> > ---
> > Changes since v2:
> > 
> > - Added Frieder's reviewed-by tag.
> > - Cc stable
> > - Improved the commit log and fixed typo in 'dereferenced'
> > 
> >  drivers/usb/chipidea/ci_hdrc_imx.c | 15 ++++++++++-----
> >  1 file changed, 10 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
> > index 8b7bc10b6e8b..f1d100671ee6 100644
> > --- a/drivers/usb/chipidea/ci_hdrc_imx.c
> > +++ b/drivers/usb/chipidea/ci_hdrc_imx.c
> > @@ -420,11 +420,16 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
> >  	data->phy = devm_usb_get_phy_by_phandle(dev, "fsl,usbphy", 0);
> >  	if (IS_ERR(data->phy)) {
> >  		ret = PTR_ERR(data->phy);
> > -		/* Return -EINVAL if no usbphy is available */
> > -		if (ret == -ENODEV)
> > -			data->phy = NULL;
> > -		else
> > -			goto err_clk;
> > +		if (ret == -ENODEV) {
> > +			data->phy = devm_usb_get_phy_by_phandle(dev, "phys", 0);
> > +			if (IS_ERR(data->phy)) {
> > +				ret = PTR_ERR(data->phy);
> > +				if (ret == -ENODEV)
> > +					data->phy = NULL;
> > +				else
> > +					goto err_clk;
> > +			}
> > +		}
> >  	}
> >  
> >  	pdata.usb_phy = data->phy;
> > 

-- 

Thanks,
Peter Chen


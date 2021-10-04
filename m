Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F62420689
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 09:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbhJDHWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 03:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229478AbhJDHWd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 03:22:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D8CC610FB;
        Mon,  4 Oct 2021 07:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633332045;
        bh=ON9CK3XRzMqoI/ij0MYu2d0w6sGiAjn9TWL7zrg3BUs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VHXEjC0/qIziU+y3wvcqO+udrRv91NeTU4mJgPvM0jCUw9CDfF8IA/D5AC8dlQf1Y
         OMVCeEKh+GnfoNdncvr/puPgqZVjv3F5uLMTyBcWmRnFfU7rQLMoq4T7g387+9P8YH
         VWOw/Tmnk/NktAtiRei39De6w/jGsKeNZKZhwPYPksy4hEb+nGAKJ2m849xaeB+qsR
         5H1+m6HeYN8J/14NhcvS0zxdaOxAPIsucE4xo4gyQJb97S9fv4ymZKoWw1DCAA2UXN
         DUgTDsBTfST5+vvuDU3TA5n2Syn41V/qYu46YLOElQ383iiKRVy5pBN7oTI5eGy7H5
         Aa2BqrI2eRQ1w==
Date:   Mon, 4 Oct 2021 15:20:39 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Frieder Schrempf <frieder.schrempf@kontron.de>,
        Fabio Estevam <festevam@gmail.com>, shawnguo@kernel.org,
        marex@denx.de, linux-usb@vger.kernel.org, heiko.thiery@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] usb: chipidea: ci_hdrc_imx: Also search for 'phys'
 phandle
Message-ID: <20211004072039.GB27151@Peter>
References: <20210921113754.767631-1-festevam@gmail.com>
 <7f3b82ad-ff12-ce23-12a3-25b09c767759@kontron.de>
 <20211004065142.GA27151@Peter>
 <YVqpKIq88Co4IWCP@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVqpKIq88Co4IWCP@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-10-04 09:11:36, Greg KH wrote:
> On Mon, Oct 04, 2021 at 02:51:42PM +0800, Peter Chen wrote:
> > On 21-09-30 16:36:51, Frieder Schrempf wrote:
> > > On 21.09.21 13:37, Fabio Estevam wrote:
> > > > When passing 'phys' in the devicetree to describe the USB PHY phandle
> > > > (which is the recommended way according to
> > > > Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt) the
> > > > following NULL pointer dereference is observed on i.MX7 and i.MX8MM:
> > > > 
> > > > [    1.489344] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000098
> > > > [    1.498170] Mem abort info:
> > > > [    1.500966]   ESR = 0x96000044
> > > > [    1.504030]   EC = 0x25: DABT (current EL), IL = 32 bits
> > > > [    1.509356]   SET = 0, FnV = 0
> > > > [    1.512416]   EA = 0, S1PTW = 0
> > > > [    1.515569]   FSC = 0x04: level 0 translation fault
> > > > [    1.520458] Data abort info:
> > > > [    1.523349]   ISV = 0, ISS = 0x00000044
> > > > [    1.527196]   CM = 0, WnR = 1
> > > > [    1.530176] [0000000000000098] user address but active_mm is swapper
> > > > [    1.536544] Internal error: Oops: 96000044 [#1] PREEMPT SMP
> > > > [    1.542125] Modules linked in:
> > > > [    1.545190] CPU: 3 PID: 7 Comm: kworker/u8:0 Not tainted 5.14.0-dirty #3
> > > > [    1.551901] Hardware name: Kontron i.MX8MM N801X S (DT)
> > > > [    1.557133] Workqueue: events_unbound deferred_probe_work_func
> > > > [    1.562984] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
> > > > [    1.568998] pc : imx7d_charger_detection+0x3f0/0x510
> > > > [    1.573973] lr : imx7d_charger_detection+0x22c/0x510
> > > > 
> > > > This happens because the charger functions check for the phy presence
> > > > inside the imx_usbmisc_data structure (data->usb_phy), but the chipidea
> > > > core populates the usb_phy passed via 'phys' inside 'struct ci_hdrc'
> > > > (ci->usb_phy) instead.
> > > > 
> > > > This causes the NULL pointer dereference inside imx7d_charger_detection().
> > > > 
> > > > Fix it by also searching for 'phys' in case 'fsl,usbphy' is not found.
> > > > 
> > > > Tested on a imx7s-warp board.
> > > > 
> > > > Cc: stable@vger.kernel.org
> > > > Fixes: 746f316b753a ("usb: chipidea: introduce imx7d USB charger detection")
> > > > Reported-by: Heiko Thiery <heiko.thiery@gmail.com>
> > > > Signed-off-by: Fabio Estevam <festevam@gmail.com>
> > > > Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> > > 
> > > Tested-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> > 
> > Acked-by: Peter Chen <peter.chen@kernel.org>
> > 
> > Greg, would you please help apply it?
> 
> Sure.  But I have usually been ignoring chipidea patches and hoping you
> would pick them up and forward them on to me.  Should I no longer do
> that and just wait for an ack from you?

Yes, please do that way, thanks.

-- 

Thanks,
Peter Chen


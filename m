Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22AD2347A8
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 16:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729220AbgGaOWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 10:22:13 -0400
Received: from netrider.rowland.org ([192.131.102.5]:35489 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1729184AbgGaOWN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jul 2020 10:22:13 -0400
Received: (qmail 37750 invoked by uid 1000); 31 Jul 2020 10:22:12 -0400
Date:   Fri, 31 Jul 2020 10:22:12 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Macpaul Lin <macpaul.lin@mediatek.com>
Cc:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Eddie Hung <eddie.hung@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: mtu3: fix panic in mtu3_gadget_disconnect()
Message-ID: <20200731142212.GE36650@rowland.harvard.edu>
References: <1596177366-12029-1-git-send-email-macpaul.lin@mediatek.com>
 <1596185878-24360-1-git-send-email-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596185878-24360-1-git-send-email-macpaul.lin@mediatek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 31, 2020 at 04:57:58PM +0800, Macpaul Lin wrote:
> This patch fixes a possible issue when mtu3_gadget_stop()
> already assigned NULL to mtu->gadget_driver during mtu_gadget_disconnect().

> 
> Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> Cc: stable@vger.kernel.org
> ---
> Changes for v2:
>   - Check mtu_gadget_driver out of spin_lock might still not work.
>     We use a temporary pointer to keep the callback function.
> 
>  drivers/usb/mtu3/mtu3_gadget.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/mtu3/mtu3_gadget.c b/drivers/usb/mtu3/mtu3_gadget.c
> index 68ea4395f871..40cb6626f496 100644
> --- a/drivers/usb/mtu3/mtu3_gadget.c
> +++ b/drivers/usb/mtu3/mtu3_gadget.c
> @@ -840,10 +840,17 @@ void mtu3_gadget_suspend(struct mtu3 *mtu)
>  /* called when VBUS drops below session threshold, and in other cases */
>  void mtu3_gadget_disconnect(struct mtu3 *mtu)
>  {
> +	struct usb_gadget_driver *driver;
> +
>  	dev_dbg(mtu->dev, "gadget DISCONNECT\n");
>  	if (mtu->gadget_driver && mtu->gadget_driver->disconnect) {
> +		driver = mtu->gadget_driver;
>  		spin_unlock(&mtu->lock);
> -		mtu->gadget_driver->disconnect(&mtu->g);
> +		/*
> +		 * avoid kernel panic because mtu3_gadget_stop() assigned NULL
> +		 * to mtu->gadget_driver.
> +		 */
> +		driver->disconnect(&mtu->g);
>  		spin_lock(&mtu->lock);
>  	}

This is not the right approach; it might race with the gadget driver 
unregistering itself.

Instead, mtu3_gadget_stop() should call synchronize_irq() after 
releasing the IRQ line.  When synchronize_irq() returns, you'll know any 
IRQ handlers have finished running, so you won't receive any more 
disconnect notifications.  Then it will be safe to acquire the spinlock 
and set mtu->gadget_driver to NULL.

Alan Stern

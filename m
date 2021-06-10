Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABD53A24C1
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 08:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhFJGxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 02:53:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229634AbhFJGxL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 02:53:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C750C613E2;
        Thu, 10 Jun 2021 06:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623307859;
        bh=gL9kKCK+CsHPorwNub9yfvx7kZWcnzWe/A3bbR9fiEs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v+A9wTWYBeEPqHsjLU+9uhEJGoaY2/nO4wsOyPnz9s/yEypfQInZrN7mWgLcfnkXE
         9rO7xJnPs+CEgzOsrpcdogwRvxBIIOTa1UNZBhjL2wnEL351+hNcJJ4JgJ1IqJvDSz
         E4esok7hx70R0ZO86KlDLi++yBH/iYLVlnx/y0cI=
Date:   Thu, 10 Jun 2021 08:50:57 +0200
From:   'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
To:     linyyuan@codeaurora.org
Cc:     'Felipe Balbi' <balbi@kernel.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: eem: fix command packet transfer issue
Message-ID: <YMG2UWeqodfTRRnQ@kroah.com>
References: <000201d75dbf$58d1cc40$0a7564c0$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000201d75dbf$58d1cc40$0a7564c0$@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 10, 2021 at 02:10:40PM +0800, linyyuan@codeaurora.org wrote:
> From: Linyu Yuan <linyyuan@codeaurora.com>
> 
> there is following warning,
> [<ffffff8008905a94>] dwc3_gadget_ep_queue+0x1b4/0x1c8
> [<ffffff800895ec9c>] usb_ep_queue+0x3c/0x120
> [<ffffff80089677a0>] eem_unwrap+0x180/0x330
> [<ffffff80089634f8>] rx_complete+0x70/0x230
> [<ffffff800895edbc>] usb_gadget_giveback_request+0x3c/0xe8
> [<ffffff8008901e7c>] dwc3_gadget_giveback+0xb4/0x190
> [<ffffff8008905254>] dwc3_endpoint_transfer_complete+0x32c/0x410
> [<ffffff80089060fc>] dwc3_bh_work+0x654/0x12e8
> [<ffffff80080c63fc>] process_one_work+0x1d4/0x4a8
> [<ffffff80080c6720>] worker_thread+0x50/0x4a8
> [<ffffff80080cc8e8>] kthread+0xe8/0x100
> [<ffffff8008083980>] ret_from_fork+0x10/0x50
> request ffffffc0716bf200 belongs to 'ep0out'
> 
> when gadget receive a eem command packet from host, it need to response,
> but queue usb request to wrong endpoint.

What is the full warning here?  THe above traceback is a bit odd and
does not show what is happening.

> fix it by queue usb request to eem IN endpoint and allow host read it.

I do not understand how this matches up with your kernel patch, when you
resend this, can you please expand on this and make it more obvious what
you are doing here?

thanks,

greg k-h

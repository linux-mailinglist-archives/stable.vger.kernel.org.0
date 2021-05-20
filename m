Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393F2389FE3
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 10:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhETIfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 04:35:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229536AbhETIfw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 04:35:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E5636109F;
        Thu, 20 May 2021 08:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621499670;
        bh=u4rAT+IESICmMNtLLzr6UXo0VOeuySTjohvGBb78gO8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CkE2J9mM+Y6CaEfojl2Gl2O2RUfezyePT9l3irRUy+8cZ1qjKtE053geAcVNzV1+N
         KI4ohL54RJgcTjw4DhPgjt+JAm+9x6LZyi1++DRR8P1idMPUlR6KNSt8STkI9nVbyi
         HcazCoapc+K7s024Dp47z+Ws0MsKyk7a7DrEnTig=
Date:   Thu, 20 May 2021 10:34:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH for 4.4, 4.9 and 4.14] xhci: Do not use GFP_KERNEL in
 (potentially) atomic context
Message-ID: <YKYfFAXul22Xy0lH@kroah.com>
References: <20210518033035.37976-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518033035.37976-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 18, 2021 at 12:30:35PM +0900, Nobuhiro Iwamatsu wrote:
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> commit dda32c00c9a0fa103b5d54ef72c477b7aa993679 upstream.
> 
> 'xhci_urb_enqueue()' is passed a 'mem_flags' argument, because "URBs may be
> submitted in interrupt context" (see comment related to 'usb_submit_urb()'
> in 'drivers/usb/core/urb.c')
> 
> So this flag should be used in all the calling chain.
> Up to now, 'xhci_check_maxpacket()' which is only called from
> 'xhci_urb_enqueue()', uses GFP_KERNEL.
> 
> Be safe and pass the mem_flags to this function as well.
> 
> Fixes: ddba5cd0aeff ("xhci: Use command structures when queuing commands on the command ring")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> Link: https://lore.kernel.org/r/20210512080816.866037-4-mathias.nyman@linux.intel.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [iwamatsu: Adjust context]
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>

Now queued up, thanks.

greg k-h

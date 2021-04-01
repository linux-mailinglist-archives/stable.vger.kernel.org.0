Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54E63519BC
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 20:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236939AbhDAR4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 13:56:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235366AbhDARxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Apr 2021 13:53:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C3F161354;
        Thu,  1 Apr 2021 14:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617286453;
        bh=xuTCkOPvf9aiKJguttK3hihOeX+O3bzSR6YnnMU9Itg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XU+GGkElgULOox0k5B8IMHv1KsALo4FbRTP0Y4ehjFyam8qEHbiXvTzcalDQq8f0D
         QArRoE1+xfP/PbS5ElkJ4PB+1+iCV984/b6tuwq4uyrAE1gH/nyeSKQYl3RpBZU3Jd
         87jkabWYmj5vqQW7d2KqdiEmC+T64vF7s6rtoJEE=
Date:   Thu, 1 Apr 2021 16:14:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     balbi@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-usb@vger.kernel.org,
        wcheng@codeaurora.org
Subject: Re: [PATCH v2] Revert "usb: dwc3: gadget: Prevent EP queuing while
 stopping transfers"
Message-ID: <YGXVMzwXXXFKfbuI@kroah.com>
References: <YGXE0gQoj8HOzpuw@kroah.com>
 <20210401131108.2149766-1-martin.kepplinger@puri.sm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401131108.2149766-1-martin.kepplinger@puri.sm>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 01, 2021 at 03:11:08PM +0200, Martin Kepplinger wrote:
> commit 9de499997c ("usb: dwc3: gadget: Prevent EP queuing while stopping
> transfers") results in the below error every time I connect the type-c
> connector to the dwc3, configured with serial and ethernet gadgets.
> I also apply the following to dwc3 on this port:
> 
> dr_mode = "otg";                                                        
> snps,dis_u3_susphy_quirk;                                               
> hnp-disable;                                                            
> srp-disable;                                                            
> adp-disable;                                                            

Why all the trailing whitespace?

> usb-role-switch;
> 
> [   51.148220] ------------[ cut here ]------------
> [   51.148241] dwc3 38100000.usb: No resource for ep2in
> [   51.148376] WARNING: CPU: 0 PID: 299 at drivers/usb/dwc3/gadget.c:360 dwc3_send_gadget_ep_cmd+0x570/0x740 [dwc3]
> [   51.148837] CPU: 0 PID: 299 Comm: irq/64-dwc3 Not tainted 5.11.11-librem5-00334-ge4c4ff3624e9 #218
> [   51.148848] Hardware name: Purism Librem 5r4 (DT)
> [   51.148854] pstate: 60000085 (nZCv daIf -PAN -UAO -TCO BTYPE=--)
> [   51.148863] pc : dwc3_send_gadget_ep_cmd+0x570/0x740 [dwc3]
> [   51.148894] lr : dwc3_send_gadget_ep_cmd+0x570/0x740 [dwc3]
> [   51.148924] sp : ffff800011cb3ac0
> [   51.148929] x29: ffff800011cb3ac0 x28: ffff0000032a7b00 
> [   51.148942] x27: ffff00000327da00 x26: 0000000000000000 
> [   51.148954] x25: 00000000ffffffea x24: 0000000000000006 
> [   51.148967] x23: ffff0000bee1c080 x22: ffff800011cb3b7c 
> [   51.148979] x21: 0000000000000406 x20: ffff0000bf170000 
> [   51.148992] x19: 0000000000000001 x18: 0000000000000000 
> [   51.149004] x17: 0000000000000000 x16: 0000000000000000 
> [   51.149016] x15: 0000000000000000 x14: ffff8000114512c0 
> [   51.149028] x13: 0000000000001698 x12: 0000000000000040 
> [   51.149040] x11: ffff80001151a6f8 x10: 00000000ffffe000 
> [   51.149052] x9 : ffff8000100b2b7c x8 : ffff80001146a6f8 
> [   51.149065] x7 : ffff80001151a6f8 x6 : 0000000000000000 
> [   51.149077] x5 : ffff0000bf939948 x4 : 0000000000000000 
> [   51.149089] x3 : 0000000000000027 x2 : 0000000000000000 
> [   51.149101] x1 : 0000000000000000 x0 : ffff0000049ae040 
> [   51.149114] Call trace:
> [   51.149120]  dwc3_send_gadget_ep_cmd+0x570/0x740 [dwc3]
> [   51.149150]  __dwc3_gadget_ep_enable+0x288/0x4fc [dwc3]
> [   51.149179]  dwc3_gadget_ep_enable+0x6c/0x15c [dwc3]
> [   51.149209]  usb_ep_enable+0x48/0x110 [udc_core]
> [   51.149251]  rndis_set_alt+0x138/0x1c0 [usb_f_rndis]
> [   51.149276]  composite_setup+0x674/0x194c [libcomposite]
> [   51.149314]  dwc3_ep0_interrupt+0x9c4/0xb9c [dwc3]
> [   51.149344]  dwc3_thread_interrupt+0x8bc/0xe74 [dwc3]
> [   51.149374]  irq_thread_fn+0x38/0xb0
> [   51.149388]  irq_thread+0x170/0x294
> [   51.149397]  kthread+0x164/0x16c
> [   51.149407]  ret_from_fork+0x10/0x34
> [   51.149419] ---[ end trace 62c6cc2ebfb18047 ]---
> 
> Linus' tree isn't affected. Revert the change.

What does this mean?

> 
> Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
> 
> ---

What changed from v1?  Always put that below the --- line.

And as this is a revert, is a "Fixes:" line also relevant?

thanks,

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE533537B7
	for <lists+stable@lfdr.de>; Sun,  4 Apr 2021 12:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhDDKB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Apr 2021 06:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhDDKBy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Apr 2021 06:01:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB28761380;
        Sun,  4 Apr 2021 10:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617530510;
        bh=+Sbjpu/h3oW/uHOmokvoHfsBFkSIytwPkB6wZ0l8d6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z4INeRpt9eEGAHcaobW7exZYNEfMnfFOaSELZ14lFd4TNliVJ2SS1tvSGi/yPMkG/
         tvNQNJf1S19++zuUMnLD5FAC8cavqM6P7sgKaB3pRouQ5VfSqPdmMKo/TyDs/kL5Dg
         A6SqCQZcjy4lgTvRF5rnwXTcYgTlYg3NZyFZsxho=
Date:   Sun, 4 Apr 2021 12:01:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Wesley Cheng <wcheng@codeaurora.org>,
        Felipe Balbi <balbi@kernel.org>, stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        kernel@pyra-handheld.com,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>, linux-usb@vger.kernel.org
Subject: Re: [BUG]: usb: dwc3: gadget: Prevent EP queuing while stopping
 transfers
Message-ID: <YGmOiV7yiQtdaXqD@kroah.com>
References: <DF98BCBA-E13B-4E33-98AD-216816625F3B@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DF98BCBA-E13B-4E33-98AD-216816625F3B@goldelico.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 04, 2021 at 11:29:00AM +0200, H. Nikolaus Schaller wrote:
> it seems as if the patch
> 
> 	9de499997c37 ("usb: dwc3: gadget: Prevent EP queuing while stopping transfers") in v5.11.y
> 	f09ddcfcb8c5 ("usb: dwc3: gadget: Prevent EP queuing while stopping transfers") in v5.12-rc5
> 
> reproducible breaks dwc3 RNDIS gadget, at least on the Pyra Handheld (OMAP5).
> 
> The symptom of having this patch in tree (v5.11.10 or v5.12) is that
> rndis/gadget initially works after boot.

Should be fixed now by 5aef629704ad ("usb: dwc3: gadget: Clear DEP flags
after stop transfers in ep disable").  Can you test and verify this?

thanks,

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8858F3644E3
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241422AbhDSNfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:35:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240785AbhDSNck (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:32:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E672A610CC;
        Mon, 19 Apr 2021 13:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618839130;
        bh=4NjvgVgMuvT7DX09szbtdLhhGBXmnMMgxYuw1NDeiBQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iQZcAa/UWwwH0IH3l++elYw4EWvM+s85iShmrEKeCsK3cf1fDiQNDF/cs9cOh38jv
         lixzz9htlfPbwPV6Wk+8+JSlidfcgEHVH7Z2AWgx5vtYSu5+tltt3fnPLIu8DlmoKZ
         gsZFOVAqwliubGqYcZ4YZ7GRrB2hO87fmwXSFDo0=
Date:   Mon, 19 Apr 2021 14:25:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Tom Seewald <tseewald@gmail.com>, stable@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH] usbip: Fix incorrect double assignment to udc->ud.tcp_rx
Message-ID: <YH121CyWCD18M3hA@kroah.com>
References: <20210412185902.27755-1-tseewald@gmail.com>
 <f3e734e4-afc2-4d7c-8d02-714935b45764@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3e734e4-afc2-4d7c-8d02-714935b45764@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 16, 2021 at 09:32:35AM -0600, Shuah Khan wrote:
> On 4/12/21 12:59 PM, Tom Seewald wrote:
> > commit 9858af27e69247c5d04c3b093190a93ca365f33d upstream.
> > 
> > Currently udc->ud.tcp_rx is being assigned twice, the second assignment
> > is incorrect, it should be to udc->ud.tcp_tx instead of rx. Fix this.
> > 
> > Fixes: 46613c9dfa96 ("usbip: fix vudc usbip_sockfd_store races leading to gpf")
> > Acked-by: Shuah Khan <skhan@linuxfoundation.org>
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > Cc: stable <stable@vger.kernel.org>
> > Addresses-Coverity: ("Unused value")
> > Link: https://lore.kernel.org/r/20210311104445.7811-1-colin.king@canonical.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Tom Seewald <tseewald@gmail.com>
> > ---
> >   drivers/usb/usbip/vudc_sysfs.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/usb/usbip/vudc_sysfs.c b/drivers/usb/usbip/vudc_sysfs.c
> > index f44d98eeb36a..51cc5258b63e 100644
> > --- a/drivers/usb/usbip/vudc_sysfs.c
> > +++ b/drivers/usb/usbip/vudc_sysfs.c
> > @@ -187,7 +187,7 @@ static ssize_t store_sockfd(struct device *dev,
> >   		udc->ud.tcp_socket = socket;
> >   		udc->ud.tcp_rx = tcp_rx;
> > -		udc->ud.tcp_rx = tcp_tx;
> > +		udc->ud.tcp_tx = tcp_tx;
> >   		udc->ud.status = SDEV_ST_USED;
> >   		spin_unlock_irq(&udc->ud.lock);
> > 
> 
> Greg,
> 
> Please pick this up for 4.9 and 4.14

Why?  The commit it says it fixes, 46613c9dfa96 ("usbip: fix vudc
usbip_sockfd_store races leading to gpf"), is not in any kernel older
than 4.19.y at the moment.

Should that commit also be backported?

confused,

greg k-h

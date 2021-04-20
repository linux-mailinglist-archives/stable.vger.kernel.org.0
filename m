Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9205D365817
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 13:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhDTLva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 07:51:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231196AbhDTLv3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Apr 2021 07:51:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE2C0613B4;
        Tue, 20 Apr 2021 11:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618919458;
        bh=/vF2t84dAR7o9fVFTDS/JoJiOMJukRX4OiuMH7Ppa+E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H8xYegxWe6pP/WNUkl6ELXaQR06XqbjeEmthF61MWy6/dWigarZGfSrxi5iX3rg1o
         UERPkjFcjX9+2DyV2xNrjxaUfF0KuNj4VW6DtHunW6TmBoyAIvTBcyZFx708vwxG3F
         rRjlNPzaSGS0FevMJfciCt9x27l9/GihOGRfDXkM=
Date:   Tue, 20 Apr 2021 13:50:55 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Tom Seewald <tseewald@gmail.com>, stable@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH] usbip: Fix incorrect double assignment to udc->ud.tcp_rx
Message-ID: <YH7AHwt3EQJqNvE8@kroah.com>
References: <20210412185902.27755-1-tseewald@gmail.com>
 <f3e734e4-afc2-4d7c-8d02-714935b45764@linuxfoundation.org>
 <YH121CyWCD18M3hA@kroah.com>
 <8726436e-49ab-df18-724f-d87625949773@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8726436e-49ab-df18-724f-d87625949773@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 04:06:49PM -0600, Shuah Khan wrote:
> On 4/19/21 6:25 AM, Greg Kroah-Hartman wrote:
> > On Fri, Apr 16, 2021 at 09:32:35AM -0600, Shuah Khan wrote:
> > > On 4/12/21 12:59 PM, Tom Seewald wrote:
> > > > commit 9858af27e69247c5d04c3b093190a93ca365f33d upstream.
> > > > 
> > > > Currently udc->ud.tcp_rx is being assigned twice, the second assignment
> > > > is incorrect, it should be to udc->ud.tcp_tx instead of rx. Fix this.
> > > > 
> > > > Fixes: 46613c9dfa96 ("usbip: fix vudc usbip_sockfd_store races leading to gpf")
> > > > Acked-by: Shuah Khan <skhan@linuxfoundation.org>
> > > > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > > > Cc: stable <stable@vger.kernel.org>
> > > > Addresses-Coverity: ("Unused value")
> > > > Link: https://lore.kernel.org/r/20210311104445.7811-1-colin.king@canonical.com
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Signed-off-by: Tom Seewald <tseewald@gmail.com>
> > > > ---
> > > >    drivers/usb/usbip/vudc_sysfs.c | 2 +-
> > > >    1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/usb/usbip/vudc_sysfs.c b/drivers/usb/usbip/vudc_sysfs.c
> > > > index f44d98eeb36a..51cc5258b63e 100644
> > > > --- a/drivers/usb/usbip/vudc_sysfs.c
> > > > +++ b/drivers/usb/usbip/vudc_sysfs.c
> > > > @@ -187,7 +187,7 @@ static ssize_t store_sockfd(struct device *dev,
> > > >    		udc->ud.tcp_socket = socket;
> > > >    		udc->ud.tcp_rx = tcp_rx;
> > > > -		udc->ud.tcp_rx = tcp_tx;
> > > > +		udc->ud.tcp_tx = tcp_tx;
> > > >    		udc->ud.status = SDEV_ST_USED;
> > > >    		spin_unlock_irq(&udc->ud.lock);
> > > > 
> > > 
> > > Greg,
> > > 
> > > Please pick this up for 4.9 and 4.14
> > 
> > Why?  The commit it says it fixes, 46613c9dfa96 ("usbip: fix vudc
> > usbip_sockfd_store races leading to gpf"), is not in any kernel older
> > than 4.19.y at the moment.
> > 
> 
> Tom back ported this one a couple of weeks ago to 4.14.y and 4.9.y
> 
> I see this commit in 4.14 (checked on 4.14.231)
> e9c1341b4c948c20f030b6b146fa82575e2fc37b
> 
> 
> I see this commit in 4.9.267 as well.
> 
> fe9e15a30be666ec8071f325a39fe13e2251b51d
> 
> This fix can go on top of these commits.

Now queued up, thanks.

greg k-h

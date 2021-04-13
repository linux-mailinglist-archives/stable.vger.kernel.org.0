Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A6535D8E3
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 09:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239917AbhDMHa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 03:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239308AbhDMHaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Apr 2021 03:30:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78E406054E;
        Tue, 13 Apr 2021 07:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618299004;
        bh=YrtgzV42Yw9Uvecp+Hsq9q4+SBCkks1PP+2nS/No7NA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d3VEQKaoYll1/wZVqIXPpb+duCXWNXHbDd1q/PZTpr5fb5dKJ3rLDlpQYRv0/RWbo
         5lG9sFDJQg1OfDJAerui9Qzv7Lwow5yGIMfRziQuP1GqK71BuguaVFc7F2zr84o8ZT
         +nnHyxKYCnC8JU9xPf25q53lVZ3mZtfGtE/iXFYA=
Date:   Tue, 13 Apr 2021 09:30:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Tom Seewald <tseewald@gmail.com>, stable@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH] usbip: Fix incorrect double assignment to udc->ud.tcp_rx
Message-ID: <YHVIeWbZCu7RvQmM@kroah.com>
References: <20210412185902.27755-1-tseewald@gmail.com>
 <4fc29f02-2284-70a2-2995-407f5c45b11f@gmail.com>
 <0a4197a2-d417-dca5-20fe-908bb5e76b55@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a4197a2-d417-dca5-20fe-908bb5e76b55@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 01:25:20PM -0600, Shuah Khan wrote:
> On 4/12/21 1:06 PM, Tom Seewald wrote:
> > On 4/12/21 1:59 PM, Tom Seewald wrote:
> > 
> > > commit 9858af27e69247c5d04c3b093190a93ca365f33d upstream.
> > > 
> > > Currently udc->ud.tcp_rx is being assigned twice, the second assignment
> > > is incorrect, it should be to udc->ud.tcp_tx instead of rx. Fix this.
> > > 
> > > Fixes: 46613c9dfa96 ("usbip: fix vudc usbip_sockfd_store races leading to gpf")
> > > Acked-by: Shuah Khan <skhan@linuxfoundation.org>
> > > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > > Cc: stable <stable@vger.kernel.org>
> > > Addresses-Coverity: ("Unused value")
> > > Link: https://lore.kernel.org/r/20210311104445.7811-1-colin.king@canonical.com
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Signed-off-by: Tom Seewald <tseewald@gmail.com>
> > > ---
> > >   drivers/usb/usbip/vudc_sysfs.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/usb/usbip/vudc_sysfs.c b/drivers/usb/usbip/vudc_sysfs.c
> > > index f44d98eeb36a..51cc5258b63e 100644
> > > --- a/drivers/usb/usbip/vudc_sysfs.c
> > > +++ b/drivers/usb/usbip/vudc_sysfs.c
> > > @@ -187,7 +187,7 @@ static ssize_t store_sockfd(struct device *dev,
> > >   		udc->ud.tcp_socket = socket;
> > >   		udc->ud.tcp_rx = tcp_rx;
> > > -		udc->ud.tcp_rx = tcp_tx;
> > > +		udc->ud.tcp_tx = tcp_tx;
> > >   		udc->ud.status = SDEV_ST_USED;
> > >   		spin_unlock_irq(&udc->ud.lock);
> > I sent this because I believe this patch needs to be backported to the
> > 4.9.y and 4.14.y stable trees.
> > 
> 
> Tom,
> 
> Correct. This needs proting to 4.14 and 4.9. However, you have to also
> backport the patch it fixes to 4.14 and 4.9
> 
> 46613c9dfa96 ("usbip: fix vudc usbip_sockfd_store races leading to gpf")
> 
> You can combine the two patches when you backport to 4.14 and 4.9 and
> add both upstream commits in the change log.

Please do not ever combine patches for stable submissions, we want to
keep things as close as to what happened in Linus's tree as possible as
we track commit ids and putting 2 together is pretty impossible to
manage over time.

thanks,

greg k-h

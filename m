Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84D82A788A
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 09:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgKEIF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 03:05:56 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36153 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgKEIF4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 03:05:56 -0500
Received: by mail-lf1-f68.google.com with SMTP id h6so990457lfj.3;
        Thu, 05 Nov 2020 00:05:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jcbSFuZNjbwwPpmdXXuMLatE+ma/MkyayRwCMh0xeEw=;
        b=IY8TTTT/TCb1AnXBp6d4v1bQzZdEXp1SAmpAyAEBxdC1FOFpM44VUu8GQDT47gW1UF
         NTvwbU31OSEew7Yw70XGfM3uXK1EXn7BBqscXXjSeNejlQcxJhvykg8TggqifpTlRg6u
         FWLs88lCd+JcWhr9vG0mF+qBBXd6r5NLAvb/MBm7tw7DRfKEugTTYJ/YquzXHgTnKtDH
         j34SL7xegiF2OF2UYPjQLu99IDlbeK6lakp09e3bS12RuhWRxROlGUZlNZVsOw4pnOQA
         3QOczezbbcUvVn5tQnhYRZdr1pY1Ri68efFDDMYNAftpAqLtsp5ahVr44hdByZjeAZIL
         yhmg==
X-Gm-Message-State: AOAM530+OoYYDrSd/tW0erPGoKQDLkCrmFimyXLPef8VqYiDfcAkYB9W
        fZTAXHVXXb74HzsG67NNUVgi8dZxqW1zAg==
X-Google-Smtp-Source: ABdhPJxO6iT4ufyTU4k10t0H9GULmCKc8Mk9EcLRvKpR1sNEwto031olXZ7Kd6J9qcksigpxE1jkag==
X-Received: by 2002:a19:458:: with SMTP id 85mr458868lfe.249.1604563553248;
        Thu, 05 Nov 2020 00:05:53 -0800 (PST)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id d26sm79031ljj.102.2020.11.05.00.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 00:05:52 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kaaHN-0000UQ-4T; Thu, 05 Nov 2020 09:05:57 +0100
Date:   Thu, 5 Nov 2020 09:05:57 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: serial: mos7720: fix parallel-port state restore
Message-ID: <20201105080557.GZ4085@localhost>
References: <20201104164727.26351-1-johan@kernel.org>
 <20201104165910.GA2342981@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104165910.GA2342981@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 04, 2020 at 05:59:10PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Nov 04, 2020 at 05:47:27PM +0100, Johan Hovold wrote:
> > The parallel-port restore operations is called when a driver claims the
> > port and is supposed to restore the provided state (e.g. saved when
> > releasing the port).
> > 
> > Fixes: b69578df7e98 ("USB: usbserial: mos7720: add support for parallel port on moschip 7715")
> > Cc: stable <stable@vger.kernel.org>     # 2.6.35
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >  drivers/usb/serial/mos7720.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
> > index 5eed1078fac8..5a5d2a95070e 100644
> > --- a/drivers/usb/serial/mos7720.c
> > +++ b/drivers/usb/serial/mos7720.c
> > @@ -639,6 +639,8 @@ static void parport_mos7715_restore_state(struct parport *pp,
> >  		spin_unlock(&release_lock);
> >  		return;
> >  	}
> > +	mos_parport->shadowDCR = s->u.pc.ctr;
> > +	mos_parport->shadowECR = s->u.pc.ecr;
> 
> Wow that's old code.  I'm guessing no one uses these devices really :(

Possibly, but this would still work as long as you don't switch parallel
port driver without disconnecting the mos7715 device in between.

> Anyway, nice work:
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks, now applied for -next.

Johan

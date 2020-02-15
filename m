Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A6915FB99
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 01:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbgBOAnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 19:43:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:49606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727567AbgBOAnO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 19:43:14 -0500
Received: from localhost (unknown [38.98.37.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02278206CC;
        Sat, 15 Feb 2020 00:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581727393;
        bh=0UAAK02GitBI6FTXefoYEPz9/ZW54ed8x6IUi26cUHI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gv0P4a/rT4LBRqfYd4yV+05ufIKtFjrjAINPkiGxdf1xzuM0TsfXuZmUI6XabSC29
         BKZqBILAA/HmRQe/QKN4jsdAv5xbPE+bNIa5guSOtRZQylAhdlBWeT44QctUWJcRwV
         3pi9Lf8sUqTIuyRDXpyyBBlSM/pASyyGzRQrEgXo=
Date:   Fri, 14 Feb 2020 19:03:55 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH AUTOSEL 4.4 080/100] char: hpet: Use flexible-array member
Message-ID: <20200215000355.GA5524@kroah.com>
References: <20200214162425.21071-1-sashal@kernel.org>
 <20200214162425.21071-80-sashal@kernel.org>
 <20200214174314.GA250980@gmail.com>
 <20200214233650.GF1734@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214233650.GF1734@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 06:36:50PM -0500, Sasha Levin wrote:
> On Fri, Feb 14, 2020 at 09:43:14AM -0800, Eric Biggers wrote:
> > On Fri, Feb 14, 2020 at 11:24:04AM -0500, Sasha Levin wrote:
> > > From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
> > > 
> > > [ Upstream commit 987f028b8637cfa7658aa456ae73f8f21a7a7f6f ]
> > > 
> > > Old code in the kernel uses 1-byte and 0-byte arrays to indicate the
> > > presence of a "variable length array":
> > > 
> > > struct something {
> > >     int length;
> > >     u8 data[1];
> > > };
> > > 
> > > struct something *instance;
> > > 
> > > instance = kmalloc(sizeof(*instance) + size, GFP_KERNEL);
> > > instance->length = size;
> > > memcpy(instance->data, source, size);
> > > 
> > > There is also 0-byte arrays. Both cases pose confusion for things like
> > > sizeof(), CONFIG_FORTIFY_SOURCE, etc.[1] Instead, the preferred mechanism
> > > to declare variable-length types such as the one above is a flexible array
> > > member[2] which need to be the last member of a structure and empty-sized:
> > > 
> > > struct something {
> > >         int stuff;
> > >         u8 data[];
> > > };
> > > 
> > > Also, by making use of the mechanism above, we will get a compiler warning
> > > in case the flexible array does not occur last in the structure, which
> > > will help us prevent some kind of undefined behavior bugs from being
> > > unadvertenly introduced[3] to the codebase from now on.
> > > 
> > > [1] https://github.com/KSPP/linux/issues/21
> > > [2] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> > > [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> > > 
> > > Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> > > Link: https://lore.kernel.org/r/20200120235326.GA29231@embeddedor.com
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  drivers/char/hpet.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
> > > index 5b38d7a8202a1..38c2ae93ce492 100644
> > > --- a/drivers/char/hpet.c
> > > +++ b/drivers/char/hpet.c
> > > @@ -112,7 +112,7 @@ struct hpets {
> > >  	unsigned long hp_delta;
> > >  	unsigned int hp_ntimer;
> > >  	unsigned int hp_which;
> > > -	struct hpet_dev hp_dev[1];
> > > +	struct hpet_dev hp_dev[];
> > >  };
> > > 
> > 
> > Umm, why are you backporting this without the commit that fixes it?  Does your
> 
> mhm, for some reason it failed to apply to 4.19 and older. I can look at
> that.
> 
> > AUTOSEL process really still not pay attention to Fixes tags?  They are there
> > for a reason.
> 
> Yes, it looks at the Fixes tag, thank you for the explanation.
> 
> > And for that matter, why are you backporting it all, given that this is a
> > cleanup and not a fix?
> 
> If I recall correctly CONFIG_FORTIFY_SOURCE=y results in user visible
> warnings, which we try to fix in the stable kernel.

I don't think that's the case here, that build option does not turn on
this build warning from what I recall based on the original thread that
started this type of conversion.  I know I sure do not see those
warnings :)

thanks,

greg k-h

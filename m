Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 372C11796DE
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 18:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgCDRjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 12:39:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:53430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727084AbgCDRjX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 12:39:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC64722B48;
        Wed,  4 Mar 2020 17:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583343562;
        bh=zmIwO51Hh63E1n4MRaJjKLbrwtR5cfkgw9392d7mZws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xZh5c4jDIW0uTlWHNG1M7ujBNVkDJZuO6YnMu46FwMPJs6WWSnWSxQaruozBa0kg6
         tAfCOf8aFk5I7PwG/VJEj5qEgdtxQ7vXsCCx+wyvd0p+3eG4x/K9Pduom66bgdIOGP
         73DdrjeItnicDz0iw+EccziwygH57A3bzSP/bjSQ=
Date:   Wed, 4 Mar 2020 18:39:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Chen <peter.chen@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 60/87] usb: charger: assign specific number for enum
 value
Message-ID: <20200304173920.GA1866286@kroah.com>
References: <20200303174349.075101355@linuxfoundation.org>
 <20200303174355.750234821@linuxfoundation.org>
 <20200304172736.GC2367@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304172736.GC2367@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 04, 2020 at 06:27:36PM +0100, Pavel Machek wrote:
> On Tue 2020-03-03 18:43:51, Greg Kroah-Hartman wrote:
> > From: Peter Chen <peter.chen@nxp.com>
> > 
> > commit ca4b43c14cd88d28cfc6467d2fa075aad6818f1d upstream.
> > 
> > To work properly on every architectures and compilers, the enum value
> > needs to be specific numbers.
> 
> All compilers are expected to handle this in the same way, as this is
> in C standard. This patch is not neccessary, and should not be in mainline,
> either.
> 
> http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf
> 
> 6.7.2.2 Enumeration specifiers
> Syntax
> ...
> 3 The identifiers in an enumerator list are declared as constants that have type int and
> may appear wherever such are permitted.107) An enumerator with = defines its
> enumeration constant as the value of the constant expression. If the first enumerator has
> no =, the value of its enumeration constant is 0. Each subsequent enumerator with no =
> defines its enumeration constant as the value of the constant expression obtained by
> adding 1 to the value of the previous enumeration constant. (The use of enumerators with
> = may produce enumeration constants with values that duplicate other values in the same
> enumeration.) The enumerators of an enumeration are also known as its members.
> 
> Best regards,
> 								Pavel
> 
> >  enum usb_charger_type {
> > -	UNKNOWN_TYPE,
> > -	SDP_TYPE,
> > -	DCP_TYPE,
> > -	CDP_TYPE,
> > -	ACA_TYPE,
> > +	UNKNOWN_TYPE = 0,
> > +	SDP_TYPE = 1,
> > +	DCP_TYPE = 2,
> > +	CDP_TYPE = 3,
> > +	ACA_TYPE = 4,
> >  };

It specified that we need to do this by the in-kernel documentation
about how to write a solid api (which I can't find at the moment to
point you at, sorry...)  Also, you pointed at a draft C standard, is
that really implemented by older compilers?

thanks,

greg k-h

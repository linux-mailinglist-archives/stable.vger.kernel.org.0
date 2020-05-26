Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4681E25F1
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 17:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgEZPsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 11:48:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:27189 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727061AbgEZPsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 11:48:43 -0400
IronPort-SDR: KRGgT9oQ9Der3d4hH0ZOEIRyfDJ/B0MadeUpkkdeFxVPFONYKYN4Rzy5k9BTQ2kcaM1Qy9NXlO
 18i8V+SKrtoA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 08:48:36 -0700
IronPort-SDR: 9r1wevZOJJL4X3ZpDu4uVOXS/LfIhzSY80MVMsGu9VilwjF0IoSxDNFLoHZusveuLa+8k+eaiu
 g5y9tOhzbybQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,437,1583222400"; 
   d="scan'208";a="256491252"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by fmsmga008.fm.intel.com with ESMTP; 26 May 2020 08:48:36 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 06777301C5F; Tue, 26 May 2020 08:48:36 -0700 (PDT)
Date:   Tue, 26 May 2020 08:48:35 -0700
From:   Andi Kleen <ak@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1] x86: Pin cr4 FSGSBASE
Message-ID: <20200526154835.GW499505@tassilo.jf.intel.com>
References: <20200526052848.605423-1-andi@firstfloor.org>
 <20200526065618.GC2580410@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526065618.GC2580410@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 08:56:18AM +0200, Greg KH wrote:
> On Mon, May 25, 2020 at 10:28:48PM -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Since there seem to be kernel modules floating around that set
> > FSGSBASE incorrectly, prevent this in the CR4 pinning. Currently
> > CR4 pinning just checks that bits are set, this also checks
> > that the FSGSBASE bit is not set, and if it is clears it again.
> 
> So we are trying to "protect" ourselves from broken out-of-tree kernel
> modules now?  

Well it's a specific case where we know they're opening a root hole
unintentionally. This is just an pragmatic attempt to protect the users in the 
short term.

> Why stop with this type of check, why not just forbid them
> entirely if we don't trust them?  :)

Would be pointless -- lots of people rely on them, so such a rule
wouldn't survive very long in production kernels.

> > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> > index bed0cb83fe24..1f5b7871ae9a 100644
> > --- a/arch/x86/kernel/cpu/common.c
> > +++ b/arch/x86/kernel/cpu/common.c
> > @@ -385,6 +385,11 @@ void native_write_cr4(unsigned long val)
> >  		/* Warn after we've set the missing bits. */
> >  		WARN_ONCE(bits_missing, "CR4 bits went missing: %lx!?\n",
> >  			  bits_missing);
> > +		if (val & X86_CR4_FSGSBASE) {
> > +			WARN_ONCE(1, "CR4 unexpectedly set FSGSBASE!?\n");
> 
> Like this will actually be noticed by anyone who calls this?  What is a
> user supposed to do about this?

In the long term they would need to apply the proper patches
for FSGSBASE.

> 
> What about those systems that panic-on-warn?

I assume they're ok with "panic on root hole"

> 
> > +			val &= ~X86_CR4_FSGSBASE;
> 
> So you just prevented them from setting this, thereby fixing up their
> broken code that will never be fixed because you did this?  Why do this?

If they rely on the functionality they will apply the proper patches
then. Or at least they will be aware that they have a root hole,
which they are currently not.

-Andi

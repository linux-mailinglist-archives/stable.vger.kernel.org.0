Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2B7AA97C
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 18:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390819AbfIEQ5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 12:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389547AbfIEQ5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Sep 2019 12:57:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C65720825;
        Thu,  5 Sep 2019 16:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567702625;
        bh=A9rEMrkzcP1PllWUo7qsbxgP4IfNmyWL9LWYqH72v+s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NMA2qIoVrX7S/z/t3jBgNqQm/y28n8bEfnyEUp/5gy3FqP9MZt2NUF+SJLZhDJBEf
         Hs7syyJTF8NT+PmKrugERHEsji/M8ehihFon8eM23ni1ye0sR/NtPXwwU6mPYs8jsl
         DCbXQWizidahWTMhPgvy3gpdE954wHEdxKZG3H5c=
Date:   Thu, 5 Sep 2019 18:57:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Travis <mike.travis@hpe.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Christoph Hellwig <hch@infradead.org>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6/8] x86/platform/uv: Decode UVsystab Info
Message-ID: <20190905165701.GB2737@kroah.com>
References: <20190905130252.590161292@stormcage.eag.rdlabs.hpecorp.net>
 <20190905130253.325911213@stormcage.eag.rdlabs.hpecorp.net>
 <20190905141634.GA25790@kroah.com>
 <ae007007-02cc-0081-22c0-34b2d67f2cd3@hpe.com>
 <d0675e8f-80a2-bba4-888c-90feda085a14@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d0675e8f-80a2-bba4-888c-90feda085a14@hpe.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 05, 2019 at 09:43:57AM -0700, Mike Travis wrote:
> 
> 
> On 9/5/2019 7:47 AM, Mike Travis wrote:
> > Also, nit:
> > 
> > > --- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
> > > +++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
> > > @@ -1303,7 +1303,8 @@ static int __init decode_uv_systab(void)
> > >       struct uv_systab *st;
> > >       int i;
> > > -    if (uv_hub_info->hub_revision < UV4_HUB_REVISION_BASE)
> > > +    /* Select only UV4 (hubbed or hubless) and higher */
> > > +    if (is_uv_hubbed(-2) < uv(4) && is_uv_hubless(-2) < uv(4))
> > >           return 0;    /* No extended UVsystab required */
> > >       st = uv_systab;
> > > @@ -1554,8 +1555,19 @@ static __init int uv_system_init_hubless
> > >       /* Init kernel/BIOS interface */
> > >       rc = uv_bios_init();
> > > +    if (rc < 0) {
> > > +        pr_err("UV: BIOS init error:%d\n", rc);
> > 
> > Why isn't that function printing an error?
> > 
> > 
> > > +        return rc;
> > > +    }
> > > +
> > > +    /* Process UVsystab */
> > > +    rc = decode_uv_systab();
> > > +    if (rc < 0) {
> > > +        pr_err("UV: UVsystab decode error:%d\n", rc);
> > 
> > Same here, have the function itself print the error, makes this type of
> > stuff much cleaner.
> 
> Turns out both functions already print an error message for each instance of
> an error.  The only redundancy is the caller also printing an error with
> just the numeric error code.  Shall I remove that?

Of course you should, why would you want to see multiple error messages
for the same single error?

greg k-h

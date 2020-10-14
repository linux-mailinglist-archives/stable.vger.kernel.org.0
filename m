Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5ED928DFE3
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 13:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387873AbgJNLhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 07:37:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387867AbgJNLhQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 07:37:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D22820725;
        Wed, 14 Oct 2020 11:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602675434;
        bh=fR8EojBjyqlC6VfmMLX4OReRPtfhrwp2l9jjEeu7+Kg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CcercRVDHep/B9owVIsPo0RiF+NKHdIG11Sjz1s43X+gnnTO+RCwjlX01WJyn26bk
         ihFYKD4ndp+cFFDo8FvCMFiEiYJFjaCTgcWMWbHhunpECdJ9LukG3Aj3VzcjgDwLQv
         hmOH4wxecoS3yjm2Q+NQmr5fTBeIIU7CAwA/GaYw=
Date:   Wed, 14 Oct 2020 13:37:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ben Chuang <benchuanggli@gmail.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Ben Chuang <ben.chuang@genesyslogic.com.tw>,
        greg.tu@genesyslogic.com.tw, seanhy.chen@genesyslogic.com.tw,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: sdhci-pci-gli: Set SDR104's clock to 205MHz and
 enable SSC for GL975x
Message-ID: <20201014113749.GA3679515@kroah.com>
References: <20201013074600.9784-1-benchuanggli@gmail.com>
 <20201013080105.GA1681211@kroah.com>
 <CACT4zj8xjeRFnXekojFseHUTqouRwCwmXsCFVMWA+jhnW-DaDQ@mail.gmail.com>
 <20201013085806.GB1681211@kroah.com>
 <CACT4zj-ShpspM0PNA_Q4fkEAubiTfp_rxcZ6FkQgcKoYx7WaNA@mail.gmail.com>
 <20201013134849.GA1968052@kroah.com>
 <CACT4zj8GW57Ugaaade5BnAeHgo15uf=zbmYNJhxwBygevXLW3g@mail.gmail.com>
 <20201014081119.GA3009479@kroah.com>
 <CACT4zj_uS+Ziip0EZa32+PGVLC0ZP7+=MbovrUR+rCwe6r5_4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACT4zj_uS+Ziip0EZa32+PGVLC0ZP7+=MbovrUR+rCwe6r5_4Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 14, 2020 at 06:42:06PM +0800, Ben Chuang wrote:
> Hi Greg,
> 
> On Wed, Oct 14, 2020 at 4:10 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Oct 14, 2020 at 04:00:49PM +0800, Ben Chuang wrote:
> > > Hi Greg,
> > >
> > > On Tue, Oct 13, 2020 at 9:48 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Tue, Oct 13, 2020 at 07:11:13PM +0800, Ben Chuang wrote:
> > > > > On Tue, Oct 13, 2020 at 4:57 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > > >
> > > > > > On Tue, Oct 13, 2020 at 04:33:38PM +0800, Ben Chuang wrote:
> > > > > > > On Tue, Oct 13, 2020 at 4:00 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > > > > >
> > > > > > > > On Tue, Oct 13, 2020 at 03:46:00PM +0800, Ben Chuang wrote:
> > > > > > > > > From: Ben Chuang <ben.chuang@genesyslogic.com.tw>
> > > > > > > > >
> > > > > > > > > commit 786d33c887e15061ff95942db68fe5c6ca98e5fc upstream.
> > > > > > > > >
> > > > > > > > > Set SDR104's clock to 205MHz and enable SSC for GL9750 and GL9755
> > > > > > > > >
> > > > > > > > > Signed-off-by: Ben Chuang <ben.chuang@genesyslogic.com.tw>
> > > > > > > > > Link: https://lore.kernel.org/r/20200717033350.13006-1-benchuanggli@gmail.com
> > > > > > > > > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> > > > > > > > > Cc: <stable@vger.kernel.org> # 5.4.x
> > > > > > > > > ---
> > > > > > > > > Hi Greg and Sasha,
> > > > > > > > >
> > > > > > > > > The patch is to improve the EMI of the hardware.
> > > > > > > > > So it should be also required for some hardware devices using the v5.4.
> > > > > > > > > Please tell me if have other questions.
> > > > > > > >
> > > > > > > > This looks like a "add support for new hardware" type of patch, right?
> > > > > > >
> > > > > > > No, this is for a mass production hardware.
> > > > > >
> > > > > > That does not make sense, sorry.
> > > > > >
> > > > > > Is this a bug that is being fixed, did the hardware work properly before
> > > > > > 5.4 and now it does not?  Or has it never worked properly and 5.9 is the
> > > > > > first kernel that it now works on?
> > > > >
> > > > > It seems there is misunderstanding regarding “hardware” means.
> > > > > I originally thought that the "hardware" refers to GL975x chips.
> > > > >
> > > > > This Genesys patch is to fix the EMI problem for GL975x controller on a system.
> > > >
> > > > Did it work on the 4.19 kernel?  Another older kernel?  Or is 5.9 the
> > > > first kernel release where it works?
> > >
> > > The patch works on after v5.4.
> >
> > You are not answering the question I am trying to ask.
> >
> > My question is:
> >         Did this hardware ever work properly before the 5.9 kernel
> >         release.
> 
> Yes.

It did?  What kernel release from kernel.org did it work, and what
kernel release did it break on?

> > > > In other words, is this fixing a regression, or just enabling hardware
> > > > support for something that has never worked before for this hardware?
> > >
> > > This patch is to reduce the EMI at SDR104 mode for GL975x.
> > > It changes the preset frequency of SDR104 to 205Mhz and sets the SSC value.
> > > So I think it is fixing a regression.
> >
> > A regression is when an older kernel works fine, but a newer kernel does
> > not.  When that happens, you can point to a specific commit and say,
> > "this commit here broke this previously working hardware".
> >
> > Is that the case here?  If not, this is not a regression.
> 
> With this definition, no.

Wait, I do not understand, this is the exact oposite of what you said
above.

Which is true?

totally confused,

greg k-h

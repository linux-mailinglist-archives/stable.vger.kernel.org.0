Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A3020C288
	for <lists+stable@lfdr.de>; Sat, 27 Jun 2020 16:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgF0O5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jun 2020 10:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbgF0O5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 27 Jun 2020 10:57:19 -0400
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E324208B6;
        Sat, 27 Jun 2020 14:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593269839;
        bh=2k+Ddvpy38yCyS24U3uqfEu9sS8DoXsnMunaJLPEhwM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FxGuDTOWd4gGbazeLB6tt0juiurDHonA2P6+DxziSUgnwD3twuvKPxhAe7s4qn3kv
         bm8Evici7YPzopjFwnqUyO925FKQmtZlZk+9AlO78Lye1GxeOyRrNhILXW+MMwpFTN
         Fr/3d5VMqaMmuAUrtCD8SAiHgQmBV6L49FNAEmPE=
Date:   Sat, 27 Jun 2020 15:57:14 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Rob Herring <robh+dt@kernel.org>, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: iio: bmc150_magn: Document missing
 compatibles
Message-ID: <20200627155714.15478f60@archlinux>
In-Reply-To: <20200622051940.GA4021@kozik-lap>
References: <20200617101259.12525-1-krzk@kernel.org>
        <20200620164049.5aa91365@archlinux>
        <20200622051940.GA4021@kozik-lap>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Jun 2020 07:19:40 +0200
Krzysztof Kozlowski <krzk@kernel.org> wrote:

> On Sat, Jun 20, 2020 at 04:40:49PM +0100, Jonathan Cameron wrote:
> > On Wed, 17 Jun 2020 12:12:59 +0200
> > Krzysztof Kozlowski <krzk@kernel.org> wrote:
> >   
> > > The driver supports also BMC156B and BMM150B so document the compatibles
> > > for these devices.
> > > 
> > > Fixes: 9d75db36df14 ("iio: magn: Add support for BMM150 magnetometer")
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > > 
> > > ---
> > > 
> > > The fixes tag is not accurate but at least offer some backporting.  
> > 
> > I'm not sure we generally bother backporting a missing section of binding
> > documentation. Particularly as this doc isn't in yaml yet so it's not
> > as though any automated checking is likely to be occurring.
> > 
> > Rob, any views on backporting this sort of missing id addition?
> > 
> > One side comment here is that the devices that are magnetometers only
> > should never have had the _magn prefix in their compatibles. We only
> > do that for devices in incorporating several sensors in one package
> > (like the bmc150) where we have multiple drivers for the different
> > sensors incorporated. We are too late to fix that now though.  It
> > may make sense to mark the _magn variants deprecated though and
> > add the ones without the _magn postfix.  
> 
> I can add proper compatibles and mark these as deprecated but actually
> the driver should not have additional compatibles in first place - all
> devices are just compatible with bosch,bmc150.

Why not?  Whilst the devices may be compatible in theory, it's not unusual
for subtle differences to emerge later.   As such we tend to at least
support the most specific compatible possible for a part - though we
can use fallback compatibles.

> 
> Therefore I can just add one new compatible: "bosch,bmc156" and mark the
> last two deprecated.

Sorry. I missed this earlier in the week.   The bmc156 is a SIP combining
separate silicon for the magnetometer and accelerometer.  Hence that one
should have the _magn extension as we will (I think) be loading two drivers
for the same part number.  The bmm part however is just a magnetometer
so doesn't need the postfix.

> 
> Best regards,
> Krzysztof
> 
> 
> >   
> > > ---
> > >  .../devicetree/bindings/iio/magnetometer/bmc150_magn.txt     | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/Documentation/devicetree/bindings/iio/magnetometer/bmc150_magn.txt b/Documentation/devicetree/bindings/iio/magnetometer/bmc150_magn.txt
> > > index fd5fca90fb39..7469073022db 100644
> > > --- a/Documentation/devicetree/bindings/iio/magnetometer/bmc150_magn.txt
> > > +++ b/Documentation/devicetree/bindings/iio/magnetometer/bmc150_magn.txt
> > > @@ -4,7 +4,10 @@ http://ae-bst.resource.bosch.com/media/products/dokumente/bmc150/BST-BMC150-DS00
> > >  
> > >  Required properties:
> > >  
> > > -  - compatible : should be "bosch,bmc150_magn"
> > > +  - compatible : should be one of:
> > > +                 "bosch,bmc150_magn"
> > > +                 "bosch,bmc156_magn"
> > > +                 "bosch,bmm150_magn"
> > >    - reg : the I2C address of the magnetometer
> > >  
> > >  Optional properties:  
> >   


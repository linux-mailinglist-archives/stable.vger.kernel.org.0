Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A422AABF1
	for <lists+stable@lfdr.de>; Sun,  8 Nov 2020 16:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgKHPeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 10:34:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:50358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbgKHPeO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Nov 2020 10:34:14 -0500
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 809CD206E0;
        Sun,  8 Nov 2020 15:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604849653;
        bh=pW03Q8PavMrNNrZtRrt0VdR4H/knxEM4zLDSJghIlDI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P4k1BZRuFAGrtOM3AxvHQTDPghXX2884LqyqFo5QL2x8S7eL2uYUblcakhH0ALoUc
         xx4sC3gYMl/U7p+aYIx0dFVg1S75YA+egQvoPjs/GfmaHhA6k5p9rTgPF6zWdRYVmx
         XASBnkss5TZNv3qQ3CWbpaFbwKQ+Y05FsxO6bnaA=
Date:   Sun, 8 Nov 2020 15:34:09 +0000
From:   Jonathan Cameron <jic23@kernel.org>
To:     Artur Rojek <contact@artur-rojek.eu>
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>, od@zcrc.me,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] iio/adc: ingenic: Fix battery VREF for JZ4770 SoC
Message-ID: <20201108153409.723eeb8c@archlinux>
In-Reply-To: <1a319d53f1fd74b41056663421ef785e@artur-rojek.eu>
References: <20201104192843.67187-1-paul@crapouillou.net>
        <cb8b8ff426500db61c61b51413f3746c@artur-rojek.eu>
        <F3RAJQ.DZODDTV09KM21@crapouillou.net>
        <1a319d53f1fd74b41056663421ef785e@artur-rojek.eu>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 05 Nov 2020 01:27:51 +0100
Artur Rojek <contact@artur-rojek.eu> wrote:

> On 2020-11-05 01:09, Paul Cercueil wrote:
> > Hi Artur,
> >=20
> > Le mer. 4 nov. 2020 =C3=A0 23:29, Artur Rojek <contact@artur-rojek.eu> =
a=20
> > =C3=A9crit : =20
> >> Hi Paul,
> >>=20
> >> On 2020-11-04 20:28, Paul Cercueil wrote: =20
> >>> The reference voltage for the battery is clearly marked as 1.2V in=20
> >>> the
> >>> programming manual. With this fixed, the battery channel now returns
> >>> correct values.
> >>>=20
> >>> Fixes: a515d6488505 ("IIO: Ingenic JZ47xx: Add support for JZ4770 SoC=
=20
> >>> =7FADC.")
> >>> Cc: <stable@vger.kernel.org>
> >>> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> >>> ---
> >>>  drivers/iio/adc/ingenic-adc.c | 2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>=20
> >>> diff --git a/drivers/iio/adc/ingenic-adc.c=20
> >>> =7Fb/drivers/iio/adc/ingenic-adc.c
> >>> index ecaff6a9b716..19b95905a45c 100644
> >>> --- a/drivers/iio/adc/ingenic-adc.c
> >>> +++ b/drivers/iio/adc/ingenic-adc.c
> >>> @@ -71,7 +71,7 @@
> >>>  #define JZ4725B_ADC_BATTERY_HIGH_VREF_BITS	10
> >>>  #define JZ4740_ADC_BATTERY_HIGH_VREF		(7500 * 0.986)
> >>>  #define JZ4740_ADC_BATTERY_HIGH_VREF_BITS	12
> >>> -#define JZ4770_ADC_BATTERY_VREF			6600
> >>> +#define JZ4770_ADC_BATTERY_VREF			1200
> >>>  #define JZ4770_ADC_BATTERY_VREF_BITS		12
> >>>=20
> >>>  #define JZ_ADC_IRQ_AUX			BIT(0) =20
> >>=20
> >> I thought we set it to 6600 because GCW Zero was not showing correct=20
> >> battery values at 1200.
> >> But if you verified that 1200 works with JZ4770, then:
> >> Acked-by: Artur Rojek <contact@artur-rojek.eu> =20
> >=20
> > Yes, IIRC we were trying to figure out the range and settled with
> > [-3.3V,+3.3V] since it would give "plausible" values but which were
> > never quite right. The doc does say that the voltage is (hw_val /
> > 4096) * 1.2V, but also says that the ADC operated with 3.3V power
> > supply, I guess we got confused. We never considered the battery could
> > not be connected directly to the ADC's VBAT pin, so a 1.2V reference
> > didn't make sense at that time. I guess we need to learn about
> > electronics :) =20
> Yes we do :)
> >=20
> > It turns out the battery is connected to the VBAT pin with a 1 MOhm
> > resistor, and the VBAT pin is also pulled low with a 332 kOhm
> > resistor. So a fully charged battery with 4.2V reads as (4.2V *
> > 332000) / (1332000) =3D 1.05V, which totally fits in a [0V,+1.2V] range.
> >=20
> > With that same 4.2V battery I get a hardware value of about 3584, and
> > (3584 / 4096) * 1.2V =3D=3D 1.05V, which matches the value computed abo=
ve.
> > So the battery reading looks accurate this time. =20
> Excellent! Thanks for the detailed explanation.

Applied to the fixes-togreg branch of iio.git

Thanks,

Jonathan

>=20
> Cheers,
> Artur
> >=20
> > Cheers,
> > -Paul =20


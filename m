Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA692FEC7F
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 14:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfKPNy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 08:54:27 -0500
Received: from outils.crapouillou.net ([89.234.176.41]:43426 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727551AbfKPNy0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Nov 2019 08:54:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1573912464; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FMg2UQ0AjVfNKkZxaPXgwun/tawVgx5MduyoijaPIVs=;
        b=JCs4egWjPEhJHCVnunWe+Hv6R2v65qQYjiqSqtcMixHFDWutHoMZF8TjB9+5zoG4Q5pb39
        BJNhzUS0fRap2UUDLH7OUw0F/7TuQWGjs6aGIR0qZKttvQ/FZgmQiPPYwIIvlTtE0ITBoC
        4rcssO5nR4YVmfmTNLkTco2LDd1jS2g=
Date:   Sat, 16 Nov 2019 14:54:18 +0100
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH v2] power/supply: ingenic-battery: Don't change scale if
 there's only one
To:     Artur Rojek <contact@artur-rojek.eu>
Cc:     Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Message-Id: <1573912458.3.0@crapouillou.net>
In-Reply-To: <0f300a5f82b4cce76cdbdb5ba081d7ae@artur-rojek.eu>
References: <20191114163500.57384-1-paul@crapouillou.net>
        <0f300a5f82b4cce76cdbdb5ba081d7ae@artur-rojek.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Artur,


Le ven., nov. 15, 2019 at 18:39, Artur Rojek <contact@artur-rojek.eu> a=20
=E9crit :
> Hi Paul.
> Comments inline.
>=20
> On 2019-11-14 17:35, Paul Cercueil wrote:
>> The ADC in the JZ4740 can work either in high-precision mode with a=20
>> =7F2.5V
>> range, or in low-precision mode with a 7.5V range. The code in place=20
>> in
>> this driver will select the proper scale according to the maximum
>> voltage of the battery.
>>=20
>> The JZ4770 however only has one mode, with a 6.6V range. If only one
>> scale is available, there's no need to change it (and nothing to=20
>> change
>> it to), and trying to do so will fail with -EINVAL.
>>=20
>> Fixes: fb24ccfbe1e0 ("power: supply: add Ingenic JZ47xx battery=20
>> =7Fdriver.")
>>=20
>> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
>> Cc: stable@vger.kernel.org
>> ---
>>=20
>> Notes:
>>     v2: Rebased on v5.4-rc7
>>=20
>>  drivers/power/supply/ingenic-battery.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>=20
>> diff --git a/drivers/power/supply/ingenic-battery.c
>> b/drivers/power/supply/ingenic-battery.c
>> index 35816d4b3012..5a53057b4f64 100644
>> --- a/drivers/power/supply/ingenic-battery.c
>> +++ b/drivers/power/supply/ingenic-battery.c
>> @@ -80,6 +80,10 @@ static int ingenic_battery_set_scale(struct
>> ingenic_battery *bat)
>>  	if (ret !=3D IIO_AVAIL_LIST || scale_type !=3D IIO_VAL_FRACTIONAL_LOG2=
)
>>  		return -EINVAL;
>>=20
>> +	/* Only one (fractional) entry - nothing to change */
>> +	if (scale_len =3D=3D 2)
>> +		return 0;
>> +
>=20
> This function also serves to validate that the maximum voltage is in=20
> range of available scales.
> Please move your code down a bit so that the check for max_mV is=20
> still being done.

Good point - I'll send a V3.

-Paul

>=20
> Thanks,
> Artur
>=20
>>  	max_mV =3D bat->info.voltage_max_design_uv / 1000;
>>=20
>>  	for (i =3D 0; i < scale_len; i +=3D 2) {

=


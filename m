Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60241216287
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 01:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgGFXuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 19:50:13 -0400
Received: from crapouillou.net ([89.234.176.41]:53578 "EHLO crapouillou.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbgGFXuN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jul 2020 19:50:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1594079410; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NboD0HuCCOCTz3ZvzoSX9hS0Fzn/G2ArNDsjnk2M+qY=;
        b=gEAErzWQGyz4moVpKPHo4splZgegEadql6JwC2qaisrd0+qP+TPB2uI3F+nrFS7tqOgfAR
        MtIT8xWuXZn+f7qSfOMDFerYQy0QG8yZv9gR8Pf+u1KyyrmsfVEQS6PQh+vQvoioabP88Q
        RNGME1GfxlfaYnyFzs/iaQfnFYjzESg=
Date:   Tue, 07 Jul 2020 01:49:59 +0200
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH] drm/dbi: Fix SPI Type 1 (9-bit) transfer
To:     Noralf =?iso-8859-1?q?Tr=F8nnes?= <noralf@tronnes.org>
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Sam Ravnborg <sam@ravnborg.org>,
        stable@vger.kernel.org
Message-Id: <BJN2DQ.10EODF78DAWA@crapouillou.net>
In-Reply-To: <0dda6b3f-ea8c-6a7e-5c7c-f26874b825c8@tronnes.org>
References: <20200703141341.1266263-1-paul@crapouillou.net>
        <0dda6b3f-ea8c-6a7e-5c7c-f26874b825c8@tronnes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Noralf,

Le dim. 5 juil. 2020 =E0 17:58, Noralf Tr=F8nnes <noralf@tronnes.org> a=20
=E9crit :
>=20
>=20
> Den 03.07.2020 16.13, skrev Paul Cercueil:
>>  The function mipi_dbi_spi1_transfer() will transfer its payload as=20
>> 9-bit
>>  data, the 9th (MSB) bit being the data/command bit. In order to do=20
>> that,
>>  it unpacks the 8-bit values into 16-bit values, then sets the 9th=20
>> bit if
>>  the byte corresponds to data, clears it otherwise. The 7 MSB are
>>  padding. The array of now 16-bit values is then passed to the SPI=20
>> core
>>  for transfer.
>>=20
>>  This function was broken since its introduction, as the length of=20
>> the
>>  SPI transfer was set to the payload size before its conversion, but=20
>> the
>>  payload doubled in size due to the 8-bit -> 16-bit conversion.
>>=20
>>  Fixes: 02dd95fe3169 ("drm/tinydrm: Add MIPI DBI support")
>>  Cc: <stable@vger.kernel.org> # 4.10
>=20
> The code was moved to drm_mipi_dbi.c in 5.4 so this patch won't apply
> before that.

I believe I can submit a patch for pre-5.4 too.

>>  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
>>  ---
>=20
> Thanks for fixing this, clearly I didn't test this. Probably because=20
> the
> aux spi ip block on the Raspberry Pi that can do 9 bit didn't have a
> driver at the time. Did you actually test this or was it spotted=20
> reading
> the code?

I did test it on hardware, yes - that's how I spotted the bug.

-Paul

> Reviewed-by: Noralf Tr=F8nnes <noralf@tronnes.org>
>=20
>>   drivers/gpu/drm/drm_mipi_dbi.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>>  diff --git a/drivers/gpu/drm/drm_mipi_dbi.c=20
>> b/drivers/gpu/drm/drm_mipi_dbi.c
>>  index bb27c82757f1..bf7888ad9ad4 100644
>>  --- a/drivers/gpu/drm/drm_mipi_dbi.c
>>  +++ b/drivers/gpu/drm/drm_mipi_dbi.c
>>  @@ -923,7 +923,7 @@ static int mipi_dbi_spi1_transfer(struct=20
>> mipi_dbi *dbi, int dc,
>>   			}
>>   		}
>>=20
>>  -		tr.len =3D chunk;
>>  +		tr.len =3D chunk * 2;
>>   		len -=3D chunk;
>>=20
>>   		ret =3D spi_sync(spi, &m);
>>=20



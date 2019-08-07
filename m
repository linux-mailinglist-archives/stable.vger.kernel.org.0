Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4E138481B
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 10:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbfHGItz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 7 Aug 2019 04:49:55 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:36985 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728360AbfHGItz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Aug 2019 04:49:55 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-219-Xw5AdrD2MRiS34lGOcsHNg-1; Wed, 07 Aug 2019 09:49:52 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 7 Aug 2019 09:49:52 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 7 Aug 2019 09:49:52 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Sasha Levin' <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Colin Ian King <colin.king@canonical.com>,
        Inki Dae <inki.dae@samsung.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: RE: [PATCH AUTOSEL 5.2 51/59] drm/exynos: fix missing decrement of
 retry counter
Thread-Topic: [PATCH AUTOSEL 5.2 51/59] drm/exynos: fix missing decrement of
 retry counter
Thread-Index: AQHVTJ/1OP2tfkMm3E2/Hf9p02kXJabvYCkQ
Date:   Wed, 7 Aug 2019 08:49:52 +0000
Message-ID: <2ecde45912fc44b88df2ff5129b8ab67@AcuMS.aculab.com>
References: <20190806213319.19203-1-sashal@kernel.org>
 <20190806213319.19203-51-sashal@kernel.org>
In-Reply-To: <20190806213319.19203-51-sashal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: Xw5AdrD2MRiS34lGOcsHNg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Levin
> Sent: 06 August 2019 22:33
> 
> From: Colin Ian King <colin.king@canonical.com>
> 
> [ Upstream commit 1bbbab097a05276e312dd2462791d32b21ceb1ee ]
> 
> Currently the retry counter is not being decremented, leading to a
> potential infinite spin if the scalar_reads don't change state.
> 
> Addresses-Coverity: ("Infinite loop")
> Fixes: 280e54c9f614 ("drm/exynos: scaler: Reset hardware before starting the operation")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Inki Dae <inki.dae@samsung.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_scaler.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_scaler.c b/drivers/gpu/drm/exynos/exynos_drm_scaler.c
> index ec9c1b7d31033..8989f8af716b7 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_scaler.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_scaler.c
> @@ -94,12 +94,12 @@ static inline int scaler_reset(struct scaler_context *scaler)
>  	scaler_write(SCALER_CFG_SOFT_RESET, SCALER_CFG);
>  	do {
>  		cpu_relax();
> -	} while (retry > 1 &&
> +	} while (--retry > 1 &&
>  		 scaler_read(SCALER_CFG) & SCALER_CFG_SOFT_RESET);
>  	do {
>  		cpu_relax();
>  		scaler_write(1, SCALER_INT_EN);
> -	} while (retry > 0 && scaler_read(SCALER_INT_EN) != 1);
> +	} while (--retry > 0 && scaler_read(SCALER_INT_EN) != 1);
> 
>  	return retry ? 0 : -EIO;

If the first loop hits the retry limit the second loop won't be right
and the final return value will be 0.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


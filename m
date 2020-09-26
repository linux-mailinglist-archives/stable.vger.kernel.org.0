Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCB9279A1F
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 16:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgIZOcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 10:32:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726244AbgIZOcv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Sep 2020 10:32:51 -0400
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6355920BED;
        Sat, 26 Sep 2020 14:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601130771;
        bh=Hs5xYTDMb0F0AjFpvAFDnp75Yob3TMgGbH+KRU9xUo8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eORSPQ2+/iHHig92EzVpbwvq/LIlyUUvtA6RNZtYYFqy5WXlT/g/4i5vjvJWoVbvB
         A4PxSZ6KFdOtz3jHbqz16D1ElpLRHEr+pWOtwU+G6uELXJqJzbZKdiIwF4/acJ12JQ
         hQmijf+ZlZj0ZdLcwBodq68svCjaHA6XDtgnkP3s=
Date:   Sat, 26 Sep 2020 15:32:46 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     Nuno =?UTF-8?B?U8Oh?= <nuno.sa@analog.com>
Cc:     <linux-iio@vger.kernel.org>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Lars-Peter Clausen <lars@metafoo.de>, <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] iio: ltc2983: Fix of_node refcounting
Message-ID: <20200926153246.43ea05e2@archlinux>
In-Reply-To: <20200925091045.302-1-nuno.sa@analog.com>
References: <20200925091045.302-1-nuno.sa@analog.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Sep 2020 11:10:44 +0200
Nuno S=C3=A1 <nuno.sa@analog.com> wrote:

> When returning or breaking early from a
> `for_each_available_child_of_node()` loop, we need to explicitly call
> `of_node_put()` on the child node to possibly release the node.
>=20
> Fixes: f110f3188e563 ("iio: temperature: Add support for LTC2983")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nuno S=C3=A1 <nuno.sa@analog.com>

I've tweaked this a tiny bit and applied it to the fixes-togreg branch
of iio.git on assumption it won't now go in until after the merge
window.  If merge window is delayed, I may sneak it in for that.

Thanks,

Jonathan

> ---
>  drivers/iio/temperature/ltc2983.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/iio/temperature/ltc2983.c b/drivers/iio/temperature/=
ltc2983.c
> index 55ff28a0f1c7..c6641bc185cb 100644
> --- a/drivers/iio/temperature/ltc2983.c
> +++ b/drivers/iio/temperature/ltc2983.c
> @@ -1285,18 +1285,19 @@ static int ltc2983_parse_dt(struct ltc2983_data *=
st)
>  		ret =3D of_property_read_u32(child, "reg", &sensor.chan);
>  		if (ret) {
>  			dev_err(dev, "reg property must given for child nodes\n");
> -			return ret;
> +			goto put_child;
>  		}
> =20
>  		/* check if we have a valid channel */
> +		ret =3D -EINVAL;

I'm not keen on this being here rather than in the error path.
It will obvious work, but is harder to read and more
fragile if future changes are made.

I've moved it down into the two cases this covers.

>  		if (sensor.chan < LTC2983_MIN_CHANNELS_NR ||
>  		    sensor.chan > LTC2983_MAX_CHANNELS_NR) {
>  			dev_err(dev,
>  				"chan:%d must be from 1 to 20\n", sensor.chan);
> -			return -EINVAL;
> +			goto put_child;
>  		} else if (channel_avail_mask & BIT(sensor.chan)) {
>  			dev_err(dev, "chan:%d already in use\n", sensor.chan);
> -			return -EINVAL;
> +			goto put_child;
>  		}
> =20
>  		ret =3D of_property_read_u32(child, "adi,sensor-type",
> @@ -1304,7 +1305,7 @@ static int ltc2983_parse_dt(struct ltc2983_data *st)
>  		if (ret) {
>  			dev_err(dev,
>  				"adi,sensor-type property must given for child nodes\n");
> -			return ret;
> +			goto put_child;
>  		}
> =20
>  		dev_dbg(dev, "Create new sensor, type %u, chann %u",
> @@ -1334,13 +1335,15 @@ static int ltc2983_parse_dt(struct ltc2983_data *=
st)
>  			st->sensors[chan] =3D ltc2983_adc_new(child, st, &sensor);
>  		} else {
>  			dev_err(dev, "Unknown sensor type %d\n", sensor.type);
> -			return -EINVAL;
> +			ret =3D -EINVAL;
> +			goto put_child;
>  		}
> =20
>  		if (IS_ERR(st->sensors[chan])) {
>  			dev_err(dev, "Failed to create sensor %ld",
>  				PTR_ERR(st->sensors[chan]));
> -			return PTR_ERR(st->sensors[chan]);
> +			ret =3D PTR_ERR(st->sensors[chan]);
> +			goto put_child;
>  		}
>  		/* set generic sensor parameters */
>  		st->sensors[chan]->chan =3D sensor.chan;
> @@ -1351,6 +1354,9 @@ static int ltc2983_parse_dt(struct ltc2983_data *st)
>  	}
> =20
>  	return 0;
> +put_child:
> +	of_node_put(child);
> +	return ret;
>  }
> =20
>  static int ltc2983_setup(struct ltc2983_data *st, bool assign_iio)


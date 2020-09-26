Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60131279A26
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 16:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgIZOnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 10:43:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgIZOnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Sep 2020 10:43:09 -0400
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5324720BED;
        Sat, 26 Sep 2020 14:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601131388;
        bh=DX633K5mKSo//7wFYke/29iydSK/7sr78KqgfCmnErE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0opKTnqE64+2e7/8fECEuA95OO6X6N62Au1tuQdwstCPr9WSTf4j0cD6RguPDlLQv
         mX1zOwK2HNrPmMuVB2scR8c2o8IjOzq0tmgU3uQxqwfFI9AnuEleu2LdQ+8HQDnrZf
         HzjhNkVsuTUZyJcPQSKAQOg0Srascd3r0AuVsJ94=
Date:   Sat, 26 Sep 2020 15:43:03 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     Nuno =?UTF-8?B?U8Oh?= <nuno.sa@analog.com>
Cc:     <linux-iio@vger.kernel.org>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Lars-Peter Clausen <lars@metafoo.de>, <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] iio: ad7292: Fix of_node refcounting
Message-ID: <20200926154303.5f51fba5@archlinux>
In-Reply-To: <20200925091045.302-2-nuno.sa@analog.com>
References: <20200925091045.302-1-nuno.sa@analog.com>
        <20200925091045.302-2-nuno.sa@analog.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Sep 2020 11:10:45 +0200
Nuno S=C3=A1 <nuno.sa@analog.com> wrote:

> When returning or breaking early from a
> `for_each_available_child_of_node()` loop, we need to explicitly call
> `of_node_put()` on the child node to possibly release the node.
>=20
> Fixes: 506d2e317a0a0 ("iio: adc: Add driver support for AD7292")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nuno S=C3=A1 <nuno.sa@analog.com>
Applied to the fixes togreg branch of iio.git.

Thanks

Jonathan

> ---
>  drivers/iio/adc/ad7292.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/iio/adc/ad7292.c b/drivers/iio/adc/ad7292.c
> index 2eafbe7ac7c7..ab204e9199e9 100644
> --- a/drivers/iio/adc/ad7292.c
> +++ b/drivers/iio/adc/ad7292.c
> @@ -310,8 +310,10 @@ static int ad7292_probe(struct spi_device *spi)
> =20
>  	for_each_available_child_of_node(spi->dev.of_node, child) {
>  		diff_channels =3D of_property_read_bool(child, "diff-channels");
> -		if (diff_channels)
> +		if (diff_channels) {
> +			of_node_put(child);
>  			break;
> +		}
>  	}
> =20
>  	if (diff_channels) {


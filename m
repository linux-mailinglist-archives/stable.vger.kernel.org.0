Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3EA2024D7
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 17:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgFTPk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 11:40:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbgFTPky (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Jun 2020 11:40:54 -0400
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EBC82223D;
        Sat, 20 Jun 2020 15:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592667654;
        bh=wJqRmUEjXy05CpW9EdYLIq8LxOWnaokFve9D0jGhooY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rM0t7by234zMl0km87iFyQSHmjWD3+N8vovzb0cF2DBi7rN0IG+FxR5eMMB/ezpiF
         8gUoMJ5PiAaKE/VBXviZrWcpvoqgvp+BGWthIUgCBaF4P2GmrAZzf9+Sj4PxkYtMxb
         3Gg0JVeGvLl5yyE4+rwH9XFUhXPi4I4Po0q7NegM=
Date:   Sat, 20 Jun 2020 16:40:49 +0100
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
Message-ID: <20200620164049.5aa91365@archlinux>
In-Reply-To: <20200617101259.12525-1-krzk@kernel.org>
References: <20200617101259.12525-1-krzk@kernel.org>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 17 Jun 2020 12:12:59 +0200
Krzysztof Kozlowski <krzk@kernel.org> wrote:

> The driver supports also BMC156B and BMM150B so document the compatibles
> for these devices.
> 
> Fixes: 9d75db36df14 ("iio: magn: Add support for BMM150 magnetometer")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> 
> ---
> 
> The fixes tag is not accurate but at least offer some backporting.

I'm not sure we generally bother backporting a missing section of binding
documentation. Particularly as this doc isn't in yaml yet so it's not
as though any automated checking is likely to be occurring.

Rob, any views on backporting this sort of missing id addition?

One side comment here is that the devices that are magnetometers only
should never have had the _magn prefix in their compatibles. We only
do that for devices in incorporating several sensors in one package
(like the bmc150) where we have multiple drivers for the different
sensors incorporated. We are too late to fix that now though.  It
may make sense to mark the _magn variants deprecated though and
add the ones without the _magn postfix.

> ---
>  .../devicetree/bindings/iio/magnetometer/bmc150_magn.txt     | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/iio/magnetometer/bmc150_magn.txt b/Documentation/devicetree/bindings/iio/magnetometer/bmc150_magn.txt
> index fd5fca90fb39..7469073022db 100644
> --- a/Documentation/devicetree/bindings/iio/magnetometer/bmc150_magn.txt
> +++ b/Documentation/devicetree/bindings/iio/magnetometer/bmc150_magn.txt
> @@ -4,7 +4,10 @@ http://ae-bst.resource.bosch.com/media/products/dokumente/bmc150/BST-BMC150-DS00
>  
>  Required properties:
>  
> -  - compatible : should be "bosch,bmc150_magn"
> +  - compatible : should be one of:
> +                 "bosch,bmc150_magn"
> +                 "bosch,bmc156_magn"
> +                 "bosch,bmm150_magn"
>    - reg : the I2C address of the magnetometer
>  
>  Optional properties:


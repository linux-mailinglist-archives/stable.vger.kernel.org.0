Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFB5367F2E
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 13:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235800AbhDVLC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 07:02:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235634AbhDVLCZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Apr 2021 07:02:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BACD161445;
        Thu, 22 Apr 2021 11:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619089310;
        bh=IdqNjuBgiVG/bfNOGbyctqmbMhRNfuCZRrtIeDnl3mM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=PwYKvGXJSN7U53zHu2hKhrn4igmctxZ8LpicBGW3wT4+WPNobJfuUs9riXJqUvXMv
         Qy9j6INyUppve2M0EoIm4JD9LWoCRq7Y8/0GXQWvjiSFVvo7t7GZ1ShHw1OHqgrFY9
         z//2lglzBL7flXjkwIblfUclOedtGaWb3ZtdRkJEDSl2mCrqWMFJfL1w/ILV5UnC8H
         tqh8c7JAOiJoRponpD8zSG6fJ7w7s5BvYVE3rAH4AR1g9kI7T5dzTkqlanF5DCdN6b
         42d+4XIOpaG2sv+PJbrgwM/OqQQD1/OsN+vO4Ssu3CVj4gb8Eb627kvUkdL/EJ4WZO
         PZHQJJ/e3zdmA==
From:   Felipe Balbi <balbi@kernel.org>
To:     Wesley Cheng <wcheng@codeaurora.org>, gregkh@linuxfoundation.org,
        peter.chen@kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hemant Kumar <hemantk@codeaurora.org>, stable@vger.kernel.org,
        Wesley Cheng <wcheng@codeaurora.org>
Subject: Re: [PATCH v2] usb: gadget: Fix double free of device descriptor
 pointers
In-Reply-To: <1619034452-17334-1-git-send-email-wcheng@codeaurora.org>
References: <1619034452-17334-1-git-send-email-wcheng@codeaurora.org>
Date:   Thu, 22 Apr 2021 14:01:42 +0300
Message-ID: <87lf9amvl5.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Wesley Cheng <wcheng@codeaurora.org> writes:

> From: Hemant Kumar <hemantk@codeaurora.org>
>
> Upon driver unbind usb_free_all_descriptors() function frees all
> speed descriptor pointers without setting them to NULL. In case
> gadget speed changes (i.e from super speed plus to super speed)
> after driver unbind only upto super speed descriptor pointers get
> populated. Super speed plus desc still holds the stale (already
> freed) pointer. Fix this issue by setting all descriptor pointers
> to NULL after freeing them in usb_free_all_descriptors().

could you describe this a little better? How can one trigger this case?
Is the speed demotion happening after unbinding? It's not clear how to
cause this bug.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAmCBV5YRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQZlOQ/8D3Da/0KsYkeI/35cTjiwN80ady26jB4s
4IRUsq6IQJr4zb4onfb/prNv9fESatLnRcN3rvC4ICHkZldz4MQYtbZu1KXK+MeB
z8wfY6PBrxdgf6R/NELqsg7PNX6siOPKEykX/4pk4WYv2ks55FCRJZ4jLQEDvcC/
zpv6GoALmtlBS4u+JcG58aKz58TK5C+B7AMHwNqmtmDw2GkrBqtXnRIPBhsyR0lX
5L0JLBp3t8nifPL1f9JPRcJwMO/IjQIKJZc0feDiZW8OvyMRzZ7tRLUWbyG6zBLV
ZBTizo4jPeTdO6Xzzaun0m3+V0jTcO8Gn4Vo7+TbGbxEuceUEP79CnL3JspDTkYU
+H1+wTwReuHrdv1EwkziviYrnOqp96Vpz5XrIJS0Sg4FBsiNk+rZ9Le4sH/uXMlT
DDbkoewgXlgTjDfVYCxw9h2mPdkHwmGvwfOeqXBez/CZL/Yz3dEYSrduzfWUDtlF
bxM2hoSozvVQrc0MgP7YqYSuHcUixJfRnarl+TQF6IgJDDV1/mQ83Egl/yE95bdO
6fzLcCKtzKzBr214+n/DvLycx94RhaAb3ABUCEfyCZSl3n/2KVa1HAPxC9cIJ2DK
N6T7c/gQVjlcxN+ySPdDt4CGijvpjmHP5a/686Lw2XWx5I2sg7aks4r4wLfDgw73
A6YIjzc1Y5k=
=MYza
-----END PGP SIGNATURE-----
--=-=-=--

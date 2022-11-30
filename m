Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5413563E5D3
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 00:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiK3XxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 18:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiK3XxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 18:53:22 -0500
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824C4299
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 15:53:20 -0800 (PST)
Received: from 213.219.160.184.adsl.dyn.edpnet.net ([213.219.160.184] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1p0WtA-0002Ex-Uy; Thu, 01 Dec 2022 00:53:16 +0100
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1p0WtA-000AA0-1O;
        Thu, 01 Dec 2022 00:53:16 +0100
Message-ID: <eadb1fd5a181975bcf63b742b02207a2f347dd57.camel@decadent.org.uk>
Subject: Re: [PATCH 4.14] efi: random: Properly limit the size of the random
 seed
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        stable <stable@vger.kernel.org>
Date:   Thu, 01 Dec 2022 00:53:03 +0100
In-Reply-To: <Y4frikbdKtF5V1WU@decadent.org.uk>
References: <Y4frikbdKtF5V1WU@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-w45id9uMw3Kzk4bfXPpp"
User-Agent: Evolution 3.46.1-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 213.219.160.184
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-w45id9uMw3Kzk4bfXPpp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2022-12-01 at 00:47 +0100, Ben Hutchings wrote:
> Commit be36f9e7517e ("efi: READ_ONCE rng seed size before munmap")
> added a READ_ONCE() and also changed the call to
> add_bootloader_randomness() to use the local size variable.  Neither
> of these changes was actually needed and this was not backported to
> the 4.14 stable branch.
>=20
> Commit 161a438d730d ("efi: random: reduce seed size to 32 bytes")
> reverted the addition of READ_ONCE() and added a limit to the value of
> size.  This depends on the earlier commit, because size can now differ
> from seed->size, but it was wrongly backported to the 4.14 stable
> branch by itself.
>=20
> Apply the missing change to the add_bootloader_randomness() parameter
> (except that here we are still using add_device_randomness()).
[...]

This made me wonder: shouldn't commit 18b915ac6b0a ("efi/random: Treat
EFI_RNG_PROTOCOL output as bootloader randomness") be applied to these
older stable branches?  Without that, the EFI RNG can't be distrusted
if necessary.

Ben.

--=20
Ben Hutchings
compatible: Gracefully accepts erroneous data from any source

--=-w45id9uMw3Kzk4bfXPpp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmOH7N8ACgkQ57/I7JWG
EQlwAxAAumGIcl6KiA4Xsw0u4uuODDR/58rj5ZDPpWeeK/9BmPCv6MST/xRQKMbP
0E1Q1G6CV05m9Eh8pDXR1jWB5vzo0c/gb4uQ2DF8HtRES2tSz6pN3f2Iwyd59X6S
SKDFbBbFB9Mg5vjOSVS2hydyYvrvPysd3sWcsxfdHK1ZQDcXrHTG5QRPkYCR1N99
DNPjOe40CgtbCp1hs74xHhtsWSHMkcqljDds0JlVxacJjV93RIe/U4AyexnUhhUl
7RB3Bei3gfoiP5zRi3hFKD5yGJMI5ZKSfxVoIsuaxb4rtH86zllq0jnT9KqcxT2c
WNcJ1guhgMc/C4RKixgza7lvAgLKD3VWjGXU8Ei18pXFpa887Sqe7Hvlt43ikAMK
KbLkMd6AZVEPgB2zuxIFV2j0JBEv+ULg5TsqJXU/I7/wgzHGlxGtlGmOtTvQSULG
P6Bmw5Ds5TrjIhOyqg9/jnrgUNvYin4g6gwGTYLxs3/COqcBk2TQ/Umagh8pD9UJ
dPsNGn+R1gipWBUlIMTzKLjk04/JHGKnaqU0MBxgF6VUybARiTtv8LotF6PbiKjx
HC3algr3IiS9cqIIg0BC7K6YjZ6967hT0JiHyJgXYJUxYEiZ5GgK54Phxr104gNZ
WKmnuSYdqzR180mP7Of4mPTYCJZPFs1eF13G7LrYqBW/7HVc4+M=
=g75M
-----END PGP SIGNATURE-----

--=-w45id9uMw3Kzk4bfXPpp--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECBEB5B5EF8
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 19:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiILRMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 13:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbiILRMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 13:12:30 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2EA3ED44;
        Mon, 12 Sep 2022 10:12:25 -0700 (PDT)
Received: from mercury (unknown [185.122.133.20])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 02EBD6601DA4;
        Mon, 12 Sep 2022 18:12:23 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1663002743;
        bh=u/Atv23PoM1M00Cd+vSduc6NhPeHPLYi8E24tTfRl3s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dt3hfvjtdPagBbd1n3+g0gomk79w6z6kZUertM+8DwyF/ymkcjOlNqfaQ3UU+1mPr
         L4iSEyN7O647cmmH3U7WEtKj50hvsbk7/0bhfvn6pqsQQ2GFNu9aHNR2DWlGYNOAAq
         V937XXgjwsbm/N75QS/8KIYFWegEXNstSkbCia9JnXvlFrRIE/hkW0ODTz254xzgya
         epZh/MZ6+48/7sowV4f2S+MweCKe+T5tK31PL9mCT1CiSTMbtgpvwagyeIiSL/2Qnn
         l1AHvZcU1JhN6hoPdjk7o07xS1BgAe3G0CjT2i8gvv/4BCrIoB6hkNwQ0GIHS2SS6P
         B2oUGHqmnTruw==
Received: by mercury (Postfix, from userid 1000)
        id 822A4106084A; Mon, 12 Sep 2022 19:12:18 +0200 (CEST)
Date:   Mon, 12 Sep 2022 19:12:18 +0200
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Mark Pearson <mpearson@lenovo.com>, linux-pm@vger.kernel.org,
        stable@vger.kernel.org, "Rafael J . Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH RESEND] power: supply: avoid nullptr deref in
 __power_supply_is_system_supplied
Message-ID: <20220912171218.kmbi3slsqoh3l3a2@mercury.elektranox.org>
References: <CAJZ5v0js78b3qZXoxgXEwG7g0a7n_ALnEYjjzBGaQW7q4_ceCA@mail.gmail.com>
 <20220905172428.105564-1-Jason@zx2c4.com>
 <20220911123346.a7xbzdlbb7r5p6ih@mercury.elektranox.org>
 <Yx8N0hGNcbVPnJxW@zx2c4.com>
 <CAHmME9popsZskH5xR0sX2Prhd_R78Dc9mEO3BKy6qcvaok1MXQ@mail.gmail.com>
 <CAHmME9qUirnDQCxLvcQPTVYjSXEgGZcTnYTfRRVkVUwziFTywQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yb6ws2ziljsoffyz"
Content-Disposition: inline
In-Reply-To: <CAHmME9qUirnDQCxLvcQPTVYjSXEgGZcTnYTfRRVkVUwziFTywQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yb6ws2ziljsoffyz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 12, 2022 at 11:56:43AM +0100, Jason A. Donenfeld wrote:
> AFAIK, I'm just using the normal ACPI one. Really nothing fancy.
> Thinkpad X1 Extreme Gen 4.

All ACPI drivers setup get_property method in their power-supply
devices.

> Maybe get_property was being set and unset during some kind of
> initialization/deinitialization that was happening in response to some
> other event? Not sure, except that I managed to trigger it twice before
> patching my kernel so my laptop would keep working.

The function is not intended to be changed during the lifetime of
the device and AFAIK no mainline drivers does this.

> On Mon, Sep 12, 2022 at 11:48 AM Jason A. Donenfeld <Jason@zx2c4.com> wro=
te:
> > On Mon, Sep 12, 2022 at 11:45 AM Jason A. Donenfeld <Jason@zx2c4.com> w=
rote:
> > > My machine went through three changes I know about between the thresh=
old
> > > of "not crashing" and "crashing":
> > > - Upgraded to 5.19 and then 6.0-rc1.
> > > - I used my laptop on batteries for a prolonged period of time for the
> > >   first time in a while.
> > > - I updated KDE, whose power management UI elements may or may not ma=
ke
> > >   frequent calls to this subsystem to update some visual representati=
on.
> >
> > - Updated my BIOS.
>=20
> GASP! The plot thickens.
>=20
> It appears that the BIOS update I applied has been removed from
> https://pcsupport.lenovo.com/fr/en/downloads/ds551052-bios-update-utility=
-bootable-cd-for-windows-10-64-bit-and-linux-thinkpad-p1-gen-4-x1-extreme-g=
en-4
> and now it only shows the 1.16 version. I updated from 1.16 to 1.18.
>=20
> The missing release notes are still online if you futz with the URL:
> https://download.lenovo.com/pccbbs/mobiles/n40ur14w.txt
> https://download.lenovo.com/pccbbs/mobiles/n40ur15w.txt
>=20
> One of the items for 1.17 says:
> > - (Fix) Fixed an issue where it took a long time to update the battery =
FW.
>=20
> So maybe something was happening here...
>=20
> I'm CC'ing Mark from Lenovo to see if he has any insight as to why
> this BIOS update was pulled.
>=20
> Maybe the battery was appearing and disappearing rapidly.
>
> If that's correct, then it'd indicate that this bandaid patch is
> *wrong* and what actually is needed is some kind of reference
> counting or RCU around that sysfs interface (and maybe others).

Device create/remove is the only time that is supposed to touch
the get_property callback. So I suppose a race condition in that
path would be a sensible root cause. Considering systems usually
registers the device once and keeps it until shutdown would also
explain why this has not been noticed earlier.

The function you modified is only called by
power_supply_is_system_supplied(), which is an in-kernel function to
figure out if the system is running on battery.

Can you trigger this easy enough to figure out a few more details
about the state of the problematic device?

-- Sebastian

--yb6ws2ziljsoffyz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmMfaG4ACgkQ2O7X88g7
+ppUtQ/+LsX7V9m1P3dq/WGaMIWyH33JXo/CKrWypbCrKOSM72f8D5fVV4GT6y7H
hUPvLWbof4GWVz0cLZyskEDk6XmoOn2HSsmVR8zcNPrw36egbJS+Ig0CTwtxY8Ci
s8rPYUttxgDohoWnX7lJxQA9uT+VWqW6IsblGH+rGN5PUEaR2FBtXXORrRADntiP
1w5BBPBTcqxdDobWysqjsBKcXzDiomN0UazbNKdkO7pYjbe6qVSiLcL22LQEX7SI
DDO+1wPPzK2WKhA1+kU80eUIuGroFAuJrPdpKUO1wmPGZ6FYEUUz1tDD3WEVsSbb
WIoCg6jclA7AAW0vZeHY7fSsEHtIAiyVSWexC8TLEna2XWLu6KOrRmBoH2+Sn22I
Ln7xMCIbVOpUd8CRv3oUfakIgsxuaLVtVx0Ju5fNbtb+Cr23oI2dVeNfaeA+X8bH
t57bl3IG2aETNfaS8Zu15rT/9LjIFsCruAmk7lbKCfPXqlVXRPq+ko9HOpLSzzmk
i/abWU7v1uN3eYVgVXBVuaxBC6kDG5DOKRgyUVFrelsPqPQKj+tTdLW86Etx37u6
nIqRSNO6AeazM5bYaMw19WuwdIazQDHsi0EVX9OCHeLN25rVExkqr65E1NDQ7pzt
IWl77RH38jhx8Rk07UuRuCodNTfIRQ2L1uOmz4N8rfV50fH86JM=
=qjfi
-----END PGP SIGNATURE-----

--yb6ws2ziljsoffyz--

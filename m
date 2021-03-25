Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D86B349D0F
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 00:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbhCYX53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 19:57:29 -0400
Received: from maynard.decadent.org.uk ([95.217.213.242]:35590 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhCYX47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 19:56:59 -0400
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lPZqF-000196-4c; Fri, 26 Mar 2021 00:56:43 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lPZqD-00210q-FM; Fri, 26 Mar 2021 00:56:41 +0100
Message-ID: <7e2ab5dbd76773c03f6e27af6fb8254c13e6402f.camel@decadent.org.uk>
Subject: Re: [PATCH] x86/tlb: Flush global mappings when KAISER is disabled
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Sasha Levin <sashal@kernel.org>, Borislav Petkov <bp@alien8.de>
Cc:     stable <stable@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Babu Moger <babu.moger@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>, carnil@debian.org
Date:   Fri, 26 Mar 2021 00:56:23 +0100
In-Reply-To: <YF0anj5TFU5D8tXD@sashalap>
References: <4a72f780-3797-229e-a938-6dc5b14bec8d@amd.com>
         <20210311235215.GI5829@zn.tnic>
         <ed590709-65c8-ca2f-013f-d2c63d5ee0b7@amd.com>
         <20210324212139.GN5010@zn.tnic>
         <alpine.LSU.2.11.2103241651280.9593@eggly.anvils>
         <alpine.LSU.2.11.2103241913190.10112@eggly.anvils>
         <20210325095619.GC31322@zn.tnic> <20210325102959.GD31322@zn.tnic>
         <20210325200942.GJ31322@zn.tnic> <YFz0Z8/6eeYI72fq@sashalap>
         <YF0anj5TFU5D8tXD@sashalap>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-BZCkuB3+koKnPKrmigAc"
User-Agent: Evolution 3.38.2-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-BZCkuB3+koKnPKrmigAc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-03-25 at 19:19 -0400, Sasha Levin wrote:
> On Thu, Mar 25, 2021 at 04:36:55PM -0400, Sasha Levin wrote:
> > On Thu, Mar 25, 2021 at 09:09:42PM +0100, Borislav Petkov wrote:
> > > Hi stable folks,
> > >=20
> > > the patch below fixes kernels 4.4 and 4.9 booting on AMD platforms wi=
th
> > > PCID support. It doesn't have an upstream counterpart because it patc=
hes
> > > the KAISER code which didn't go upstream. It applies fine to both of =
the
> > > aforementioned kernels - please pick it up.
> >=20
> > Queued up for 4.9 and 4.4, thanks!
> >=20
> > > Jim Mattson reported that Debian 9 guests using a 4.9-stable kernel
> > > are exploding during alternatives patching:
> >=20
> > (Cc Ben & Salvatore)
> >=20
> > I'm not sure if 4.9 or Debian is still alive or not, but FYI...
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *on
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 :)

We're supporting both 4.9 and 4.19 in Debian 9.  The general rule is we
carry on with the same stable kernel branch for the whole 5 year
support period, but add the option of using the kernel version from the
next stable release.

Ben.

--=20
Ben Hutchings
Teamwork is essential - it allows you to blame someone else.

--=-BZCkuB3+koKnPKrmigAc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmBdIygACgkQ57/I7JWG
EQmePRAAou+cNc9EAXhWMu8MifMJaX2sqIkYtavWuhzOsy6IuDpi129ppi2m/7kv
rzTjBYKj7AYz0N/az8lPhEtOPE3mfiusppv2a1f4HnHWkjRZMegw9JKjR9cANxN3
ZaXrvPRciV0Afv4KVsPTX2NhqQwjMILB646X69/CmOgmq8KP5OQQ4wM7RpIleeWA
Q/MDBD0HO9lIr/16HxSOUUhhezZHBxE27tNjWMRrWALntlKUxc6Z/upr3A89Uyte
ggEYiI7JIp4jTbvG7GW7qyMSYT2zs69iE17TayzZQUl4L2iSfDDI2jQtg4OgKDel
XEkwUy/S7PHP5hSHglwf+W+ef1e3946z3J9eJ5XFDPDR0WIj/+dFNzKBi/iM+1JW
SQyZ1XHNEYXDW9WrfGKaqYpZEefcjZhCvYmhHFrmWUaYS0upb7vM2Un56BRufNJ9
34k2BKCFs4e5G7HDeVBSIQ2LChvx+05b0KVP83I9m5ghGr3kVOgH2L6sCPiEeAPF
E53DBNf8lL7xiwL10HERNUVgxLbE7yp+K0JKC9B6CTOr/VDUEilQmGb16j4EIucc
HiPlqUiomHTcaExu/lSBET3HZxunTWGoA1ju+C/rlE6mjK+JKP7dRhpxbq7KUmBS
bW6vzaiys+AJJm/9paGDCiYvjAynu/wZT/PY62TpWp0LjZDHq1M=
=CDeP
-----END PGP SIGNATURE-----

--=-BZCkuB3+koKnPKrmigAc--

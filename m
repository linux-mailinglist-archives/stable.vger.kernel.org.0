Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7443532D4E5
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 15:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239143AbhCDOGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 09:06:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:53812 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237908AbhCDOGQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 09:06:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E1DFBAAC5;
        Thu,  4 Mar 2021 14:05:34 +0000 (UTC)
Message-ID: <9bc396116372de5b538d71d8f9ae9c3259f1002e.camel@suse.de>
Subject: Re: [PATCH stable v5.10 0/7] arm64: Default to 32-bit wide ZONE_DMA
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc:     catalin.marinas@arm.com, will@kernel.org,
        akpm@linux-foundation.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, rppt@kernel.org,
        lorenzo.pieralisi@arm.com, guohanjun@huawei.com,
        sudeep.holla@arm.com, rjw@rjwysocki.net, lenb@kernel.org,
        song.bao.hua@hisilicon.com, ardb@kernel.org,
        anshuman.khandual@arm.com, bhelgaas@google.com, guro@fb.com,
        robh+dt@kernel.org, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, frowand.list@gmail.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        wangkefeng.wang@huawei.com
Date:   Thu, 04 Mar 2021 15:05:32 +0100
In-Reply-To: <YEDkmj6cchMPAq2h@kroah.com>
References: <20210303073319.2215839-1-jingxiangfeng@huawei.com>
         <YEDkmj6cchMPAq2h@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ahu+lDeVyw/D0YYfX8dU"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-ahu+lDeVyw/D0YYfX8dU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg.

On Thu, 2021-03-04 at 14:46 +0100, Greg KH wrote:
> On Wed, Mar 03, 2021 at 03:33:12PM +0800, Jing Xiangfeng wrote:
> > Using two distinct DMA zones turned out to be problematic. Here's an
> > attempt go back to a saner default.
>=20
> What problem does this solve?  How does this fit into the stable kernel
> rules?

We changed the way we setup memory zones in arm64 in order to cater for
Raspberry Pi 4's weird DMA constraints: ZONE_DMA spans the lower 1GB of mem=
ory
and ZONE_DMA32 the rest of the 32bit address space. Since you can't allocat=
e
memory that crosses zone boundaries, this broke crashkernel allocations on =
big
machines. This series fixes all this by parsing the HW description and chec=
king
for DMA constrained buses. When not found, the unnecessary zone creation is
skipped.

That said, I have no clue whether this falls or not into the stable kernel
rules.

Regards,
Nicolas


--=-ahu+lDeVyw/D0YYfX8dU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAmBA6SwACgkQlfZmHno8
x/63Hwf/dPKsaiMfp4bHs98aLzm1BcfLltFqLOj2tjBqOYX6mUdfSKOkKZYGvyTs
zZo2tT5ezbzEvU69CHgGmb6u3y4Q6PxDKqoL94xC+7RGwDrw4g4o0TZp67pcA/9d
fUjl00sLvQUl6YYcajb6s0Ev97pb3XAyvAozXb3hfz36j/30mKbizfnxhn9gTZD0
lJ6Kp8Bmm0/weVW4Kj/SOnBk0J2WF7IwSxbJMKRz8k2ejAytoILh4PZ24V9c58Jw
qhATgehwhDXk7hyZYQAKCr3pQD9fjWVVjU4/vbWXqBFvUhdmDSkCRAfYwZLJA1Cw
lRRAL3P3GOOnCmGp7VZpexw14txF9Q==
=1f1V
-----END PGP SIGNATURE-----

--=-ahu+lDeVyw/D0YYfX8dU--


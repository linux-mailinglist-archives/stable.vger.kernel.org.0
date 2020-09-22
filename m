Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED93927433D
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 15:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgIVNgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 09:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbgIVNgm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 09:36:42 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3E6C061755
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 06:36:42 -0700 (PDT)
Received: from xpredator (unknown [IPv6:2a02:2f08:4c14:a400:24d7:51ff:fed6:906d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: mvlad)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 013F928BCD9;
        Tue, 22 Sep 2020 14:36:39 +0100 (BST)
Date:   Tue, 22 Sep 2020 16:36:36 +0300
From:   Marius Vlad <marius.vlad@collabora.com>
To:     Daniel Stone <daniel@fooishbar.org>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Pekka Paalanen <pekka.paalanen@collabora.co.uk>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH] drm: avoid spurious EBUSY due to nonblocking atomic
 modesets
Message-ID: <20200922133636.GA2369@xpredator>
References: <20180705101043.4883-1-daniel.vetter@ffwll.ch>
 <20180705102121.5091-1-daniel.vetter@ffwll.ch>
 <CAPj87rN48S8+pLd0ksOX4pdCTqtO=bDgjhkPxpWr_AnpVvgaSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <CAPj87rN48S8+pLd0ksOX4pdCTqtO=bDgjhkPxpWr_AnpVvgaSQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 31, 2020 at 07:34:00AM +0000, Daniel Stone wrote:
> On Thu, 5 Jul 2018 at 11:21, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > When doing an atomic modeset with ALLOW_MODESET drivers are allowed to
> > pull in arbitrary other resources, including CRTCs (e.g. when
> > reconfiguring global resources).
> >
> > But in nonblocking mode userspace has then no idea this happened,
> > which can lead to spurious EBUSY calls, both:
> > - when that other CRTC is currently busy doing a page_flip the
> >   ALLOW_MODESET commit can fail with an EBUSY
> > - on the other CRTC a normal atomic flip can fail with EBUSY because
> >   of the additional commit inserted by the kernel without userspace's
> >   knowledge
> >
> > For blocking commits this isn't a problem, because everyone else will
> > just block until all the CRTC are reconfigured. Only thing userspace
> > can notice is the dropped frames without any reason for why frames got
> > dropped.
> >
> > Consensus is that we need new uapi to handle this properly, but no one
> > has any idea what exactly the new uapi should look like. As a stop-gap
> > plug this problem by demoting nonblocking commits which might cause
> > issues by including CRTCs not in the original request to blocking
> > commits.
Gentle ping. I've tried out Linus's master tree and, and like Pekka,
I've noticed this isn't integrated/added.

Noticed this is fixing (also) DPMS when multiple outputs are in use.
Wondering if we can just use a _ONCE() variant instead of WARN_ON(). I'm se=
eing
the warning quite often.

>=20
> Thanks for writing this up Daniel, and for reminding me about it some
> time later as well ...
>=20
> Reviewed-by: Daniel Stone <daniels@collabora.com>
>=20
> Cheers,
> Daniel
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEcDKHej6x6uPk3J379jQS5glH1u8FAl9p/eEACgkQ9jQS5glH
1u+jdA/+O56ABMNHZb4ZlGgrNqnM3JeFVC+/2TEKHcsP3zUvFMnaaDFfW0LCsBEE
UExkXe9GR6MgFmsWteUrY9I0/Rr3nvoA0KWLewzBrFJ3EOHPuz1CbJEStGr5L9aK
STfu/5Q8wmV7iLJwsyvHaS/7Ro6ssYOMJq3njD/NuSkoRok+0khJmbWnsE3TlZRY
IL2WlvmjvsYAHG5P2aC+d/AzD+SlOlFwM7O79Ap+4Vaq5eodjVqGbfVfiAKncwNX
ux836tTS9Jzf7AO4jeA78E0P98/6FrTIftkm68ABLzkSITK8K3t6t9sobi1eLfyB
LArlUj6OTgmVyiD1QqILmvJvVpq+gyg8TW716QmpJn8tAViB/FspWHPS8nwQ+BnJ
q7xnvlMqIaZ0Qbvk9lrzjt0cxfHw3z7kIuNj3WZMMlCy50Iq3ZxfmTuCKWwYec4D
BA+hUq9fOoWhsRukeL2+py+d3bN/dN6XxalODNtfYzVaYr0XE9qFoI85rLFrWu+/
DMAfdNiBwYCkNtOyII5H00SFCgmsLLkUlH8fJrzO1VRHO/4i4NcMMk2u3/Qln0ia
6RafuOLxQ67wOsdDqaiePVAEH8mBse+S+FvyfHx8CwtvL+sYthwAmasmOjkffJhY
U8vzCepbr6FKpXiC4fJbd9kYozLmZ2aDhMJtvqQTwYtBWccDxq0=
=xlhH
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--

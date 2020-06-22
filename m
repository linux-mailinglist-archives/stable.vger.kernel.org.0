Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE10204029
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 21:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgFVTVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 15:21:40 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56146 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728231AbgFVTVk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 15:21:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592853699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C7RyCHezaJ4V0niM26jYi9h0CNHLN7luH74Uczt/+Xg=;
        b=gkrKYoCqWPvS4MXd5NSFJdefoPqDBkl+UAis0YQtN9gbGSRNsBIq4VPsDvv2aX0NqvDnCM
        tRGR2Mvx6HAHBWQudtW1JxhdDzi18XTHkM7FsUQZ/Rz3YELiYfUVVz6ciWdGrqR2yQ8k95
        8cx8RMCLEIfjALsp9N++GZcSDlHUYUM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-N8cZWfZBNRClOT5kctZPuA-1; Mon, 22 Jun 2020 15:21:15 -0400
X-MC-Unique: N8cZWfZBNRClOT5kctZPuA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08FB4BFC2;
        Mon, 22 Jun 2020 19:21:14 +0000 (UTC)
Received: from localhost (ovpn-116-68.gru2.redhat.com [10.97.116.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96CEA2B4BD;
        Mon, 22 Jun 2020 19:21:13 +0000 (UTC)
Date:   Mon, 22 Jun 2020 16:21:12 -0300
From:   Bruno Meneguele <bmeneg@redhat.com>
To:     Nayna <nayna@linux.vnet.ibm.com>
Cc:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.ibm.com, erichte@linux.ibm.com, nayna@linux.ibm.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] ima: move APPRAISE_BOOTPARAM dependency on
 ARCH_POLICY to runtime
Message-ID: <20200622192112.GB8956@glitch>
References: <20200622172754.10763-1-bmeneg@redhat.com>
 <043e52d4-6835-c2c4-bc9d-d36ddb3db0e9@linux.vnet.ibm.com>
MIME-Version: 1.0
In-Reply-To: <043e52d4-6835-c2c4-bc9d-d36ddb3db0e9@linux.vnet.ibm.com>
X-PGP-Key: http://keys.gnupg.net/pks/lookup?op=get&search=0x3823031E4660608D
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=bmeneg@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 22, 2020 at 03:01:27PM -0400, Nayna wrote:
>=20
> On 6/22/20 1:27 PM, Bruno Meneguele wrote:
> > IMA_APPRAISE_BOOTPARAM has been marked as dependent on !IMA_ARCH_POLICY=
 in
> > compile time, enforcing the appraisal whenever the kernel had the arch
> > policy option enabled.
> >=20
> > However it breaks systems where the option is actually set but the syst=
em
> > wasn't booted in a "secure boot" platform. In this scenario, anytime th=
e
> > an appraisal policy (i.e. ima_policy=3Dappraisal_tcb) is used it will b=
e
> > forced, giving no chance to the user set the 'fix' state (ima_appraise=
=3Dfix)
> > to actually measure system's files.
> >=20
> > This patch remove this compile time dependency and move it to a runtime
> > decision, based on the arch policy loading failure/success.
>=20
> Thanks for looking at this.
>=20
> For arch specific policies, kernel signature verification is enabled base=
d
> on the secure boot state of the system. Perhaps, enforce the appraisal as
> well based on if secure boot is enabled.
>=20
> Thanks & Regards,

That's a good point.

I'm going to take another look and see where the check fits better and
come back with a new patch(set).

Thanks Nayna.

--=20
bmeneg=20
PGP Key: http://bmeneg.com/pubkey.txt

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEdWo6nTbnZdbDmXutYdRkFR+RokMFAl7xBKgACgkQYdRkFR+R
okM+3gf/WklZhJKgeCkRvrX3iYG8I3bbB7Vve/pzDsKzG9dYjwuriAm4fN8Eoaa9
inXX10GjEZ4s+7bWDQUn++hiYVSG+tfYKvYQZLPa0AJBwar+m7VroeoyoV3W3vu6
GAo9FwHLB50n02qyEv1vwalBy59mazStcToTKDnLQQ6dRetAD/CzZHce5qLojYvS
R8GX28GhmyNPxERFrAn/0J72oK1nJV8MOfMrIjLlh8xryBrTM8uLsiPUgwsYrUEZ
cPo/jRriLK9d49WWA2adw7mlhlxZ8/RN1ZcByDWthcUOp/a2GzgZaqMNCoYoKSyO
EhhSgJkW8xg5/O9jpgh+h+cevAWazQ==
=hG7c
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--


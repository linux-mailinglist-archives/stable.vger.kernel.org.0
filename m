Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D715AB499
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 16:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236573AbiIBO7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 10:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237168AbiIBO7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 10:59:30 -0400
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9F6F2D5E
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 07:27:19 -0700 (PDT)
Received: from [46.183.103.8] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1oU7db-0003uP-A5; Fri, 02 Sep 2022 16:27:15 +0200
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1oU7dO-002XWH-21;
        Fri, 02 Sep 2022 16:27:02 +0200
Message-ID: <ff8d3521a32e1a425af32711856d0d8fdfa84d2b.camel@decadent.org.uk>
Subject: Re: FAILED: patch "[PATCH] x86/nospec: Fix i386 RSB stuffing"
 failed to apply to 5.10-stable tree
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     peterz@infradead.org, stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>
Date:   Fri, 02 Sep 2022 16:26:57 +0200
In-Reply-To: <YxB+xgcz9QD5BK77@kroah.com>
References: <166176181110563@kroah.com>
         <3e14d81d0576aed9583d07fbd14e6a502f2d4739.camel@decadent.org.uk>
         <YxB+xgcz9QD5BK77@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-cMXtPABZemhkc0VW3bNe"
User-Agent: Evolution 3.44.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 46.183.103.8
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-cMXtPABZemhkc0VW3bNe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2022-09-01 at 11:43 +0200, Greg KH wrote:
> On Mon, Aug 29, 2022 at 04:04:58PM +0200, Ben Hutchings wrote:
> > On Mon, 2022-08-29 at 10:30 +0200, gregkh@linuxfoundation.org wrote:
> > > The patch below does not apply to the 5.10-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git comm=
it
> > > id to <stable@vger.kernel.org>.
> > >=20
> >=20
> > You need commit 4e3aa9238277 "x86/nospec: Unwreck the RSB stuffing"
> > before this one.  I've attached the backport of that for 5.10.  I
> > haven't checked the older branches.
>=20
> Great, thanks, this worked.  But the backport did not apply to 4.19, so
> I will need that in order to take this one as well.

I've had a look at 5.4, and it's sufficiently different from upstream
that I don't see how to move forward.

However, I also found that the PBRSB mitigation seems broken, as commit
fc02735b14ff "KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS"
was not backported (and would be hard to add).

So, perhaps it would be best to revert the backports of:

2b1299322016 x86/speculation: Add RSB VM Exit protections
ba6e31af2be9 x86/speculation: Add LFENCE to RSB fill sequence

in stable branches older than 5.10.

Ben.

--=20
Ben Hutchings
Lowery's Law:
        If it jams, force it. If it breaks, it needed replacing anyway.

--=-cMXtPABZemhkc0VW3bNe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmMSErEACgkQ57/I7JWG
EQln6A/+K+wnP0kdgqKTGV1h/qaIGlF4M6xvzmbbJUKd2QPVlDOek3A3l4mPulwK
5yJBjedbBkBF8tK0m0bsQGP6rie7rYomG5zHbimB0HxgLOUywXylatZjOVfDuosc
plZidiFCcvJLKeWpjHpS017tZKU557ma1fzt0o22Y9tdUOmF2mIbd5TQUjPhzG+U
OBFe54gZ0a1s1SDwk5+et4T5X9osed9bL7roPBfu7DjEgk2MB1MdyTHYWPAf0s78
lWIsoIPnHOci65dyQcBbdjIS28srSouDUTXrksjnWOTXheVomqdpELnQmJ7m9fqE
/9K/rLE088LQ0cJ5G+6B6TslrMe63heqxH3fGdChD2hLhGCSM24ttuHQmM3iLaR8
3mGorbpvjicmGZ3t1guAC8Fg+SpFpbrYNupxj+7vlB8zrWRTVBQdKN32nDcWQ+Ud
wrs/Ty1UXZ7J6ej3Y1ZKBFJytWIMV373IwUfIGMnOIICNANaY9j3AGCyns1XhUIG
e3l+8nHfZpnqjb/2MWvxem07P0zKA/jZ1Nqp4m9iYLqC7BdjmhYxQIf1FtEP3zN8
Bt8PzN0Ayv2CHh0Sca8oq768RJZkfW5nnHGpsdyJ3q77UfiK2/ljajHUpCOKqHTD
3kc58Nucc5oFwloCyJPqBnO02mMrplv1k1HANF3rITqXhu9v4Tg=
=dmoQ
-----END PGP SIGNATURE-----

--=-cMXtPABZemhkc0VW3bNe--

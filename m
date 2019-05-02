Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBB331213C
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 19:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfEBRpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 13:45:22 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:44635 "EHLO mailer.gwdg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbfEBRpV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 13:45:21 -0400
Received: from mailgw.tuebingen.mpg.de ([192.124.27.5] helo=tuebingen.mpg.de)
        by mailer.gwdg.de with esmtp (Exim 4.90_1)
        (envelope-from <maan@tuebingen.mpg.de>)
        id 1hMFlm-0001jJ-BN; Thu, 02 May 2019 19:45:18 +0200
Received: from [10.37.80.2] (HELO mailhost.tuebingen.mpg.de)
  by tuebingen.mpg.de (CommuniGate Pro SMTP 6.2.6)
  with SMTP id 22815410; Thu, 02 May 2019 19:46:44 +0200
Received: by mailhost.tuebingen.mpg.de (sSMTP sendmail emulation); Thu, 02 May 2019 19:45:16 +0200
Date:   Thu, 2 May 2019 19:45:16 +0200
From:   Andre Noll <maan@tuebingen.mpg.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: xfs: Assertion failed in xfs_ag_resv_init()
Message-ID: <20190502174516.GY2780@tuebingen.mpg.de>
References: <20190501165933.GF2780@tuebingen.mpg.de>
 <20190501171529.GB28949@kroah.com>
 <20190501175129.GH2780@tuebingen.mpg.de>
 <20190501192822.GM5207@magnolia>
 <20190501221107.GI29573@dread.disaster.area>
 <20190502114440.GB21563@kroah.com>
 <20190502132027.GF11584@sasha-vm>
 <20190502141025.GB13141@kroah.com>
 <20190502152736.GW2780@tuebingen.mpg.de>
 <20190502165244.GB14995@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="i6jgfrJswdyoXnQp"
Content-Disposition: inline
In-Reply-To: <20190502165244.GB14995@kroah.com>
User-Agent: Mutt/1.11.4 (207b9306) (2019-03-13)
X-Spam-Level: $
X-Virus-Scanned: (clean) by clamav
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--i6jgfrJswdyoXnQp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 02, 18:52, Greg Kroah-Hartman wrote
> On Thu, May 02, 2019 at 05:27:36PM +0200, Andre Noll wrote:
> > On Thu, May 02, 16:10, Greg Kroah-Hartman wrote
> > > Ok, then how about we hold off on this patch for 4.9.y then.  "no one"
> > > should be using 4.9.y in a "server system" anymore, unless you happen=
 to
> > > have an enterprise kernel based on it.  So we should be fine as the
> > > users of the older kernels don't run xfs.
> >=20
> > Well, we do run xfs on top of bcache on vanilla 4.9 kernels on a few
> > dozen production servers here. Mainly because we ran into all sorts
> > of issues with newer kernels (not necessary related to xfs). 4.9,
> > OTOH, appears to be rock solid for our workload.
>=20
> Great, but what is wrong with 4.14.y or better yet, 4.19.y?  Do those
> also work for your workload?  If not, we should fix that, and soon :)

Some months ago we tried 4.14 and it was a real disaster: random
crashes with nothing in the logs on the file servers and unkillable
hung processes on the compute machines. The thing is, I can't afford
an extended downtime of these production systems, or test patches, or
enable debugging options which slow down the systems too much. Also,
10 of the compute nodes load the nvidia module, so all bets are off
anyway. But we've seen the hung processes also on the non-gpu nodes
where the nvidia module is not loaded.

As for 4.19, xfs on bcache was broken until a couple of weeks
ago. Meanwhile the fix (e578f90d8a9c) went in, so I benchmarked 4.19.x
on one system briefly. To my surprise the results were *worse* than
with 4.9. This seems to be another cache bypass issue, but I need to
have a closer look, and more reliable numbers.

> I would _STRONGLY_ recommend moving of of 4.9 on any non-SoC-based
> system at this point in time, there should not be any reason to stick
> with it, unless you are paying a company to provide support for it.

That's really bad news :(

Thanks for sharing your thoughts about the future of 4.9, though. I'll
try to spend some time on the bcache issue on 4.19.

Best
Andre
--=20
Max Planck Institute for Developmental Biology
Max-Planck-Ring 5, 72076 T=C3=BCbingen, Germany. Phone: (+49) 7071 601 829
http://people.tuebingen.mpg.de/maan/

--i6jgfrJswdyoXnQp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSHtF/cbZGyylvqq1Ra2jVAMQCTDwUCXMssqgAKCRBa2jVAMQCT
DyVWAJ9Yd0kcgEQk7OwCBOHAfyg509i+UwCgjXe+/ysrUCSuPFifli5bf93B1Wo=
=rJSZ
-----END PGP SIGNATURE-----

--i6jgfrJswdyoXnQp--

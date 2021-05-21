Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC1E38CAA9
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 18:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237247AbhEUQNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 12:13:36 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:6839 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236522AbhEUQNf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 12:13:35 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 21 May 2021 09:12:06 -0700
Received: from smtpclient.apple (unknown [10.200.196.160])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 2F13F20446;
        Fri, 21 May 2021 09:12:12 -0700 (PDT)
From:   Alexey Makhalov <amakhalov@vmware.com>
Message-ID: <D3ECB26C-F77D-43CB-AE6F-F6919ED6CCB9@vmware.com>
Content-Type: multipart/signed;
        boundary="Apple-Mail=_8E632069-FAA9-4C7C-A864-41C39A5A7FD3";
        protocol="application/pgp-signature"; micalg=pgp-sha256
MIME-Version: 1.0 (Mac OS X Mail 14.0 \(3654.80.0.2.43\))
Subject: Re: [PATCH] ext4: fix memory leak in ext4_fill_super
Date:   Fri, 21 May 2021 09:12:09 -0700
In-Reply-To: <YKfDrcEfu7Gp0dGi@mit.edu>
CC:     <linux-ext4@vger.kernel.org>, <stable@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
References: <20210428221928.38960-1-amakhalov@vmware.com>
 <YKc6fidMj95TZp2w@mit.edu> <459B4724-842E-4B47-B2E7-D29805431E69@vmware.com>
 <YKfDrcEfu7Gp0dGi@mit.edu>
X-Mailer: Apple Mail (2.3654.80.0.2.43)
Received-SPF: None (EX13-EDG-OU-001.vmware.com: amakhalov@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Apple-Mail=_8E632069-FAA9-4C7C-A864-41C39A5A7FD3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Sounds good! Thanks for the guidance and v3) =E2=80=94Alexey

> On May 21, 2021, at 7:29 AM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
>=20
> On Fri, May 21, 2021 at 12:43:46AM -0700, Alexey Makhalov wrote:
>> Hi Ted,
>>=20
>> Good point! This paragraph can be just dropped as the next one
>> describes the issue with superblock re-read. Will send v2 shortly.
>=20
> Thanks; for what it's worth, I'm going to be editing the commit
> description anyway; it's really helpful during the patch review to
> understand how you found the problem, and how to reproduce it.
> However, the commit description when it lands upstream will include a
> link to this mail thread on lore.kernel.org, and so including a long
> stack trace isn't really necessary.
>=20
> I'm going to cut it down to something like this:
>=20
> ------------------------------
> ext4: fix memory leak in ext4_fill_super
>=20
> Buffer head references must be released before calling kill_bdev();
> otherwise the buffer head (and its page referenced by b_data) will not
> be freed by kill_bdev, and subsequently that bh will be leaked.
>=20
> If blocksizes differ, sb_set_blocksize() will kill current buffers and
> page cache by using kill_bdev(). And then super block will be reread
> again but using correct blocksize this time. sb_set_blocksize() didn't
> fully free superblock page and buffer head, and being busy, they were
> not freed and instead leaked.
>=20
> This can easily be reproduced by calling an infinite loop of:
>=20
>  systemctl start <ext4_on_lvm>.mount, and
>  systemctl stop <ext4_on_lvm>.mount
>=20
> ... since systemd creates a cgroup for each slice which it mounts, and
> the bh leak get amplified by a dying memory cgroup that also never
> gets freed, and memory consumption is much more easily noticed.
>=20
> Signed-off-by: Alexey Makhalov <amakhalov@vmware.com>
> Cc: stable@vger.kernel.org
> Link: =
https://nam04.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.k=
ernel.org%2Fr%2F459B4724-842E-4B47-B2E7-D29805431E69%40vmware.com&amp;data=
=3D04%7C01%7Camakhalov%40vmware.com%7Ce5ae2270f1134d9a3cce08d91c64cb26%7Cb=
39138ca3cee4b4aa4d6cd83d9dd62f0%7C0%7C1%7C637572041508854286%7CUnknown%7CT=
WFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0=
%3D%7C3000&amp;sdata=3D%2Fa%2FqTcBfL1tYkIq0byM46DXmpxTFOraAly2Ib9sbghE%3D&=
amp;reserved=3D0
> Fixes: ce40733ce93d ("ext4: Check for return value from =
sb_set_blocksize")
> Fixes: ac27a0ec112a ("ext4: initial copy of files from ext3")
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> ------------------------------
>=20
> The commit description above is 18 lines (exclusive of trailers and
> headers) versus 71 lines, and is much more to the point for someone
> who might be doing code archeology via "git log".
>=20
> When submitting this as a patch, you can either use a separate cover
> letter (git format-patch --cover-letter) or including the explanation
> after the --- in the diff, so that it disappears before the commit is
> added via "git am".  But it's not that hard for me to rework a commit
> description, so I'll take care of it for this patch; no need to send a
> V3.
>=20
> Cheers,
>=20
> 					- Ted


--Apple-Mail=_8E632069-FAA9-4C7C-A864-41C39A5A7FD3
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEQe6bu7hIFElmsM7CGW4w8WwwaSUFAmCn29kACgkQGW4w8Www
aSWibA//RbCDAXmr84gyrkKt0PeNjoJkyzvO9efyIt3y1x4j56JvpPSzc+Di7kyb
e2NTJrLr0biHJdkvBuLJIrAp5nmesf0JBCiQe2zM3LfmRY3GDjj3ZcHkSaBjK+Lo
rZJuiRbZ+NBhP1A2X5RbXNwr8YHl4lkEqE1yqxXvKUMDj2ZjOcg6OWNDtp1P5z9e
VGdF7JCqTMsXlDUQQsTzGT60qvWvt4UCGZIAEt0J1cbB7fg3qFqLxLPgGijq44Vf
VJwibbtWQivCZ4LIW3i6UF5MAZiHbavlcUVzRvROmRQysBOTLXr47Oov2VZuXAOb
rJIG+mEaTK5awT71yIWstLAlZhk6nZT2kgTCEVRfUQEg/p0Ysklm6t9MXmyyYpqL
ErNBu6PX5yGTTmsqw/wcuGIVbgv5TZ4dyTVVJJH3Qyxo/7CBEIygja4xmlyVP72D
EPHBzSrMRZnMzoHl5mDGzGuthFN/aZFtN4gJSqHKGUZEby8huAO+kwKcrkaxbMZZ
TNKkGIdEZrtmDRnQLS3cipl3bmVx6xEP6X0X3rIruLrwV5/6WN44upmh3YOBe83C
kJYuS/Q7bYrEff0mOfQcPbItzSARv7do5xl39szjPkf8I/M3ZDhqUK0SklXOdpWV
1aYPXD/Cm+Yo2rgkmeDP4FoiqJj9sRvFoHu/ANCtMouSQhme1lc=
=bZBa
-----END PGP SIGNATURE-----

--Apple-Mail=_8E632069-FAA9-4C7C-A864-41C39A5A7FD3--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C381217636
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 20:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgGGSQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 14:16:44 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46696 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbgGGSQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 14:16:43 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 07FA91C0C0F; Tue,  7 Jul 2020 20:16:42 +0200 (CEST)
Date:   Tue, 7 Jul 2020 20:16:41 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anton Eidelman <anton@lightbitslabs.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 10/36] nvme: fix possible deadlock when I/O is
 blocked
Message-ID: <20200707181641.GA6290@amd>
References: <20200707145749.130272978@linuxfoundation.org>
 <20200707145749.639245963@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <20200707145749.639245963@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Sagi Grimberg <sagi@grimberg.me>
>=20
> [ Upstream commit 3b4b19721ec652ad2c4fe51dfbe5124212b5f581 ]
>=20
> Revert fab7772bfbcf ("nvme-multipath: revalidate nvme_ns_head gendisk
> in nvme_validate_ns")
>=20
> When adding a new namespace to the head disk (via nvme_mpath_set_live)
> we will see partition scan which triggers I/O on the mpath device node.
> This process will usually be triggered from the scan_work which holds
> the scan_lock. If I/O blocks (if we got ana change currently have only
> available paths but none are accessible) this can deadlock on the head
> disk bd_mutex as both partition scan I/O takes it, and head disk revalida=
tion
> takes it to check for resize (also triggered from scan_work on a different
> path). See trace [1].
>=20
> The mpath disk revalidation was originally added to detect online disk
> size change, but this is no longer needed since commit cb224c3af4df
> ("nvme: Convert to use set_capacity_revalidate_and_notify") which
> already

AFAICT cb224c3af4df is not applied to 4.19-stable series, so this is
not safe according to the changelog.

cb224c3af4df is simple enough, but AFAICT
set_capacity_revalidate_and_notify() is missing in 4.19.132-rc1.

Best regards,
								Pavel

> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 0d60f2f8f3eec..5c9326777334f 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -1602,7 +1602,6 @@ static void __nvme_revalidate_disk(struct gendisk *=
disk, struct nvme_id_ns *id)
>  	if (ns->head->disk) {
>  		nvme_update_disk_info(ns->head->disk, ns, id);
>  		blk_queue_stack_limits(ns->head->disk->queue, ns->queue);
> -		revalidate_disk(ns->head->disk);
>  	}
>  #endif
>  }

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8EvAkACgkQMOfwapXb+vJHhACfTcrMsI65LhKNa96+BH3NEXsp
J80AoI0xlSa4NxGSIETKmktvgmbol1lY
=TlK9
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--

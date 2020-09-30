Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5B027EF01
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 18:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgI3QW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 12:22:57 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:51078 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgI3QW5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 12:22:57 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0EE5A1C0B81; Wed, 30 Sep 2020 18:22:55 +0200 (CEST)
Date:   Wed, 30 Sep 2020 18:22:54 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anton Eidelman <anton@lightbitslabs.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 196/245] nvme: fix possible deadlock when I/O is
 blocked
Message-ID: <20200930162254.GB23434@duo.ucw.cz>
References: <20200929105946.978650816@linuxfoundation.org>
 <20200929105956.511527430@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9zSXsLTf0vkW971A"
Content-Disposition: inline
In-Reply-To: <20200929105956.511527430@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9zSXsLTf0vkW971A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

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
> ("nvme: Convert to use set_capacity_revalidate_and_notify") which already
> updates resize info without unnecessarily revalidating the disk (the
> mpath disk doesn't even implement .revalidate_disk fop).

Commit cb224c3af4df ("nvme: Convert to use
set_capacity_revalidate_and_notify") is not in 4.19-stable.

Does that mean we'll no longer detect disk size changes after this?

Best regards,
									Pavel

> index faa7feebb6095..84fcfcdb8ba5f 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -1599,7 +1599,6 @@ static void __nvme_revalidate_disk(struct gendisk *=
disk, struct nvme_id_ns *id)
>  	if (ns->head->disk) {
>  		nvme_update_disk_info(ns->head->disk, ns, id);
>  		blk_queue_stack_limits(ns->head->disk->queue, ns->queue);
> -		revalidate_disk(ns->head->disk);
>  	}
>  #endif
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--9zSXsLTf0vkW971A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX3Sw3gAKCRAw5/Bqldv6
8t4DAJ4rcxxp+UnUWIjiAXQB7wbfwWEb5QCePmHmhzP4Yk6dyrSZjnESc5/eNhk=
=aSgn
-----END PGP SIGNATURE-----

--9zSXsLTf0vkW971A--

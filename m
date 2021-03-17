Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422E933ED21
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 10:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhCQJhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 05:37:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34937 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229730AbhCQJhD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 05:37:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615973823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SPq25jtfYHNoMdRcDr249FaN2pikM90IE2m6m6T2KCQ=;
        b=OFqgWb6Fgz6ZC391su4fTz77+KXqPgcXZ5EkdfI3P92wvvTAwZRdklXCqUg7iiVw1jtIp1
        FGGv/YTT1bDr+IsSUJBS/WivwKinOJhQAaoetKcC5GypojVMBD5wZX9KViHREBPa8sDXxc
        /dSlLPz9+EGcIYjn3sqazieR9gST7A8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-JmLCvksuO3-LxUz5PFZ9UA-1; Wed, 17 Mar 2021 05:36:59 -0400
X-MC-Unique: JmLCvksuO3-LxUz5PFZ9UA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76F6B802B45;
        Wed, 17 Mar 2021 09:36:57 +0000 (UTC)
Received: from localhost (ovpn-114-113.ams2.redhat.com [10.36.114.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26B095C8BE;
        Wed, 17 Mar 2021 09:36:47 +0000 (UTC)
Date:   Wed, 17 Mar 2021 09:36:47 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtio-fs@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] virtiofs: fix memory leak in virtio_fs_probe()
Message-ID: <YFHNr/Sqgo6QnoGV@stefanha-x1.localdomain>
References: <20210317084443.22657-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Ut6GBzXLkDIRjWkj"
Content-Disposition: inline
In-Reply-To: <20210317084443.22657-1-lhenriques@suse.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Ut6GBzXLkDIRjWkj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 17, 2021 at 08:44:43AM +0000, Luis Henriques wrote:
> When accidentally passing twice the same tag to qemu, kmemleak ended up
> reporting a memory leak in virtiofs.  Also, looking at the log I saw the
> following error (that's when I realised the duplicated tag):
>=20
>   virtiofs: probe of virtio5 failed with error -17
>=20
> Here's the kmemleak log for reference:
>=20
> unreferenced object 0xffff888103d47800 (size 1024):
>   comm "systemd-udevd", pid 118, jiffies 4294893780 (age 18.340s)
>   hex dump (first 32 bytes):
>     00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
>     ff ff ff ff ff ff ff ff 80 90 02 a0 ff ff ff ff  ................
>   backtrace:
>     [<000000000ebb87c1>] virtio_fs_probe+0x171/0x7ae [virtiofs]
>     [<00000000f8aca419>] virtio_dev_probe+0x15f/0x210
>     [<000000004d6baf3c>] really_probe+0xea/0x430
>     [<00000000a6ceeac8>] device_driver_attach+0xa8/0xb0
>     [<00000000196f47a7>] __driver_attach+0x98/0x140
>     [<000000000b20601d>] bus_for_each_dev+0x7b/0xc0
>     [<00000000399c7b7f>] bus_add_driver+0x11b/0x1f0
>     [<0000000032b09ba7>] driver_register+0x8f/0xe0
>     [<00000000cdd55998>] 0xffffffffa002c013
>     [<000000000ea196a2>] do_one_initcall+0x64/0x2e0
>     [<0000000008f727ce>] do_init_module+0x5c/0x260
>     [<000000003cdedab6>] __do_sys_finit_module+0xb5/0x120
>     [<00000000ad2f48c6>] do_syscall_64+0x33/0x40
>     [<00000000809526b5>] entry_SYSCALL_64_after_hwframe+0x44/0xae
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Luis Henriques <lhenriques@suse.de>
> ---
> Changes since v1:
> - Use kfree() to free fs->vqs instead of calling virtio_fs_put()
>=20
>  fs/fuse/virtio_fs.c | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--Ut6GBzXLkDIRjWkj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBRza8ACgkQnKSrs4Gr
c8jnxQgArLrpuXxh9hc3EbwX0Cb5eLWUCOMDFF3Nd6fM4WjDFDc/ZBYzk2W8iZIj
S8uH8ZpSF1RTgM327Zo+XqkFFfuSgdjqCrmW9z6iR7gSpnqOuSD2HReZcu3XxRln
gfW+XA3v0IB97Xpm6mDgdJFnZaowJVPiGafLQsc6VZiv3UtkHI4FXwYJzM7pWknS
HX/lMfSAi1TRkkJEY4zAkZKPVV3Jmgx5MOsMLbjjIa8griE4FnHQ7q5FlU3xDXla
ooBxfh2hqUb/p9SAlNh6zxg8VCgQTRMo6a5kZupcH9PhVorr8Ki2tYvZUpmKwEwm
y/8FuXXLTWEGnuX27koOOzoGvcl1Ag==
=3lq4
-----END PGP SIGNATURE-----

--Ut6GBzXLkDIRjWkj--


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A4624CB73
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 05:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgHUDe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 23:34:59 -0400
Received: from mout.gmx.net ([212.227.17.22]:38707 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbgHUDez (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 23:34:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1597980879;
        bh=lc0mdqveFr60wFUPrbFPqClesxYv9vVRyB+2BO44duw=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=VfmjB9Rkmhu7RAUcDOd3c6M2A/Ux2sEnqLNXqZQvN3WxTaT7Q8iUe+3ZczV3SnUSX
         A4AYvQTNuAMhoqY+dq6Xmh7Vmvb+hBzNRt1YsmMAKHZv9slneWxRSNiCjdsqAAu+j6
         LorOO7g7QVFB8hSBJ7wyENy07ke7rntmKhnguNmU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N0oBx-1ku4nj13if-00wq7h; Fri, 21
 Aug 2020 05:34:38 +0200
Subject: Re: [PATCH] btrfs: block-group: Fix free-space bitmap threshould
To:     Marcos Paulo de Souza <marcos@mpdesouza.com>,
        linux-kernel@vger.kernel.org
Cc:     dsterba@suse.com, wqu@suse.com, linux-btrfs@vger.kernel.org,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        stable@vger.kernel.org
References: <20200821024231.16256-1-marcos@mpdesouza.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAU4EEwEIADgCGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCXZw1oQAKCRDC
 PZHzoSX+qCY6CACd+mWu3okGwRKXju6bou+7VkqCaHTdyXwWFTsr+/0ly5nUdDtT3yEVggPJ
 3VP70wjlrxUjNjFb6iIvGYxiPOrop1NGwGYvQktgRhaIhALG6rPoSSAhGNjwGVRw0km0PlIN
 D29BTj/lYEk+jVM1YL0QLgAE1AI3krihg/lp/fQT53wLhR8YZIF8ETXbClQG1vJ0cllPuEEv
 efKxRyiTSjB+PsozSvYWhXsPeJ+KKjFen7ebE5reQTPFzSHctCdPnoR/4jSPlnTlnEvLeqcD
 ZTuKfQe1gWrPeevQzgCtgBF/WjIOeJs41klnYzC3DymuQlmFubss0jShLOW8eSOOWhLRuQEN
 BFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcgaCbPEwhLj
 1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj/IrRUUka
 68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fNGSsRb+pK
 EKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0q1eW4Jrv
 0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEvABEBAAGJ
 ATwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCXZw1rgUJCWpOfwAKCRDCPZHz
 oSX+qFcEB/95cs8cM1OQdE/GgOfCGxwgckMeWyzOR7bkAWW0lDVp2hpgJuxBW/gyfmtBnUai
 fnggx3EE3ev8HTysZU9q0h+TJwwJKGv6sUc8qcTGFDtavnnl+r6xDUY7A6GvXEsSoCEEynby
 72byGeSovfq/4AWGNPBG1L61Exl+gbqfvbECP3ziXnob009+z9I4qXodHSYINfAkZkA523JG
 ap12LndJeLk3gfWNZfXEWyGnuciRGbqESkhIRav8ootsCIops/SqXm0/k+Kcl4gGUO/iD/T5
 oagaDh0QtOd8RWSMwLxwn8uIhpH84Q4X1LadJ5NCgGa6xPP5qqRuiC+9gZqbq4Nj
Message-ID: <9953a211-5068-c31d-3cf7-fe8441f3c38c@gmx.com>
Date:   Fri, 21 Aug 2020 11:34:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200821024231.16256-1-marcos@mpdesouza.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HrZcJayGj3sStp9uLWJOvIUMaUl3bnKQT"
X-Provags-ID: V03:K1:0/UbLUJd4XPwUqnVbjPdKxeOASGg4qAF9pMqAW3uzVXsBbdYdXG
 Oa6WPpfnKodmX8me4I5xGnM+oHuNdvGWbxzwNH2XbTV3na62XXPijqpEQrPXcbRLkJONMHX
 izPTJf/QD/OtupF2wClQl886pj/2oHzTxj/UupCuuM6Celo4p7WPP8aDw2SXc6aWsRj9ISA
 Z27sYsnL1XXKuNoMScFnQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:EmBD6lFznxQ=:WDxcwc54pXtV0YYMUaKoam
 8m2Mlxwjuh5oAsh8/nH34EtyrPQc2qTQzmmPRE0kcfabG8BthJJtP/mE11rEhz7xMHa84cGKC
 go9Q9Wd7Gw9DO5PMSO7OddsrYuhgE2roHPfBuL+PBvyWQoydHQM754J5LLdR1+kOkrJx9adRF
 ByCFLQFuf11Yv2ul1IH/iSbfwahLY5FP5IEeN2Nyw3rIKQgGqYDyv2feN4sLpstbN1plqo8rj
 TEqUA9RI+3ZimZBkYeqOsad0qiQciR4xlTdAzvTM10mb6J6szkzVALpLZB8ztEnQaWbrPW1vR
 /18NxvqCoHdJ4rskAhgl6Hocqo8g9+2V1UsxRteEbCxYSpl1zC8IXWa2NX6qQKV5Lz/aKP50r
 v8DfrgQMqIcDb8TJiW/4cq/UAP1zz3inMU/ClNaD+JXw9zytpBi+WytXCDn+0s9WeE6iwDsEK
 9rhQ9F5e3FLJuisY4aD7eZfyL/gruS/tq+vvzvdyaJdB7USK8KYQjwB6PQKde706mM58bLpDF
 FgARV3ZQD0+Q88gXkI2vq/lclLKAS+cg63NC/faBnCwKWPuvtoG1AD6gn9Kr9Kc9wjokOCRdr
 kMnYrord+bPichOpxsNuZJck8ZJQK+cPKp1pCPbDlS/6KUtnqjBKm2oJ3HgJD0O9KXzBKZAX0
 Bo0iV06jhebWPTku+OxC4miw9/obR8uQvZOtKVWEyNaCez6r+mzubu7CGsnvTYUUZyfKEPnyt
 Qxe3Aa8U3z0QJszPZwU64GOvyAQABVaBjkY5q1f+7lMnZt9XoTaytE1H/wvDvyr7MhmLB8zzl
 WFSbnOniBNL+zeBeFEKucoBhp1b+RxvZc/zgKIDEr6br1rm++9tUxB4ragVkdV8zHcjqhGSzo
 H6tAwglvB9Ri6pp0QpTu6SqcGP4RY3OE+K0214pMlm/I4gE7IVuApMAgAysGtnpfiHpnB9puj
 JHrTUVeNCq3j1X2DSv0Xfq4L0pjfGQCDaIgJw3xJDKaBhaxzSa+xQnpfKM22atUUgs+FStO/H
 +rtNig9EKaFVkObqw4TIKR/10I8ZyNmD5vwM+QLX4sG04dmkBsF0FttWHTmNe/rJbsnD2K7Y8
 A0oL/rNdTLHMROyyyzHbmu2q7Jq2ZJUpnMPa9/7kIQHBLlCjUmeLw48iIy06zYAvlDfef1gME
 Cr4H4NL1yRt+Mj2nGtUHX2W6u3ngpoIoV9TRiSEHNzmF1yKIPGwrNehy3ccux1lIMefrhz1gs
 NjEgFkZVaVEo4ZSpHlCrH/BZFcXvaBCumeY+22w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HrZcJayGj3sStp9uLWJOvIUMaUl3bnKQT
Content-Type: multipart/mixed; boundary="NOenamEG6rrykhIMvMIb4Z4zs328jK2E0"

--NOenamEG6rrykhIMvMIb4Z4zs328jK2E0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2020/8/21 =E4=B8=8A=E5=8D=8810:42, Marcos Paulo de Souza wrote:
> From: Marcos Paulo de Souza <mpdesouza@suse.com>
>=20
> [BUG]
> After commit 9afc66498a0b ("btrfs: block-group: refactor how we read on=
e
> block group item"), cache->length is being assigned after calling
> btrfs_create_block_group_cache. This causes a problem since
> set_free_space_tree_thresholds is calculate the free-space threshould t=
o
> decide is the free-space tree should convert from extents to bitmaps.
>=20
> The current code calls set_free_space_tree_thresholds with cache->lengt=
h
> being 0, which then makes cache->bitmap_high_thresh being zero. This
> implies the system will always use bitmap instead of extents, which is
> not desired if the block group is not fragmented.
>=20
> This behavior can be seen by a test that expects to repair systems
> with FREE_SPACE_EXTENT and FREE_SPACE_BITMAP, but the current code only=

> created FREE_SPACE_BITMAP.
>=20
> [FIX]
> Call set_free_space_tree_thresholds after setting cache->length.
>=20
> Link: https://github.com/kdave/btrfs-progs/issues/251
> Fixes: 9afc66498a0b ("btrfs: block-group: refactor how we read one bloc=
k group item")
> CC: stable@vger.kernel.org # 5.8+
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

It would be even nicer if you could add some warning or self-test on
cache->length to prevent such problem from happening again.

Thanks,
Qu
> ---
>  fs/btrfs/block-group.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index 44fdfa2eeb2e..01e8ba1da1d3 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -1798,7 +1798,6 @@ static struct btrfs_block_group *btrfs_create_blo=
ck_group_cache(
> =20
>  	cache->fs_info =3D fs_info;
>  	cache->full_stripe_len =3D btrfs_full_stripe_len(fs_info, start);
> -	set_free_space_tree_thresholds(cache);
> =20
>  	cache->discard_index =3D BTRFS_DISCARD_INDEX_UNUSED;
> =20
> @@ -1908,6 +1907,8 @@ static int read_one_block_group(struct btrfs_fs_i=
nfo *info,
> =20
>  	read_block_group_item(cache, path, key);
> =20
> +	set_free_space_tree_thresholds(cache);
> +
>  	if (need_clear) {
>  		/*
>  		 * When we mount with old space cache, we need to
> @@ -2128,6 +2129,7 @@ int btrfs_make_block_group(struct btrfs_trans_han=
dle *trans, u64 bytes_used,
>  		return -ENOMEM;
> =20
>  	cache->length =3D size;
> +	set_free_space_tree_thresholds(cache);
>  	cache->used =3D bytes_used;
>  	cache->flags =3D type;
>  	cache->last_byte_to_unpin =3D (u64)-1;
>=20


--NOenamEG6rrykhIMvMIb4Z4zs328jK2E0--

--HrZcJayGj3sStp9uLWJOvIUMaUl3bnKQT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAl8/QMYACgkQwj2R86El
/qj5jggAmLxVcKj1aXb2Lvibd53N1wzI+XHZ4tiioomUxQC3tzZxBIjIcU8rUP87
fwSr4WpvN1nJCoxTcugQPMSwyEB+NFSzrslmS3TUuH37TtUOUh9kzKtaNPrZrAo6
qpXTRc2RCkTeFU8u8zhZFjCu2hjCjtJPqdT0XZLoqmbds4joJgukEwXwOaxRiYKY
4cx2iA4u4Q2Lxqu3bKBvxSCAxUbeVNHBjP4obbtxcb0ndQ4HFkDIBWwWYVtupGPP
m5T/A9svMJrpc5yB94w9Nx9n55F7mro8bPEim2GagfAi8B5DuOv72IWvLTH9bVwU
RDU37zvYNY9VkzIGQCX9RzHnbYCekw==
=hh8V
-----END PGP SIGNATURE-----

--HrZcJayGj3sStp9uLWJOvIUMaUl3bnKQT--

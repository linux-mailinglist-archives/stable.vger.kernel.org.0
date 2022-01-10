Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5288B489601
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 11:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243661AbiAJKKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 05:10:25 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:59572 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243669AbiAJKKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 05:10:03 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 541331C0B76; Mon, 10 Jan 2022 11:10:02 +0100 (CET)
Date:   Mon, 10 Jan 2022 11:10:01 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Di Zhu <zhudi2@huawei.com>, Rui Zhang <zhangrui182@huawei.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH 4.19 06/21] i40e: fix use-after-free in
 i40e_sync_filters_subtask()
Message-ID: <20220110101001.GB5588@duo.ucw.cz>
References: <20220110071813.967414697@linuxfoundation.org>
 <20220110071814.172190135@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
In-Reply-To: <20220110071814.172190135@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit 3116f59c12bd24c513194cd3acb3ec1f7d468954 upstream.
>=20
> Using ifconfig command to delete the ipv6 address will cause
> the i40e network card driver to delete its internal mac_filter and
> i40e_service_task kernel thread will concurrently access the mac_filter.
> These two processes are not protected by lock
> so causing the following use-after-free problems.

Ok, but...

> +static void netdev_hw_addr_refcnt(struct i40e_mac_filter *f,
> +				  struct net_device *netdev, int delta)
> +{
> +	struct netdev_hw_addr *ha;
> +
> +	if (!f || !netdev)
> +		return;
> +
> +	netdev_for_each_mc_addr(ha, netdev) {
> +		if (ether_addr_equal(ha->addr, f->macaddr)) {
> +			ha->refcount +=3D delta;
> +			if (ha->refcount <=3D 0)
> +				ha->refcount =3D 1;
> +			break;
> +		}
> +	}
> +}

What is going on here? Is refcount expected to underflow under normal
operation? Should we at least have WARN_ON there?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYdwF+QAKCRAw5/Bqldv6
8iEWAJ9TS2tZGkkz6lQwYF8uHAi9aLjdjgCeIFvO0NVkfgv43yHGabJsTCvUfD4=
=isAm
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--

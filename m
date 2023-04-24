Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C4A6EC8E3
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 11:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbjDXJbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 05:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjDXJbP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 05:31:15 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC892702
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 02:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682328673; x=1713864673;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qHKQEqoJI9EU0p7/+9sGZqJHHprQDWSkDXakE9khIwg=;
  b=pV9YnmtNpAVHul+fx1T33o4ORNozllyHWeRoqKnVGYLnrpl3bbP7mGJG
   LSG6mSOi/fP6b3oUdQwhhJIiHubD61wFOMF2AjoYZuRFDLAN9vPFkZdtW
   ON4JDbWxXmEMsHxfdD7QTsHOVbTjYsqvL8qqpwXyjGmX9+P2FUGTmJafX
   vT+hiL1P0wb7BAj3A58rXbHxLl9aVUVP8vwBvHYa9zs17OIaeULZ8i3b2
   ZKOSEBAzXjD94BlzMky6NMA4b26G3t/oZcPHpzPBs8kRve2rI2kxSxuJD
   1wEhTohDGlvn0hLkA8Q10B5tukDaZHEl515VeWDsfGO2FxZd28wYkuTgO
   w==;
X-IronPort-AV: E=Sophos;i="5.99,222,1677567600"; 
   d="asc'?scan'208";a="222257341"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Apr 2023 02:31:12 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 24 Apr 2023 02:31:12 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 24 Apr 2023 02:31:11 -0700
Date:   Mon, 24 Apr 2023 10:30:53 +0100
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <conor@kernel.org>,
        Greentime Hu <greentime.hu@sifive.com>,
        Zong Li <zong.li@sifive.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: Re: [PATCH 5.15 2/3] soc: sifive: l2_cache: fix missing free_irq()
 in error path in sifive_l2_init()
Message-ID: <20230424-unruffled-protozoan-19b883707ff5@wendy>
References: <20230421-scam-karma-3de5bf7904b3@wendy>
 <20230421-dole-ignition-10fe81114811@wendy>
 <2023042330-tartness-geology-a090@gregkh>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZweifSPcNWg9ozSc"
Content-Disposition: inline
In-Reply-To: <2023042330-tartness-geology-a090@gregkh>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--ZweifSPcNWg9ozSc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 23, 2023 at 03:11:48PM +0200, Greg Kroah-Hartman wrote:
> On Fri, Apr 21, 2023 at 02:58:17PM +0100, Conor Dooley wrote:
> > From: Yang Yingliang <yangyingliang@huawei.com>
> >=20
> > commit 73e770f085023da327dc9ffeb6cd96b0bb22d97e upstream.
>=20
> No, sorry, wrong git id :(

Whoops, guess I did `P` instead of pasting from my systems clipboard.

> Please fix up and resend the series.

Done, <20230424-slingshot-knelt-7a2f81b422a3@wendy>.

--ZweifSPcNWg9ozSc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZEZMTQAKCRB4tDGHoIJi
0lH8AQDd25IA0o1PKFgXx1lQFC9SnOdHxow7yB1VJb/1ef8IcgD+Mq6/sKYEXBUo
hfIBjNnucxFeohIfOszSwDMxTEJWIgk=
=W1zN
-----END PGP SIGNATURE-----

--ZweifSPcNWg9ozSc--

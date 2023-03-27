Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCC56CA846
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 16:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbjC0OzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 10:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjC0Oyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 10:54:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D713A80;
        Mon, 27 Mar 2023 07:54:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2B6C4CE122B;
        Mon, 27 Mar 2023 14:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF56C433EF;
        Mon, 27 Mar 2023 14:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679928886;
        bh=E4YD9UhzA51aarLNwwe1oXuA4ITF8ovQGB7U2nahqBY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q91KKPRDajS3v4wkummmMfdrSuvEs/r3Dk6cctCJ9s5VmjSo6dySQVes4feFaAr2m
         XSlNoqyAvQguvXDk7WkSOgwJdKzjI2p0Hr7FEB28N9mwSZ/UpZYMpdfZ/hqfhOp8Bv
         Lk4RnTT7RVFFlA2oy1QSdXIJqubFo0fTZzXBV5W8ZWQjkrMmSYpRE9jHM2oJIG+nA0
         wr8bX4kH4zsrLhOhG6h+G+QUPPzJn/WQxyx6mVm8HpdFC9zCy7fDYTiN8zntWxbt9C
         Pv9QjAy6MylPbpKONfcNLP0eQu9uBXn1ik4RJ30cFNMfcfPcxOuBmqJqAA+j5Fh2a4
         b6dJlYeD3LS5g==
Date:   Mon, 27 Mar 2023 16:54:43 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Benjamin Bara <bbara93@gmail.com>
Cc:     Lee Jones <lee@kernel.org>, rafael.j.wysocki@intel.com,
        dmitry.osipenko@collabora.com, jonathanh@nvidia.com,
        richard.leitner@linux.dev, treding@nvidia.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        Benjamin Bara <benjamin.bara@skidata.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 2/4] i2c: core: run atomic i2c xfer when !preemptible
Message-ID: <ZCGuMzmS0Lz5WX2/@ninjato>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Benjamin Bara <bbara93@gmail.com>, Lee Jones <lee@kernel.org>,
        rafael.j.wysocki@intel.com, dmitry.osipenko@collabora.com,
        jonathanh@nvidia.com, richard.leitner@linux.dev, treding@nvidia.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        Benjamin Bara <benjamin.bara@skidata.com>, stable@vger.kernel.org
References: <20230327-tegra-pmic-reboot-v3-0-3c0ee3567e14@skidata.com>
 <20230327-tegra-pmic-reboot-v3-2-3c0ee3567e14@skidata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mTzm4KGcMhUw6XkC"
Content-Disposition: inline
In-Reply-To: <20230327-tegra-pmic-reboot-v3-2-3c0ee3567e14@skidata.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mTzm4KGcMhUw6XkC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> -	return system_state > SYSTEM_RUNNING && irqs_disabled();
> +	return system_state > SYSTEM_RUNNING && !preemptible();

For the !CONFIG_PREEMPT_COUNT case, preemptible() is defined 0. So,
don't we lose the irqs_disabled() check in that case?


--mTzm4KGcMhUw6XkC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmQhrikACgkQFA3kzBSg
KbYTSxAAhu1oioVlg3a+6Wpxav9PdJ3/W10uegdGB7fNN1w/1+JXPfbNjO08eHAk
MBj5qYRYA9syYhNvq0ufRSGLLaGc7YoJnxLphU9Rwx+07ZsZbMdEmzkhHPau2GKM
fRIWY06kmTJ+ZW4G6XxCeEQklD1xjmKgs5dsmTG9n1Qvfifo7mbf3bgj13zh4+ww
Wqd031uW8YWwnJ51G/hkJz3VitxTwUKVmTTZY8Ta2rN6MxoXZoavGbylk2urO2ob
GTDnz6yBxynpNsG/vJuaU0m/ieqKSFlfRGJBGaClWbdzvdd9O4SWE/SHswbZpGJI
5/Wx18KdPdZaiiSK9Nw61pRj66AqXjRDBsJGT7Wc70Sr1P5VhFXxwhPXjY0/7q8h
6KfwQhN8UwndhpERxsLz0Mx2y0P9puRz5IPGavk5fReL1NvBEtgTMnKLW2I6g9ZB
bXpH7kzE1ZTrarqwDkquYR7erZr40e1ZJ5OdIuj3eSNJHcvfI4Ya1oS5SIFi3KMz
U4y3mQhQJ6XL/l7K7PDDhuMWSDdj2aovJVwFKoZEaU41A+x85BK5h/4MHDTdkqdb
8km1QMmMDAXTNfcMqiz4kmMLW6zkWY/lvXYe1iQAoHyXDjsu6ItJL0sEeg845uDr
A0U6sECmTV47Gn8cX5FzcMWDsVAjFGAcOnJ/JrjGOld0b3WzIA0=
=CNU/
-----END PGP SIGNATURE-----

--mTzm4KGcMhUw6XkC--

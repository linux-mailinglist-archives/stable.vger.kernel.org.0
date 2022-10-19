Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF82605099
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 21:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiJSTiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 15:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbiJSTiC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 15:38:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F19D1CBAAE;
        Wed, 19 Oct 2022 12:38:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB5666199B;
        Wed, 19 Oct 2022 19:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B15C433C1;
        Wed, 19 Oct 2022 19:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666208279;
        bh=pYGwlKtIvtEUPHvL5dQFOXwsod/jU89jA0iPylkzLh4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I82iLEraoMvA5Gns4bG9X+tOTAqmXWBm5PV6TB/HPICGZ7vnOirozDPxUXgvZuzOP
         VZU7QeW7QVLxjMWuADjoR4BWRb4Ey6dOIAXjy/tyLK6FGVcG918YlRoEZqpR85wXTr
         546A9NIG7habHoBfb1X0nlDD4DWYe5Gd0BLjy+uy4JXwXD+SfvMCC5aZUXGg/eN430
         m/b+Iyhf9SKjGu2nW+OLg8jSYDfm2E0prOSnbFqSh1jWE4JgXcQ+c3XgNIMO40nLgJ
         N+UmkihJ2t2RTIiYPVXTb7YOxThh7eYBI5PqIBe8gKonBnoaerHqbUMtQYi14yzyJh
         kvhqqVL9spPKg==
Date:   Wed, 19 Oct 2022 21:37:56 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc:     loic.poulain@linaro.org, robert.foss@linaro.org,
        linux-i2c@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vladimir.zapolskiy@linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 1/1] i2c: qcom-cci: Fix ordering of pm_runtime_xx and
 i2c_add_adapter
Message-ID: <Y1BSFBshaMjt6ECG@shikoro>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        loic.poulain@linaro.org, robert.foss@linaro.org,
        linux-i2c@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vladimir.zapolskiy@linaro.org,
        stable@vger.kernel.org
References: <20221018021920.3747344-1-bryan.odonoghue@linaro.org>
 <20221018021920.3747344-2-bryan.odonoghue@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="VISfz4IeabZvLQ+p"
Content-Disposition: inline
In-Reply-To: <20221018021920.3747344-2-bryan.odonoghue@linaro.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--VISfz4IeabZvLQ+p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 18, 2022 at 03:19:20AM +0100, Bryan O'Donoghue wrote:
> When we compile-in the CCI along with the imx412 driver and run on the RB5
> we see that i2c_add_adapter() causes the probe of the imx412 driver to
> happen.
>=20
> This probe tries to perform an i2c xfer() and the xfer() in i2c-qcom-cci.c
> fails on pm_runtime_get() because the i2c-qcom-cci.c::probe() function has
> not completed to pm_runtime_enable(dev).
>=20
> Fix this sequence by ensuring pm_runtime_xxx() calls happen prior to addi=
ng
> the i2c adapter.
>=20
> Fixes: e517526195de ("i2c: Add Qualcomm CCI I2C driver")
> Reported-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
> Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
> Tested-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

Applied to for-current, thanks!


--VISfz4IeabZvLQ+p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmNQUhQACgkQFA3kzBSg
KbYWZBAAky1ib17XA9gxloboUy3qGaybcaYZsd1mzt6PWKSNYwVBtKkZZ+wiZYi4
2YxEU+0us6M8aLRSrscKgDcKiZI43r0PwMLOY79dOMIRDlhET5s2uBW9Tp/vIwCR
j7pFLBGR6+++llARQZoyUyjddH3Pd5XyzXaJxQNHrIYe6DQAo/CGScaIEN68hZov
u+9BGEwn1ZfAppbikhmj3kqAVq5XFQrn2bll3yL0PLfGJo8+g/R/lN53ukyIk3RN
U/0ng2tOi775qhTBdYUhYUNOgKp67aO6T06a51uMLZfQHlm0KokI32+0xjuBg9pi
LVHQlXx1ybXKrMaiCH8IOU8UDjIdVEvLSoqDXyAfaVMxdU729iwCjIoEwk35k/Iw
OtowtXucRtffEx4c7mQlBawTGTGMych9riqSr9Plilw20hsGCshW5ar+lkM55OtD
nhVyq8miNXGQbU5UcPgp4yQq9psFrUUlC/HHukwSfr11YqMPAW1WvUPMVxMOUtjK
f9GUHHYBx5dK3YTl4N3j9/Sq82/CyWzhzQbxexRCe1Ed/I2jrDATevOJRIYX+PVu
KqMkukAhimmuZD1cforPmM3sApFZAWNtZzKyKdHd1iK82vX9t9cpG86QRqXLoRqf
eh4j9NUEZdD704p3F0B8TE6iUfZ+HVXgFGF7PNIVP9kOz352l3w=
=KhQP
-----END PGP SIGNATURE-----

--VISfz4IeabZvLQ+p--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36135BB72D
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 10:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiIQIRC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 04:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiIQIRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 04:17:00 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E7C4DB78;
        Sat, 17 Sep 2022 01:16:51 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id w20so11429923ply.12;
        Sat, 17 Sep 2022 01:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=AzWQOXNKDaxnJqKyeDXhMh1EHCF3LUwWo3msNgCklfs=;
        b=ZvOD5fn5tGHbVzp3a7qvJUGHB4VCBYM9VmaIArFqbRp9nuQERXj/bIc7eTJej8uyEH
         7aGsVZX3ySzNPmGppPwgB2wBIn9cIgZ3KNrKMVneHm8mxvszod9F1DOhLHRtAF+auEtW
         /uj577mAmaGniVNgNDWpMf8YOwr+vj2GhbwiowIWhvoLcljiA/3ljdsRGvISFOXc77eD
         /Qww0ExJ5n2oW7S4EUEpwbYUna9BEfg71Dj6yLS+sJiaTwL4Sb0DTLxjo3jiwE2EFwQq
         DJaoOL2UW6l87OuJ/qStHO/fvUyLDhVRlBXyt9qr42ReKnBdKUZER75cL3V1anwdkGS9
         H64w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=AzWQOXNKDaxnJqKyeDXhMh1EHCF3LUwWo3msNgCklfs=;
        b=VpN7rFVaP6azQnawSDBR0FZMjEsj19lBt4Hph0tSjieI55k+kt6CVPrVTcO27AL42K
         SQE8fr40ph3RwqoO6hDUGX0YqudMdH6lK9AbNxlN6kTh8AduXjSy/Le1oei0TowSYIFs
         BNZ4FBzks8V77FQACcE9UoP+KldsLGwTkt24OmbZ836udsKA4MBdYfOqxtcB4iJ7gtcH
         kd+8njsMf9WGyN7nmqDful2aHIey/4ZaCFzwnRJX6c7cc0XX2+W4teJj7OYxqTvEglCB
         am0B8HAS8jiAp7MfKv3LRHMGApV7bs/VJANKTBccbQHEYDj2XOaouUvD7+mvNNBLcTmC
         je9g==
X-Gm-Message-State: ACrzQf1F905i3OdpcW5l32Eb6GPY8dGXCzwuLYLNkLNwkhipsUwrEpZ7
        4aZTT4+jADst/giU4KNKNUs=
X-Google-Smtp-Source: AMsMyM621VGOMbfbHbTY0ASP/hAEjOQdaDVO8leNCWteaDVLyxbnjgwZyBr4usPOqDXdNayvMhE/GQ==
X-Received: by 2002:a17:902:a418:b0:174:6711:92c1 with SMTP id p24-20020a170902a41800b00174671192c1mr3505658plq.146.1663402610870;
        Sat, 17 Sep 2022 01:16:50 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-68.three.co.id. [180.214.232.68])
        by smtp.gmail.com with ESMTPSA id p129-20020a622987000000b0053e84617fe7sm15888506pfp.106.2022.09.17.01.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Sep 2022 01:16:50 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id B3D80103C56; Sat, 17 Sep 2022 15:16:46 +0700 (WIB)
Date:   Sat, 17 Sep 2022 15:16:46 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 00/38] 5.19.10-rc1 review
Message-ID: <YyWCbnGgb+Ndqy+/@debian.me>
References: <20220916100448.431016349@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NhdloMIAwPcLQDsh"
Content-Disposition: inline
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--NhdloMIAwPcLQDsh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 16, 2022 at 12:08:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.10 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--NhdloMIAwPcLQDsh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYyWCaQAKCRD2uYlJVVFO
ox9EAP9+v7s2mXJEa434QDnp3Z9YNsR0m0EO+C15jdeQwdHfFAEAg5u8tUMIK4GV
EfphbG0XtSNbizAKEpeAtS3lor/gigA=
=0sj6
-----END PGP SIGNATURE-----

--NhdloMIAwPcLQDsh--

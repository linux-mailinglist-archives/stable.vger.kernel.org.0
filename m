Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBBCE5B8607
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 12:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiINKNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 06:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiINKN2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 06:13:28 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4019121267;
        Wed, 14 Sep 2022 03:13:27 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id h188so13859067pgc.12;
        Wed, 14 Sep 2022 03:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=nqDHXaMoqwAdqve9DN0XCRy1SvZyapEecnjNuHOuRJ0=;
        b=NgWYFQFfbabzpK6h9sQIfOCsPld4UUv7nWnR42C3GRnevDhggfcLb+cf/qBsRI9EiT
         Vl+KfvlVBUjhp5gQoy/YYFvL57kM44ML6nXTWBVTwiBa/U26bhx3STM87vzDThmLf0gM
         zlxPIOTcc52tHATSuRwR3dXtDLrLs4w/SNqvoq4bhjsqUCMZrUT7OmZdJ+hU7pBDiPrq
         qEebouF1loKxp05bNZmGoFQ5v+DolCKaXUOJqnN13t1RUG4vsjZyWrwhMS4wGjcQ2mjn
         OFx4FQZaOX4jlS0TYJsfZ5M/M3Iu77hLMwVi3Tzcbo2SXhQNbXdZYhKNCkz7foI4pl7P
         N1Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=nqDHXaMoqwAdqve9DN0XCRy1SvZyapEecnjNuHOuRJ0=;
        b=mSfSkPsWXfSBHi1UHaz6u96Aoqx3mhurE4SJ+aYNpNTiXpFjuC8HeheRua4E73Nwxo
         UsNenm44bmvSfuePWkqqgKjmhglJC3/vQzXpp4BM70si8Euya/0YPSLWHFWrgEtuhxGL
         vywBXl8UI35OEV31Io5EHFf3ToIz05Wezut9ZV1ukWwe0MFja6wzJ1dI6ki/R5paSrMK
         YCtopfZ0VBluyT+uXQ+73HaO/Z+/lSXpBDwXbFtF5cg+m3YtPqnlITzBshN+NUmWDy2W
         9wohFGfiNB0/8q8Yfi5ATDtrCEjH25JrSF7i7DO0S84FzZaNHI1vKCUTothdcqDiTnxp
         p/7g==
X-Gm-Message-State: ACgBeo0c8IE0Ab0JVLMHx6aj0G7/STEPc7mNKTUsHhbE5BRjHyJHtHsN
        VDMQJm0lOgHuqnaUeXTuNuU=
X-Google-Smtp-Source: AA6agR5X6QkqG2WDMUOl/J0oljbi4kU3wXKMCs7FGCI1woadOffdhJ452ObTKgNp2FeBfeLWrfsdnA==
X-Received: by 2002:a05:6a00:1781:b0:53a:8572:4453 with SMTP id s1-20020a056a00178100b0053a85724453mr37189032pfg.76.1663150406780;
        Wed, 14 Sep 2022 03:13:26 -0700 (PDT)
Received: from debian.me (subs10b-223-255-225-228.three.co.id. [223.255.225.228])
        by smtp.gmail.com with ESMTPSA id x22-20020a1709027c1600b0016c5306917fsm10215939pll.53.2022.09.14.03.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 03:13:26 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 4E093101BD5; Wed, 14 Sep 2022 17:13:21 +0700 (WIB)
Date:   Wed, 14 Sep 2022 17:13:21 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/192] 5.19.9-rc1 review
Message-ID: <YyGpQcKoE60gCAXd@debian.me>
References: <20220913140410.043243217@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RW3R7vTjPwE0QZrs"
Content-Disposition: inline
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--RW3R7vTjPwE0QZrs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 13, 2022 at 04:01:46PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.9 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--RW3R7vTjPwE0QZrs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYyGpPAAKCRD2uYlJVVFO
o/RVAQCLWiFc5JdH9TyIJV209FazvhcwxbJxnZJOoL6Fq+juCwEA5Lt975pKxhPl
ixUbdcqmp1m7utQhjIt3TbLY8LZjgQY=
=hmgW
-----END PGP SIGNATURE-----

--RW3R7vTjPwE0QZrs--

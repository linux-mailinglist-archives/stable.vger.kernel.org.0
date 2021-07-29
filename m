Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F003D9F10
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 09:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234713AbhG2H6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 03:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234564AbhG2H6x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 03:58:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF1D361076;
        Thu, 29 Jul 2021 07:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627545530;
        bh=16w8tjNGUuA8ZhSM8S/EHlfbPlfcx70VQXMUVV2Qy44=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=h44270+mej1tnOX3bTJAWKajY9Eg2bFZD9vqpvAZH9O00H6USFEQi2ZFUgDO5E31d
         FgvZTsGyJnZ/fQ5TABjE6cfvncsfRFcXq49YrYi2mariEmXV4lI5kRYQYqpgYj7kL4
         Gw6L9EruUBTlZrC5C6Yr6/VOflLd8O/5gtQGi3HRGrJmzu9104FeF217JheV3Sk+G5
         SRFecnsrn+FG07oEdN7sIrYWqBQ8/sPv7IqQut60YL6YL6cVjHsFK+RDVyQNFcmQmV
         57fNyAz4euOwJ4AZiYFtDgsMnnsFb7Flx6G9Udc1MckuFEz+ReLHebbhtYa5mL4S6m
         1HIQVFyJRP+ZA==
Received: by mail-pj1-f46.google.com with SMTP id m2-20020a17090a71c2b0290175cf22899cso8130586pjs.2;
        Thu, 29 Jul 2021 00:58:50 -0700 (PDT)
X-Gm-Message-State: AOAM531DcOrF4G2UbmVeerSgNnlvrd6mGBe1/qlJTBCUADUbE+Z/uVzE
        eQovmoA4d4WIewKB8NLLhAKDkhiBu3A6S4CEKYM=
X-Google-Smtp-Source: ABdhPJyLfEm9zQ+88StFRsgV2WIB1afC8LOB0HwWdLjj15UEc88VvzVqXt5VaCEnuMqaq4STNTkEd+ohEQB1w29Bha8=
X-Received: by 2002:a17:902:8ec9:b029:12b:a69d:4146 with SMTP id
 x9-20020a1709028ec9b029012ba69d4146mr3626136plo.32.1627545530457; Thu, 29 Jul
 2021 00:58:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210531130657.971257589@linuxfoundation.org> <20210531130704.193621612@linuxfoundation.org>
In-Reply-To: <20210531130704.193621612@linuxfoundation.org>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Thu, 29 Jul 2021 09:58:38 +0200
X-Gmail-Original-Message-ID: <CAJKOXPeD7_sE4H7b3ZUYFrQmH4w4H_Npzs5NVL-cgqWYLjPW+Q@mail.gmail.com>
Message-ID: <CAJKOXPeD7_sE4H7b3ZUYFrQmH4w4H_Npzs5NVL-cgqWYLjPW+Q@mail.gmail.com>
Subject: Re: [PATCH 5.10 182/252] drm/amd/amdgpu: fix refcount leak
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jingwen Chen <Jingwen.Chen2@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 31 May 2021 at 16:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Jingwen Chen <Jingwen.Chen2@amd.com>
>
> [ Upstream commit fa7e6abc75f3d491bc561734312d065dc9dc2a77 ]
>
> [Why]
> the gem object rfb->base.obj[0] is get according to num_planes
> in amdgpufb_create, but is not put according to num_planes
>
> [How]
> put rfb->base.obj[0] in amdgpu_fbdev_destroy according to num_planes
>
> Signed-off-by: Jingwen Chen <Jingwen.Chen2@amd.com>
> Acked-by: Christian K=C3=B6nig <christian.koenig@amd.com>
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c | 3 +++
>  1 file changed, 3 insertions(+)

The original commit looks like a partial fix for 37ac3dc00da0
("drm/amdgpu: Use device specific BO size & stride check.") which came
in v5.14. Or putting it differently: this does not look entirely good
without 37ac3dc00da0 which is a fix for f258907fdd83 ("drm/amdgpu:
Verify bo size can fit framebuffer size on init.") merged in v5.13.

Backporting it earlier might cause use-after-free errors (due to GEM
refcnt dropping too early).

Can the AMD guys:
1. Confirm where this should be backported (for example not for v4.19,
v5.4, v5.10, v5.12)?
2. Mark fixes with the "Fixes" tag so we know where the fix should go?
Please include such checks in your Acking and Reviewing (unless Acks
and Reviews are just formality, not a check).

Best regards,
Krzysztof

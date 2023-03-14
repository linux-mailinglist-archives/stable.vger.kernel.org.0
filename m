Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD996B9DFE
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 19:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjCNSNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 14:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjCNSNI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 14:13:08 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB1D9660B
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 11:13:06 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-177ca271cb8so5697187fac.2
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 11:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678817585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PZ8Y7SX2RhnBYAfK1XYDwRaRgc9WldrxzgXNtGD5ZDE=;
        b=RCiWdEafD40K0Yyt+wmeyYxVFcYKySljsGXd18mVmVyek7URZuMZaEbuj2weLRoG0j
         b4GOpEPc0CS3dqc7ZcWg3Io04eO8maDN374mIj8JjE7VzfGvhP4xRQ4xV4oeUQjFscOe
         zPrKMbM9zgoaL+yvyUxtuV2X+dVZzBCpULqfQXtlXS6Q8oGTmXMO2BVJVGNvOC42jpxz
         kXWHxDHbtzQOZsJJVHqx4+Qrjzr2OOOlUBjlgn2rkQ40FGhOAiJnzGkH8uE7HWP0L1Lf
         x8a4uQf650E4hsJ+b08fQ1UFBYZgYOI3gveMGYS8l4AHiFp7+Q/ZQj5hzNIsqlWx8Ig0
         0CDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678817585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PZ8Y7SX2RhnBYAfK1XYDwRaRgc9WldrxzgXNtGD5ZDE=;
        b=aGef25V8n+GZlZJAUXgyF+q9Kb1Eu0+KNJ4cnIwM3Ieg/aht2uojU1B5znQuO/aUGB
         w230V+eVDw0tLMOQ8T4oIf4G/HI7K5MsIG9c6A/yTb47gF7pzWQRDw/5Jri/eyc6FWmR
         G/g9FlzhMZrLn9xRue2ww+vW3Pi9Z/z2t675GuZASWvJnAdvctoBC2IDHkjRUfulZpos
         9Sh7BUvBM5TMyTiKbuGSoGqQrpYsw4RCdDc/9h6RJ8ZGBG84GNRrwUCivIuJGAiLbAxO
         b+NZyKqCp6GmtAX/hJHOVynHiS6ZEgVrDNIpx0+igJXX0idH5NX7wk85MJKW/dEn2pZw
         J/iQ==
X-Gm-Message-State: AO0yUKVGpN7BlmS0Ozt2S4OXBVxDx3It0EnqxKZbgh1YStBbPpl+T3TE
        Km1uxVIjNc714T6UmPVn5xiolWT+sadqRWh2+4WUDRCJ
X-Google-Smtp-Source: AK7set8hqYbu9aicHcAU1i61SQ4F7yWByq+Z5XrqTc+jG0eg4YkvV00Gd2f6PZsun2JBCIT0LFFt01fso29UZu4DZ50=
X-Received: by 2002:a05:6870:814:b0:177:a289:46b1 with SMTP id
 fw20-20020a056870081400b00177a28946b1mr3332556oab.3.1678817584025; Tue, 14
 Mar 2023 11:13:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230314175359.1747662-1-Felix.Kuehling@amd.com>
In-Reply-To: <20230314175359.1747662-1-Felix.Kuehling@amd.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Tue, 14 Mar 2023 14:12:51 -0400
Message-ID: <CADnq5_MzJybKAOdztx=F=G+MFVqofYOkgLFSyA3wRp+h_5=tbg@mail.gmail.com>
Subject: Re: [PATCH] drm/amdgpu: Don't resume IOMMU after incomplete init
To:     Felix Kuehling <Felix.Kuehling@amd.com>
Cc:     amd-gfx@lists.freedesktop.org,
        Linux regression tracking <regressions@leemhuis.info>,
        Vasant Hegde <vasant.hegde@amd.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 14, 2023 at 1:54=E2=80=AFPM Felix Kuehling <Felix.Kuehling@amd.=
com> wrote:
>
> Check kfd->init_complete in kgd2kfd_iommu_resume, consistent with other
> kgd2kfd calls. This should fix IOMMU errors on resume from suspend when
> KFD IOMMU initialization failed.
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D217170
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2454
> Cc: Vasant Hegde <vasant.hegde@amd.com>
> Cc: Linux regression tracking (Thorsten Leemhuis) <regressions@leemhuis.i=
nfo>
> Cc: stable@vger.kernel.org
> Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>

Acked-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>  drivers/gpu/drm/amd/amdkfd/kfd_device.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/am=
d/amdkfd/kfd_device.c
> index 521dfa88aad8..989c6aa2620b 100644
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
> @@ -60,6 +60,7 @@ static int kfd_gtt_sa_init(struct kfd_dev *kfd, unsigne=
d int buf_size,
>                                 unsigned int chunk_size);
>  static void kfd_gtt_sa_fini(struct kfd_dev *kfd);
>
> +static int kfd_resume_iommu(struct kfd_dev *kfd);
>  static int kfd_resume(struct kfd_dev *kfd);
>
>  static void kfd_device_info_set_sdma_info(struct kfd_dev *kfd)
> @@ -625,7 +626,7 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
>
>         svm_migrate_init(kfd->adev);
>
> -       if (kgd2kfd_resume_iommu(kfd))
> +       if (kfd_resume_iommu(kfd))
>                 goto device_iommu_error;
>
>         if (kfd_resume(kfd))
> @@ -773,6 +774,14 @@ int kgd2kfd_resume(struct kfd_dev *kfd, bool run_pm)
>  }
>
>  int kgd2kfd_resume_iommu(struct kfd_dev *kfd)
> +{
> +       if (!kfd->init_complete)
> +               return 0;
> +
> +       return kfd_resume_iommu(kfd);
> +}
> +
> +static int kfd_resume_iommu(struct kfd_dev *kfd)
>  {
>         int err =3D 0;
>
> --
> 2.34.1
>

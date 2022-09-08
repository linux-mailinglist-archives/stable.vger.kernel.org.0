Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85AA5B1310
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 05:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiIHDxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 23:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiIHDxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 23:53:30 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16685C59C9
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 20:53:29 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-12803ac8113so7879449fac.8
        for <stable@vger.kernel.org>; Wed, 07 Sep 2022 20:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=3n8nXCeTpfbt3YDCGIcpGgS+/Nb0QWpBhoDj9s37Hdo=;
        b=kssfE/rRT/LlTIVHjSkhmjaPRpLlSBGPrXO3ZTufLLb5TkPJMDbZsipb7Zi8EFMMKK
         zjbKhYmnPQZ4HikH585CGmeqNzPkbU4Nxr7B1yUWdffuo5XLgZcaOX2VYeWXTdSei44c
         kwoOlKkJ4OTNGwgpyuWQlt+3d9c7Om8PgYUQwrW1RfVfX3bY0CijeuwrFH2WrcH251wv
         BEgHUig3QQcKUsyUvJxxOQiDLneq95DVTbh3x3Z34EV/WhAbciujT5JKxQOPLufarzg0
         lB5g2YJXg+Zyp7cxnSzZ8aUIawH9VAwaEdLZcbQ4cYlg2k4LhZN4K+vpB0fU2y/KNW1F
         AgQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=3n8nXCeTpfbt3YDCGIcpGgS+/Nb0QWpBhoDj9s37Hdo=;
        b=QX5LXdLds5yjBIk6Vmj2yiSgnmnxDm7QjHtmesHBv3S6diG/BwyasQlfCfF6MKdbYL
         oS86WXNFUThNHX6Y9LYSS6jHgXTGceN8pywTiSSptQVtOYoLhGjbHYs5I5Uwe+dMIxjo
         ZRtZR55I0gv1PfVzOL6izrlCPh7+ZLexVe6gDgqTA0c8ur9+Op4q/XWirh2eRAM3sbhL
         /5dMEE0JDnPK7M1je1xHrCFAeb0qU8MjlKhY0UVljb2XM3N2XkU/q+Btq9zh+32R0a/S
         BvSDD8j63gJK9r3n2nAhQ7HcbsEw0uD+8Z35WbjoNjczy/ektvE5UET0ZkSBB2h7mLXS
         DObQ==
X-Gm-Message-State: ACgBeo2bg9sFFpgDWVKB21dvdJ1uYCaAfZYV2xPpEMxM9QbiH0jIx7o0
        vJZhVJQ+0c3qBg6A4Jee0uGwwMlsM84VQ3au8xPnn/5Q
X-Google-Smtp-Source: AA6agR703GxBSJpV8BCgKV4fNLYSyvicNFxmRjJ634wiqIV10L57Tw0XeOMiNN3sykR1iDzTQqHO3GxQSHN4awgfhyM=
X-Received: by 2002:a05:6870:3484:b0:11e:4465:3d9b with SMTP id
 n4-20020a056870348400b0011e44653d9bmr937379oah.46.1662609208367; Wed, 07 Sep
 2022 20:53:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220908032344.1682187-1-lijo.lazar@amd.com> <CADnq5_MQ64piXz-CJeEn2e4yi_kwePYCea_sTxdFUAb+j8wu5Q@mail.gmail.com>
 <b3b786b1-2f72-4f5e-f011-8acf06867d0e@amd.com>
In-Reply-To: <b3b786b1-2f72-4f5e-f011-8acf06867d0e@amd.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Wed, 7 Sep 2022 23:53:17 -0400
Message-ID: <CADnq5_ObpVNo7CVKpNEg0UJx0BnLb7OOoBhozKRxu-nR2N-8vQ@mail.gmail.com>
Subject: Re: [PATCH] drm/amdgpu: Don't enable LTR if not supported
To:     "Lazar, Lijo" <lijo.lazar@amd.com>
Cc:     amd-gfx@lists.freedesktop.org, Alexander.Deucher@amd.com,
        wielkiegie@gmail.com, helgaas@kernel.org, stable@vger.kernel.org,
        Hawking.Zhang@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 7, 2022 at 11:40 PM Lazar, Lijo <lijo.lazar@amd.com> wrote:
>
>
>
> On 9/8/2022 8:58 AM, Alex Deucher wrote:
> > On Wed, Sep 7, 2022 at 11:24 PM Lijo Lazar <lijo.lazar@amd.com> wrote:
> >>
> >> As per PCIE Base Spec r4.0 Section 6.18
> >> 'Software must not enable LTR in an Endpoint unless the Root Complex
> >> and all intermediate Switches indicate support for LTR.'
> >>
> >> This fixes the Unsupported Request error reported through AER during
> >> ASPM enablement.
> >>
> >> Link: https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2=
F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D216455&amp;data=3D05%7C01%7Cl=
ijo.lazar%40amd.com%7Cc190635e13f047625b4508da914a47a5%7C3dd8961fe4884e608e=
11a82d994e183d%7C0%7C0%7C637982045476774989%7CUnknown%7CTWFpbGZsb3d8eyJWIjo=
iMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C=
&amp;sdata=3DmNq7A7oT2VwZVc7WtYyWj0BRAXV5MzNLir0o4%2BKiWYU%3D&amp;reserved=
=3D0
> >>
> >> The error was unnoticed before and got visible because of the commit
> >> referenced below. This doesn't fix anything in the commit below, rathe=
r
> >> fixes the issue in amdgpu exposed by the commit. The reference is only
> >> to associate this commit with below one so that both go together.
> >>
> >> Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_=
port_device_capability()")
> >>
> >> Reported-by: Gustaw Smolarczyk <wielkiegie@gmail.com>
> >> Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
> >> Cc: stable@vger.kernel.org
> >> ---
> >
> > Even though the ASPM code in si.c, cik.c, and vi.c doesn't mess with
> > LTR, it still sets up ASPM so shouldn't it be protected with
> > CONFIG_PCIEASPM as well?
> >
>
> Yes, but it is only a compilation improvement and unrelated to this
> patch. We don't access any ASPM related kernel variables in those
> sequences. ltr_path variable used under this patch is declared under
> ASPM config.

Thanks for the information.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com?

>
> Runtime protection is already there -
> 0ab5d711ec74 (drm/amd: Refactor `amdgpu_aspm` to be evaluated per device)
>
> Thanks,
> Lijo
>
> > Alex
> >
> >>   drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c | 9 ++++++++-
> >>   drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c | 9 ++++++++-
> >>   drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c | 9 ++++++++-
> >>   3 files changed, 24 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c b/drivers/gpu/drm/=
amd/amdgpu/nbio_v2_3.c
> >> index b465baa26762..aa761ff3a5fa 100644
> >> --- a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
> >> +++ b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
> >> @@ -380,6 +380,7 @@ static void nbio_v2_3_enable_aspm(struct amdgpu_de=
vice *adev,
> >>                  WREG32_PCIE(smnPCIE_LC_CNTL, data);
> >>   }
> >>
> >> +#ifdef CONFIG_PCIEASPM
> >>   static void nbio_v2_3_program_ltr(struct amdgpu_device *adev)
> >>   {
> >>          uint32_t def, data;
> >> @@ -401,9 +402,11 @@ static void nbio_v2_3_program_ltr(struct amdgpu_d=
evice *adev)
> >>          if (def !=3D data)
> >>                  WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
> >>   }
> >> +#endif
> >>
> >>   static void nbio_v2_3_program_aspm(struct amdgpu_device *adev)
> >>   {
> >> +#ifdef CONFIG_PCIEASPM
> >>          uint32_t def, data;
> >>
> >>          def =3D data =3D RREG32_PCIE(smnPCIE_LC_CNTL);
> >> @@ -459,7 +462,10 @@ static void nbio_v2_3_program_aspm(struct amdgpu_=
device *adev)
> >>          if (def !=3D data)
> >>                  WREG32_PCIE(smnPCIE_LC_CNTL6, data);
> >>
> >> -       nbio_v2_3_program_ltr(adev);
> >> +       /* Don't bother about LTR if LTR is not enabled
> >> +        * in the path */
> >> +       if (adev->pdev->ltr_path)
> >> +               nbio_v2_3_program_ltr(adev);
> >>
> >>          def =3D data =3D RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP3);
> >>          data |=3D 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIM=
ER__SHIFT;
> >> @@ -483,6 +489,7 @@ static void nbio_v2_3_program_aspm(struct amdgpu_d=
evice *adev)
> >>          data &=3D ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK=
_MASK;
> >>          if (def !=3D data)
> >>                  WREG32_PCIE(smnPCIE_LC_CNTL3, data);
> >> +#endif
> >>   }
> >>
> >>   static void nbio_v2_3_apply_lc_spc_mode_wa(struct amdgpu_device *ade=
v)
> >> diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c b/drivers/gpu/drm/=
amd/amdgpu/nbio_v6_1.c
> >> index f7f6ddebd3e4..37615a77287b 100644
> >> --- a/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
> >> +++ b/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
> >> @@ -282,6 +282,7 @@ static void nbio_v6_1_init_registers(struct amdgpu=
_device *adev)
> >>                          mmBIF_BX_DEV0_EPF0_VF0_HDP_MEM_COHERENCY_FLUS=
H_CNTL) << 2;
> >>   }
> >>
> >> +#ifdef CONFIG_PCIEASPM
> >>   static void nbio_v6_1_program_ltr(struct amdgpu_device *adev)
> >>   {
> >>          uint32_t def, data;
> >> @@ -303,9 +304,11 @@ static void nbio_v6_1_program_ltr(struct amdgpu_d=
evice *adev)
> >>          if (def !=3D data)
> >>                  WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
> >>   }
> >> +#endif
> >>
> >>   static void nbio_v6_1_program_aspm(struct amdgpu_device *adev)
> >>   {
> >> +#ifdef CONFIG_PCIEASPM
> >>          uint32_t def, data;
> >>
> >>          def =3D data =3D RREG32_PCIE(smnPCIE_LC_CNTL);
> >> @@ -361,7 +364,10 @@ static void nbio_v6_1_program_aspm(struct amdgpu_=
device *adev)
> >>          if (def !=3D data)
> >>                  WREG32_PCIE(smnPCIE_LC_CNTL6, data);
> >>
> >> -       nbio_v6_1_program_ltr(adev);
> >> +       /* Don't bother about LTR if LTR is not enabled
> >> +        * in the path */
> >> +       if (adev->pdev->ltr_path)
> >> +               nbio_v6_1_program_ltr(adev);
> >>
> >>          def =3D data =3D RREG32_PCIE(smnRCC_BIF_STRAP3);
> >>          data |=3D 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIM=
ER__SHIFT;
> >> @@ -385,6 +391,7 @@ static void nbio_v6_1_program_aspm(struct amdgpu_d=
evice *adev)
> >>          data &=3D ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK=
_MASK;
> >>          if (def !=3D data)
> >>                  WREG32_PCIE(smnPCIE_LC_CNTL3, data);
> >> +#endif
> >>   }
> >>
> >>   const struct amdgpu_nbio_funcs nbio_v6_1_funcs =3D {
> >> diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c b/drivers/gpu/drm/=
amd/amdgpu/nbio_v7_4.c
> >> index 11848d1e238b..19455a725939 100644
> >> --- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
> >> +++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
> >> @@ -673,6 +673,7 @@ struct amdgpu_nbio_ras nbio_v7_4_ras =3D {
> >>   };
> >>
> >>
> >> +#ifdef CONFIG_PCIEASPM
> >>   static void nbio_v7_4_program_ltr(struct amdgpu_device *adev)
> >>   {
> >>          uint32_t def, data;
> >> @@ -694,9 +695,11 @@ static void nbio_v7_4_program_ltr(struct amdgpu_d=
evice *adev)
> >>          if (def !=3D data)
> >>                  WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
> >>   }
> >> +#endif
> >>
> >>   static void nbio_v7_4_program_aspm(struct amdgpu_device *adev)
> >>   {
> >> +#ifdef CONFIG_PCIEASPM
> >>          uint32_t def, data;
> >>
> >>          if (adev->ip_versions[NBIO_HWIP][0] =3D=3D IP_VERSION(7, 4, 4=
))
> >> @@ -755,7 +758,10 @@ static void nbio_v7_4_program_aspm(struct amdgpu_=
device *adev)
> >>          if (def !=3D data)
> >>                  WREG32_PCIE(smnPCIE_LC_CNTL6, data);
> >>
> >> -       nbio_v7_4_program_ltr(adev);
> >> +       /* Don't bother about LTR if LTR is not enabled
> >> +        * in the path */
> >> +       if (adev->pdev->ltr_path)
> >> +               nbio_v7_4_program_ltr(adev);
> >>
> >>          def =3D data =3D RREG32_PCIE(smnRCC_BIF_STRAP3);
> >>          data |=3D 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIM=
ER__SHIFT;
> >> @@ -779,6 +785,7 @@ static void nbio_v7_4_program_aspm(struct amdgpu_d=
evice *adev)
> >>          data &=3D ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK=
_MASK;
> >>          if (def !=3D data)
> >>                  WREG32_PCIE(smnPCIE_LC_CNTL3, data);
> >> +#endif
> >>   }
> >>
> >>   const struct amdgpu_nbio_funcs nbio_v7_4_funcs =3D {
> >> --
> >> 2.25.1
> >>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7AD06B7C46
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 16:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjCMPnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 11:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjCMPnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 11:43:05 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCF27A8F
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 08:42:57 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id 89so1715734uao.0
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 08:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678722176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N8RCVnAi4IeyJIpn+hfbcj5KS7N/D7rOad8PC30GlWs=;
        b=Fn9fOsJuFs8+0eTvsgHqUyG7RN6lbTDMAxv1eOKhkMv9KfIWJ6jKy1fWoqY9Qibz3U
         JgCxX1z8gcJSz97bEIHLOpXtmS5eeILsT++wTBmMqewTTFI4qGeVjAKGzPDiBgzV8kjm
         6l7dA9ukPQM7cNp7W8+6a7ZAIbdKRNLJoYgBCrqoOPeDNiwPc5EWzwNbXQO1HbRK7Xck
         ARuPdX//dY20vwQGcDRlBlAUglvV7ZCajLHQcSouewW86Tf6mJVpAs/bc4gKQ5S0A/sS
         Bmdhk6TJfjj6rjzlAQKyatJVlZuwuRGvXQbmMhxT6QqMGtW8olfPo+aluOGe26eNAfKV
         zkrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678722176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N8RCVnAi4IeyJIpn+hfbcj5KS7N/D7rOad8PC30GlWs=;
        b=hqlnYIJrGvJp9W+BAAJa0FVUAdStirJrmNOwy7vxFzts7xGNxDgX8ARKx/TNKXnWw1
         sTs36qP3XQYlAtnkuGCPrrtYQ1/IHbPyUeiBPx1dezRX2drhyYXYBv3suO4pbqKQsxFr
         XU9oPvWi9RM4nCPU4fiweCR0pk27umW5qVVDBLqF+N6Z1MBMIn9HOQOljDv1l5wki6BL
         ceNR3nILYvEJryeMzEc9Yc9qCL6gBPs4E3Ob795gRWrLkwCSmEp3Cn6Qv2F9InjgDYI9
         GBvP0P+iryREULgvrI+xKsnSiFiA//Zi+Rp6jyyW0/85IYFgDCDkNZcESGaKuPiSKQsS
         LxnA==
X-Gm-Message-State: AO0yUKU3EcsNjgN4UONwNbwYAiHNfWTI/RCz4mjHjmsQhWy01PgAqaq1
        8LCV/lW8Tc27pd6tlpujJG/J+neDfNh+LecmoZc=
X-Google-Smtp-Source: AK7set9JfPx3fA5ZJMtn3NV+0iyuZjQA4C0DBaTYRJmnq8ulxdtbhKygcUzsvHgF9wQ5zgfP5TaO6xqeadkxp1R4y5o=
X-Received: by 2002:ac5:cd86:0:b0:401:7625:e9e3 with SMTP id
 i6-20020ac5cd86000000b004017625e9e3mr6491675vka.1.1678722176424; Mon, 13 Mar
 2023 08:42:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230312165100.1204682-1-gpiccoli@igalia.com>
In-Reply-To: <20230312165100.1204682-1-gpiccoli@igalia.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 13 Mar 2023 11:42:43 -0400
Message-ID: <CADnq5_PiGx7Lt1_XTrs8k61jZNDY9cy8Rs98iBVsi-FEmnTRpw@mail.gmail.com>
Subject: Re: [PATCH] drm/amdgpu/vcn: Disable indirect SRAM on Vangogh broken BIOSes
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     amd-gfx@lists.freedesktop.org, kernel@gpiccoli.net,
        johns@valvesoftware.com, Xinhui.Pan@amd.com,
        dri-devel@lists.freedesktop.org, cristian.ciocaltea@collabora.com,
        stable@vger.kernel.org, kernel-dev@igalia.com,
        alexander.deucher@amd.com, James Zhu <James.Zhu@amd.com>,
        Leo Liu <leo.liu@amd.com>, christian.koenig@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Applied.  Thanks!

Alex

On Sun, Mar 12, 2023 at 12:51=E2=80=AFPM Guilherme G. Piccoli
<gpiccoli@igalia.com> wrote:
>
> The VCN firmware loading path enables the indirect SRAM mode if it's
> advertised as supported. We might have some cases of FW issues that
> prevents this mode to working properly though, ending-up in a failed
> probe. An example below, observed in the Steam Deck:
>
> [...]
> [drm] failed to load ucode VCN0_RAM(0x3A)
> [drm] psp gfx command LOAD_IP_FW(0x6) failed and response status is (0xFF=
FF0000)
> amdgpu 0000:04:00.0: [drm:amdgpu_ring_test_helper [amdgpu]] *ERROR* ring =
vcn_dec_0 test failed (-110)
> [drm:amdgpu_device_init.cold [amdgpu]] *ERROR* hw_init of IP block <vcn_v=
3_0> failed -110
> amdgpu 0000:04:00.0: amdgpu: amdgpu_device_ip_init failed
> amdgpu 0000:04:00.0: amdgpu: Fatal error during GPU init
> [...]
>
> Disabling the VCN block circumvents this, but it's a very invasive
> workaround that turns off the entire feature. So, let's add a quirk
> on VCN loading that checks for known problematic BIOSes on Vangogh,
> so we can proactively disable the indirect SRAM mode and allow the
> HW proper probe and VCN IP block to work fine.
>
> Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2385
> Fixes: 82132ecc5432 ("drm/amdgpu: enable Vangogh VCN indirect sram mode")
> Cc: stable@vger.kernel.org
> Cc: James Zhu <James.Zhu@amd.com>
> Cc: Leo Liu <leo.liu@amd.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> ---
>
>
> Hi folks, based on the feedback from the gitlab issue, here is the upstre=
am
> attempt to quirk the Steam Deck's BIOSes having known issues with the
> indirect SRAM mode. I've tested it on both the quirked BIOSes, and also
> with some working ones. This patch is based on agd5f/amd-staging-drm-next=
.
>
> Thanks in advance for reviews!
> Cheers,
>
> Guilherme
>
>
>  drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c b/drivers/gpu/drm/am=
d/amdgpu/amdgpu_vcn.c
> index 02d428ddf2f8..dc4f3f4cb644 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
> @@ -26,6 +26,7 @@
>
>  #include <linux/firmware.h>
>  #include <linux/module.h>
> +#include <linux/dmi.h>
>  #include <linux/pci.h>
>  #include <linux/debugfs.h>
>  #include <drm/drm_drv.h>
> @@ -114,6 +115,24 @@ int amdgpu_vcn_sw_init(struct amdgpu_device *adev)
>             (adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG))
>                 adev->vcn.indirect_sram =3D true;
>
> +       /*
> +        * Some Steam Deck's BIOS versions are incompatible with the
> +        * indirect SRAM mode, leading to amdgpu being unable to get
> +        * properly probed (and even potentially crashing the kernel).
> +        * Hence, check for these versions here - notice this is
> +        * restricted to Vangogh (Deck's APU).
> +        */
> +       if (adev->ip_versions[UVD_HWIP][0] =3D=3D IP_VERSION(3, 0, 2)) {
> +               const char *bios_ver =3D dmi_get_system_info(DMI_BIOS_VER=
SION);
> +
> +               if (bios_ver && (!strncmp("F7A0113", bios_ver, 7) ||
> +                    !strncmp("F7A0114", bios_ver, 7))) {
> +                       adev->vcn.indirect_sram =3D false;
> +                       dev_info(adev->dev,
> +                               "Steam Deck quirk: indirect SRAM disabled=
 on BIOS %s\n", bios_ver);
> +               }
> +       }
> +
>         hdr =3D (const struct common_firmware_header *)adev->vcn.fw->data=
;
>         adev->vcn.fw_version =3D le32_to_cpu(hdr->ucode_version);
>
> --
> 2.39.2
>

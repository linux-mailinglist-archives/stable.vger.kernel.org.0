Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E9C5A5236
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 18:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiH2Qvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 12:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiH2QvV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 12:51:21 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625388C006
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 09:50:42 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-11eab59db71so7211669fac.11
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 09:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=zdRH7q9F+wHG+PPMNtagIm3kaeW9BgOf4d/Tmsl1Cbw=;
        b=E2OvaruFea+9WV6kyPskZf7OIgI2uBgOgVYh2HNmiKVT/QfLSd2nN1s2eKdYhAPjji
         2vjbZCkaOR6Xl7PA5ejpFwTM7NCYI1zw5nGtl1qTLfDK05gdAyYWa3zcZVwcszED8Nw4
         nJ9hKtTqjKfvaoQtKW7+e2veXv6iEakikUNq8xUy6ocYJyLTJUSVX4P6fMRN7h+f//RX
         JkHxrMoghsPt0JJy3wPLZi7us5rmIvt+ZOYa44Rhy+Kxsr8hFmfi5eKtEWKytbTyY32F
         q93EaZpYFTnCDgfMDufuylMmEtNQScX/v/8PQ3iTtF308FcgihfPe8KhU+cUtkRJZIGq
         CGDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=zdRH7q9F+wHG+PPMNtagIm3kaeW9BgOf4d/Tmsl1Cbw=;
        b=oHBp3SQTu+dat/WAyQlPW5yH4Jnmbnx45+aNf86ffXzLgLi4T5yVqNBshQRjqlEqfR
         2GzbQlaeO3dyDZZw61jsPRTE3W3ywhY5elj/K35jRfyTqYVs7u5qxhMgobWLqfBXelCE
         5sm/XGsaUZ/Al2ozZXqjNGNemHPQIEBA30YbXTsorL1/qNfsQ4mPV2pGHGvpKQU8YJeI
         fcHKS6prPbT3j539lMjpEymUEwpCmbjErQbj45cMdDSMbSkdwKOik7E73iYPdpoX067r
         oXovo9jI6ghluW1sLNUmvINdMxAYhFtRdTlzGXffXo34Xx3I2d0JBAEyem/kLOTdi+It
         9fzA==
X-Gm-Message-State: ACgBeo3ZNDsj+wwC4WmWFLWoXn3jfC6C50353qUfS1FHs5dRhvTDMWAW
        /G7n1zDbH1zqC7/yrRvzKAG/O6TooPXUeBbhyaNbG7c7
X-Google-Smtp-Source: AA6agR4t/aSg7WiJkQ6oW0g340G9pH83STQd5W7aVYquelg1jCBvDdMCJrYa/9JcmsIZujwFkROl5WXBvRBT7NYgDv0=
X-Received: by 2002:a05:6870:3484:b0:11e:4465:3d9b with SMTP id
 n4-20020a056870348400b0011e44653d9bmr8685176oah.46.1661791840799; Mon, 29 Aug
 2022 09:50:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220829081752.1258274-1-lijo.lazar@amd.com>
In-Reply-To: <20220829081752.1258274-1-lijo.lazar@amd.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 29 Aug 2022 12:50:29 -0400
Message-ID: <CADnq5_O=3u1Z4kH_5A+UsynQ31Grh-=j=3+hPWo398kfMi411w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] drm/amdgpu: Move HDP remapping earlier during init
To:     Lijo Lazar <lijo.lazar@amd.com>
Cc:     amd-gfx@lists.freedesktop.org, Felix.Kuehling@amd.com,
        stable@vger.kernel.org, tseewald@gmail.com, helgaas@kernel.org,
        Alexander.Deucher@amd.com, sr@denx.de, Christian.Koenig@amd.com,
        Hawking.Zhang@amd.com
Content-Type: multipart/mixed; boundary="0000000000005d067105e76410d9"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--0000000000005d067105e76410d9
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 29, 2022 at 4:18 AM Lijo Lazar <lijo.lazar@amd.com> wrote:
>
> HDP flush is used early in the init sequence as part of memory controller
> block initialization. Hence remapping of HDP registers needed for flush
> needs to happen earlier.
>
> This also fixes the Unsupported Request error reported through AER during
> driver load. The error happens as a write happens to the remap offset
> before real remapping is done.
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216373
>
> The error was unnoticed before and got visible because of the commit
> referenced below. This doesn't fix anything in the commit below, rather
> fixes the issue in amdgpu exposed by the commit. The reference is only
> to associate this commit with below one so that both go together.
>
> Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")
>
> Reported-by: Tom Seewald <tseewald@gmail.com>
> Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
> Cc: stable@vger.kernel.org

How about something like the attached patch rather than these two
patches?  It's a bit bigger but seems cleaner and more defensive in my
opinion.

Alex

> ---
> v2:
>         Take care of IP resume cases (Alex Deucher)
>         Add NULL check to nbio.funcs to cover older (GFXv8) ASICs (Felix Kuehling)
>         Add more details in commit message and associate with AER patch (Bjorn
> Helgaas)
>
>  drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 24 ++++++++++++++++++++++
>  drivers/gpu/drm/amd/amdgpu/nv.c            |  6 ------
>  drivers/gpu/drm/amd/amdgpu/soc15.c         |  6 ------
>  drivers/gpu/drm/amd/amdgpu/soc21.c         |  6 ------
>  4 files changed, 24 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> index ce7d117efdb5..e420118769a5 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> @@ -2334,6 +2334,26 @@ static int amdgpu_device_init_schedulers(struct amdgpu_device *adev)
>         return 0;
>  }
>
> +/**
> + * amdgpu_device_prepare_ip - prepare IPs for hardware initialization
> + *
> + * @adev: amdgpu_device pointer
> + *
> + * Any common hardware initialization sequence that needs to be done before
> + * hw init of individual IPs is performed here. This is different from the
> + * 'common block' which initializes a set of IPs.
> + */
> +static void amdgpu_device_prepare_ip(struct amdgpu_device *adev)
> +{
> +       /* Remap HDP registers to a hole in mmio space, for the purpose
> +        * of exposing those registers to process space. This needs to be
> +        * done before hw init of ip blocks to take care of HDP flush
> +        * operations through registers during hw_init.
> +        */
> +       if (adev->nbio.funcs && adev->nbio.funcs->remap_hdp_registers &&
> +           !amdgpu_sriov_vf(adev))
> +               adev->nbio.funcs->remap_hdp_registers(adev);
> +}
>
>  /**
>   * amdgpu_device_ip_init - run init for hardware IPs
> @@ -2376,6 +2396,8 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
>                                 DRM_ERROR("amdgpu_vram_scratch_init failed %d\n", r);
>                                 goto init_failed;
>                         }
> +
> +                       amdgpu_device_prepare_ip(adev);
>                         r = adev->ip_blocks[i].version->funcs->hw_init((void *)adev);
>                         if (r) {
>                                 DRM_ERROR("hw_init %d failed %d\n", i, r);
> @@ -3058,6 +3080,7 @@ static int amdgpu_device_ip_reinit_early_sriov(struct amdgpu_device *adev)
>                 AMD_IP_BLOCK_TYPE_IH,
>         };
>
> +       amdgpu_device_prepare_ip(adev);
>         for (i = 0; i < adev->num_ip_blocks; i++) {
>                 int j;
>                 struct amdgpu_ip_block *block;
> @@ -3139,6 +3162,7 @@ static int amdgpu_device_ip_resume_phase1(struct amdgpu_device *adev)
>  {
>         int i, r;
>
> +       amdgpu_device_prepare_ip(adev);
>         for (i = 0; i < adev->num_ip_blocks; i++) {
>                 if (!adev->ip_blocks[i].status.valid || adev->ip_blocks[i].status.hw)
>                         continue;
> diff --git a/drivers/gpu/drm/amd/amdgpu/nv.c b/drivers/gpu/drm/amd/amdgpu/nv.c
> index b3fba8dea63c..3ac7fef74277 100644
> --- a/drivers/gpu/drm/amd/amdgpu/nv.c
> +++ b/drivers/gpu/drm/amd/amdgpu/nv.c
> @@ -1032,12 +1032,6 @@ static int nv_common_hw_init(void *handle)
>         nv_program_aspm(adev);
>         /* setup nbio registers */
>         adev->nbio.funcs->init_registers(adev);
> -       /* remap HDP registers to a hole in mmio space,
> -        * for the purpose of expose those registers
> -        * to process space
> -        */
> -       if (adev->nbio.funcs->remap_hdp_registers && !amdgpu_sriov_vf(adev))
> -               adev->nbio.funcs->remap_hdp_registers(adev);
>         /* enable the doorbell aperture */
>         nv_enable_doorbell_aperture(adev, true);
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
> index fde6154f2009..a0481e37d7cf 100644
> --- a/drivers/gpu/drm/amd/amdgpu/soc15.c
> +++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
> @@ -1240,12 +1240,6 @@ static int soc15_common_hw_init(void *handle)
>         soc15_program_aspm(adev);
>         /* setup nbio registers */
>         adev->nbio.funcs->init_registers(adev);
> -       /* remap HDP registers to a hole in mmio space,
> -        * for the purpose of expose those registers
> -        * to process space
> -        */
> -       if (adev->nbio.funcs->remap_hdp_registers && !amdgpu_sriov_vf(adev))
> -               adev->nbio.funcs->remap_hdp_registers(adev);
>
>         /* enable the doorbell aperture */
>         soc15_enable_doorbell_aperture(adev, true);
> diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
> index 55284b24f113..16b447055102 100644
> --- a/drivers/gpu/drm/amd/amdgpu/soc21.c
> +++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
> @@ -660,12 +660,6 @@ static int soc21_common_hw_init(void *handle)
>         soc21_program_aspm(adev);
>         /* setup nbio registers */
>         adev->nbio.funcs->init_registers(adev);
> -       /* remap HDP registers to a hole in mmio space,
> -        * for the purpose of expose those registers
> -        * to process space
> -        */
> -       if (adev->nbio.funcs->remap_hdp_registers)
> -               adev->nbio.funcs->remap_hdp_registers(adev);
>         /* enable the doorbell aperture */
>         soc21_enable_doorbell_aperture(adev, true);
>
> --
> 2.25.1
>

--0000000000005d067105e76410d9
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-drm-amdgpu-cleanup-HDP-flush-remap-handling.patch"
Content-Disposition: attachment; 
	filename="0001-drm-amdgpu-cleanup-HDP-flush-remap-handling.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l7ezx4tk0>
X-Attachment-Id: f_l7ezx4tk0

RnJvbSA4ZWEwZGNhNGY0OTZkNDQ4YTExYWJjNjY1MWM0NWE1NmE5OWI4MzAzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IE1vbiwgMjkgQXVnIDIwMjIgMTI6Mzc6MDIgLTA0MDAKU3ViamVjdDogW1BBVENI
XSBkcm0vYW1kZ3B1OiBjbGVhbnVwIEhEUCBmbHVzaCByZW1hcCBoYW5kbGluZwoKVXNlIHRoZSBv
cmlnaW5hbCByZWdpc3RlciBsb2NhdGlvbiBpZiB0aGUgcmVtYXAgaGFzIG5vdApoYXBwZW5lZCB5
ZXQuICBIRFAgZmx1c2ggaGFwcGVucyBlYXJseSBhcyBwYXJ0IG9mIHRoZQpHTUMgSVAgc2V0dXAg
d2hpY2ggaGFwcGVucyBiZWZvcmUgdGhlIEhEUCByZWdpc3RlcnMgYXJlCnJlbWFwcGVkLiAgRml4
IHRoZSBIRFAgZmx1c2ggZnVuY3Rpb24gdG8gdXNlIGVpdGhlciB0aGUKcmVtYXBwZWQgb3IgdGhl
IG9yaWdpbmFsIG9mZnNldCBkZXBlbmRpbmcgb24gd2hldGhlciB0aGUKcmVtYXAgaGFzIGhhcHBl
bmVkIG9yIG5vdC4KClRoaXMgZml4ZXMgdGhlIFVuc3VwcG9ydGVkIFJlcXVlc3QgZXJyb3IgcmVw
b3J0ZWQgdGhyb3VnaApBRVIgZHVyaW5nIGRyaXZlciBsb2FkLiBUaGUgZXJyb3IgaGFwcGVucyBh
cyBhIHdyaXRlIGhhcHBlbnMKdG8gdGhlIHJlbWFwIG9mZnNldCBiZWZvcmUgcmVhbCByZW1hcHBp
bmcgaXMgZG9uZS4gIFRoaXMgc2hvdWxkCmFsc28gZml4IEFTSUNzIHdpdGggTkJJTyA3Ljcgd2hp
Y2ggZG8gbm90IGN1cnJlbnQgcmVtYXAgdGhlCkhEUCByZWdpc3Rlci4KCkxpbms6IGh0dHBzOi8v
YnVnemlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MjE2MzczCgpUaGUgZXJyb3Igd2Fz
IHVubm90aWNlZCBiZWZvcmUgYW5kIGdvdCB2aXNpYmxlIGJlY2F1c2Ugb2YgdGhlIGNvbW1pdApy
ZWZlcmVuY2VkIGJlbG93LiBUaGlzIGRvZXNuJ3QgZml4IGFueXRoaW5nIGluIHRoZSBjb21taXQg
YmVsb3csIHJhdGhlcgpmaXhlcyB0aGUgaXNzdWUgaW4gYW1kZ3B1IGV4cG9zZWQgYnkgdGhlIGNv
bW1pdC4gVGhlIHJlZmVyZW5jZSBpcyBvbmx5CnRvIGFzc29jaWF0ZSB0aGlzIGNvbW1pdCB3aXRo
IGJlbG93IG9uZSBzbyB0aGF0IGJvdGggZ28gdG9nZXRoZXIuCgpGaXhlczogODc5NWUxODJiMDJk
ICgiUENJL3BvcnRkcnY6IERvbid0IGRpc2FibGUgQUVSIHJlcG9ydGluZyBpbiBnZXRfcG9ydF9k
ZXZpY2VfY2FwYWJpbGl0eSgpIikKClNpZ25lZC1vZmYtYnk6IEFsZXggRGV1Y2hlciA8YWxleGFu
ZGVyLmRldWNoZXJAYW1kLmNvbT4KLS0tCiBkcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9oZHBf
djRfMC5jICB8IDEzICsrKysrKysrKysrLS0KIGRyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2hk
cF92NV8wLmMgIHwgMTMgKysrKysrKysrKystLQogZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUv
aGRwX3Y1XzIuYyAgfCAxNiArKysrKysrKysrKy0tLS0tCiBkcml2ZXJzL2dwdS9kcm0vYW1kL2Ft
ZGdwdS9oZHBfdjZfMC5jICB8IDEzICsrKysrKysrKysrLS0KIGRyaXZlcnMvZ3B1L2RybS9hbWQv
YW1kZ3B1L25iaW9fdjJfMy5jIHwgMTggKysrKysrKysrKy0tLS0tLS0tCiBkcml2ZXJzL2dwdS9k
cm0vYW1kL2FtZGdwdS9uYmlvX3Y0XzMuYyB8IDE0ICsrKysrKysrKystLS0tCiBkcml2ZXJzL2dw
dS9kcm0vYW1kL2FtZGdwdS9uYmlvX3Y2XzEuYyB8IDE4ICsrKysrKysrKystLS0tLS0tLQogZHJp
dmVycy9ncHUvZHJtL2FtZC9hbWRncHUvbmJpb192N18wLmMgfCAxNyArKysrKysrKysrLS0tLS0t
LQogZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvbmJpb192N18yLmMgfCAxOCArKysrKysrKysr
LS0tLS0tLS0KIGRyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L25iaW9fdjdfNC5jIHwgMTggKysr
KysrKysrKy0tLS0tLS0tCiBkcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9udi5jICAgICAgICB8
ICA3ICstLS0tLS0KIGRyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L3NvYzE1LmMgICAgIHwgIDcg
Ky0tLS0tLQogZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvc29jMjEuYyAgICAgfCAgMyAtLS0K
IDEzIGZpbGVzIGNoYW5nZWQsIDEwNiBpbnNlcnRpb25zKCspLCA2OSBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9oZHBfdjRfMC5jIGIvZHJpdmVy
cy9ncHUvZHJtL2FtZC9hbWRncHUvaGRwX3Y0XzAuYwppbmRleCBhZGY4OTY4MGY1M2UuLjk2NzY4
YmJkYTkxZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvaGRwX3Y0XzAu
YworKysgYi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9oZHBfdjRfMC5jCkBAIC0yNyw2ICsy
Nyw3IEBACiAKICNpbmNsdWRlICJoZHAvaGRwXzRfMF9vZmZzZXQuaCIKICNpbmNsdWRlICJoZHAv
aGRwXzRfMF9zaF9tYXNrLmgiCisjaW5jbHVkZSAibmJpby9uYmlvXzZfMV9vZmZzZXQuaCIKICNp
bmNsdWRlIDx1YXBpL2xpbnV4L2tmZF9pb2N0bC5oPgogCiAvKiBmb3IgVmVnYTIwIHJlZ2lzdGVy
IG5hbWUgY2hhbmdlICovCkBAIC00MCwxMCArNDEsMTggQEAKIHN0YXRpYyB2b2lkIGhkcF92NF8w
X2ZsdXNoX2hkcChzdHJ1Y3QgYW1kZ3B1X2RldmljZSAqYWRldiwKIAkJCQlzdHJ1Y3QgYW1kZ3B1
X3JpbmcgKnJpbmcpCiB7CisJdTMyIHJlZ19vZmZzZXQ7CisKKwlpZiAoYWRldi0+cm1taW9fcmVt
YXAucmVnX29mZnNldCkKKwkJcmVnX29mZnNldCA9IChhZGV2LT5ybW1pb19yZW1hcC5yZWdfb2Zm
c2V0ICsgS0ZEX01NSU9fUkVNQVBfSERQX01FTV9GTFVTSF9DTlRMKSA+PiAyOworCWVsc2UKKwkJ
cmVnX29mZnNldCA9IFNPQzE1X1JFR19PRkZTRVQoTkJJTywgMCwKKwkJCQkJICAgICAgbW1CSUZf
QlhfREVWMF9FUEYwX1ZGMF9IRFBfTUVNX0NPSEVSRU5DWV9GTFVTSF9DTlRMKSA8PCAyOworCiAJ
aWYgKCFyaW5nIHx8ICFyaW5nLT5mdW5jcy0+ZW1pdF93cmVnKQotCQlXUkVHMzJfTk9fS0lRKChh
ZGV2LT5ybW1pb19yZW1hcC5yZWdfb2Zmc2V0ICsgS0ZEX01NSU9fUkVNQVBfSERQX01FTV9GTFVT
SF9DTlRMKSA+PiAyLCAwKTsKKwkJV1JFRzMyX05PX0tJUShyZWdfb2Zmc2V0LCAwKTsKIAllbHNl
Ci0JCWFtZGdwdV9yaW5nX2VtaXRfd3JlZyhyaW5nLCAoYWRldi0+cm1taW9fcmVtYXAucmVnX29m
ZnNldCArIEtGRF9NTUlPX1JFTUFQX0hEUF9NRU1fRkxVU0hfQ05UTCkgPj4gMiwgMCk7CisJCWFt
ZGdwdV9yaW5nX2VtaXRfd3JlZyhyaW5nLCByZWdfb2Zmc2V0LCAwKTsKIH0KIAogc3RhdGljIHZv
aWQgaGRwX3Y0XzBfaW52YWxpZGF0ZV9oZHAoc3RydWN0IGFtZGdwdV9kZXZpY2UgKmFkZXYsCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9oZHBfdjVfMC5jIGIvZHJpdmVy
cy9ncHUvZHJtL2FtZC9hbWRncHUvaGRwX3Y1XzAuYwppbmRleCBhOWVhMjNmYTBkZWYuLjQ3OTcx
MDNlMWIxNCAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvaGRwX3Y1XzAu
YworKysgYi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9oZHBfdjVfMC5jCkBAIC0yNiwxNSAr
MjYsMjQgQEAKIAogI2luY2x1ZGUgImhkcC9oZHBfNV8wXzBfb2Zmc2V0LmgiCiAjaW5jbHVkZSAi
aGRwL2hkcF81XzBfMF9zaF9tYXNrLmgiCisjaW5jbHVkZSAibmJpby9uYmlvXzJfM19vZmZzZXQu
aCIKICNpbmNsdWRlIDx1YXBpL2xpbnV4L2tmZF9pb2N0bC5oPgogCiBzdGF0aWMgdm9pZCBoZHBf
djVfMF9mbHVzaF9oZHAoc3RydWN0IGFtZGdwdV9kZXZpY2UgKmFkZXYsCiAJCQkJc3RydWN0IGFt
ZGdwdV9yaW5nICpyaW5nKQogeworCXUzMiByZWdfb2Zmc2V0OworCisJaWYgKGFkZXYtPnJtbWlv
X3JlbWFwLnJlZ19vZmZzZXQpCisJCXJlZ19vZmZzZXQgPSAoYWRldi0+cm1taW9fcmVtYXAucmVn
X29mZnNldCArIEtGRF9NTUlPX1JFTUFQX0hEUF9NRU1fRkxVU0hfQ05UTCkgPj4gMjsKKwllbHNl
CisJCXJlZ19vZmZzZXQgPSBTT0MxNV9SRUdfT0ZGU0VUKE5CSU8sIDAsCisJCQkJCSAgICAgIG1t
QklGX0JYX0RFVjBfRVBGMF9WRjBfSERQX01FTV9DT0hFUkVOQ1lfRkxVU0hfQ05UTCkgPDwgMjsK
KwogCWlmICghcmluZyB8fCAhcmluZy0+ZnVuY3MtPmVtaXRfd3JlZykKLQkJV1JFRzMyX05PX0tJ
USgoYWRldi0+cm1taW9fcmVtYXAucmVnX29mZnNldCArIEtGRF9NTUlPX1JFTUFQX0hEUF9NRU1f
RkxVU0hfQ05UTCkgPj4gMiwgMCk7CisJCVdSRUczMl9OT19LSVEocmVnX29mZnNldCwgMCk7CiAJ
ZWxzZQotCQlhbWRncHVfcmluZ19lbWl0X3dyZWcocmluZywgKGFkZXYtPnJtbWlvX3JlbWFwLnJl
Z19vZmZzZXQgKyBLRkRfTU1JT19SRU1BUF9IRFBfTUVNX0ZMVVNIX0NOVEwpID4+IDIsIDApOwor
CQlhbWRncHVfcmluZ19lbWl0X3dyZWcocmluZywgcmVnX29mZnNldCwgMCk7CiB9CiAKIHN0YXRp
YyB2b2lkIGhkcF92NV8wX2ludmFsaWRhdGVfaGRwKHN0cnVjdCBhbWRncHVfZGV2aWNlICphZGV2
LApkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvaGRwX3Y1XzIuYyBiL2Ry
aXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2hkcF92NV8yLmMKaW5kZXggMjljMzQ4NGFlMWYxLi5i
MjZiMWQ2ZmU2YTYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2hkcF92
NV8yLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvaGRwX3Y1XzIuYwpAQCAtMjYs
MTggKzI2LDI0IEBACiAKICNpbmNsdWRlICJoZHAvaGRwXzVfMl8xX29mZnNldC5oIgogI2luY2x1
ZGUgImhkcC9oZHBfNV8yXzFfc2hfbWFzay5oIgorI2luY2x1ZGUgIm5iaW8vbmJpb18yXzNfb2Zm
c2V0LmgiCiAjaW5jbHVkZSA8dWFwaS9saW51eC9rZmRfaW9jdGwuaD4KIAogc3RhdGljIHZvaWQg
aGRwX3Y1XzJfZmx1c2hfaGRwKHN0cnVjdCBhbWRncHVfZGV2aWNlICphZGV2LAogCQkJCXN0cnVj
dCBhbWRncHVfcmluZyAqcmluZykKIHsKKwl1MzIgcmVnX29mZnNldDsKKworCWlmIChhZGV2LT5y
bW1pb19yZW1hcC5yZWdfb2Zmc2V0KQorCQlyZWdfb2Zmc2V0ID0gKGFkZXYtPnJtbWlvX3JlbWFw
LnJlZ19vZmZzZXQgKyBLRkRfTU1JT19SRU1BUF9IRFBfTUVNX0ZMVVNIX0NOVEwpID4+IDI7CisJ
ZWxzZQorCQlyZWdfb2Zmc2V0ID0gU09DMTVfUkVHX09GRlNFVChOQklPLCAwLAorCQkJCQkgICAg
ICBtbUJJRl9CWF9ERVYwX0VQRjBfVkYwX0hEUF9NRU1fQ09IRVJFTkNZX0ZMVVNIX0NOVEwpIDw8
IDI7CisKIAlpZiAoIXJpbmcgfHwgIXJpbmctPmZ1bmNzLT5lbWl0X3dyZWcpCi0JCVdSRUczMl9O
T19LSVEoKGFkZXYtPnJtbWlvX3JlbWFwLnJlZ19vZmZzZXQgKyBLRkRfTU1JT19SRU1BUF9IRFBf
TUVNX0ZMVVNIX0NOVEwpID4+IDIsCi0JCQkwKTsKKwkJV1JFRzMyX05PX0tJUShyZWdfb2Zmc2V0
LCAwKTsKIAllbHNlCi0JCWFtZGdwdV9yaW5nX2VtaXRfd3JlZyhyaW5nLAotCQkJKGFkZXYtPnJt
bWlvX3JlbWFwLnJlZ19vZmZzZXQgKyBLRkRfTU1JT19SRU1BUF9IRFBfTUVNX0ZMVVNIX0NOVEwp
ID4+IDIsCi0JCQkwKTsKKwkJYW1kZ3B1X3JpbmdfZW1pdF93cmVnKHJpbmcsIHJlZ19vZmZzZXQs
IDApOwogfQogCiBzdGF0aWMgdm9pZCBoZHBfdjVfMl91cGRhdGVfbWVtX3Bvd2VyX2dhdGluZyhz
dHJ1Y3QgYW1kZ3B1X2RldmljZSAqYWRldiwKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9h
bWQvYW1kZ3B1L2hkcF92Nl8wLmMgYi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9oZHBfdjZf
MC5jCmluZGV4IDA2M2ViYTYxOWYyZi4uZDYzNTI0OTgyMmZjIDEwMDY0NAotLS0gYS9kcml2ZXJz
L2dwdS9kcm0vYW1kL2FtZGdwdS9oZHBfdjZfMC5jCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9hbWQv
YW1kZ3B1L2hkcF92Nl8wLmMKQEAgLTI2LDE1ICsyNiwyNCBAQAogCiAjaW5jbHVkZSAiaGRwL2hk
cF82XzBfMF9vZmZzZXQuaCIKICNpbmNsdWRlICJoZHAvaGRwXzZfMF8wX3NoX21hc2suaCIKKyNp
bmNsdWRlICJuYmlvL25iaW9fNF8zXzBfb2Zmc2V0LmgiCiAjaW5jbHVkZSA8dWFwaS9saW51eC9r
ZmRfaW9jdGwuaD4KIAogc3RhdGljIHZvaWQgaGRwX3Y2XzBfZmx1c2hfaGRwKHN0cnVjdCBhbWRn
cHVfZGV2aWNlICphZGV2LAogCQkJCXN0cnVjdCBhbWRncHVfcmluZyAqcmluZykKIHsKKwl1MzIg
cmVnX29mZnNldDsKKworCWlmIChhZGV2LT5ybW1pb19yZW1hcC5yZWdfb2Zmc2V0KQorCQlyZWdf
b2Zmc2V0ID0gKGFkZXYtPnJtbWlvX3JlbWFwLnJlZ19vZmZzZXQgKyBLRkRfTU1JT19SRU1BUF9I
RFBfTUVNX0ZMVVNIX0NOVEwpID4+IDI7CisJZWxzZQorCQlyZWdfb2Zmc2V0ID0gU09DMTVfUkVH
X09GRlNFVChOQklPLCAwLAorCQkJCQkgICAgICByZWdCSUZfQlhfUEYwX0hEUF9NRU1fQ09IRVJF
TkNZX0ZMVVNIX0NOVEwpIDw8IDI7CisKIAlpZiAoIXJpbmcgfHwgIXJpbmctPmZ1bmNzLT5lbWl0
X3dyZWcpCi0JCVdSRUczMl9OT19LSVEoKGFkZXYtPnJtbWlvX3JlbWFwLnJlZ19vZmZzZXQgKyBL
RkRfTU1JT19SRU1BUF9IRFBfTUVNX0ZMVVNIX0NOVEwpID4+IDIsIDApOworCQlXUkVHMzJfTk9f
S0lRKHJlZ19vZmZzZXQsIDApOwogCWVsc2UKLQkJYW1kZ3B1X3JpbmdfZW1pdF93cmVnKHJpbmcs
IChhZGV2LT5ybW1pb19yZW1hcC5yZWdfb2Zmc2V0ICsgS0ZEX01NSU9fUkVNQVBfSERQX01FTV9G
TFVTSF9DTlRMKSA+PiAyLCAwKTsKKwkJYW1kZ3B1X3JpbmdfZW1pdF93cmVnKHJpbmcsIHJlZ19v
ZmZzZXQsIDApOwogfQogCiBzdGF0aWMgdm9pZCBoZHBfdjZfMF91cGRhdGVfY2xvY2tfZ2F0aW5n
KHN0cnVjdCBhbWRncHVfZGV2aWNlICphZGV2LApkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJt
L2FtZC9hbWRncHUvbmJpb192Ml8zLmMgYi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9uYmlv
X3YyXzMuYwppbmRleCBiNDY1YmFhMjY3NjIuLmFjMGVhMWE0MjYzYiAxMDA2NDQKLS0tIGEvZHJp
dmVycy9ncHUvZHJtL2FtZC9hbWRncHUvbmJpb192Ml8zLmMKKysrIGIvZHJpdmVycy9ncHUvZHJt
L2FtZC9hbWRncHUvbmJpb192Ml8zLmMKQEAgLTYzLDEyICs2MywxOCBAQAogI2RlZmluZSBHUFVf
SERQX0ZMVVNIX0RPTkVfX1JTVkRfRU5HN19NQVNLCTB4MDAwODAwMDBMCiAjZGVmaW5lIEdQVV9I
RFBfRkxVU0hfRE9ORV9fUlNWRF9FTkc4X01BU0sJMHgwMDEwMDAwMEwKIAorI2RlZmluZSBNTUlP
X1JFR19IT0xFX09GRlNFVCAoMHg4MDAwMCAtIFBBR0VfU0laRSkKKwogc3RhdGljIHZvaWQgbmJp
b192Ml8zX3JlbWFwX2hkcF9yZWdpc3RlcnMoc3RydWN0IGFtZGdwdV9kZXZpY2UgKmFkZXYpCiB7
Ci0JV1JFRzMyX1NPQzE1KE5CSU8sIDAsIG1tUkVNQVBfSERQX01FTV9GTFVTSF9DTlRMLAotCQlh
ZGV2LT5ybW1pb19yZW1hcC5yZWdfb2Zmc2V0ICsgS0ZEX01NSU9fUkVNQVBfSERQX01FTV9GTFVT
SF9DTlRMKTsKLQlXUkVHMzJfU09DMTUoTkJJTywgMCwgbW1SRU1BUF9IRFBfUkVHX0ZMVVNIX0NO
VEwsCi0JCWFkZXYtPnJtbWlvX3JlbWFwLnJlZ19vZmZzZXQgKyBLRkRfTU1JT19SRU1BUF9IRFBf
UkVHX0ZMVVNIX0NOVEwpOworCWlmICghYW1kZ3B1X3NyaW92X3ZmKGFkZXYpKSB7CisJCWFkZXYt
PnJtbWlvX3JlbWFwLnJlZ19vZmZzZXQgPSBNTUlPX1JFR19IT0xFX09GRlNFVDsKKwkJYWRldi0+
cm1taW9fcmVtYXAuYnVzX2FkZHIgPSBhZGV2LT5ybW1pb19iYXNlICsgTU1JT19SRUdfSE9MRV9P
RkZTRVQ7CisJCVdSRUczMl9TT0MxNShOQklPLCAwLCBtbVJFTUFQX0hEUF9NRU1fRkxVU0hfQ05U
TCwKKwkJCSAgICAgYWRldi0+cm1taW9fcmVtYXAucmVnX29mZnNldCArIEtGRF9NTUlPX1JFTUFQ
X0hEUF9NRU1fRkxVU0hfQ05UTCk7CisJCVdSRUczMl9TT0MxNShOQklPLCAwLCBtbVJFTUFQX0hE
UF9SRUdfRkxVU0hfQ05UTCwKKwkJCSAgICAgYWRldi0+cm1taW9fcmVtYXAucmVnX29mZnNldCAr
IEtGRF9NTUlPX1JFTUFQX0hEUF9SRUdfRkxVU0hfQ05UTCk7CisJfQogfQogCiBzdGF0aWMgdTMy
IG5iaW9fdjJfM19nZXRfcmV2X2lkKHN0cnVjdCBhbWRncHVfZGV2aWNlICphZGV2KQpAQCAtMzM4
LDEwICszNDQsNiBAQCBzdGF0aWMgdm9pZCBuYmlvX3YyXzNfaW5pdF9yZWdpc3RlcnMoc3RydWN0
IGFtZGdwdV9kZXZpY2UgKmFkZXYpCiAKIAlpZiAoZGVmICE9IGRhdGEpCiAJCVdSRUczMl9QQ0lF
KHNtblBDSUVfQ09ORklHX0NOVEwsIGRhdGEpOwotCi0JaWYgKGFtZGdwdV9zcmlvdl92ZihhZGV2
KSkKLQkJYWRldi0+cm1taW9fcmVtYXAucmVnX29mZnNldCA9IFNPQzE1X1JFR19PRkZTRVQoTkJJ
TywgMCwKLQkJCW1tQklGX0JYX0RFVjBfRVBGMF9WRjBfSERQX01FTV9DT0hFUkVOQ1lfRkxVU0hf
Q05UTCkgPDwgMjsKIH0KIAogI2RlZmluZSBOQVZJMTBfUENJRV9fTENfTDBTX0lOQUNUSVZJVFlf
REVGQVVMVAkJMHgwMDAwMDAwMCAvLyBvZmYgYnkgZGVmYXVsdCwgbm8gZ2FpbnMgb3ZlciBMMQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvbmJpb192NF8zLmMgYi9kcml2
ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9uYmlvX3Y0XzMuYwppbmRleCA5ODJhODlmODQxZDUuLmYx
NTEwNTE0ZmMwNyAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvbmJpb192
NF8zLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvbmJpb192NF8zLmMKQEAgLTI4
LDEyICsyOCwxOCBAQAogI2luY2x1ZGUgIm5iaW8vbmJpb180XzNfMF9zaF9tYXNrLmgiCiAjaW5j
bHVkZSA8dWFwaS9saW51eC9rZmRfaW9jdGwuaD4KIAorI2RlZmluZSBNTUlPX1JFR19IT0xFX09G
RlNFVCAoMHg4MDAwMCAtIFBBR0VfU0laRSkKKwogc3RhdGljIHZvaWQgbmJpb192NF8zX3JlbWFw
X2hkcF9yZWdpc3RlcnMoc3RydWN0IGFtZGdwdV9kZXZpY2UgKmFkZXYpCiB7Ci0JV1JFRzMyX1NP
QzE1KE5CSU8sIDAsIHJlZ0JJRl9CWDBfUkVNQVBfSERQX01FTV9GTFVTSF9DTlRMLAotCQlhZGV2
LT5ybW1pb19yZW1hcC5yZWdfb2Zmc2V0ICsgS0ZEX01NSU9fUkVNQVBfSERQX01FTV9GTFVTSF9D
TlRMKTsKLQlXUkVHMzJfU09DMTUoTkJJTywgMCwgcmVnQklGX0JYMF9SRU1BUF9IRFBfUkVHX0ZM
VVNIX0NOVEwsCi0JCWFkZXYtPnJtbWlvX3JlbWFwLnJlZ19vZmZzZXQgKyBLRkRfTU1JT19SRU1B
UF9IRFBfUkVHX0ZMVVNIX0NOVEwpOworCWlmICghYW1kZ3B1X3NyaW92X3ZmKGFkZXYpKSB7CisJ
CWFkZXYtPnJtbWlvX3JlbWFwLnJlZ19vZmZzZXQgPSBNTUlPX1JFR19IT0xFX09GRlNFVDsKKwkJ
YWRldi0+cm1taW9fcmVtYXAuYnVzX2FkZHIgPSBhZGV2LT5ybW1pb19iYXNlICsgTU1JT19SRUdf
SE9MRV9PRkZTRVQ7CisJCVdSRUczMl9TT0MxNShOQklPLCAwLCByZWdCSUZfQlgwX1JFTUFQX0hE
UF9NRU1fRkxVU0hfQ05UTCwKKwkJCSAgICAgYWRldi0+cm1taW9fcmVtYXAucmVnX29mZnNldCAr
IEtGRF9NTUlPX1JFTUFQX0hEUF9NRU1fRkxVU0hfQ05UTCk7CisJCVdSRUczMl9TT0MxNShOQklP
LCAwLCByZWdCSUZfQlgwX1JFTUFQX0hEUF9SRUdfRkxVU0hfQ05UTCwKKwkJCSAgICAgYWRldi0+
cm1taW9fcmVtYXAucmVnX29mZnNldCArIEtGRF9NTUlPX1JFTUFQX0hEUF9SRUdfRkxVU0hfQ05U
TCk7CisJfQogfQogCiBzdGF0aWMgdTMyIG5iaW9fdjRfM19nZXRfcmV2X2lkKHN0cnVjdCBhbWRn
cHVfZGV2aWNlICphZGV2KQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUv
bmJpb192Nl8xLmMgYi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9uYmlvX3Y2XzEuYwppbmRl
eCBmN2Y2ZGRlYmQzZTQuLjBjNDdiOGI4ZjQ2YSAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJt
L2FtZC9hbWRncHUvbmJpb192Nl8xLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUv
bmJpb192Nl8xLmMKQEAgLTUzLDEyICs1MywxOCBAQAogI2RlZmluZSBSQ0NfQklGX1NUUkFQM19f
U1RSQVBfVkxJTktfUE1fTDFfRU5UUllfVElNRVJfX1NISUZUCTB4MTAKICNkZWZpbmUgUkNDX0JJ
Rl9TVFJBUDVfX1NUUkFQX1ZMSU5LX0xETl9FTlRSWV9USU1FUl9fU0hJRlQJMHgwCiAKKyNkZWZp
bmUgTU1JT19SRUdfSE9MRV9PRkZTRVQgKDB4ODAwMDAgLSBQQUdFX1NJWkUpCisKIHN0YXRpYyB2
b2lkIG5iaW9fdjZfMV9yZW1hcF9oZHBfcmVnaXN0ZXJzKHN0cnVjdCBhbWRncHVfZGV2aWNlICph
ZGV2KQogewotCVdSRUczMl9TT0MxNShOQklPLCAwLCBtbVJFTUFQX0hEUF9NRU1fRkxVU0hfQ05U
TCwKLQkJYWRldi0+cm1taW9fcmVtYXAucmVnX29mZnNldCArIEtGRF9NTUlPX1JFTUFQX0hEUF9N
RU1fRkxVU0hfQ05UTCk7Ci0JV1JFRzMyX1NPQzE1KE5CSU8sIDAsIG1tUkVNQVBfSERQX1JFR19G
TFVTSF9DTlRMLAotCQlhZGV2LT5ybW1pb19yZW1hcC5yZWdfb2Zmc2V0ICsgS0ZEX01NSU9fUkVN
QVBfSERQX1JFR19GTFVTSF9DTlRMKTsKKwlpZiAoIWFtZGdwdV9zcmlvdl92ZihhZGV2KSkgewor
CQlhZGV2LT5ybW1pb19yZW1hcC5yZWdfb2Zmc2V0ID0gTU1JT19SRUdfSE9MRV9PRkZTRVQ7CisJ
CWFkZXYtPnJtbWlvX3JlbWFwLmJ1c19hZGRyID0gYWRldi0+cm1taW9fYmFzZSArIE1NSU9fUkVH
X0hPTEVfT0ZGU0VUOworCQlXUkVHMzJfU09DMTUoTkJJTywgMCwgbW1SRU1BUF9IRFBfTUVNX0ZM
VVNIX0NOVEwsCisJCQkgICAgIGFkZXYtPnJtbWlvX3JlbWFwLnJlZ19vZmZzZXQgKyBLRkRfTU1J
T19SRU1BUF9IRFBfTUVNX0ZMVVNIX0NOVEwpOworCQlXUkVHMzJfU09DMTUoTkJJTywgMCwgbW1S
RU1BUF9IRFBfUkVHX0ZMVVNIX0NOVEwsCisJCQkgICAgIGFkZXYtPnJtbWlvX3JlbWFwLnJlZ19v
ZmZzZXQgKyBLRkRfTU1JT19SRU1BUF9IRFBfUkVHX0ZMVVNIX0NOVEwpOworCX0KIH0KIAogc3Rh
dGljIHUzMiBuYmlvX3Y2XzFfZ2V0X3Jldl9pZChzdHJ1Y3QgYW1kZ3B1X2RldmljZSAqYWRldikK
QEAgLTI3NiwxMCArMjgyLDYgQEAgc3RhdGljIHZvaWQgbmJpb192Nl8xX2luaXRfcmVnaXN0ZXJz
KHN0cnVjdCBhbWRncHVfZGV2aWNlICphZGV2KQogCiAJaWYgKGRlZiAhPSBkYXRhKQogCQlXUkVH
MzJfUENJRShzbW5QQ0lFX0NJX0NOVEwsIGRhdGEpOwotCi0JaWYgKGFtZGdwdV9zcmlvdl92Zihh
ZGV2KSkKLQkJYWRldi0+cm1taW9fcmVtYXAucmVnX29mZnNldCA9IFNPQzE1X1JFR19PRkZTRVQo
TkJJTywgMCwKLQkJCW1tQklGX0JYX0RFVjBfRVBGMF9WRjBfSERQX01FTV9DT0hFUkVOQ1lfRkxV
U0hfQ05UTCkgPDwgMjsKIH0KIAogc3RhdGljIHZvaWQgbmJpb192Nl8xX3Byb2dyYW1fbHRyKHN0
cnVjdCBhbWRncHVfZGV2aWNlICphZGV2KQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2Ft
ZC9hbWRncHUvbmJpb192N18wLmMgYi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9uYmlvX3Y3
XzAuYwppbmRleCBhYTAzMjZkMDBjNzIuLjlhZmEwYmY5YmMxMiAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9ncHUvZHJtL2FtZC9hbWRncHUvbmJpb192N18wLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL2Ft
ZC9hbWRncHUvbmJpb192N18wLmMKQEAgLTMzLDEyICszMywxOCBAQAogCiAjZGVmaW5lIHNtbk5C
SUZfTUdDR19DVFJMX0xDTEsJMHgxMDEzYTA1YwogCisjZGVmaW5lIE1NSU9fUkVHX0hPTEVfT0ZG
U0VUICgweDgwMDAwIC0gUEFHRV9TSVpFKQorCiBzdGF0aWMgdm9pZCBuYmlvX3Y3XzBfcmVtYXBf
aGRwX3JlZ2lzdGVycyhzdHJ1Y3QgYW1kZ3B1X2RldmljZSAqYWRldikKIHsKLQlXUkVHMzJfU09D
MTUoTkJJTywgMCwgbW1SRU1BUF9IRFBfTUVNX0ZMVVNIX0NOVEwsCi0JCWFkZXYtPnJtbWlvX3Jl
bWFwLnJlZ19vZmZzZXQgKyBLRkRfTU1JT19SRU1BUF9IRFBfTUVNX0ZMVVNIX0NOVEwpOwotCVdS
RUczMl9TT0MxNShOQklPLCAwLCBtbVJFTUFQX0hEUF9SRUdfRkxVU0hfQ05UTCwKLQkJYWRldi0+
cm1taW9fcmVtYXAucmVnX29mZnNldCArIEtGRF9NTUlPX1JFTUFQX0hEUF9SRUdfRkxVU0hfQ05U
TCk7CisJaWYgKCFhbWRncHVfc3Jpb3ZfdmYoYWRldikpIHsKKwkJYWRldi0+cm1taW9fcmVtYXAu
cmVnX29mZnNldCA9IE1NSU9fUkVHX0hPTEVfT0ZGU0VUOworCQlhZGV2LT5ybW1pb19yZW1hcC5i
dXNfYWRkciA9IGFkZXYtPnJtbWlvX2Jhc2UgKyBNTUlPX1JFR19IT0xFX09GRlNFVDsKKwkJV1JF
RzMyX1NPQzE1KE5CSU8sIDAsIG1tUkVNQVBfSERQX01FTV9GTFVTSF9DTlRMLAorCQkJICAgICBh
ZGV2LT5ybW1pb19yZW1hcC5yZWdfb2Zmc2V0ICsgS0ZEX01NSU9fUkVNQVBfSERQX01FTV9GTFVT
SF9DTlRMKTsKKwkJV1JFRzMyX1NPQzE1KE5CSU8sIDAsIG1tUkVNQVBfSERQX1JFR19GTFVTSF9D
TlRMLAorCQkJICAgICBhZGV2LT5ybW1pb19yZW1hcC5yZWdfb2Zmc2V0ICsgS0ZEX01NSU9fUkVN
QVBfSERQX1JFR19GTFVTSF9DTlRMKTsKKwl9CiB9CiAKIHN0YXRpYyB1MzIgbmJpb192N18wX2dl
dF9yZXZfaWQoc3RydWN0IGFtZGdwdV9kZXZpY2UgKmFkZXYpCkBAIC0yNzMsOSArMjc5LDYgQEAg
Y29uc3Qgc3RydWN0IG5iaW9faGRwX2ZsdXNoX3JlZyBuYmlvX3Y3XzBfaGRwX2ZsdXNoX3JlZyA9
IHsKIAogc3RhdGljIHZvaWQgbmJpb192N18wX2luaXRfcmVnaXN0ZXJzKHN0cnVjdCBhbWRncHVf
ZGV2aWNlICphZGV2KQogewotCWlmIChhbWRncHVfc3Jpb3ZfdmYoYWRldikpCi0JCWFkZXYtPnJt
bWlvX3JlbWFwLnJlZ19vZmZzZXQgPQotCQkJU09DMTVfUkVHX09GRlNFVChOQklPLCAwLCBtbUhE
UF9NRU1fQ09IRVJFTkNZX0ZMVVNIX0NOVEwpIDw8IDI7CiB9CiAKIGNvbnN0IHN0cnVjdCBhbWRn
cHVfbmJpb19mdW5jcyBuYmlvX3Y3XzBfZnVuY3MgPSB7CmRpZmYgLS1naXQgYS9kcml2ZXJzL2dw
dS9kcm0vYW1kL2FtZGdwdS9uYmlvX3Y3XzIuYyBiL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1
L25iaW9fdjdfMi5jCmluZGV4IDMxNzc2YjEyZTRjNC4uMTMyY2E5NDliYmFiIDEwMDY0NAotLS0g
YS9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9uYmlvX3Y3XzIuYworKysgYi9kcml2ZXJzL2dw
dS9kcm0vYW1kL2FtZGdwdS9uYmlvX3Y3XzIuYwpAQCAtNDcsMTIgKzQ3LDE4IEBACiAjZGVmaW5l
IEJJRjFfUENJRV9UWF9QT1dFUl9DVFJMXzFfX01TVF9NRU1fTFNfRU5fTUFTSwkJMHgwMDAwMDAw
MUwKICNkZWZpbmUgQklGMV9QQ0lFX1RYX1BPV0VSX0NUUkxfMV9fUkVQTEFZX01FTV9MU19FTl9N
QVNLCTB4MDAwMDAwMDhMCiAKKyNkZWZpbmUgTU1JT19SRUdfSE9MRV9PRkZTRVQgKDB4ODAwMDAg
LSBQQUdFX1NJWkUpCisKIHN0YXRpYyB2b2lkIG5iaW9fdjdfMl9yZW1hcF9oZHBfcmVnaXN0ZXJz
KHN0cnVjdCBhbWRncHVfZGV2aWNlICphZGV2KQogewotCVdSRUczMl9TT0MxNShOQklPLCAwLCBy
ZWdCSUZfQlgwX1JFTUFQX0hEUF9NRU1fRkxVU0hfQ05UTCwKLQkJYWRldi0+cm1taW9fcmVtYXAu
cmVnX29mZnNldCArIEtGRF9NTUlPX1JFTUFQX0hEUF9NRU1fRkxVU0hfQ05UTCk7Ci0JV1JFRzMy
X1NPQzE1KE5CSU8sIDAsIHJlZ0JJRl9CWDBfUkVNQVBfSERQX1JFR19GTFVTSF9DTlRMLAotCQlh
ZGV2LT5ybW1pb19yZW1hcC5yZWdfb2Zmc2V0ICsgS0ZEX01NSU9fUkVNQVBfSERQX1JFR19GTFVT
SF9DTlRMKTsKKwlpZiAoIWFtZGdwdV9zcmlvdl92ZihhZGV2KSkgeworCQlhZGV2LT5ybW1pb19y
ZW1hcC5yZWdfb2Zmc2V0ID0gTU1JT19SRUdfSE9MRV9PRkZTRVQ7CisJCWFkZXYtPnJtbWlvX3Jl
bWFwLmJ1c19hZGRyID0gYWRldi0+cm1taW9fYmFzZSArIE1NSU9fUkVHX0hPTEVfT0ZGU0VUOwor
CQlXUkVHMzJfU09DMTUoTkJJTywgMCwgcmVnQklGX0JYMF9SRU1BUF9IRFBfTUVNX0ZMVVNIX0NO
VEwsCisJCQkgICAgIGFkZXYtPnJtbWlvX3JlbWFwLnJlZ19vZmZzZXQgKyBLRkRfTU1JT19SRU1B
UF9IRFBfTUVNX0ZMVVNIX0NOVEwpOworCQlXUkVHMzJfU09DMTUoTkJJTywgMCwgcmVnQklGX0JY
MF9SRU1BUF9IRFBfUkVHX0ZMVVNIX0NOVEwsCisJCQkgICAgIGFkZXYtPnJtbWlvX3JlbWFwLnJl
Z19vZmZzZXQgKyBLRkRfTU1JT19SRU1BUF9IRFBfUkVHX0ZMVVNIX0NOVEwpOworCX0KIH0KIAog
c3RhdGljIHUzMiBuYmlvX3Y3XzJfZ2V0X3Jldl9pZChzdHJ1Y3QgYW1kZ3B1X2RldmljZSAqYWRl
dikKQEAgLTM5MywxMCArMzk5LDYgQEAgc3RhdGljIHZvaWQgbmJpb192N18yX2luaXRfcmVnaXN0
ZXJzKHN0cnVjdCBhbWRncHVfZGV2aWNlICphZGV2KQogCQkJV1JFRzMyX1BDSUVfUE9SVChTT0Mx
NV9SRUdfT0ZGU0VUKE5CSU8sIDAsIHJlZ1BDSUVfQ09ORklHX0NOVEwpLCBkYXRhKTsKIAkJYnJl
YWs7CiAJfQotCi0JaWYgKGFtZGdwdV9zcmlvdl92ZihhZGV2KSkKLQkJYWRldi0+cm1taW9fcmVt
YXAucmVnX29mZnNldCA9IFNPQzE1X1JFR19PRkZTRVQoTkJJTywgMCwKLQkJCXJlZ0JJRl9CWF9Q
RjBfSERQX01FTV9DT0hFUkVOQ1lfRkxVU0hfQ05UTCkgPDwgMjsKIH0KIAogY29uc3Qgc3RydWN0
IGFtZGdwdV9uYmlvX2Z1bmNzIG5iaW9fdjdfMl9mdW5jcyA9IHsKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvZ3B1L2RybS9hbWQvYW1kZ3B1L25iaW9fdjdfNC5jIGIvZHJpdmVycy9ncHUvZHJtL2FtZC9h
bWRncHUvbmJpb192N180LmMKaW5kZXggMTE4NDhkMWUyMzhiLi5iZDNkZWU1MzAxNTAgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L25iaW9fdjdfNC5jCisrKyBiL2RyaXZl
cnMvZ3B1L2RybS9hbWQvYW1kZ3B1L25iaW9fdjdfNC5jCkBAIC05OSwxMiArOTksMTggQEAKIHN0
YXRpYyB2b2lkIG5iaW9fdjdfNF9xdWVyeV9yYXNfZXJyb3JfY291bnQoc3RydWN0IGFtZGdwdV9k
ZXZpY2UgKmFkZXYsCiAJCQkJCXZvaWQgKnJhc19lcnJvcl9zdGF0dXMpOwogCisjZGVmaW5lIE1N
SU9fUkVHX0hPTEVfT0ZGU0VUICgweDgwMDAwIC0gUEFHRV9TSVpFKQorCiBzdGF0aWMgdm9pZCBu
YmlvX3Y3XzRfcmVtYXBfaGRwX3JlZ2lzdGVycyhzdHJ1Y3QgYW1kZ3B1X2RldmljZSAqYWRldikK
IHsKLQlXUkVHMzJfU09DMTUoTkJJTywgMCwgbW1SRU1BUF9IRFBfTUVNX0ZMVVNIX0NOVEwsCi0J
CWFkZXYtPnJtbWlvX3JlbWFwLnJlZ19vZmZzZXQgKyBLRkRfTU1JT19SRU1BUF9IRFBfTUVNX0ZM
VVNIX0NOVEwpOwotCVdSRUczMl9TT0MxNShOQklPLCAwLCBtbVJFTUFQX0hEUF9SRUdfRkxVU0hf
Q05UTCwKLQkJYWRldi0+cm1taW9fcmVtYXAucmVnX29mZnNldCArIEtGRF9NTUlPX1JFTUFQX0hE
UF9SRUdfRkxVU0hfQ05UTCk7CisJaWYgKCFhbWRncHVfc3Jpb3ZfdmYoYWRldikpIHsKKwkJYWRl
di0+cm1taW9fcmVtYXAucmVnX29mZnNldCA9IE1NSU9fUkVHX0hPTEVfT0ZGU0VUOworCQlhZGV2
LT5ybW1pb19yZW1hcC5idXNfYWRkciA9IGFkZXYtPnJtbWlvX2Jhc2UgKyBNTUlPX1JFR19IT0xF
X09GRlNFVDsKKwkJV1JFRzMyX1NPQzE1KE5CSU8sIDAsIG1tUkVNQVBfSERQX01FTV9GTFVTSF9D
TlRMLAorCQkJICAgICBhZGV2LT5ybW1pb19yZW1hcC5yZWdfb2Zmc2V0ICsgS0ZEX01NSU9fUkVN
QVBfSERQX01FTV9GTFVTSF9DTlRMKTsKKwkJV1JFRzMyX1NPQzE1KE5CSU8sIDAsIG1tUkVNQVBf
SERQX1JFR19GTFVTSF9DTlRMLAorCQkJICAgICBhZGV2LT5ybW1pb19yZW1hcC5yZWdfb2Zmc2V0
ICsgS0ZEX01NSU9fUkVNQVBfSERQX1JFR19GTFVTSF9DTlRMKTsKKwl9CiB9CiAKIHN0YXRpYyB1
MzIgbmJpb192N180X2dldF9yZXZfaWQoc3RydWN0IGFtZGdwdV9kZXZpY2UgKmFkZXYpCkBAIC0z
NDMsMTAgKzM0OSw2IEBAIHN0YXRpYyB2b2lkIG5iaW9fdjdfNF9pbml0X3JlZ2lzdGVycyhzdHJ1
Y3QgYW1kZ3B1X2RldmljZSAqYWRldikKIHsKIAl1aW50MzJfdCBiYWNvX2NudGw7CiAKLQlpZiAo
YW1kZ3B1X3NyaW92X3ZmKGFkZXYpKQotCQlhZGV2LT5ybW1pb19yZW1hcC5yZWdfb2Zmc2V0ID0g
U09DMTVfUkVHX09GRlNFVChOQklPLCAwLAotCQkJbW1CSUZfQlhfREVWMF9FUEYwX1ZGMF9IRFBf
TUVNX0NPSEVSRU5DWV9GTFVTSF9DTlRMKSA8PCAyOwotCiAJaWYgKGFkZXYtPmlwX3ZlcnNpb25z
W05CSU9fSFdJUF1bMF0gPT0gSVBfVkVSU0lPTig3LCA0LCA0KSAmJgogCSAgICAhYW1kZ3B1X3Ny
aW92X3ZmKGFkZXYpKSB7CiAJCWJhY29fY250bCA9IFJSRUczMl9TT0MxNShOQklPLCAwLCBtbUJB
Q09fQ05UTCk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9udi5jIGIv
ZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvbnYuYwppbmRleCBiM2ZiYThkZWE2M2MuLmEyMzM5
Y2JlZGQzMiAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvbnYuYworKysg
Yi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9udi5jCkBAIC02NzcsMTMgKzY3Nyw4IEBAIHN0
YXRpYyBjb25zdCBzdHJ1Y3QgYW1kZ3B1X2FzaWNfZnVuY3MgbnZfYXNpY19mdW5jcyA9CiAKIHN0
YXRpYyBpbnQgbnZfY29tbW9uX2Vhcmx5X2luaXQodm9pZCAqaGFuZGxlKQogewotI2RlZmluZSBN
TUlPX1JFR19IT0xFX09GRlNFVCAoMHg4MDAwMCAtIFBBR0VfU0laRSkKIAlzdHJ1Y3QgYW1kZ3B1
X2RldmljZSAqYWRldiA9IChzdHJ1Y3QgYW1kZ3B1X2RldmljZSAqKWhhbmRsZTsKIAotCWlmICgh
YW1kZ3B1X3NyaW92X3ZmKGFkZXYpKSB7Ci0JCWFkZXYtPnJtbWlvX3JlbWFwLnJlZ19vZmZzZXQg
PSBNTUlPX1JFR19IT0xFX09GRlNFVDsKLQkJYWRldi0+cm1taW9fcmVtYXAuYnVzX2FkZHIgPSBh
ZGV2LT5ybW1pb19iYXNlICsgTU1JT19SRUdfSE9MRV9PRkZTRVQ7Ci0JfQogCWFkZXYtPnNtY19y
cmVnID0gTlVMTDsKIAlhZGV2LT5zbWNfd3JlZyA9IE5VTEw7CiAJYWRldi0+cGNpZV9ycmVnID0g
Jm52X3BjaWVfcnJlZzsKQEAgLTEwMzYsNyArMTAzMSw3IEBAIHN0YXRpYyBpbnQgbnZfY29tbW9u
X2h3X2luaXQodm9pZCAqaGFuZGxlKQogCSAqIGZvciB0aGUgcHVycG9zZSBvZiBleHBvc2UgdGhv
c2UgcmVnaXN0ZXJzCiAJICogdG8gcHJvY2VzcyBzcGFjZQogCSAqLwotCWlmIChhZGV2LT5uYmlv
LmZ1bmNzLT5yZW1hcF9oZHBfcmVnaXN0ZXJzICYmICFhbWRncHVfc3Jpb3ZfdmYoYWRldikpCisJ
aWYgKGFkZXYtPm5iaW8uZnVuY3MtPnJlbWFwX2hkcF9yZWdpc3RlcnMpCiAJCWFkZXYtPm5iaW8u
ZnVuY3MtPnJlbWFwX2hkcF9yZWdpc3RlcnMoYWRldik7CiAJLyogZW5hYmxlIHRoZSBkb29yYmVs
bCBhcGVydHVyZSAqLwogCW52X2VuYWJsZV9kb29yYmVsbF9hcGVydHVyZShhZGV2LCB0cnVlKTsK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L3NvYzE1LmMgYi9kcml2ZXJz
L2dwdS9kcm0vYW1kL2FtZGdwdS9zb2MxNS5jCmluZGV4IGZkZTYxNTRmMjAwOS4uODk5MjZhMDE0
MTc0IDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9zb2MxNS5jCisrKyBi
L2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L3NvYzE1LmMKQEAgLTkyNiwxMyArOTI2LDggQEAg
c3RhdGljIGNvbnN0IHN0cnVjdCBhbWRncHVfYXNpY19mdW5jcyB2ZWdhMjBfYXNpY19mdW5jcyA9
CiAKIHN0YXRpYyBpbnQgc29jMTVfY29tbW9uX2Vhcmx5X2luaXQodm9pZCAqaGFuZGxlKQogewot
I2RlZmluZSBNTUlPX1JFR19IT0xFX09GRlNFVCAoMHg4MDAwMCAtIFBBR0VfU0laRSkKIAlzdHJ1
Y3QgYW1kZ3B1X2RldmljZSAqYWRldiA9IChzdHJ1Y3QgYW1kZ3B1X2RldmljZSAqKWhhbmRsZTsK
IAotCWlmICghYW1kZ3B1X3NyaW92X3ZmKGFkZXYpKSB7Ci0JCWFkZXYtPnJtbWlvX3JlbWFwLnJl
Z19vZmZzZXQgPSBNTUlPX1JFR19IT0xFX09GRlNFVDsKLQkJYWRldi0+cm1taW9fcmVtYXAuYnVz
X2FkZHIgPSBhZGV2LT5ybW1pb19iYXNlICsgTU1JT19SRUdfSE9MRV9PRkZTRVQ7Ci0JfQogCWFk
ZXYtPnNtY19ycmVnID0gTlVMTDsKIAlhZGV2LT5zbWNfd3JlZyA9IE5VTEw7CiAJYWRldi0+cGNp
ZV9ycmVnID0gJnNvYzE1X3BjaWVfcnJlZzsKQEAgLTEyNDQsNyArMTIzOSw3IEBAIHN0YXRpYyBp
bnQgc29jMTVfY29tbW9uX2h3X2luaXQodm9pZCAqaGFuZGxlKQogCSAqIGZvciB0aGUgcHVycG9z
ZSBvZiBleHBvc2UgdGhvc2UgcmVnaXN0ZXJzCiAJICogdG8gcHJvY2VzcyBzcGFjZQogCSAqLwot
CWlmIChhZGV2LT5uYmlvLmZ1bmNzLT5yZW1hcF9oZHBfcmVnaXN0ZXJzICYmICFhbWRncHVfc3Jp
b3ZfdmYoYWRldikpCisJaWYgKGFkZXYtPm5iaW8uZnVuY3MtPnJlbWFwX2hkcF9yZWdpc3RlcnMp
CiAJCWFkZXYtPm5iaW8uZnVuY3MtPnJlbWFwX2hkcF9yZWdpc3RlcnMoYWRldik7CiAKIAkvKiBl
bmFibGUgdGhlIGRvb3JiZWxsIGFwZXJ0dXJlICovCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9k
cm0vYW1kL2FtZGdwdS9zb2MyMS5jIGIvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvc29jMjEu
YwppbmRleCA1NTI4NGIyNGYxMTMuLjRkM2RkY2ZkMDc2OSAxMDA2NDQKLS0tIGEvZHJpdmVycy9n
cHUvZHJtL2FtZC9hbWRncHUvc29jMjEuYworKysgYi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdw
dS9zb2MyMS5jCkBAIC01MzIsMTEgKzUzMiw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgYW1kZ3B1
X2FzaWNfZnVuY3Mgc29jMjFfYXNpY19mdW5jcyA9CiAKIHN0YXRpYyBpbnQgc29jMjFfY29tbW9u
X2Vhcmx5X2luaXQodm9pZCAqaGFuZGxlKQogewotI2RlZmluZSBNTUlPX1JFR19IT0xFX09GRlNF
VCAoMHg4MDAwMCAtIFBBR0VfU0laRSkKIAlzdHJ1Y3QgYW1kZ3B1X2RldmljZSAqYWRldiA9IChz
dHJ1Y3QgYW1kZ3B1X2RldmljZSAqKWhhbmRsZTsKIAotCWFkZXYtPnJtbWlvX3JlbWFwLnJlZ19v
ZmZzZXQgPSBNTUlPX1JFR19IT0xFX09GRlNFVDsKLQlhZGV2LT5ybW1pb19yZW1hcC5idXNfYWRk
ciA9IGFkZXYtPnJtbWlvX2Jhc2UgKyBNTUlPX1JFR19IT0xFX09GRlNFVDsKIAlhZGV2LT5zbWNf
cnJlZyA9IE5VTEw7CiAJYWRldi0+c21jX3dyZWcgPSBOVUxMOwogCWFkZXYtPnBjaWVfcnJlZyA9
ICZzb2MyMV9wY2llX3JyZWc7Ci0tIAoyLjM3LjEKCg==
--0000000000005d067105e76410d9--

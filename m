Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C31D446588
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 16:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbhKEPRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 11:17:48 -0400
Received: from mail-ot1-f48.google.com ([209.85.210.48]:35713 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233355AbhKEPRr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 11:17:47 -0400
Received: by mail-ot1-f48.google.com with SMTP id p11-20020a9d4e0b000000b0055a5741bff7so13514645otf.2;
        Fri, 05 Nov 2021 08:15:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wq3urfHFTmgpur6CZP1GgUU206NT9HzsQZj8tzO+YYg=;
        b=q0BtzLIJfnRUc5k/T8qpzn0bhjXZu6kJFKc7PFpyJie3be9mZb9WN4M0kOmWwfewDP
         3MOF6pVIbcs7VYidNYAiW+W/hpnbyUZqMFp90Axugks0XtnwVOxINEDA4oihnz93hShb
         XEusU5L2FybsFBlFRzNOS4F98cq43lq2ETV8V+uFq1pSWjecE7ee+eBZcwaF7wgyTz0W
         6mTFNPhR6cf2kh2rlghbUdGQwQaqGLWZFEz5xR92IjSQW5O7een9FhcN0V6CKr/fDX8I
         uWzuni7k2pgX5m2SEcUG/zX7nwASS9C0CYhVmfPCfA1s/svi0wkOJnJhQr1XvztjPYng
         +Gaw==
X-Gm-Message-State: AOAM531rDkEgY8rO7aLIKswHboTUPj4T9PWXfKC+aQ0ot6pVzzC/+J8j
        JkOirXKzQkCPTykNp+eA8HR61gQ1uafc+g/2SBo=
X-Google-Smtp-Source: ABdhPJxyc2pR9l7x3/X8gyPFkpj+2SbxSiikNlBi1FTyhgvOqSrZ1hsgGjFNRAvNyYeEfykwcD8KvlkVojdEzM3LkhY=
X-Received: by 2002:a05:6830:3484:: with SMTP id c4mr28490596otu.254.1636125307487;
 Fri, 05 Nov 2021 08:15:07 -0700 (PDT)
MIME-Version: 1.0
References: <1636070227-15909-1-git-send-email-quic_subbaram@quicinc.com>
In-Reply-To: <1636070227-15909-1-git-send-email-quic_subbaram@quicinc.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 5 Nov 2021 16:14:56 +0100
Message-ID: <CAJZ5v0gONybD_pVCAq6ZJTMuStXtoF064u9qPYxco4y=b-JD9A@mail.gmail.com>
Subject: Re: [RESEND PATCH v2] thermal: Fix a NULL pointer dereference
To:     Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Collins <quic_collinsd@quicinc.com>,
        Manaf Meethalavalappu Pallikunhi <quic_manafm@quicinc.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 5, 2021 at 12:57 AM Subbaraman Narayanamurthy
<quic_subbaram@quicinc.com> wrote:
>
> of_parse_thermal_zones() parses the thermal-zones node and registers a
> thermal_zone device for each subnode. However, if a thermal zone is
> consuming a thermal sensor and that thermal sensor device hasn't probed
> yet, an attempt to set trip_point_*_temp for that thermal zone device
> can cause a NULL pointer dereference. Fix it.
>
>  console:/sys/class/thermal/thermal_zone87 # echo 120000 > trip_point_0_temp
>  ...
>  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
>  ...
>  Call trace:
>   of_thermal_set_trip_temp+0x40/0xc4
>   trip_point_temp_store+0xc0/0x1dc
>   dev_attr_store+0x38/0x88
>   sysfs_kf_write+0x64/0xc0
>   kernfs_fop_write_iter+0x108/0x1d0
>   vfs_write+0x2f4/0x368
>   ksys_write+0x7c/0xec
>   __arm64_sys_write+0x20/0x30
>   el0_svc_common.llvm.7279915941325364641+0xbc/0x1bc
>   do_el0_svc+0x28/0xa0
>   el0_svc+0x14/0x24
>   el0_sync_handler+0x88/0xec
>   el0_sync+0x1c0/0x200
>
> While at it, fix the possible NULL pointer dereference in other
> functions as well: of_thermal_get_temp(), of_thermal_set_emul_temp(),
> of_thermal_get_trend().

Can the subject be more specific, please?

The issue appears to be limited to the of_thermal_ family of
functions, but the subject doesn't reflect that at all.

> Suggested-by: David Collins <quic_collinsd@quicinc.com>
> Signed-off-by: Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>

Daniel, any concerns regarding the code changes below?

> ---
>  drivers/thermal/thermal_of.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
> index 6379f26..9233f7e 100644
> --- a/drivers/thermal/thermal_of.c
> +++ b/drivers/thermal/thermal_of.c
> @@ -89,7 +89,7 @@ static int of_thermal_get_temp(struct thermal_zone_device *tz,
>  {
>         struct __thermal_zone *data = tz->devdata;
>
> -       if (!data->ops->get_temp)
> +       if (!data->ops || !data->ops->get_temp)
>                 return -EINVAL;
>
>         return data->ops->get_temp(data->sensor_data, temp);
> @@ -186,6 +186,9 @@ static int of_thermal_set_emul_temp(struct thermal_zone_device *tz,
>  {
>         struct __thermal_zone *data = tz->devdata;
>
> +       if (!data->ops || !data->ops->set_emul_temp)
> +               return -EINVAL;
> +
>         return data->ops->set_emul_temp(data->sensor_data, temp);
>  }
>
> @@ -194,7 +197,7 @@ static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
>  {
>         struct __thermal_zone *data = tz->devdata;
>
> -       if (!data->ops->get_trend)
> +       if (!data->ops || !data->ops->get_trend)
>                 return -EINVAL;
>
>         return data->ops->get_trend(data->sensor_data, trip, trend);
> @@ -301,7 +304,7 @@ static int of_thermal_set_trip_temp(struct thermal_zone_device *tz, int trip,
>         if (trip >= data->ntrips || trip < 0)
>                 return -EDOM;
>
> -       if (data->ops->set_trip_temp) {
> +       if (data->ops && data->ops->set_trip_temp) {
>                 int ret;
>
>                 ret = data->ops->set_trip_temp(data->sensor_data, trip, temp);
> --
> 2.7.4
>

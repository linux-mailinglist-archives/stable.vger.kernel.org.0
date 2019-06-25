Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2820A5573D
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 20:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732845AbfFYSbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 14:31:37 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40631 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732725AbfFYSbg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 14:31:36 -0400
Received: by mail-wr1-f68.google.com with SMTP id p11so18995715wre.7;
        Tue, 25 Jun 2019 11:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1k6hfZcpJIBaCfeqIL60ce8xDXxgWj93nj94jCgJSTo=;
        b=chHO/3WEzBX/decN9UB4l37wLw6z5xTvYZGNBOMe9Z9yTmakHWVHUmyabomJX3nL3M
         aI0J4BoysTsG5hi4JvoahKxA2psG7dUGssEpIwqoMDTXSu33VB+SsdOwP8bIsbwMITxw
         BNdePvVU+tt/I+KD7Yw6Sl5gxP0uUOqqpOhCN9Bv7TmOsmF5Y5NYHbaIjQWQr+pkcFan
         q4M7Q944QOpB1VSz3+lAcX4ChtZnVir5tKpfS4/+OZmKseIgFI38HSYEbQOxuOWCXc6B
         kqJeDXQ8tgUXNqzoQaSEphFa3cwiESCPqJxQrhHt4i2hnb2hj7RVVoAwPlnZ2ntTEoI0
         FLpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1k6hfZcpJIBaCfeqIL60ce8xDXxgWj93nj94jCgJSTo=;
        b=ig9NnTKjsH2frv+fNXNoU4kFvz2BTUQqd3TA/IbyU8vK+u4xUY+DZN1DIsmcMuOuWu
         jfF95XrFujhftFFTncIKLL4poBdybId0aXrAtN86gDu8B7VtEvQjLlmxBBlC4IAdZRc7
         TJ2GeueUPr4OoozkhwK9L6hR+e2zm2Nx+JUMGijDg3mWcnNjXGIbdpW7Gqoe/ddQDdVT
         cZ+niR+TvYEeIJLojzobq7Jlq//1E88+qC238kmzmjesR7K+IoTTJOoxZr2Ppoh9j8Rr
         HuxGuyK+RadajOegyvTAK2AlvmcFBNrrm/cuLjnqIXIraDaawD8/3E52R9fC3sfVk8Bq
         ctQg==
X-Gm-Message-State: APjAAAXBjK1juK/SY968EkBpZIsX3up82xp0q0IygEhMX8KfIv4+FFsS
        YJZd7ZgmMejiOTXvxrhrpuxYUxDYYlwPSnO7y/g=
X-Google-Smtp-Source: APXvYqwfe6KcLiCe8FzulhaOqL1BbjYOGqtafi2ofby/R8/XEKqS+DPyFOG5DnAaeHtviD5jOo78NRS7rIJt7YWYQ08=
X-Received: by 2002:a5d:4752:: with SMTP id o18mr13462492wrs.74.1561487494677;
 Tue, 25 Jun 2019 11:31:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190620232127.25436-1-lyude@redhat.com>
In-Reply-To: <20190620232127.25436-1-lyude@redhat.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Tue, 25 Jun 2019 14:31:22 -0400
Message-ID: <CADnq5_OsM9H3mT8cnobWGOfQH7qEfq8thYtqsFHmnb06v8sTDA@mail.gmail.com>
Subject: Re: [PATCH] drm/amdgpu: Don't skip display settings in hwmgr_resume()
To:     Lyude Paul <lyude@redhat.com>
Cc:     amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "David (ChunMing) Zhou" <David1.Zhou@amd.com>,
        David Airlie <airlied@linux.ie>,
        LKML <linux-kernel@vger.kernel.org>,
        "for 3.8" <stable@vger.kernel.org>, Huang Rui <ray.huang@amd.com>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>, Daniel Vetter <daniel@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        Likun Gao <Likun.Gao@amd.com>, Evan Quan <evan.quan@amd.com>,
        Rex Zhu <rex.zhu@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 20, 2019 at 7:22 PM Lyude Paul <lyude@redhat.com> wrote:
>
> I'm not entirely sure why this is, but for some reason:
>
> 921935dc6404 ("drm/amd/powerplay: enforce display related settings only on needed")
>
> Breaks runtime PM resume on the Radeon PRO WX 3100 (Lexa) in one the
> pre-production laptops I have. The issue manifests as the following
> messages in dmesg:
>
> [drm] UVD and UVD ENC initialized successfully.
> amdgpu 0000:3b:00.0: [drm:amdgpu_ring_test_helper [amdgpu]] *ERROR* ring vce1 test failed (-110)
> [drm:amdgpu_device_ip_resume_phase2 [amdgpu]] *ERROR* resume of IP block <vce_v3_0> failed -110
> [drm:amdgpu_device_resume [amdgpu]] *ERROR* amdgpu_device_ip_resume failed (-110).
>
> And happens after about 6-10 runtime PM suspend/resume cycles (sometimes
> sooner, if you're lucky!). Unfortunately I can't seem to pin down
> precisely which part in psm_adjust_power_state_dynamic that is causing
> the issue, but not skipping the display setting setup seems to fix it.
> Hopefully if there is a better fix for this, this patch will spark
> discussion around it.
>

Evan, any ideas on this?  Otherwise, let's just apply it.

Alex


> Fixes: 921935dc6404 ("drm/amd/powerplay: enforce display related settings only on needed")
> Cc: Evan Quan <evan.quan@amd.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Huang Rui <ray.huang@amd.com>
> Cc: Rex Zhu <Rex.Zhu@amd.com>
> Cc: Likun Gao <Likun.Gao@amd.com>
> Cc: <stable@vger.kernel.org> # v5.1+
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> ---
>  drivers/gpu/drm/amd/powerplay/hwmgr/hwmgr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/hwmgr.c b/drivers/gpu/drm/amd/powerplay/hwmgr/hwmgr.c
> index 6cd6497c6fc2..0e1b2d930816 100644
> --- a/drivers/gpu/drm/amd/powerplay/hwmgr/hwmgr.c
> +++ b/drivers/gpu/drm/amd/powerplay/hwmgr/hwmgr.c
> @@ -325,7 +325,7 @@ int hwmgr_resume(struct pp_hwmgr *hwmgr)
>         if (ret)
>                 return ret;
>
> -       ret = psm_adjust_power_state_dynamic(hwmgr, true, NULL);
> +       ret = psm_adjust_power_state_dynamic(hwmgr, false, NULL);
>
>         return ret;
>  }
> --
> 2.21.0
>
> _______________________________________________
> amd-gfx mailing list
> amd-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/amd-gfx

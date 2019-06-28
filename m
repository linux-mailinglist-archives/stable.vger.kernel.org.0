Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B0059D7A
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 16:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfF1OHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 10:07:25 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37819 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfF1OHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 10:07:25 -0400
Received: by mail-wr1-f67.google.com with SMTP id v14so6453398wrr.4;
        Fri, 28 Jun 2019 07:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/6jW6fB4qBM1ltEdu2ACDjRjsBmJdRc1AykbkyWaR7c=;
        b=an187nEon/JK/g5ZzKOxXQnPuUnO9U6A/T2nqKVyK2NO4SElnkHUJeZ5gSBOl78AUA
         JFWlQUG15flw/TVfg328lGdoWQFefyK8n77DGksSOK6CxZGQLLsUkICYJwpCXBYIbH3e
         ll9F3vXxoLCyl87K4WzFMCCnULY5+vLnCMgwdw+7iBin0JOSH7NovQ1kQ4Q5Xj2owEhG
         kT9NdI2p1PKRsL8IiBaO97kVpNZ42vwRKgg0ytHUo0ZS5jnZC6iGt6AXJ3LJ6pwsxMLt
         nTNQleZcYjh8Ue5Lieb4iW9Men3bcAOu7qTNKsTSMhS4WkrEg3beAdykiU86wPcYhqlO
         sz3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/6jW6fB4qBM1ltEdu2ACDjRjsBmJdRc1AykbkyWaR7c=;
        b=tUkLlvt1EyEA93yOLYQ7m+p3Cuuat25XvhgP+RSpeg7KcGNrgfdrxeBEnWWZp7YMxT
         S9078xkSaBkGM4tZN7CUWVHYxWlz3oFZ7l3dkwu2ypEy/w3t6EM8IGsqmUhNP+AbeYGB
         5SDtSatjpNXbqPt8M43Li57B56jJ8hJwfrZ9EJdTg1ZBZp9wVrYm2pXGsugahfSxxLiz
         b5XM3CdCU/PaAJdpLGc3jAgr0mNaZ2K2eHc71UhSDG+pDaEhaVMqP8Fh9hQfhIXl6Cc/
         P6b2at+fnsfIPzi8jj+mMGm4it/FnGK7AjORg6DOMN/rKI1X92RALpM5cp0K4VVuydJm
         ovZQ==
X-Gm-Message-State: APjAAAU+2qPkxRTkgtSkrebKaS659kgXGmEKbPI1z1dsvgWh/EEZeplA
        xzmOFj5lqGqyrvMbzmuiTrCsvH6gH6nYAuO0o9mUnuj6
X-Google-Smtp-Source: APXvYqy5v+daBdSZiNMJysCVnYu4Yb3AFNKs9v26dcnm3gDIIeAbNl8J/Ofwl1JUddZkKKQjAVFjv8bzrn7FfNzgwgc=
X-Received: by 2002:adf:dec3:: with SMTP id i3mr8017515wrn.74.1561730843076;
 Fri, 28 Jun 2019 07:07:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190620232127.25436-1-lyude@redhat.com>
In-Reply-To: <20190620232127.25436-1-lyude@redhat.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Fri, 28 Jun 2019 10:07:11 -0400
Message-ID: <CADnq5_ODsuKDRFyi5v5nOLmXCFnguaVYLXAn-Z2=bX6sK8DLsQ@mail.gmail.com>
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
> Fixes: 921935dc6404 ("drm/amd/powerplay: enforce display related settings only on needed")
> Cc: Evan Quan <evan.quan@amd.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Huang Rui <ray.huang@amd.com>
> Cc: Rex Zhu <Rex.Zhu@amd.com>
> Cc: Likun Gao <Likun.Gao@amd.com>
> Cc: <stable@vger.kernel.org> # v5.1+
> Signed-off-by: Lyude Paul <lyude@redhat.com>

I've gone ahead and applied this.

Thanks,

Alex

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

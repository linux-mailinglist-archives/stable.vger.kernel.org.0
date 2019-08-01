Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF937E6A5
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 01:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbfHAXqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 19:46:05 -0400
Received: from mail-vk1-f193.google.com ([209.85.221.193]:43957 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390411AbfHAXqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 19:46:04 -0400
Received: by mail-vk1-f193.google.com with SMTP id b200so14985502vkf.10;
        Thu, 01 Aug 2019 16:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PhuFM2pdRnW2kX108enkfIuXqe+2wuG+ARNOH5L+Sds=;
        b=va1tKdssM+gKOUvvNunrZBekJn5ccALnpSDxSI76pAmLOUxB0xAuqPlAx8pHMrFYRn
         AEXjxmVNbmQc86qbUbqlRbQAvSU2lupPHjr/iMKzTyU5QuE+zV5BV1zGRE5mXtWtXa9I
         AK84q1HiHlBCExd9gbz/p/lhTOH5qLzbMG4s6JUjR/8xndXPuxdZ0Z9XNDaxO8e6tYfF
         wYxF5ToKRSCB51NZjKea552bepCsYNBj8WlYGWuLzC3FeUjRogM5h5yz35xfnuGn8kzY
         7kRLDObIkjHmVOykGk1qg8d7BHDHdflHFdRCydlJxiYIl9dyuvFs7/+rtRUjZ+P2sh5x
         aMWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PhuFM2pdRnW2kX108enkfIuXqe+2wuG+ARNOH5L+Sds=;
        b=rAlYUpGu00tMr2u+qt7X7B7T8wTCw7fvOhZVZ8uwZr/t62W9STBABpzf8A3XqEESOo
         UTCDGCA02ZLsxoFXh8kGUdgiAkBwGwYGgiGBXz4QMyJBEr9Z70k1X0T73ArDjWa5Thxz
         ZeUZtqIYWTVDrztO39CczYsQ++3g0yazblNaLYeb3gDjg2jtm401DKZUpbDAjUw+O+mb
         5Aru1jxfnOOLm5YnA1ZQAIt/LLQCFz4xE1ZGumQspBFNmKsiqKwDNP2e4oRH8p1ctwft
         lsPuI0ggxzGHubDrWchjpbdKBhWjgFaOp3jVK9mH5MMSdwnK7ndpW7FN61UR6Hp8S0qe
         Juwg==
X-Gm-Message-State: APjAAAWAGId0+d5WN8cVE2EWLtF0A6Y5eXJuczUAWqbcaorJOt1y9BcU
        kCzwbjab43UrRShE1Pn1/4FWvYBhGUPuygAJ9bc=
X-Google-Smtp-Source: APXvYqz7HVl1IX60b6WZ5btm0hhToTNvYT8T77SPWWR/N2VB8mJecpIuoTni0zoAIqdXtxl+FsDlqejJHrdMLaN9vcg=
X-Received: by 2002:a1f:4107:: with SMTP id o7mr52276511vka.34.1564703163073;
 Thu, 01 Aug 2019 16:46:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190801220216.15323-1-lyude@redhat.com>
In-Reply-To: <20190801220216.15323-1-lyude@redhat.com>
From:   Ben Skeggs <skeggsb@gmail.com>
Date:   Fri, 2 Aug 2019 09:45:52 +1000
Message-ID: <CACAvsv7sBPrC-6yxqKCT=H8FhVYvUSoN2GEqWrcfkAtXZmXprw@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH] drm/nouveau: Only release VCPI slots on mode changes
To:     Lyude Paul <lyude@redhat.com>
Cc:     ML nouveau <nouveau@lists.freedesktop.org>,
        David Airlie <airlied@linux.ie>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jerry Zuo <Jerry.Zuo@amd.com>, Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@redhat.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Juston Li <juston.li@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2 Aug 2019 at 08:02, Lyude Paul <lyude@redhat.com> wrote:
>
> Looks like a regression got introduced into nv50_mstc_atomic_check()
> that somehow didn't get found until now. If userspace changes
> crtc_state->active to false but leaves the CRTC enabled, we end up
> calling drm_dp_atomic_find_vcpi_slots() using the PBN calculated in
> asyh->dp.pbn. However, if the display is inactive we end up calculating
> a PBN of 0, which inadvertently causes us to have an allocation of 0.
> From there, if userspace then disables the CRTC afterwards we end up
> accidentally attempting to free the VCPI twice:
>
> WARNING: CPU: 0 PID: 1484 at drivers/gpu/drm/drm_dp_mst_topology.c:3336
> drm_dp_atomic_release_vcpi_slots+0x87/0xb0 [drm_kms_helper]
> RIP: 0010:drm_dp_atomic_release_vcpi_slots+0x87/0xb0 [drm_kms_helper]
> Call Trace:
>  drm_atomic_helper_check_modeset+0x3f3/0xa60 [drm_kms_helper]
>  ? drm_atomic_check_only+0x43/0x780 [drm]
>  drm_atomic_helper_check+0x15/0x90 [drm_kms_helper]
>  nv50_disp_atomic_check+0x83/0x1d0 [nouveau]
>  drm_atomic_check_only+0x54d/0x780 [drm]
>  ? drm_atomic_set_crtc_for_connector+0xec/0x100 [drm]
>  drm_atomic_commit+0x13/0x50 [drm]
>  drm_atomic_helper_set_config+0x81/0x90 [drm_kms_helper]
>  drm_mode_setcrtc+0x194/0x6a0 [drm]
>  ? vprintk_emit+0x16a/0x230
>  ? drm_ioctl+0x163/0x390 [drm]
>  ? drm_mode_getcrtc+0x180/0x180 [drm]
>  drm_ioctl_kernel+0xaa/0xf0 [drm]
>  drm_ioctl+0x208/0x390 [drm]
>  ? drm_mode_getcrtc+0x180/0x180 [drm]
>  nouveau_drm_ioctl+0x63/0xb0 [nouveau]
>  do_vfs_ioctl+0x405/0x660
>  ? recalc_sigpending+0x17/0x50
>  ? _copy_from_user+0x37/0x60
>  ksys_ioctl+0x5e/0x90
>  ? exit_to_usermode_loop+0x92/0xe0
>  __x64_sys_ioctl+0x16/0x20
>  do_syscall_64+0x59/0x190
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> WARNING: CPU: 0 PID: 1484 at drivers/gpu/drm/drm_dp_mst_topology.c:3336
> drm_dp_atomic_release_vcpi_slots+0x87/0xb0 [drm_kms_helper]
> ---[ end trace 4c395c0c51b1f88d ]---
> [drm:drm_dp_atomic_release_vcpi_slots [drm_kms_helper]] *ERROR* no VCPI for
> [MST PORT:00000000e288eb7d] found in mst state 000000008e642070
>
> So, fix this by doing what we probably should have done from the start: only
> call drm_dp_atomic_find_vcpi_slots() when crtc_state->mode_changed is set, so
> that VCPI allocations remain for as long as the CRTC is enabled.
>
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Fixes: 232c9eec417a ("drm/nouveau: Use atomic VCPI helpers for MST")
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Ben Skeggs <bskeggs@redhat.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: David Airlie <airlied@redhat.com>
> Cc: Jerry Zuo <Jerry.Zuo@amd.com>
> Cc: Harry Wentland <harry.wentland@amd.com>
> Cc: Juston Li <juston.li@intel.com>
> Cc: Karol Herbst <karolherbst@gmail.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Ilia Mirkin <imirkin@alum.mit.edu>
> Cc: <stable@vger.kernel.org> # v5.1+
Acked-by: Ben Skeggs <bskeggs@redhat.com>

> ---
>  drivers/gpu/drm/nouveau/dispnv50/disp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> index 8497768f1b41..126703816794 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> @@ -780,7 +780,7 @@ nv50_msto_atomic_check(struct drm_encoder *encoder,
>                         drm_dp_calc_pbn_mode(crtc_state->adjusted_mode.clock,
>                                              connector->display_info.bpc * 3);
>
> -       if (drm_atomic_crtc_needs_modeset(crtc_state)) {
> +       if (crtc_state->mode_changed) {
>                 slots = drm_dp_atomic_find_vcpi_slots(state, &mstm->mgr,
>                                                       mstc->port,
>                                                       asyh->dp.pbn);
> --
> 2.21.0
>
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/nouveau

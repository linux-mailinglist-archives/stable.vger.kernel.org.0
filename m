Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEAEB1B0FC9
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 17:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbgDTPSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 11:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbgDTPSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 11:18:52 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA477C061A0F
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 08:18:51 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id y185so6223169vsy.8
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 08:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YfyacNg0ARyLn1S38i+mX6SSSP9vEqDETb8XNh3Njww=;
        b=urM9KDTMPDanXCVIXrrKnhmVNMn+XEmT9gx3/l03Dgt1l5YgpmN9i2LI4+FNdg3hd0
         3RnD0vysOEjt7Pnidurj82ChZh7ysaNXK2oNNwdEKedwWlkXYkIuVOS1o5iseCl/wAcK
         BJ8ASu8crvxyiko1sd9XzgZNO6AE1lsgQlDBPrutSpPIxVLpkFAGHxWvwjL8AafAb30K
         YDAtjgUMouXY/lVh18IJBFbr2lgfGfGMMra0PyAdfqSYsZFott/Ir0ge5pIivpscqFW7
         0OAVFi54M1S9wpeuY8wPhAv9bi59tKNmD3dM6mhk/+ciR6gbyMQtC4TzCctXJUM1D6W5
         i7zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YfyacNg0ARyLn1S38i+mX6SSSP9vEqDETb8XNh3Njww=;
        b=QUWSnhN7+voispa+rUsFnmJBCp7+zKVc5B/2EI6gPXJY7brSj+krqUg0qIfCTC8Yx/
         xl3wJMhWjq/rkxilQlqMsj7o9PbbnNiaWJK6nvfWtv7koHDpxUCb8WfAWAyGXs2unHVC
         8XX1POVx8KeXG3+eVlGKQjMdn+43nJrrOyETBv/ChIK1DogDS5cMgjqLz38YRdF+nSN+
         1EOQ/lyXK3KcxkcQM9WHbhklQLFqXifIOSOG3uuZZhHFAJeoJbyicVpvzI0hueF89cKl
         x6y0fQC8KfyOq2H5qMdKt9s9WqY8acZ3vkQGgxoa12jg9BkF5exAaVscrkLLJA687W4A
         GeRg==
X-Gm-Message-State: AGi0PuZnUOEBdjRuPwPqELZvDhpiWN3fo8L93W0CtmZatNl4SMzPENoe
        J0sXBcFg7sEnQI3TXVml90qQaNfRms71UqeA05I=
X-Google-Smtp-Source: APiQypJgqKabYfxPiW6Z91w0cd9hQSJZ92sx0VgBs/RWUDW7eMBV3WTtguCXZp3IJUDQk0iR2pYhyRh0Ho1H7dj27vU=
X-Received: by 2002:a67:11c4:: with SMTP id 187mr11485879vsr.34.1587395931148;
 Mon, 20 Apr 2020 08:18:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200420125356.26614-1-chris@chris-wilson.co.uk>
In-Reply-To: <20200420125356.26614-1-chris@chris-wilson.co.uk>
From:   Matthew Auld <matthew.william.auld@gmail.com>
Date:   Mon, 20 Apr 2020 16:18:25 +0100
Message-ID: <CAM0jSHP+jsu1txyd=DH-OKitmA1DZ0z9Fq+EKhzYZ0cEKmQv4A@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 1/2] drm/i915/gem: Remove object_is_locked
 assertion from unpin_from_display_plane
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Matthew Auld <matthew.auld@intel.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Apr 2020 at 13:54, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> Since moving the obj->vma.list to a spin_lock, and the vm->bound_list to
> its vm->mutex, along with tracking shrinkable status under its own
> spinlock, we no long require the object to be locked by the caller.
>
> This is fortunate as it appears we can be called with the lock along an
> error path in flipping:
>
> <4> [139.942851] WARN_ON(debug_locks && !lock_is_held(&(&((obj)->base.resv)->lock.base)->dep_map))
> <4> [139.943242] WARNING: CPU: 0 PID: 1203 at drivers/gpu/drm/i915/gem/i915_gem_domain.c:405 i915_gem_object_unpin_from_display_plane+0x70/0x130 [i915]
> <4> [139.943263] Modules linked in: snd_hda_intel i915 vgem snd_hda_codec_realtek snd_hda_codec_generic coretemp snd_intel_dspcfg snd_hda_codec snd_hwdep snd_hda_core r8169 lpc_ich snd_pcm realtek prime_numbers [last unloaded: i915]
> <4> [139.943347] CPU: 0 PID: 1203 Comm: kms_flip Tainted: G     U            5.6.0-gd0fda5c2cf3f1-drmtip_474+ #1
> <4> [139.943363] Hardware name:  /D510MO, BIOS MOPNV10J.86A.0311.2010.0802.2346 08/02/2010
> <4> [139.943589] RIP: 0010:i915_gem_object_unpin_from_display_plane+0x70/0x130 [i915]
> <4> [139.943589] Code: 85 28 01 00 00 be ff ff ff ff 48 8d 78 60 e8 d7 9b f0 e2 85 c0 75 b9 48 c7 c6 50 b9 38 c0 48 c7 c7 e9 48 3c c0 e8 20 d4 e9 e2 <0f> 0b eb a2 48 c7 c1 08 bb 38 c0 ba 0a 01 00 00 48 c7 c6 88 a3 35
> <4> [139.943589] RSP: 0018:ffffb774c0603b48 EFLAGS: 00010282
> <4> [139.943589] RAX: 0000000000000000 RBX: ffff9a142fa36e80 RCX: 0000000000000006
> <4> [139.943589] RDX: 000000000000160d RSI: ffff9a142c1a88f8 RDI: ffffffffa434a64d
> <4> [139.943589] RBP: ffff9a1410a513c0 R08: ffff9a142c1a88f8 R09: 0000000000000000
> <4> [139.943589] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9a1436ee94b8
> <4> [139.943589] R13: 0000000000000001 R14: 00000000ffffffff R15: ffff9a1410960000
> <4> [139.943589] FS:  00007fc73a744e40(0000) GS:ffff9a143da00000(0000) knlGS:0000000000000000
> <4> [139.943589] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> <4> [139.943589] CR2: 00007fc73997e098 CR3: 000000002f5fe000 CR4: 00000000000006f0
> <4> [139.943589] Call Trace:
> <4> [139.943589]  intel_pin_and_fence_fb_obj+0x1c9/0x1f0 [i915]
> <4> [139.943589]  intel_plane_pin_fb+0x3f/0xd0 [i915]
> <4> [139.943589]  intel_prepare_plane_fb+0x13b/0x5c0 [i915]
> <4> [139.943589]  drm_atomic_helper_prepare_planes+0x85/0x110
> <4> [139.943589]  intel_atomic_commit+0xda/0x390 [i915]
> <4> [139.943589]  drm_atomic_helper_page_flip+0x9c/0xd0
> <4> [139.943589]  ? drm_event_reserve_init+0x46/0x60
> <4> [139.943589]  drm_mode_page_flip_ioctl+0x587/0x5d0
>
> This completes the symmetry lost in commit 8b1c78e06e61 ("drm/i915: Avoid
> calling i915_gem_object_unbind holding object lock").
>
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1743
> Fixes: 8b1c78e06e61 ("drm/i915: Avoid calling i915_gem_object_unbind holding object lock")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Matthew Auld <matthew.auld@intel.com>
> Cc: Andi Shyti <andi.shyti@intel.com>
> Cc: <stable@vger.kernel.org> # v5.6+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>

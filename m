Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A91A6E4F4F
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 19:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjDQRfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 13:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjDQRfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 13:35:07 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484F7B74D;
        Mon, 17 Apr 2023 10:34:46 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id be20so3238135oib.4;
        Mon, 17 Apr 2023 10:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681752885; x=1684344885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eeGDsMuMU6qRe43N99vF2ssCtRufnnsTh9UIA9+QypE=;
        b=IDInwrW+xH9jdKHhQwGZ9AMx5IBZdTD6+1g3OhLs9BWIvByeuF8PqXlZYUpbq13ny8
         /CYUx0aSkCiH+tnQ1E70s+IGQ8WA2eqmH7hS/7MnAaKcHofmJ86YfSi1Y38FKGOCNdMA
         g3m+DAZpNsBcTuqDcyVLYTwgcWMeqR0Jb3MZD8ZYVQNxghqAIUU6r/lyLwqGDpf0w29g
         WjOwYOtrKN8/k4FPwJhoEp1I0+NGXF6sglPcQq3Qlo1TNlp6XLoWjB1IP4AI9+4i64bv
         UqXueR38VYZqbwHAIWrwo/ZOTqmMuybmySOdU86AU7kuz5YsH33MG6ug6/G30vMd7Pl4
         o6wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681752885; x=1684344885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eeGDsMuMU6qRe43N99vF2ssCtRufnnsTh9UIA9+QypE=;
        b=hhosQUQGKgnWkTotJELwLCKQgevmSweGfwN+UW9UW9BrtFHY7ZyCjoJgD3GUMz9kzQ
         a6ulSjOO9wSncF1E+ZHJrhBxxkcOV+07dYKDhr81IqVlkcehb/wggfeIUAO+fftYIj/G
         HKktlu9sa7JtSaO8HLCi2a/7IcEIO/LRi4JvIJt/gy6fy7QzATsZsE5r8/Uz127xg44T
         o5d8fnABRCFY/tY8fZRaAHMA9bZxAWpNyhhucaI9uUCohpkpt1OlOi9xExrse7cqmOTa
         7qsTm3FuU1JVFD78F47nG+ksazktCufnLQ1EUsDop4UZH0l0lvzixZMwwhjiepKgXLMk
         VnFg==
X-Gm-Message-State: AAQBX9dPhDKUeEpNT3D8JIVQ2c4IxZK7Yy0FJz5brFPsWJWb/kPIj9rq
        EvIwrpFAJZheJq7rN1eaOV7SkRlP/LnAr/bfqRY=
X-Google-Smtp-Source: AKy350bTrioIHzK5dr57vHhkLOTsyDawAXA2vhtRBswSuZM9nYlM43t4FGB7iGqblWvkCMZohmexiSP4DPey+QT8DqY=
X-Received: by 2002:aca:ea8b:0:b0:38e:2135:697f with SMTP id
 i133-20020acaea8b000000b0038e2135697fmr426732oih.3.1681752885378; Mon, 17 Apr
 2023 10:34:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230414193331.199598-1-hamza.mahfooz@amd.com> <4207e848-4e79-29a7-2bb0-44f74a2d62c7@amd.com>
In-Reply-To: <4207e848-4e79-29a7-2bb0-44f74a2d62c7@amd.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 17 Apr 2023 13:34:33 -0400
Message-ID: <CADnq5_MRMjr3byW_qO==Ps+X9grYQ9FLYGFEnd_Jsu3FLQBzCw@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: fix flickering caused by S/G mode
To:     =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc:     Hamza Mahfooz <hamza.mahfooz@amd.com>,
        amd-gfx@lists.freedesktop.org, Stylon Wang <stylon.wang@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>
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

On Mon, Apr 17, 2023 at 1:59=E2=80=AFAM Christian K=C3=B6nig
<christian.koenig@amd.com> wrote:
>
> Am 14.04.23 um 21:33 schrieb Hamza Mahfooz:
> > Currently, we allow the framebuffer for a given plane to move between
> > memory domains, however when that happens it causes the screen to
> > flicker, it is even possible for the framebuffer to change memory
> > domains on every plane update (causing a continuous flicker effect). So=
,
> > to fix this, don't perform an immediate flip in the aforementioned case=
.
>
> That sounds strongly like you just forget to wait for the move to finish!

It doesn't exhibit when we allow only gtt or only vram, only when
switches between pools does it flicker.

Alex

>
> What is the order of things done here? E.g. who calls amdgpu_bo_pin()
> and who waits for fences for finish signaling? Is that maybe just in the
> wrong order?
>
> Regards,
> Christian.
>
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 81d0bcf99009 ("drm/amdgpu: make display pinning more flexible (v=
2)")
> > Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
> > ---
> >   .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 41 ++++++++++++++++++=
-
> >   1 file changed, 39 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/driver=
s/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > index da3045fdcb6d..9a4e7408384a 100644
> > --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > @@ -7897,6 +7897,34 @@ static void amdgpu_dm_commit_cursors(struct drm_=
atomic_state *state)
> >                       amdgpu_dm_plane_handle_cursor_update(plane, old_p=
lane_state);
> >   }
> >
> > +static inline uint32_t get_mem_type(struct amdgpu_device *adev,
> > +                                 struct drm_gem_object *obj,
> > +                                 bool check_domain)
> > +{
> > +     struct amdgpu_bo *abo =3D gem_to_amdgpu_bo(obj);
> > +     uint32_t mem_type;
> > +
> > +     if (unlikely(amdgpu_bo_reserve(abo, true)))
> > +             return 0;
> > +
> > +     if (unlikely(dma_resv_reserve_fences(abo->tbo.base.resv, 1)))
> > +             goto err;
> > +
> > +     if (check_domain &&
> > +         amdgpu_display_supported_domains(adev, abo->flags) !=3D
> > +         (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT))
> > +             goto err;
> > +
> > +     mem_type =3D abo->tbo.resource->mem_type;
> > +     amdgpu_bo_unreserve(abo);
> > +
> > +     return mem_type;
> > +
> > +err:
> > +     amdgpu_bo_unreserve(abo);
> > +     return 0;
> > +}
> > +
> >   static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
> >                                   struct dc_state *dc_state,
> >                                   struct drm_device *dev,
> > @@ -7916,6 +7944,7 @@ static void amdgpu_dm_commit_planes(struct drm_at=
omic_state *state,
> >                       to_dm_crtc_state(drm_atomic_get_old_crtc_state(st=
ate, pcrtc));
> >       int planes_count =3D 0, vpos, hpos;
> >       unsigned long flags;
> > +     uint32_t mem_type;
> >       u32 target_vblank, last_flip_vblank;
> >       bool vrr_active =3D amdgpu_dm_crtc_vrr_active(acrtc_state);
> >       bool cursor_update =3D false;
> > @@ -8035,13 +8064,21 @@ static void amdgpu_dm_commit_planes(struct drm_=
atomic_state *state,
> >                       }
> >               }
> >
> > +             mem_type =3D get_mem_type(dm->adev, old_plane_state->fb->=
obj[0],
> > +                                     true);
> > +
> >               /*
> >                * Only allow immediate flips for fast updates that don't
> > -              * change FB pitch, DCC state, rotation or mirroing.
> > +              * change memory domain, FB pitch, DCC state, rotation or
> > +              * mirroring.
> >                */
> >               bundle->flip_addrs[planes_count].flip_immediate =3D
> >                       crtc->state->async_flip &&
> > -                     acrtc_state->update_type =3D=3D UPDATE_TYPE_FAST;
> > +                     acrtc_state->update_type =3D=3D UPDATE_TYPE_FAST =
&&
> > +                     (!mem_type || (mem_type && get_mem_type(dm->adev,
> > +                                                             fb->obj[0=
],
> > +                                                             false) =
=3D=3D
> > +                                    mem_type));
> >
> >               timestamp_ns =3D ktime_get_ns();
> >               bundle->flip_addrs[planes_count].flip_timestamp_in_us =3D=
 div_u64(timestamp_ns, 1000);
>

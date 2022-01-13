Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6A648DA4D
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 16:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233639AbiAMPA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 10:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbiAMPA1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 10:00:27 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB36C06161C
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 07:00:26 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id q186so7997639oih.8
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 07:00:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lgpQS2Ev6D4tHPtETfEK2unFwJICopCqDHcvSTUSs3U=;
        b=QC69U+eYQfXeNHWOCGjrVKMl+uF7/InTME8bRr2n/CcIWLhK8Xovu9vyqUuH65QvJG
         vdBFY6p5jTNs7IGcE4W17t3NMzaowdQ4+i0LTHIbO9wiAi79nCSLVNZD2ZTsQmtmeJLk
         EOso6w3jsmwTGKfnqy+74EjnQ0wS1CwdE03h0GQCIFBnEjLB/VRCbbO04OeFh+XuSvhV
         9mfy8lSkaNmuXr+4O5wPnOEaq1+DsHnz8d+Oj0WmTO7FNfyqF/dcbKBLtVtVNJ7kDtFA
         OH7zOByJN7MIEbAQe9WSLE8/GsUtsewhu6Wmrj5cdB888vLzBlV/iXUDhjACrrNOKveA
         JCDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lgpQS2Ev6D4tHPtETfEK2unFwJICopCqDHcvSTUSs3U=;
        b=mpyUyAgbADi5heYm0YDLhQwOQHYr6lCfgLKzy5kJawjmfYBmJwEdvQLYIOEaOBejO/
         XD/MewCF2g497Rp7/XfLYQBmYIUdI6nXYesj/NuyxxB3shoX65hcbbj+rhkV9HhXiqAs
         4trOcA34LlI8Qh+K9Juula/qF2EUJIX1KNCouflclJBIc6CgB9Z82zGBc+uMO3qJrOIi
         j/wg9OFWVzf7+SVVUy/nGnvajl+mESqdeKKgGgL4uUSuGxpbTYBTVknworG8YGBp6YM4
         wEnuFTFs8F0VcgM1+t9UXVQj6MDOAKJpl3af35VvvgNoYAvxU1Z80N7XJcrKnHcEw190
         X/mQ==
X-Gm-Message-State: AOAM532VgjqiDseuFTpr5LKyTnOYS+kQ/72nMfExKr9waOTSz9YRzp2X
        FacL0K72f5/lFMdlk2OqNoV0ojHiXxKzXaAGk7YzI/Vn5NU=
X-Google-Smtp-Source: ABdhPJykKZ017BQ47eDrAkrwuvGzIWuhI9b5QLfaW8b5fuEwOw9A6KPP1mwK+LSNfO78LsyJVO0LlXV36sTUxdDVbSw=
X-Received: by 2002:a05:6808:300b:: with SMTP id ay11mr3396140oib.120.1642086026062;
 Thu, 13 Jan 2022 07:00:26 -0800 (PST)
MIME-Version: 1.0
References: <20220113040103.311160-1-alexander.deucher@amd.com> <1586c31f-9e84-c63b-8abc-1862b08cf707@amd.com>
In-Reply-To: <1586c31f-9e84-c63b-8abc-1862b08cf707@amd.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Thu, 13 Jan 2022 10:00:14 -0500
Message-ID: <CADnq5_OwmDh_TDkGJLBYKbOcLWeXvreYSu-OY+E7w+uqYYG+Kw@mail.gmail.com>
Subject: Re: [PATCH] drm/amdgpu: don't do resets on APUs which don't support it
To:     "Lazar, Lijo" <lijo.lazar@amd.com>
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "for 3.8" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 13, 2022 at 1:56 AM Lazar, Lijo <lijo.lazar@amd.com> wrote:
>
> Hi Alex,
>
> What about something like this?
>
> bool amdgpu_device_reset_on_suspend(struct amdgpu_device *adev)
> {
>          if (adev->in_s0ix || adev->gmc.xgmi.num_physical_nodes > 1)
>                  return false;
>
>          switch (amdgpu_asic_reset_method(adev)) {
>          case AMD_RESET_METHOD_BACO:
>          case AMD_RESET_METHOD_MODE1:
>          case AMD_RESET_METHOD_MODE2:

This should also work on AMD_RESET_METHOD_LEGACY, at least for dGPUs.
I think the current approach is probably better since I don't think
GPU resets work reliably on these chips anyway (it's not enabled by
default on them gor hangs), so better to just not do it as it may make
the problem worse.

Alex


>                  return true;
>          }
>
>          return false;
> }
>
> Thanks,
> Lijo
>
> On 1/13/2022 9:31 AM, Alex Deucher wrote:
> > It can cause a hang.  This is normally not enabled for GPU
> > hangs on these asics, but was recently enabled for handling
> > aborted suspends.  This causes hangs on some platforms
> > on suspend.
> >
> > Fixes: daf8de0874ab5b ("drm/amdgpu: always reset the asic in suspend (v2)")
> > Cc: stable@vger.kernel.org
> > Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1858
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > ---
> >   drivers/gpu/drm/amd/amdgpu/cik.c | 4 ++++
> >   drivers/gpu/drm/amd/amdgpu/vi.c  | 4 ++++
> >   2 files changed, 8 insertions(+)
> >
> > diff --git a/drivers/gpu/drm/amd/amdgpu/cik.c b/drivers/gpu/drm/amd/amdgpu/cik.c
> > index 54f28c075f21..f10ce740a29c 100644
> > --- a/drivers/gpu/drm/amd/amdgpu/cik.c
> > +++ b/drivers/gpu/drm/amd/amdgpu/cik.c
> > @@ -1428,6 +1428,10 @@ static int cik_asic_reset(struct amdgpu_device *adev)
> >   {
> >       int r;
> >
> > +     /* APUs don't have full asic reset */
> > +     if (adev->flags & AMD_IS_APU)
> > +             return 0;
> > +
> >       if (cik_asic_reset_method(adev) == AMD_RESET_METHOD_BACO) {
> >               dev_info(adev->dev, "BACO reset\n");
> >               r = amdgpu_dpm_baco_reset(adev);
> > diff --git a/drivers/gpu/drm/amd/amdgpu/vi.c b/drivers/gpu/drm/amd/amdgpu/vi.c
> > index fe9a7cc8d9eb..6645ebbd2696 100644
> > --- a/drivers/gpu/drm/amd/amdgpu/vi.c
> > +++ b/drivers/gpu/drm/amd/amdgpu/vi.c
> > @@ -956,6 +956,10 @@ static int vi_asic_reset(struct amdgpu_device *adev)
> >   {
> >       int r;
> >
> > +     /* APUs don't have full asic reset */
> > +     if (adev->flags & AMD_IS_APU)
> > +             return 0;
> > +
> >       if (vi_asic_reset_method(adev) == AMD_RESET_METHOD_BACO) {
> >               dev_info(adev->dev, "BACO reset\n");
> >               r = amdgpu_dpm_baco_reset(adev);
> >

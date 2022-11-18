Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA36862FEC1
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 21:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiKRUZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 15:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKRUZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 15:25:19 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4696D5F848;
        Fri, 18 Nov 2022 12:25:18 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id h132so6578790oif.2;
        Fri, 18 Nov 2022 12:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XYhudk4n0csLtHKc5OqIA86HMN/FrexIaMhEuyhh/as=;
        b=MmI0I+1r38yYv5LPgjxyeS7G/aAZKj/Z1FzGVTFOLjdvcaesIb4AMQhEAGxfpJSSAO
         a465wj0cKQpDBfrQbsNf6z75BxfMcABr3lrqtufqrZCVMssFE7WaXxLrOIcgdj+tcWH5
         UAL6q1Nx2u3Cky7pu6rtGCZFt6TYuydYXfuxjOoznwI6t4292SqW6R1P4+YZgxLgCXvK
         deCE+A/cNcMVArxkG9Q/oxFa0QIMlLbu3b7rvXtmXdm2H9fmHxQ6/6lzwaitdfbYTkAM
         dHI/+hN+PbD2ykrha0bxhGjMlNn159Bala0AIzGI1fXsUckpARYhlggOkcBJc19CKkJE
         BlZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XYhudk4n0csLtHKc5OqIA86HMN/FrexIaMhEuyhh/as=;
        b=0JqFIkkk7230wHL3RWFpKbjrP1Yxb7YkLa0sv+ewRM6Agrvi9Bd4iv1qxnpf4m7UgI
         qOCEZ2WS0T43IuZF4aN5fQ99dNtKMUoJBreKdMyjMije+qJDZsPfcOSm/c1z9BkrtdJS
         x/FkD9C3KRam/6GnannJPoFksk4NjY1URgCdK8QS9Aapx/tCVv3nPzvhf9xd0GZmn/hS
         9lyCa9w8V1FZntK+48FqOPM459qnDAvfxqao215s0bcb5dKbo/tsZz+/WUYpo9cZvuKn
         pon7vIR+kHGe8YHbfIcjVTOSJHNulijpLqiyMUsnk9QrqhgaV/+EqK5YSLN4GFzTNkXw
         iFZw==
X-Gm-Message-State: ANoB5pkPa0crFSzb0A3K3RBIwEUevHdPoCNWFGjRUMGxU3F2MU4e/WnK
        0A5qGfxIHRcEEvcP3jWSc29qqUt0aQdBzw8JajA=
X-Google-Smtp-Source: AA0mqf7O3LV8jYqCnEp37MCuUsvOT+0DDbKU874q78jM901EOHTiXZq9fQpE1W7Q4WuTtQ6WdlnOsuto8TGzEim9Tx8=
X-Received: by 2002:a05:6808:295:b0:357:670f:9e4e with SMTP id
 z21-20020a056808029500b00357670f9e4emr7419778oic.46.1668803117591; Fri, 18
 Nov 2022 12:25:17 -0800 (PST)
MIME-Version: 1.0
References: <20221114222046.386560-1-lyude@redhat.com> <CADnq5_PrarJPZQu6uRwDdCqhZr7Hvbtxo_HuhiQ7H1DYRgSyqQ@mail.gmail.com>
In-Reply-To: <CADnq5_PrarJPZQu6uRwDdCqhZr7Hvbtxo_HuhiQ7H1DYRgSyqQ@mail.gmail.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Fri, 18 Nov 2022 15:25:06 -0500
Message-ID: <CADnq5_O+bTG3992uZKvJct6-iRWL9nW1xEzXhh3SShm1=VLFtQ@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/dc/dce120: Fix audio register mapping, stop
 triggering KASAN
To:     Lyude Paul <lyude@redhat.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>
Cc:     amd-gfx@lists.freedesktop.org, Alan Liu <HaoPing.Liu@amd.com>,
        Leo Li <sunpeng.li@amd.com>, David Airlie <airlied@gmail.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 17, 2022 at 4:40 PM Alex Deucher <alexdeucher@gmail.com> wrote:
>
> On Mon, Nov 14, 2022 at 5:21 PM Lyude Paul <lyude@redhat.com> wrote:
> >
> > There's been a very long running bug that seems to have been neglected for
> > a while, where amdgpu consistently triggers a KASAN error at start:
> >
> >   BUG: KASAN: global-out-of-bounds in read_indirect_azalia_reg+0x1d4/0x2a0 [amdgpu]
> >   Read of size 4 at addr ffffffffc2274b28 by task modprobe/1889
> >
> > After digging through amd's rather creative method for accessing registers,
> > I eventually discovered the problem likely has to do with the fact that on
> > my dce120 GPU there are supposedly 7 sets of audio registers. But we only
> > define a register mapping for 6 sets.
> >
> > So, fix this and fix the KASAN warning finally.
> >
> > Signed-off-by: Lyude Paul <lyude@redhat.com>
> > Cc: stable@vger.kernel.org
>
> This is the correct fix for asics having 7 audio instances.  It looks
> correct to me, assuming DCE12 actually has 7 audio instances.
> @Wentland, Harry Do you know off hand?  If you can confirm that, the
> patch is:
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

The driver currently defines 7 audio instances, whether or not it
actually has 7 remains to be seen but the code as is is broken, so
I'll apply this.  If it turns out there are only 6 instances we can
fix the count later.  Applied.  Thanks!

Alex

>
>
> > ---
> > Sending this one separately from the rest of my fixes since:
> >
> > * It's definitely completely unrelated to the Gitlab 2171 issue
> > * I'm not sure if this is the correct fix since it's in DC
> >
> >  drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c b/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
> > index 1b70b78e2fa15..af631085e88c5 100644
> > --- a/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
> > +++ b/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
> > @@ -359,7 +359,8 @@ static const struct dce_audio_registers audio_regs[] = {
> >         audio_regs(2),
> >         audio_regs(3),
> >         audio_regs(4),
> > -       audio_regs(5)
> > +       audio_regs(5),
> > +       audio_regs(6),
> >  };
> >
> >  #define DCE120_AUD_COMMON_MASK_SH_LIST(mask_sh)\
> > --
> > 2.37.3
> >

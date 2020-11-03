Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF78E2A507E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 20:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgKCTxT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 3 Nov 2020 14:53:19 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:47023 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgKCTxT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 14:53:19 -0500
Received: by mail-vs1-f65.google.com with SMTP id r14so5217432vsa.13;
        Tue, 03 Nov 2020 11:53:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LPtP+9CQKIJmcik5TfvwygpKuN/Q0uAwXqya4YloAdw=;
        b=BeqWv36YVC55OIi+JjFaXh/l+04AaDI8sX5X/jWx4prkz26Y/FDISSPIvryZW2dPcr
         PmFsPA7RyZY4u3gLlml7k8spIIdUZo3P1LeyacbsCORaEOzz2MHuHlEDAGPMJVp3FiIL
         Wfdn+b8rVB5I63e5XM5AXtD0fTWm7mH2zWHP+Ujk+4T/+Qoh7q9gSfcA18VwG+ABQkdX
         8vC/B0gw/7xFxiXX+eScJcLTX3Qs2XraO9dsRBBO9zptkiHb1I0V9HxXjaKWZ5ogE1G6
         0Q6Rk1pelMDKa+rm9rwsmiJPgh00EzC05HbfFVBemQKUiuc7aFPWQPgRX9/HigNhMX5M
         P0Vg==
X-Gm-Message-State: AOAM530SiHNGngb9CKSUmofZzkVvDDm6sPPirspwPBJM37J5wY5Pkw5s
        a5yPMKkeJ76162dRbZeTH2vMcXMaBHj3cy2F7kmVt24L
X-Google-Smtp-Source: ABdhPJx4YmOziGVtLAIcDjvkVsd2iI7cO9OJ9Fc3RUpf8kGA3o8WVbldKHp0pQbO701GqFnl14XHag7m54w7qsSERqk=
X-Received: by 2002:a67:f699:: with SMTP id n25mr19488936vso.52.1604433196168;
 Tue, 03 Nov 2020 11:53:16 -0800 (PST)
MIME-Version: 1.0
References: <20201022165450.682571-1-lyude@redhat.com> <CAKb7UvhfWA6ijoQnq2Mvrx8jfn57EC-P5KBkYR3HmrBUrntJhg@mail.gmail.com>
 <8d15a513bd38a01b3607e5c75b5754cc599fe33c.camel@redhat.com>
In-Reply-To: <8d15a513bd38a01b3607e5c75b5754cc599fe33c.camel@redhat.com>
From:   Ilia Mirkin <imirkin@alum.mit.edu>
Date:   Tue, 3 Nov 2020 14:53:05 -0500
Message-ID: <CAKb7UvjJHMbDEAYJRCCdQ=LZfpogb4Z6y+yYFgPYKvbE1mM1ig@mail.gmail.com>
Subject: Re: [PATCH] drm/edid: Fix uninitialized variable in drm_cvt_modes()
To:     Lyude <lyude@redhat.com>
Cc:     dri-devel <dri-devel@lists.freedesktop.org>,
        Leon Romanovsky <leon@kernel.org>,
        David Airlie <airlied@linux.ie>, Chao Yu <chao@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "# 3.9+" <stable@vger.kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 3, 2020 at 2:47 PM Lyude Paul <lyude@redhat.com> wrote:
>
> Sorry! Thought I had responded to this but apparently not, comments down below
>
> On Thu, 2020-10-22 at 14:04 -0400, Ilia Mirkin wrote:
> > On Thu, Oct 22, 2020 at 12:55 PM Lyude Paul <lyude@redhat.com> wrote:
> > >
> > > Noticed this when trying to compile with -Wall on a kernel fork. We
> > > potentially
> > > don't set width here, which causes the compiler to complain about width
> > > potentially being uninitialized in drm_cvt_modes(). So, let's fix that.
> > >
> > > Signed-off-by: Lyude Paul <lyude@redhat.com>
> > >
> > > Cc: <stable@vger.kernel.org> # v5.9+
> > > Fixes: 3f649ab728cd ("treewide: Remove uninitialized_var() usage")
> > > Signed-off-by: Lyude Paul <lyude@redhat.com>
> > > ---
> > >  drivers/gpu/drm/drm_edid.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> > > index 631125b46e04..2da158ffed8e 100644
> > > --- a/drivers/gpu/drm/drm_edid.c
> > > +++ b/drivers/gpu/drm/drm_edid.c
> > > @@ -3094,6 +3094,7 @@ static int drm_cvt_modes(struct drm_connector
> > > *connector,
> > >
> > >         for (i = 0; i < 4; i++) {
> > >                 int width, height;
> > > +               u8 cvt_aspect_ratio;
> > >
> > >                 cvt = &(timing->data.other_data.data.cvt[i]);
> > >
> > > @@ -3101,7 +3102,8 @@ static int drm_cvt_modes(struct drm_connector
> > > *connector,
> > >                         continue;
> > >
> > >                 height = (cvt->code[0] + ((cvt->code[1] & 0xf0) << 4) + 1) *
> > > 2;
> > > -               switch (cvt->code[1] & 0x0c) {
> > > +               cvt_aspect_ratio = cvt->code[1] & 0x0c;
> > > +               switch (cvt_aspect_ratio) {
> > >                 case 0x00:
> > >                         width = height * 4 / 3;
> > >                         break;
> > > @@ -3114,6 +3116,10 @@ static int drm_cvt_modes(struct drm_connector
> > > *connector,
> > >                 case 0x0c:
> > >                         width = height * 15 / 9;
> > >                         break;
> > > +               default:
> >
> > What value would cvt->code[1] have such that this gets hit?
> >
> > Or is this a "compiler is broken, so let's add more code" situation?
> > If so, perhaps the code added could just be enough to silence the
> > compiler (unreachable, etc)?
>
> I mean, this information comes from the EDID which inherently means it's coming
> from an untrusted source so the value could be literally anything as long as the
> EDID has a valid checksum. Note (assuming I'm understanding this code
> correctly):
>
> drm_add_edid_modes() → add_cvt_modes() → drm_for_each_detailed_block() →
> do_cvt_mode() → drm_cvt_modes()
>
> So afaict this isn't a broken compiler but a legitimate uninitialized variable.

The value can be anything, but it has to be something. The switch is
on "unknown & 0x0c", so only 4 cases are possible, which are
enumerated in the switch.

  -ilia

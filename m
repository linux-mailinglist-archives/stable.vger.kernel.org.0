Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99F94406FF
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 04:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhJ3C5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 22:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbhJ3C5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 22:57:06 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4C6C061570;
        Fri, 29 Oct 2021 19:54:37 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id r2so9677195qtw.12;
        Fri, 29 Oct 2021 19:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jB7wLuFVeBRaCCuZXBeTJY8kZP4RLd0O4+lxl57Ejj8=;
        b=bp3cs1RuPFFgh34vTSzop9PmgEAtvFBeGvPnagP/eExiK8w7UIeeGzHZANNFDzOjfv
         oqkcB3LAIt5d5X0Tx13EWf89UT0itwa8yNtwvUfYYV9HE3twFjFKEQeYwgA5LQmf8yBx
         WZ6fXj49FkZR1vezIuWnmAGRM8iQQYq26HiOSoVAzdtoTNKZzVJbZ+/Y7h0j0mBeUF/v
         XJwi1HfFymuc6Bx9lSoxn+8f/fNyC6t62ektH44FoOLLi1YCzznAXQpXTqG1BSDXZBR4
         8GukG25iRi+w26NZPCTgYre5tk9Hj7wpvhHjAJJfzRwyEOhNe6K5OxPng0EbzHW7pMJj
         mM/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jB7wLuFVeBRaCCuZXBeTJY8kZP4RLd0O4+lxl57Ejj8=;
        b=M925VNHIuCP1/vQFw9FAN2hSHEPYiZR2XRVC3ZB+cFLQEIYKM+u6EmWuGHrv7OdIoS
         qFJeCC97eTwTesvobaf9IptVX6i1Kv37iWsXBgkfgSb26SrI4NCMXVO5/LcAnNepjGVL
         iApiM8nqsJEoV5UG7h7eru7QWK6/ny7NqRWiV6MWIkPdWCkb+XARIt1mP/InZgoYtT1h
         qZ4UCXa5ysrREQbZzgeZDlTI/OpLxh+rHJPCemKAiwAtoEjbH37OuxkPE5i1AlaMpiZr
         web76gddgJR0Ui1U/mztC1rRBh3XuISKX64/v7pFKG5tYHYvBax1mZnedf0nZGWGxc92
         3gLw==
X-Gm-Message-State: AOAM530+yzKZI0EDxBDwGYignQK9vWLiF0V8vk/xAAR4c/cJVeffsQpn
        OJIbioOvUa8rg/baVXx4DjNB/lwnH9+b6kvosyKtjKZBsahJog==
X-Google-Smtp-Source: ABdhPJxMa0vbfx6UgHhODBZymu7reXsvFbwtEjSJvWCgP57vbFVBw6Q9h2Y2pGjdEOLuQEhE3pq/+889F5L0aZRjZ/o=
X-Received: by 2002:ac8:5cc5:: with SMTP id s5mr16045347qta.256.1635562476163;
 Fri, 29 Oct 2021 19:54:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211022232837.18988-1-ping.cheng@wacom.com> <CAF8JNhJKcB4n98SgD9Q-ETeF_465k7bqgijt+vDBLh5AqMWGrQ@mail.gmail.com>
In-Reply-To: <CAF8JNhJKcB4n98SgD9Q-ETeF_465k7bqgijt+vDBLh5AqMWGrQ@mail.gmail.com>
From:   Ping Cheng <pinglinux@gmail.com>
Date:   Fri, 29 Oct 2021 19:54:24 -0700
Message-ID: <CAF8JNhJQo3dbT7=2z1NV3+FkCBRuoW4uhWV6U=TEU6mOLf2w3w@mail.gmail.com>
Subject: Re: [PATCH] HID: input: fix the incorrectly reported
 BTN_TOOL_RUBBER/PEN tools
To:     jikos@kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc:     linux-input@vger.kernel.org, stable@vger.kernel.org,
        Jason Gerecke <killertofu@gmail.com>,
        Tatsunosuke Tobita <junkpainting@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ok, I know why no one follow-up with my patch. Life wasn't as simple
as I wished for :).

The patch missed one important fact: repeated events don't go into
userland. They are filtered! We need to initiate another input_dev to
hold all the past events for the coming tool, whether it is PEN or
RUBBER. So, it is more like a simplified multi-pen case, right? What's
your suggestions? Do we claim two tools for this particular use case?

On Wed, Oct 27, 2021 at 12:06 PM Ping Cheng <pinglinux@gmail.com> wrote:
>
> Hi @Dmitry Torokhov and @Benjamin Tissoires,
>
> Do you have any comments about this patch? The issue and the logic
> behind the fix has been explained in the commit comment and in the
> code. Jiri is probably waiting for an acknowledgment from one of
> you...
>
> Thank you,
> Ping
>
> On Fri, Oct 22, 2021 at 4:29 PM Ping Cheng <pinglinux@gmail.com> wrote:
> >
> > The HID_QUIRK_INVERT caused BTN_TOOL_RUBBER events were reported at the
> > same time as events for BTN_TOOL_PEN/PENCIL/etc, if HID_QUIRK_INVERT
> > was set by a stylus' sideswitch. The reality is that a pen can only be
> > a stylus (writing/drawing) or an eraser, but not both at the same time.
> > This patch makes that logic correct.
> >
> > CC: stable@vger.kernel.org # 2.4+
> > Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
> > Reviewed-by: Jason Gerecke <killertofu@gmail.com>
> > Tested-by: Tatsunosuke Tobita <junkpainting@gmail.com>
> > ---
> >  drivers/hid/hid-input.c | 24 ++++++++++++++++++++----
> >  1 file changed, 20 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> > index 4b5ebeacd283..85741a2d828d 100644
> > --- a/drivers/hid/hid-input.c
> > +++ b/drivers/hid/hid-input.c
> > @@ -1344,12 +1344,28 @@ void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, struct
> >         }
> >
> >         if (usage->hid == HID_DG_INRANGE) {
> > +               /* when HID_QUIRK_INVERT is set by a stylus sideswitch, HID_DG_INRANGE could be
> > +                * for stylus or eraser. Make sure events are only posted to the current valid tool:
> > +                * BTN_TOOL_RUBBER vs BTN_TOOL_PEN/BTN_TOOL_PENCIL/BTN_TOOL_BRUSH/etc since a pen
> > +                * can not be used as a stylus (to draw/write) and an erasaer at the same time
> > +                */
> > +               static unsigned int last_code = 0;
> > +               unsigned int code = (*quirks & HID_QUIRK_INVERT) ? BTN_TOOL_RUBBER : usage->code;
> >                 if (value) {
> > -                       input_event(input, usage->type, (*quirks & HID_QUIRK_INVERT) ? BTN_TOOL_RUBBER : usage->code, 1);
> > -                       return;
> > +                       if (code != last_code) {
> > +                               /* send the last tool out before allow the new one in */
> > +                               if (last_code)
> > +                                       input_event(input, usage->type, last_code, 0);
> > +                               input_event(input, usage->type, code, 1);
> > +                       }
> > +                       last_code = code;
> > +               } else {
> > +                       /* only send the last valid tool out */
> > +                       if (last_code)
> > +                               input_event(input, usage->type, last_code, 0);
> > +                       /* reset tool for next cycle */
> > +                       last_code = 0;
> >                 }
> > -               input_event(input, usage->type, usage->code, 0);
> > -               input_event(input, usage->type, BTN_TOOL_RUBBER, 0);
> >                 return;
> >         }
> >
> > --
> > 2.25.1
> >

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB942A0CF1
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 19:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgJ3SAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 14:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgJ3SAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 14:00:45 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58C9C0613D2
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 11:00:44 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id d25so7815288ljc.11
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 11:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jymM9yh2NwbUECBOMcs6up1bGqTHgPh+0sCknIZeqEc=;
        b=JcxskUBFZ/WcAF1g8J83ug0UWLLYvJoewVsMjFCWA8cwPUfGhS7/J93HXK8mFDwlrV
         h9rQHlxFzTLpABQ5cB+StsbCXXifmaImuVXpq9dx/FmxvwQrVsijAxJrAoBrcgRzMTBL
         6l/eWt39O8yFF1NSGtmhYU5qnZC8f0fcusPPA02hObCiD1dqhSomQDGFLbBUlGYj2nrx
         e9IpbQdBJyNWB/NAqYflN/yDgYNTuAW3e4rqAXLyYe84y8SslHPW/Gbvp7dmX5lQz6uO
         LHIPKP488T/78jBD7iKflU7E9MRGFKkTYXFo9RHsmBjiyoLG6iaRLjlxbUEZGNTh4MQa
         BjiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jymM9yh2NwbUECBOMcs6up1bGqTHgPh+0sCknIZeqEc=;
        b=EyI4nYMlBvY7dLhER4WVOnWriIvbxvJC1nhXIdfwurem7BxoWCLwUb8IJYQ3q2acTD
         mOUqYegfGvrIFzkLNAr/NHvyxtSNdB+16IVJ8FU2KbH0DP7+vtNkyStM0UgPu9OTPlrT
         VE+mdkijrzFA5xlCk8musokRLiUVoqHI7Vpg2OSIeG/R/0pZxMdXCVfXKLtaGC6ov3VB
         cpYi0zDKC3yZLBPTgqNf5tDGmXcA7MXVnRuAQ+fFGJYfUmod9tavLDNqw6fFNu67+YUM
         P9oR2dEWnZn3nOnPTheP1sP8f5p+6jWTFflVt+s0tFuAuqgs1cVeS14JQ5qPJVTT5kOe
         B5Cw==
X-Gm-Message-State: AOAM531pdZuLfvRaeukHldLnplkOralFGOeemnP+cg3ruF4xEJhibdEc
        CyBm+bBgMdA1YH7EONBS6fBj9fJvKmW6EtNc5sd5hg==
X-Google-Smtp-Source: ABdhPJwZqSvi8j2gM5ob7PJPJEksIgTCMgW48FigpsT1slvQtQUB++A8PxcynFJ5bOI7bing4jS9fu0mjGdGuibkkjI=
X-Received: by 2002:a2e:8816:: with SMTP id x22mr1518588ljh.377.1604080843021;
 Fri, 30 Oct 2020 11:00:43 -0700 (PDT)
MIME-Version: 1.0
References: <20201030123849.770769-1-mic@digikod.net> <20201030123849.770769-2-mic@digikod.net>
 <CAG48ez1LFAKoi-nvipsar2SAH0eNhKkOzWj4Fuf9wNCtpWsH9A@mail.gmail.com> <94a86084-5aab-4a2c-e654-f55130190c1a@digikod.net>
In-Reply-To: <94a86084-5aab-4a2c-e654-f55130190c1a@digikod.net>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 30 Oct 2020 19:00:16 +0100
Message-ID: <CAG48ez3ojo9cLuZWjeB4W2Etv3gJrkAryxMLrgFc-awgYVvoHQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] ptrace: Set PF_SUPERPRIV when checking capability
To:     =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Eric Paris <eparis@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Will Drewry <wad@chromium.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 30, 2020 at 5:06 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
> On 30/10/2020 16:47, Jann Horn wrote:
> > On Fri, Oct 30, 2020 at 1:39 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.n=
et> wrote:
> >> Commit 69f594a38967 ("ptrace: do not audit capability check when outpu=
ting
> >> /proc/pid/stat") replaced the use of ns_capable() with
> >> has_ns_capability{,_noaudit}() which doesn't set PF_SUPERPRIV.
> >>
> >> Commit 6b3ad6649a4c ("ptrace: reintroduce usage of subjective credenti=
als in
> >> ptrace_has_cap()") replaced has_ns_capability{,_noaudit}() with
> >> security_capable(), which doesn't set PF_SUPERPRIV neither.
> >>
> >> Since commit 98f368e9e263 ("kernel: Add noaudit variant of ns_capable(=
)"), a
> >> new ns_capable_noaudit() helper is available.  Let's use it!
> >>
> >> As a result, the signature of ptrace_has_cap() is restored to its orig=
inal one.
> >>
> >> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> >> Cc: Eric Paris <eparis@redhat.com>
> >> Cc: Jann Horn <jannh@google.com>
> >> Cc: Kees Cook <keescook@chromium.org>
> >> Cc: Oleg Nesterov <oleg@redhat.com>
> >> Cc: Serge E. Hallyn <serge@hallyn.com>
> >> Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
> >> Cc: stable@vger.kernel.org
> >> Fixes: 6b3ad6649a4c ("ptrace: reintroduce usage of subjective credenti=
als in ptrace_has_cap()")
> >> Fixes: 69f594a38967 ("ptrace: do not audit capability check when outpu=
ting /proc/pid/stat")
> >> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
> >
> > Yeah... I guess this makes sense. (We'd have to undo or change it if
> > we ever end up needing to use a different set of credentials, e.g.
> > from ->f_cred, but I guess that's really something we should avoid
> > anyway.)
> >
> > Reviewed-by: Jann Horn <jannh@google.com>
> >
> > with one nit:
> >
> >
> > [...]
> >>  /* Returns 0 on success, -errno on denial. */
> >>  static int __ptrace_may_access(struct task_struct *task, unsigned int=
 mode)
> >>  {
> >> -       const struct cred *cred =3D current_cred(), *tcred;
> >> +       const struct cred *const cred =3D current_cred(), *tcred;
> >
> > This is an unrelated change, and almost no kernel code marks local
> > pointer variables as "const". I would drop this change from the patch.
>
> This give guarantee that the cred variable will not be used for
> something else than current_cred(), which kinda prove that this patch
> doesn't change the behavior of __ptrace_may_access() by not using cred
> in ptrace_has_cap(). It doesn't hurt and I think it could be useful to
> spot issues when backporting.

And it might require an extra fixup while backporting because the next
line is different and that might cause the patch to not apply.

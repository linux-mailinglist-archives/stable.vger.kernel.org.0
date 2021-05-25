Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADE2390AB7
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 22:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhEYUv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 16:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbhEYUv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 16:51:27 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B92AC06175F
        for <stable@vger.kernel.org>; Tue, 25 May 2021 13:49:57 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id w15so39940577ljo.10
        for <stable@vger.kernel.org>; Tue, 25 May 2021 13:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=my1VRpGvUlfJOXYYzf5go17vJHSLCcuUwMNzSJZH5Ho=;
        b=ua8fCYcaJJV6MtDCSg1a6tMUYR+FLxUCJ8CI+LDWBkCJ4cy1Wlpe+VCemp05KLBfSO
         D9cYtH86QUDMbl/Fzop62cTA5zjzp+ljS/DdNiip70zWHVOWa1SjVYLnN3E+mf6LHYDk
         NBzxy+HOhHapf14QAL8jiDZC3fi3YG1hwbvAFwsDpsxVgJ4XLi82xUXO+wMuBxceCL7H
         6OjULEKwSnq+t0dj5lecl3Zy7J7N1jsxwerd1pfDqdxecC/4BsYyTHIC5/DbdlGb63Y6
         EZDE4FHR60y6tkNVDKpDjHk3PKbT27tUHbBOXOnHE6m/1udgz6UFcLlbe8aQXnGTODWI
         8q8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=my1VRpGvUlfJOXYYzf5go17vJHSLCcuUwMNzSJZH5Ho=;
        b=izZ4m4y6/tJRJE1l8+UjEEaSZqAng2NrUAqZZrlxaRjuzP9WNRU7T24NjLZtzgGP40
         iYAFrWFneP13/JtiXyxNaZJVyN2QIGWozMf0X0NrmYnQssAGXGxIQ9Ik5G7vIAJ0vbN8
         M9WpCaxZoQDAK1BEuaSNYVyUeggnh/HFgxcSjtvqm30d7NptoMmoAJpbjpFEv79ziGs0
         qSq9ybngPBqnVY13dA5R65YNWQ404GL8mRnIXcri2PIC2OdG6/w8d7jBJ+6R0y0lXSWm
         9iHW3ingWOZ6VIKILET3XJJ5Acv9zRSobQnloLd9FuLqd7kivnEls00U6I6NbktT2fFj
         lv6w==
X-Gm-Message-State: AOAM531iOdgfkrrJHf2zXMOyFfdeQREhI33KvXGA+sFhLfIT9y+t8Iq4
        sOREfqHejZ5En4bLHBK+WZxwkA09j+oTSMxO2EJPPg==
X-Google-Smtp-Source: ABdhPJyTHdRV8wRsB3fBdCyc7Q6itMRgKE8fVP0pJH06zWDrayKPje8tP08v4Z6WOYTp3BQkb5Jip+8X5KCHD1zohLs=
X-Received: by 2002:a2e:9f16:: with SMTP id u22mr22005702ljk.43.1621975795312;
 Tue, 25 May 2021 13:49:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210525193735.2716374-1-keescook@chromium.org>
In-Reply-To: <20210525193735.2716374-1-keescook@chromium.org>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 25 May 2021 22:49:29 +0200
Message-ID: <CAG48ez2PdgpUj3GYRLDJ9MS1uKMZ4SU77i__vhXvmbzqudzuzA@mail.gmail.com>
Subject: Re: [PATCH] proc: Check /proc/$pid/attr/ writes against file opener
To:     Kees Cook <keescook@chromium.org>
Cc:     Linus Torvalds <torvalds@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Paul Moore <paul@paul-moore.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Oleg Nesterov <oleg@redhat.com>,
        James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 25, 2021 at 9:37 PM Kees Cook <keescook@chromium.org> wrote:
> Fix another "confused deputy" weakness[1]. Writes to /proc/$pid/attr/
> files need to check the opener credentials, since these fds do not
> transition state across execve(). Without this, it is possible to
> trick another process (which may have different credentials) to write
> to its own /proc/$pid/attr/ files, leading to unexpected and possibly
> exploitable behaviors.
>
> [1] https://www.kernel.org/doc/html/latest/security/credentials.html?highlight=confused#open-file-credentials
>
> Fixes: 1da177e4c3f41 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  fs/proc/base.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 3851bfcdba56..58bbf334265b 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2703,6 +2703,10 @@ static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
>         void *page;
>         int rv;
>
> +       /* A task may only write when it was the opener. */
> +       if (file->f_cred != current_real_cred())
> +               return -EPERM;

With this, if a task forks, the child will then still be able to open
its parent's /proc/$pid/attr/current and trick the parent into writing
to that, right? Is that acceptable? If not, the ->open handler should
probably also check for "current->thread_pid == proc_pid(inode)", or
something like that?

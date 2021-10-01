Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA9E41F5E8
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 21:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhJATxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 15:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhJATxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Oct 2021 15:53:11 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9DDC06177F
        for <stable@vger.kernel.org>; Fri,  1 Oct 2021 12:51:26 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id y26so43116173lfa.11
        for <stable@vger.kernel.org>; Fri, 01 Oct 2021 12:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OASN1DWXrIyD6gQMB0CvKRtBfiSz7Btq5Vz6GIW00BE=;
        b=pggztfgWW5/r760u67qMKk/gTZdTITQgtnm3gsdGguHjcPYeUrqfnJ1Ts/Q8zWqhwu
         +HBU/MNmhVO8smF7opyPX9VNyK1Fp5kiQMn7GyqBpkTvdPA0ydBPoQSBZtdYo8YURLwl
         3tGka8IMoYW/kKnrhIpQ+1XF1sCw+rvBzldSAyrs8wm/GlQyk6fd5/JFQwk3kiF81KnQ
         onxrXDIA4LOqeSja4oFc4zGKVKfBJvfADJh3c6BplTORvbepH/RZojxT33BqibLljLad
         N/H0dfwVeCeFN3AlCaOG/FyxomgOhHkI7xyAvzbNN+fSW8TAoOKjJ6zy166m0yhWGtIt
         787Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OASN1DWXrIyD6gQMB0CvKRtBfiSz7Btq5Vz6GIW00BE=;
        b=nC3ylj74vg38kMsyj0clAM+pgYbHLc/qBKTWG9eDQTEZtZQuGqe7QzQA4cWEXXc7UA
         YccQ2HGjOxbUTvvBqyqkrCznax8aiJEHdRV0RQqBOKgHDj/ZDV31W/l29YqAGxaH3M92
         1+W3ee1yXoX8gRZGAdda/qhAhKcaUR2Y14TTv3NjMKxLvBklGT1QkIA7/5/bBfR0lHTE
         OuKuQOmOeWVwxf8iYPSo1MspP8+MRX/3CTIe+T+HSJv/9x39M6zH/8T0w+4Iro94kUSS
         rvgMHhb4DMKwe9CfO0T73YGcRlwNKtnZZYL3yMXOeKL+wBVtJueWhfX/8rNBp1AOVUkh
         gCzw==
X-Gm-Message-State: AOAM531ju2TjeDen3Z6iZD3nzln7CTudNw66dAl8IjsNxNAyU+OK6l7E
        ya/0yR+L8vB2UzKU1UkkXUJIRZVhgehLEsS8KcQ3YQ==
X-Google-Smtp-Source: ABdhPJzyi89yz4Ys7YmWbiYxSX179Y8R/JtbkovCtO5Snt8v5Te8qZFir2+vrfNRPa3XFPVfkfW/5UQtafjENmEXRYo=
X-Received: by 2002:a2e:9243:: with SMTP id v3mr2195425ljg.47.1633117884418;
 Fri, 01 Oct 2021 12:51:24 -0700 (PDT)
MIME-Version: 1.0
References: <20211001175521.3853257-1-tkjos@google.com> <c6a650e4-15e4-2943-f759-0e9577784c7a@schaufler-ca.com>
 <CAG48ez2tejBUXJGf0R9qpEiauL9-ABgkds6mZTQD7sZKLMdAAQ@mail.gmail.com>
In-Reply-To: <CAG48ez2tejBUXJGf0R9qpEiauL9-ABgkds6mZTQD7sZKLMdAAQ@mail.gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 1 Oct 2021 21:50:58 +0200
Message-ID: <CAG48ez1SRau1Tnge5HVqxCFsNCizmnQLErqnC=eSeERv8jg-zQ@mail.gmail.com>
Subject: Re: [PATCH v2] binder: use cred instead of task for selinux checks
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Todd Kjos <tkjos@google.com>, gregkh@linuxfoundation.org,
        arve@android.com, tkjos@android.com, maco@android.com,
        christian@brauner.io, jmorris@namei.org, serge@hallyn.com,
        paul@paul-moore.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, keescook@chromium.org, jeffv@google.com,
        zohar@linux.ibm.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        kernel-team@android.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 1, 2021 at 9:36 PM Jann Horn <jannh@google.com> wrote:
> On Fri, Oct 1, 2021 at 8:46 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> > On 10/1/2021 10:55 AM, Todd Kjos wrote:
> > > Save the struct cred associated with a binder process
> > > at initial open to avoid potential race conditions
> > > when converting to a security ID.
> > >
> > > Since binder was integrated with selinux, it has passed
> > > 'struct task_struct' associated with the binder_proc
> > > to represent the source and target of transactions.
> > > The conversion of task to SID was then done in the hook
> > > implementations. It turns out that there are race conditions
> > > which can result in an incorrect security context being used.
> >
> > In the LSM stacking patch set I've been posting for a while
> > (on version 29 now) I use information from the task structure
> > to ensure that the security information passed via the binder
> > interface is agreeable to both sides. Passing the cred will
> > make it impossible to do this check. The task information
> > required is not appropriate to have in the cred.
>
> Why not? Why can't you put the security identity of the task into the creds?

Ah, I get it now, you're concerned about different processes wanting
to see security contexts formatted differently (e.g. printing the
SELinux label vs printing the AppArmor label), right?

But still, I don't think you can pull that information from the
receiving task. Maybe the easiest solution would be to also store that
in the creds? Or you'd have to manually grab that information when
/dev/binder is opened.

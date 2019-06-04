Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2B5351DA
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 23:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFDV1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 17:27:06 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36562 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbfFDV1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 17:27:05 -0400
Received: by mail-lj1-f196.google.com with SMTP id i21so6593101ljj.3
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 14:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fjr6VsCXE/x8E/UigyoFfXOlatfjUvy0HOG/EWEq9/E=;
        b=AqnHNsD1VskjlimA3YwkF5JNU3DvSRUk55MoR6ni75AS44QkMcJCvxHI3dSdlI6y5J
         mKW0Es7RWq6sAXJ9MeVUOaPQSf8pexTFCehFbQMkkbeBhb+EWYhswZLPdoe2U/wgnvPd
         T/eBCFdkAAdh/w7SO0Y9hNdRXoDDz3+5dAwXw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fjr6VsCXE/x8E/UigyoFfXOlatfjUvy0HOG/EWEq9/E=;
        b=JFWbfc53F4VioslgD1jh/avfQNA7XX+s1iyyIb0429Yy20PnVC0KxEhcG84SF5ycPg
         92kTRfYgfVDuAfSqVBkSpEaeP7UZCvz4WFkH6lTjZdYz1+6Frg/WZbC925ywaP7KVjrk
         JeiKwnv9N00Qx+3A2DS/OYHf3MCpsR2ZchdFQHWN8Hp5YWZfAHy7CWxNgQYBjO/VWuJy
         EuELttxfpDnmyA+LjA3t/fzI8eDiJPnmzITkTu47qsvj/l5s04+V644wJhacAuH2qwtz
         92YA5lFPM8eApJOGWFv4JT6ZkcLqSjkqxIRq2rNcigtNP89kbSvXm/FIoF6aWnveNUII
         zwng==
X-Gm-Message-State: APjAAAVEkzSgIfPx7bFz8QhcVoJxxbKIKalVgaeDQ8nS5S8uK31N4m4H
        Ig7Cr9T36U1+SibLTNr5Vnz8mSQcouA=
X-Google-Smtp-Source: APXvYqxdUkdUcuWmZqnbVKgARRx/1YNkXkKB4ApYLVmrs8Jz3CqOEikRLZIQ3UEGopUayNXUFHq8hQ==
X-Received: by 2002:a2e:654d:: with SMTP id z74mr2642489ljb.111.1559683623250;
        Tue, 04 Jun 2019 14:27:03 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id c1sm1356784lfh.13.2019.06.04.14.26.59
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 14:27:00 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id y17so17542110lfe.0
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 14:26:59 -0700 (PDT)
X-Received: by 2002:a19:ae01:: with SMTP id f1mr17362076lfc.29.1559683618741;
 Tue, 04 Jun 2019 14:26:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com> <20190604134117.GA29963@redhat.com>
In-Reply-To: <20190604134117.GA29963@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 4 Jun 2019 14:26:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjSOh5zmApq2qsNjmY-GMn4CWe9YwdcKPjT+nVoGiDKOQ@mail.gmail.com>
Message-ID: <CAHk-=wjSOh5zmApq2qsNjmY-GMn4CWe9YwdcKPjT+nVoGiDKOQ@mail.gmail.com>
Subject: Re: [PATCH] signal: remove the wrong signal_pending() check in restore_user_sigmask()
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Davidlohr Bueso <dbueso@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>, e@80x24.org,
        Jason Baron <jbaron@akamai.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, omar.kilani@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 4, 2019 at 6:41 AM Oleg Nesterov <oleg@redhat.com> wrote:
>
> This is the minimal fix for stable, I'll send cleanups later.

Ugh. I htink this is correct, but I wish we had a better and more
intuitive interface.

In particular, since restore_user_sigmask() basically wants to check
for "signal_pending()" anyway (to decide if the mask should be
restored by signal handling or by that function), I really get the
feeling that a lot of these patterns like

> -       restore_user_sigmask(ksig.sigmask, &sigsaved);
> -       if (signal_pending(current) && !ret)
> +
> +       interrupted = signal_pending(current);
> +       restore_user_sigmask(ksig.sigmask, &sigsaved, interrupted);
> +       if (interrupted && !ret)
>                 ret = -ERESTARTNOHAND;

are wrong to begin with, and we really should aim for an interface
which says "tell me whether you completed the system call, and I'll
give you an error return if not".

How about we make restore_user_sigmask() take two return codes: the
'ret' we already have, and the return we would get if there is a
signal pending and w're currently returning zero.

IOW, I think the above could become

        ret = restore_user_sigmask(ksig.sigmask, &sigsaved, ret, -ERESTARTHAND);

instead if we just made the right interface decision.

Hmm?

             Linus

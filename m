Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 384F736D56
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 09:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfFFHan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 03:30:43 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34387 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfFFHan (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 03:30:43 -0400
Received: by mail-wr1-f68.google.com with SMTP id e16so1262145wrn.1;
        Thu, 06 Jun 2019 00:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=Qkp/lfM7R4/9VFytqPJOWBgUswxzuDafgwHDd1VibeQ=;
        b=WM7kXsdm2IIbvcKh7Z43WuKK927dq/t9c1pAayHXiNqiGiEKN1/YGCLmo/j7+JvgUk
         Wpp24mhcJAwa+3PQSNpA0BQ+EurXUl4K56KLUqkb3MRB7jqybjz/5/4iKiTWom//4ZnO
         y18oF5vZiIhWR4uEQn2+fmVojUqWJXhQ1PlNnVUyuOKE+Wwh/Se/Slh3vHQyaOxOhZJM
         Bt5ch+FJNsWpH16pYW2B5hhIDrFu2r5miwCSSPRR3k8L6qHZ3rBl3noqESoNWAVTrjlh
         vj+yKFPkR91Hkp3OiCpepQkXrnzEnXFXZhU/vB1p7FK95eXu63IuIl6cVYBzZ7qBJ3Kf
         2aRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=Qkp/lfM7R4/9VFytqPJOWBgUswxzuDafgwHDd1VibeQ=;
        b=F4o7rXH1ppXYbPbK7+8CaIdYTeKR19WMG2WpeDtWs1szpcqSdXeWCKzRWzC20T1AZc
         mbFqgQ5Bp4HiXPZEBfp6tmjO8maOGUQpMaMzBO/Gk98X3W1+ary6rTgPhrETHhaDcLks
         Y1mZgzykHLsFsArNCgQEZWQAHasQgQQ9r3g6PBs/SXpuhYRRB2KwXzFI/KocLSknsJib
         p9Lay3hmAXun978Y8Br6UX0Wlo2qZhERoo5PCDEI+j+TxxRjdYv4Ps4VR0f9kr0F3Q2y
         dMUNeO1kkqKeFtEp7BhIN7nlwu8MtHvy5egJEIoVIcWCUQPIoLvRh6mmbBbUp8SPynAo
         iQaA==
X-Gm-Message-State: APjAAAWb9AspnvbCFsr184BPJHdv0JzJem+p/RxcnRVNh4d2+lo2YQwM
        P+M12xILc1AnDMQlP6vWOHvBooF8hXeuBejCL3I=
X-Google-Smtp-Source: APXvYqzDQF9AtA/eA6w8ELmIHnhcOffQB0KRrcdedaPzSfFcPn1FEaxo7KqBd8kEnLy5p7QPH1sq+nK/AaRqyKPAnAQ=
X-Received: by 2002:adf:f78d:: with SMTP id q13mr28930531wrp.220.1559806241260;
 Thu, 06 Jun 2019 00:30:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com> <20190604134117.GA29963@redhat.com>
 <20190605155801.GA25165@redhat.com> <20190605155833.GB25165@redhat.com> <20190606072559.GA27021@redhat.com>
In-Reply-To: <20190606072559.GA27021@redhat.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 6 Jun 2019 09:30:29 +0200
Message-ID: <CA+icZUUr5Oma-HEeKOP+2M9SwCEwpeaFkanktp5eCLqkg0O67Q@mail.gmail.com>
Subject: Re: [PATCH -mm 1/1] signal: simplify set_user_sigmask/restore_user_sigmask
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        dbueso@suse.de, axboe@kernel.dk, dave@stgolabs.net, e@80x24.org,
        jbaron@akamai.com, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, omar.kilani@gmail.com, tglx@linutronix.de,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 6, 2019 at 9:28 AM Oleg Nesterov <oleg@redhat.com> wrote:
>
> On 06/05, Oleg Nesterov wrote:
> >
> > +int set_user_sigmask(const sigset_t __user *umask, size_t sigsetsize)
> >  {
> > -     if (!usigmask)
> > -             return 0;
> > +     sigset_t *kmask;
>
> Typo, this obviously should be
>
>         sigset_t kmask;
>
> I'll send v2.
>
>
> Dear Kbuild Test Robot, thank you very much,
>

Machines have emotions, too.

- sed@ -

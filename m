Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 536122C586
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 13:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfE1Lht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 07:37:49 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42115 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726580AbfE1Lht (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 07:37:49 -0400
Received: by mail-pg1-f193.google.com with SMTP id 33so7868816pgv.9;
        Tue, 28 May 2019 04:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Mje4Sqm+Ror3it0+HkeEWilvUO3xfODnH6D7IlgYARg=;
        b=leTTuzrol5cXVn4UToRdkhDMCU1N1h/DSCdgBsc6Gypt7PCMxf1rb6oUc2MEm02j/j
         a0P4UluWuPi1mTg5gFDKg2ssKVD2bFzgD4qfjQKGmjcX+TN/9OBhfmPwtojC8hQwGubu
         Se+O40//DHhIu4Bxqb4i29E0rjnEqxmhWNAIiN6URjejoY8WlInN/I4PfgF4UvY6gXDf
         H4s8+B7KBc+SwY6EbRsJLKEoKYhJI+XQVHpYA5K+jo47SsxPwoUrGpPH4lH0mydQ5TFW
         1gAbzV5B9vT1UFVBYBAspEbwKfhuqs+lNzJfCjcKcKrtoUyUwFT+tz7TWMwCbFU7K7cd
         aSYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Mje4Sqm+Ror3it0+HkeEWilvUO3xfODnH6D7IlgYARg=;
        b=a90SG42aaBXBpEXfyF5Ygom8CcPJ7dtupA5sAwWl4UE9IjJeA+ez88Bsxu0+uqGqNX
         YVflVOAbr8o/V6UlWsXdssEZxEJH2o1KkFENAsB/03WGcRJjE31Iocgb/dm+z18sZJXo
         mIA0OFvuFSsP0KH1RcDsYhPrcguThCmcEDh25/6KFpdGWhrhYKpxXlUf9gsXEbspEzgG
         IVHpxzI2hlt/WMK/R/DkV5iLBBxmOwBtlky549+TrUy2v3bROC+eIyhiFupSPW9KtdIq
         5/aT/35/tT6X+RvBmfxaOQegNT+Q4wkVvC7+frrPNK64F+v2Xen7N+lC9iUOSx6owoY9
         1A/A==
X-Gm-Message-State: APjAAAUiYXCrNOf0O1gaerMzXD0p/2xWOwIS0/PoA6hJpz7RNueYENsK
        hsGPwQsazUaTg0sK88u6lFc=
X-Google-Smtp-Source: APXvYqxJlpHL893t/ouhL8/krnA1DNT9TqKiSJUsi7IgE1NHIFH8jbwf1puz7oIy1c2loyTD9kUbvg==
X-Received: by 2002:a65:42ca:: with SMTP id l10mr77858165pgp.181.1559043468390;
        Tue, 28 May 2019 04:37:48 -0700 (PDT)
Received: from [192.168.86.32] (c-98-234-52-230.hsd1.ca.comcast.net. [98.234.52.230])
        by smtp.gmail.com with ESMTPSA id h11sm14470578pfn.170.2019.05.28.04.37.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 04:37:47 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2] signal: Adjust error codes according to restore_user_sigmask()
From:   Deepa Dinamani <deepa.kernel@gmail.com>
X-Mailer: iPhone Mail (16F203)
In-Reply-To: <ea7a1808990a4c319faa38d5d08d8f19@AcuMS.aculab.com>
Date:   Tue, 28 May 2019 04:37:46 -0700
Cc:     Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "dbueso@suse.de" <dbueso@suse.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>, Eric Wong <e@80x24.org>,
        Jason Baron <jbaron@akamai.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        Omar Kilani <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B9F0F146-C687-4D1D-8BFF-1236564631F6@gmail.com>
References: <20190522161407.GB4915@redhat.com> <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com> <4f7b6dbeab1d424baaebd7a5df116349@AcuMS.aculab.com> <20190523145944.GB23070@redhat.com> <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com> <20190523163604.GE23070@redhat.com> <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com> <CABeXuvo-wey+NHWb4gi=FSRrjJOKkVcLPQ-J+dchJeHEbhGQ6g@mail.gmail.com> <20190524141054.GB2655@redhat.com> <CABeXuvqSzy+v=3Y5NnMmfob7bvuNkafmdDqoex8BVENN3atqZA@mail.gmail.com> <20190524163310.GG2655@redhat.com> <CABeXuvrUKZnECj+NgLdpe5uhKBEmSynrakD-3q9XHqk8Aef5UQ@mail.gmail.com> <ea7a1808990a4c319faa38d5d08d8f19@AcuMS.aculab.com>
To:     David Laight <David.Laight@aculab.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On May 28, 2019, at 2:12 AM, David Laight <David.Laight@aculab.com> wrote:=

>=20
> From: Deepa Dinamani
>> Sent: 24 May 2019 18:02
> ...
>> Look at the code before 854a6ed56839a:
>>=20
>> /*
>>       * If we changed the signal mask, we need to restore the original on=
e.
>>       * In case we've got a signal while waiting, we do not restore the
>>       * signal mask yet, and we allow do_signal() to deliver the signal o=
n
>>       * the way back to userspace, before the signal mask is restored.
>>       */
>>      if (sigmask) {
>>             ####### This err has not been changed since ep_poll()
>>             ####### So if there is a signal before this point, but
>> err =3D 0, then we goto else.
>>              if (err =3D=3D -EINTR) {
>>                      memcpy(&current->saved_sigmask, &sigsaved,
>>                             sizeof(sigsaved));
>>                      set_restore_sigmask();
>>              } else
>>                    ############ This is a problem if there is signal
>> pending that is sigmask should block.
>>                    ########### This is the whole reason we have
>> current->saved_sigmask?
>>                      set_current_blocked(&sigsaved);
>>      }
>=20
> What happens if all that crap is just deleted (I presume from the
> bottom of ep_wait()) ?

Hmm, you have to update the saved_sigmask or the sigmask.

> I'm guessing that on the way back to userspace signal handlers for
> signals enabled in the process's current mask (the one specified
> to epoll_pwait) get called.
> Then the signal mask is loaded from current->saved_sigmask and
> and enabled signal handlers are called again.

Who is saving this saved_sigmask that is being restored on the way back?

> No special code there that depends on the syscall result, errno
> of the syscall number.

I didn=E2=80=99t say this has anything to do with errno.

-Deepa=20


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 704ED4A4C5
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 17:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbfFRPG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 11:06:59 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34324 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbfFRPG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 11:06:58 -0400
Received: by mail-qt1-f196.google.com with SMTP id m29so15745984qtu.1;
        Tue, 18 Jun 2019 08:06:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NSTbZII6CFZgYZ4ha7ois9c79JsFHc6lXj+oBGA25dE=;
        b=Z1v+XDsapzwmyzZpyvkCT3Ed1WrCWHMoDPUhazDasHcyWLLUof9RZlQe9kJVx+i6+I
         h+jphI4o8EgoxzB4OKzd7or1fpBCeQteUCTcAeiNncptmlWedE9SsEqCACHFWb1bOMDV
         zqRxdAyEZHM8/rbuWNUHQJqTLeXe5XaqwyDOTb8b7cjAPnh9TGQw7im/KUfEsyMp3YbY
         sH6omHdJeCrkzkjFAxN2y7ScZZVueVuMwOqnkT7ZYOj2dk4/6kpphaJCA1rGeXbJbHFY
         hvcECK/blg4qU/R5JVo91T/HIi9g1yyLhBdd2Sp0cv42jdT5jexp159dQDc3jKPJYVdD
         JuuA==
X-Gm-Message-State: APjAAAVHOd9++2kvd6VALzN8M7UevNjn8xdho6ccBuW4Q6PCk9f0usDj
        rtDBseO1RrhIAdklzi1dGmny3CM3ECoRmRBuWD4=
X-Google-Smtp-Source: APXvYqyxk5sbuVIhdcXdtak1JiLgBG3rOdIY72VJKoe4UEXZFDi2s9WaEZrSOm8hY+p6d/NV3S9io+PUKYur4PHTigY=
X-Received: by 2002:a0c:87ab:: with SMTP id 40mr26958568qvj.93.1560870417626;
 Tue, 18 Jun 2019 08:06:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190617123109.667090-1-arnd@arndb.de> <20190617140210.GB3436@hirez.programming.kicks-ass.net>
 <CAK8P3a3iwWOkMBL-H3h5aSaHKjKWFce22rvydvVE=3uMfeOhVg@mail.gmail.com>
 <fc10bc69-0628-59eb-c243-9cd1dd3b47a4@virtuozzo.com> <20190618135911.GR3436@hirez.programming.kicks-ass.net>
In-Reply-To: <20190618135911.GR3436@hirez.programming.kicks-ass.net>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 18 Jun 2019 17:06:39 +0200
Message-ID: <CAK8P3a1ZgSYMuD0Xy_fxTqzPhg=U6rqG2Lcfc+3Bni=ZijiE3A@mail.gmail.com>
Subject: Re: [PATCH] ubsan: mark ubsan_type_mismatch_common inline
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 18, 2019 at 3:59 PM Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jun 18, 2019 at 04:27:45PM +0300, Andrey Ryabinin wrote:
> > On 6/18/19 3:56 PM, Arnd Bergmann wrote:
> > > On Mon, Jun 17, 2019 at 4:02 PM Peter Zijlstra <peterz@infradead.org> wrote:

> > I guess this:
> > ccflags-y += $(DISABLE_STACKLEAK_PLUGIN)
>
> Or more specifically this, I guess:
>
> CFLAGS_ubsan.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) $(DISABLE_STACKLEAK_PLUGIN)
>
> we'd not want to exclude all of lib/ from stackleak I figure.
>
> Of these two options, I think I prefer the latter, because a smaller
> whitelist is a better whitelist and since we already disable
> stack protector, it is only consistent to also disable stack leak.

Ok, sounds good to me. Can you send that upstream then, or should
I write it up as a proper patch?

       Arnd

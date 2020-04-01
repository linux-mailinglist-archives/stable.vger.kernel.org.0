Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 022D219B92A
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 01:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732682AbgDAX7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 19:59:31 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41942 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732560AbgDAX7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 19:59:30 -0400
Received: by mail-ed1-f68.google.com with SMTP id v1so1992672edq.8
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 16:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H9rQ+4MX6AGqiS4gDh7zcouPJInPh/6Vm7fyt3tgD0k=;
        b=JX+jSiMzF2RZC7X1UHsV906x8DewgkAwWN6EQ17vLXZEJQX6swhg/zVI1vxFEEZxIH
         PbSD0KAyottCcGb/rT1bEA1sm5NRoFsrhBrQoH3A79V86rZeArdSk7sJvXfa6DN/8YJY
         Q2hGYFvnvtsGpe9Mfmd01M2hX1hq6hVJbWiug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H9rQ+4MX6AGqiS4gDh7zcouPJInPh/6Vm7fyt3tgD0k=;
        b=MrmyZ+yzDBAc2mWutu7XtqS1/xPHNxY/wuIetz3iY8TxkxRsk27brMPrVmBzYrxhBN
         ZFFaFiLsrdQ3/b+WgQYF3ZJqE5bd37LpO9wUzUihctLBpi1P5kNXhqKCEUruLWxgmxIq
         2M64kc2Z4iL59x/7dn+nya8QwKuazgyxyFibAWR//qWpZ1Haf47eDa8023IitLpFyRUJ
         93YJktfMO3zg/N6MVkjR1gaRu0mJroMsCUN44w89A3GUErS7cQtftBW+K2Qf//8GNHvk
         WxqI3n1UR5FZZ72yRMeFcgCEMQSDFNMD9Se/IH128RUj+GaMnaosMbqxBM3PcEc3GXdD
         btZg==
X-Gm-Message-State: AGi0Puby5/rFi7bdqjNgtbtp5POK0dK5PaIXaCISSYKLIvj9NPPVe5Ys
        Iu0T14MrywhdMjvWO7mf8jvvsIuYzyY=
X-Google-Smtp-Source: APiQypLhxrZFUWZb3SoGCaqcI370EdPi3Q/67vQAGd8U3DD8uvkDxYabqhFu8Tbrl2I2hvch5gr9Og==
X-Received: by 2002:a17:906:eb93:: with SMTP id mh19mr599771ejb.323.1585785566579;
        Wed, 01 Apr 2020 16:59:26 -0700 (PDT)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com. [209.85.221.43])
        by smtp.gmail.com with ESMTPSA id j10sm803511ejv.13.2020.04.01.16.59.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 16:59:26 -0700 (PDT)
Received: by mail-wr1-f43.google.com with SMTP id c7so2132525wrx.5
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 16:59:26 -0700 (PDT)
X-Received: by 2002:a2e:8652:: with SMTP id i18mr373016ljj.265.1585785113845;
 Wed, 01 Apr 2020 16:51:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200324215049.GA3710@pi3.com.pl> <202003291528.730A329@keescook>
 <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org> <CAG48ez3nYr7dj340Rk5-QbzhsFq0JTKPf2MvVJ1-oi1Zug1ftQ@mail.gmail.com>
In-Reply-To: <CAG48ez3nYr7dj340Rk5-QbzhsFq0JTKPf2MvVJ1-oi1Zug1ftQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 1 Apr 2020 16:51:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjz0LEi68oGJSQzZ--3JTFF+dX2yDaXDRKUpYxtBB=Zfw@mail.gmail.com>
Message-ID: <CAHk-=wjz0LEi68oGJSQzZ--3JTFF+dX2yDaXDRKUpYxtBB=Zfw@mail.gmail.com>
Subject: Re: [PATCH] signal: Extend exec_id to 64bits
To:     Jann Horn <jannh@google.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Luc Maranget <luc.maranget@inria.fr>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Daniel Lustig <dlustig@nvidia.com>,
        Adam Zabrocki <pi3@pi3.com.pl>,
        kernel list <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 1, 2020 at 4:37 PM Jann Horn <jannh@google.com> wrote:
>
> GCC will generate code for this without complaining, but I think it'll
> probably generate a tearing store on 32-bit platforms:

This is very much a "we don't care" case.

It's literally testing a sequence counter for equality. If you get
tearing in the high bits on the write (or the read), you'd still need
to have the low bits turn around 4G times to get a matching value.

So no. We're not doing atomics for the 32-bit case. That's insane.

               Linus

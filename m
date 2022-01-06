Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF384867E5
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 17:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241410AbiAFQt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 11:49:58 -0500
Received: from mail-qk1-f178.google.com ([209.85.222.178]:43712 "EHLO
        mail-qk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241355AbiAFQt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 11:49:58 -0500
Received: by mail-qk1-f178.google.com with SMTP id f138so3216216qke.10;
        Thu, 06 Jan 2022 08:49:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N/hDRMdEEbLIAMnZ4qCmdQf1B912hBsBwG7sO0+3zH0=;
        b=c/876aI7p1JdJhdJjQYI+4i2VchzcJP/2KRGs58HS+WU1vYngNAZx02vThsI/LqLkO
         GVHk9iY2UcDJ/yvN+T1wOiGqM/2HvQkRgth3XlNpP61mgVfJyAY5PKooe0i/daYHe450
         R5C+mnZvZm+508ID30y3IQfKLEjaoZVPRlc1oZd5CPfXL8zIURCowBYvMrbDPq7pDgWm
         05ym0B84OhJprsYnjjPZZIQ/SQfkaZFJOUHxd/cmMDLMMNAo1kVD4fG2emjcnEVk7/bi
         tJQTMqCgr0W3q72vW7Qb0crYGrG2WfAJFCtRq42LYQ3GC7VY3b5A8Li+6yMiGbnFpcE7
         s5Xg==
X-Gm-Message-State: AOAM5312FtRX2eseJsSjXcK5F2S6tFKL5uPwaJ+0QdBBADAM6ifzrhGT
        JQXsGLEg8mvvBealZ4HZfZKVZYXf4vKDYjVtu4Y=
X-Google-Smtp-Source: ABdhPJzaaUNaQ7I5dPWpR3fsZQ3SO2syFakaukmJid0nAQDW0aDtiT8tvFSe1wVtHX03PxENyHku9Gc9kockvsKVbyg=
X-Received: by 2002:a37:dc45:: with SMTP id v66mr41550178qki.516.1641487797256;
 Thu, 06 Jan 2022 08:49:57 -0800 (PST)
MIME-Version: 1.0
References: <20220106074306.2712090-1-ray.huang@amd.com> <20220106074306.2712090-2-ray.huang@amd.com>
 <Ydbdq6lXPKFG98MY@zn.tnic> <Ydb+rHXsXqxzmR0V@amd.com> <YdcC2JK7sOFs292B@amd.com>
 <YdcQz7VQEbA+K73X@zn.tnic> <CAJZ5v0hNoQmjBCYvLKaR3__6H1xe_+ySHHphjSRjvnXApsK5cQ@mail.gmail.com>
 <YdcWy0wSKSO3nzbU@zn.tnic>
In-Reply-To: <YdcWy0wSKSO3nzbU@zn.tnic>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 6 Jan 2022 17:49:46 +0100
Message-ID: <CAJZ5v0jOHGHCrAkvOkEaHNbUOX_Z3Paj9HbtRMSTojHWu=8TSw@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86, sched: Fix the undefined reference building
 error of init_freq_invariance_cppc
To:     Borislav Petkov <bp@alien8.de>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Huang Rui <ray.huang@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yuan, Perry" <Perry.Yuan@amd.com>,
        "Su, Jinzhou (Joe)" <Jinzhou.Su@amd.com>,
        "Du, Xiaojian" <Xiaojian.Du@amd.com>,
        kernel test robot <lkp@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 6, 2022 at 5:23 PM Borislav Petkov <bp@alien8.de> wrote:
>
> On Thu, Jan 06, 2022 at 05:12:51PM +0100, Rafael J. Wysocki wrote:
> > And why can't it be a real use case?
>
> You mean there's someone out there running SMP=n kernels on current
> hardware which has CPPC too? Yeah, right.
>
> > The honest answer is that we don't know.
> >
> > Moreover, AFAICS the requisite #ifdeffery is there already and  the
> > problem is that the init_freq_invariance_cppc() defined in smpboot.c
> > is not exported to modules and the CPPC code is modular in this build.
>
> Yah, I saw that. And that's why I'm saying CPPC should depend on SMP -
> because it needs that functionality which is defined there.

In fact, the CPPC code itself doesn't need that functionality.

The init_freq_invariance_cppc() call is in there, because
amd_set_max_freq_ratio() depends on CPPC and it is pointless to run it
when CPPC is not supported, not the other way around.

> But if you really wanna support SMP=n, I don't care that much to debate
> this more - I just think it is silly.

Well, I just don't want to stop supporting SMP=n just because we can't
possibly get our build dependencies right.

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF619486772
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 17:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241065AbiAFQNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 11:13:04 -0500
Received: from mail-qk1-f176.google.com ([209.85.222.176]:42543 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240952AbiAFQNE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 11:13:04 -0500
Received: by mail-qk1-f176.google.com with SMTP id r139so3103021qke.9;
        Thu, 06 Jan 2022 08:13:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DJCfqX+Wa4LqLt+UmJ+dRCTEjOf3YUWFiZmbxIVnFbE=;
        b=AAH5eISEZEXDVRafu+2bDPN40d/Sd/3lDLZ4RgbDN0askce0cLkObVeOspQSjUddm1
         JxbpGmG/r50YRMJZSuUQKkpmgHWPUqnc9v8iZPTNlxs3Wior9oRQYkEttKBTYkHpW0Qh
         6cEaaMfKVCpMoB6OQ7tc4wgtuXe7G9cL7Z/On+AJ6bWNnv40BiIudWhLGImCE1RWXujx
         f3m/RzJOAuVnXMcxd7MEg05U+RpSg+2ibvyry5wL/h1KB+H0Kg33wZMqxmPk8wn7ER53
         DqiAUMcxK2RFbjAl65sQWnLhhfSMapz1rggOb7+s+FczSxCP0ANn5owaVBsirmfkc6xU
         CuNA==
X-Gm-Message-State: AOAM533w0lwQjHqy5uk4rb1fHx9TOTsPuBDaae/gI8nDV63ZFjQkHOiU
        ILfdYcj1K5gxCxHCviPR3l0ROaaeI6XJt80j1/0=
X-Google-Smtp-Source: ABdhPJzhOsfK0Wy32733m2RPCwZt2K4AHlmWYFsenyWA09yzxb2wT3l6e8LHosFF2/UuxokLcehPl6h7gVs0EiiamIw=
X-Received: by 2002:a37:b702:: with SMTP id h2mr42668959qkf.135.1641485583213;
 Thu, 06 Jan 2022 08:13:03 -0800 (PST)
MIME-Version: 1.0
References: <20220106074306.2712090-1-ray.huang@amd.com> <20220106074306.2712090-2-ray.huang@amd.com>
 <Ydbdq6lXPKFG98MY@zn.tnic> <Ydb+rHXsXqxzmR0V@amd.com> <YdcC2JK7sOFs292B@amd.com>
 <YdcQz7VQEbA+K73X@zn.tnic>
In-Reply-To: <YdcQz7VQEbA+K73X@zn.tnic>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 6 Jan 2022 17:12:51 +0100
Message-ID: <CAJZ5v0hNoQmjBCYvLKaR3__6H1xe_+ySHHphjSRjvnXApsK5cQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86, sched: Fix the undefined reference building
 error of init_freq_invariance_cppc
To:     Borislav Petkov <bp@alien8.de>
Cc:     Huang Rui <ray.huang@amd.com>,
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

On Thu, Jan 6, 2022 at 4:55 PM Borislav Petkov <bp@alien8.de> wrote:
>
> On Thu, Jan 06, 2022 at 10:55:20PM +0800, Huang Rui wrote:
> > I just thought the CPPC function should be able to work on single core even
> > SMP is disabled.
>
> Why, because SMP=n is a real use case?!

And why can't it be a real use case?

> FWIW, we were even speculating on removing SMP=n so how practical is
> using CPPC on SMP=n at all?

The honest answer is that we don't know.

Moreover, AFAICS the requisite #ifdeffery is there already and  the
problem is that the init_freq_invariance_cppc() defined in smpboot.c
is not exported to modules and the CPPC code is modular in this build.

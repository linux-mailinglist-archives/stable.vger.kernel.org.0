Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9622548678D
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 17:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241137AbiAFQXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 11:23:04 -0500
Received: from mail.skyhub.de ([5.9.137.197]:38200 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241113AbiAFQXE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jan 2022 11:23:04 -0500
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AA8C01EC01B7;
        Thu,  6 Jan 2022 17:22:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1641486178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=h6YuYIy4qcaO/MGkQsefP3agMS1G0w2fptdzhSDRDRs=;
        b=d3yhd+T7AyXbGMUkLegGU0B807PMTThQN6H6mg6xhmzvM8OrcEYliQekclOwWqPliHZ1B9
        8ky13olLLtXegUnU/jwAwF5oeFLdqJPpUkFYH6S9rDfAJaTRVkJ7SOUwig1asNctBacq1u
        MA9bHW/H1EwTb/5VUjV9ilsfVkk95mo=
Date:   Thu, 6 Jan 2022 17:23:01 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
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
Subject: Re: [PATCH 2/2] x86, sched: Fix the undefined reference building
 error of init_freq_invariance_cppc
Message-ID: <YdcWy0wSKSO3nzbU@zn.tnic>
References: <20220106074306.2712090-1-ray.huang@amd.com>
 <20220106074306.2712090-2-ray.huang@amd.com>
 <Ydbdq6lXPKFG98MY@zn.tnic>
 <Ydb+rHXsXqxzmR0V@amd.com>
 <YdcC2JK7sOFs292B@amd.com>
 <YdcQz7VQEbA+K73X@zn.tnic>
 <CAJZ5v0hNoQmjBCYvLKaR3__6H1xe_+ySHHphjSRjvnXApsK5cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJZ5v0hNoQmjBCYvLKaR3__6H1xe_+ySHHphjSRjvnXApsK5cQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 06, 2022 at 05:12:51PM +0100, Rafael J. Wysocki wrote:
> And why can't it be a real use case?

You mean there's someone out there running SMP=n kernels on current
hardware which has CPPC too? Yeah, right.

> The honest answer is that we don't know.
>
> Moreover, AFAICS the requisite #ifdeffery is there already and  the
> problem is that the init_freq_invariance_cppc() defined in smpboot.c
> is not exported to modules and the CPPC code is modular in this build.

Yah, I saw that. And that's why I'm saying CPPC should depend on SMP -
because it needs that functionality which is defined there.

But if you really wanna support SMP=n, I don't care that much to debate
this more - I just think it is silly.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

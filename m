Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65828119198
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 21:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfLJUNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 15:13:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:45192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbfLJUNC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 15:13:02 -0500
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 834FF2073D;
        Tue, 10 Dec 2019 20:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576008781;
        bh=vJ3KhnKNnbZTTPI7grFEjsDwO4KNsvu73+dwh+qaYb0=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=Ylcp4vyIt/GhiU64FesmDccwqfmRX6TcfjKoBxFKsRUF+3qvggWee5XHSTqU3Psy3
         B7VtYVpYg5ghV28uk+27m1CmXj0GVPL/PyT2GewXFEZBu/0mPJnO4uBvsvkGqomnON
         TtIZH/wDrB146Nt79GWDQkDRZSExC3/Sc8Jug/eQ=
Date:   Tue, 10 Dec 2019 21:12:57 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
cc:     Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@ucw.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpu/SMT: fix x86 link error without CONFIG_SYSFS
In-Reply-To: <20191210195614.786555-1-arnd@arndb.de>
Message-ID: <nycvar.YFH.7.76.1912102111480.4603@cbobk.fhfr.pm>
References: <20191210195614.786555-1-arnd@arndb.de>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Dec 2019, Arnd Bergmann wrote:

> When CONFIG_SYSFS is disabled, but CONFIG_HOTPLUG_SMT is enabled,
> the kernel fails to link:

I wonder where such kernels are running ... or I rather don't :)

> arch/x86/power/cpu.o: In function `hibernate_resume_nonboot_cpu_disable':
> (.text+0x38d): undefined reference to `cpuhp_smt_enable'
> arch/x86/power/hibernate.o: In function `arch_resume_nosmt':
> hibernate.c:(.text+0x291): undefined reference to `cpuhp_smt_enable'
> hibernate.c:(.text+0x29c): undefined reference to `cpuhp_smt_disable'
> 
> Move the exported functions out of the #ifdef section into its
> own with the correct conditions.
> 
> The patch that caused this is marked for stable backports, so
> this one may need to be backported as well.
> 
> Fixes: ec527c318036 ("x86/power: Fix 'nosmt' vs hibernation triple fault during resume")

Reviewed-by: Jiri Kosina <jkosina@suse.cz>

Thanks for fixing my oversight.

-- 
Jiri Kosina
SUSE Labs


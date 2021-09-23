Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA10C415C2B
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 12:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240314AbhIWKsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 06:48:19 -0400
Received: from mail-ot1-f43.google.com ([209.85.210.43]:40761 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236299AbhIWKsT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Sep 2021 06:48:19 -0400
Received: by mail-ot1-f43.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so7905046otq.7;
        Thu, 23 Sep 2021 03:46:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8FDqbPPfgY3pejKZetLrTHwXBJAmfhHC9zFdI7YO2gg=;
        b=eELZEFCPIeNtaX8+OExCAYrdIsIbaAJpfI6PSkOcKYQkCGMtSHXZHt0Eu9lWftFmO4
         mUlyFd0jQTU8yW8CqC7tL9oKSBEuXgyDRfhb1+Acrc4pV4YS4s2xxrMOzV1fht2M/uKt
         tiN4qKlGzSzfTmxbLexlwf80uCVT/UrZ7GqIi4wyJ3b00+iMei3q/nx3xsgQWu2O0gay
         bhu1HroC/zubEslp9oVORDLxnS99/QMKtBQYyUq7uHBrPM7m33N6c+npryvUrCCyHb1T
         bZdu13jdB1aD0sNAclrftxMdWBHiXACVxBkELiA12AtaVZt2W6tGmALo5EitOdK2ymHT
         AOaQ==
X-Gm-Message-State: AOAM533eKgKaX8ZxGbaxqCQjpuooXaLuDh3029j8cafiBGf6Gts/vkHe
        xIPvhoKxIZKZvPf3WLLZvvyzIsoo2zdp4h909XXbjYL6rEg=
X-Google-Smtp-Source: ABdhPJz0pZcCTAPVYvqlS6jADguPIMCnyOId+dZCfiR7WnAoAofa60SkwdI2macPlm7ZJcg1N2DkCwotwpFasCNQHZY=
X-Received: by 2002:a05:6830:165a:: with SMTP id h26mr3770156otr.301.1632394007773;
 Thu, 23 Sep 2021 03:46:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210916131739.1260552-1-kuba@kernel.org> <20210916150707.GA1611532@bjorn-Precision-5520>
 <YURb1bzc3L4gNI9Q@hirez.programming.kicks-ass.net> <YURhL33YyXRMkdC6@hirez.programming.kicks-ass.net>
 <87v92x775x.ffs@tglx> <82c1b753-586d-dadf-54de-6509e70a00ea@intel.com>
 <87y27p65tz.ffs@tglx> <CAJZ5v0iFoz=mjkMmtM3knUAVsbAnAb1RSr4WQ1jLHXSJa4R2Nw@mail.gmail.com>
 <87sfxwgsjy.ffs@tglx>
In-Reply-To: <87sfxwgsjy.ffs@tglx>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 23 Sep 2021 12:46:36 +0200
Message-ID: <CAJZ5v0g2nNHSpckhx=KHpk1OAX0sHKpjh3hHmKbK9cPDQLH1vw@mail.gmail.com>
Subject: Re: [PATCH] x86/intel: Disable HPET on another Intel Coffee Lake platform
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>, jose.souza@intel.com,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>, rudolph@fb.com,
        xapienz@fb.com, bmilton@fb.com, Stable <stable@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 23, 2021 at 12:21 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Wed, Sep 22 2021 at 22:27, Rafael J. Wysocki wrote:
> > On Tue, Sep 21, 2021 at 10:18 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> >>
> >> On Tue, Sep 21 2021 at 20:05, Rafael J. Wysocki wrote:
> >> > On 9/19/2021 2:14 AM, Thomas Gleixner wrote:
> >> >> What's the proper way to figure out whether PC10 is supported?
> >> >
> >> > I can't say without research.  I think it'd be sufficient to check if
> >> > C10 is supported, because asking for it is the only way to get PC10.
> >>
> >> Do we have a common function for that or do I need to implement the
> >> gazillionst CPUID query for that?
> >
> > intel_idle has intel_idle_verify_cstate() that works on MWAIT
> > substates from CPUID.  It looks like this could be reused.
>
> Not to me. That's some cpuidle/intel_idle specific check which depends
> on cpuidle_state_table

No, it doesn't.  The only thing this depends on is mwait_substates
which directly comes from the CPUID evaluation in intel_idle_init().
The argument is an MWAIT hint, but it doesn't have to be one, it could
be a state number.

Anyway, this is just part of what is needed.

So the way to check the PC10 support is to get the mask of MWAIT
substates from CPUID (like in intel_idle_init()) and check if there
are any substates for C10 in that mask and check if PC10 is enabled in
MSR_PKG_CST_CONFIG_CONTROL (like in sklh_idle_state_table_update()).

The MWAIT substates checking part could then be used by intel_idle
(and maybe by ACPI idle too).

> being set up which is not available during early boot.

> The question I was asking whether we have a central place where we can
> retrieve such information w/o invoking CPUID over and over again and
> applying voodoo checks on it.
>
> Obviously we don't, which sucks.

Well, nobody except for intel_idle wanted it, so there was not much
point doing it centrally for just one user.

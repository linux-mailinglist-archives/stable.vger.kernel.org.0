Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA78415164
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 22:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237597AbhIVU3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 16:29:39 -0400
Received: from mail-oi1-f172.google.com ([209.85.167.172]:42998 "EHLO
        mail-oi1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237450AbhIVU3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 16:29:39 -0400
Received: by mail-oi1-f172.google.com with SMTP id x124so6323648oix.9;
        Wed, 22 Sep 2021 13:28:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PVvAETIcMUeDmCZ+37Ynt/nUJIZCCbsJtnlDUFE1KQc=;
        b=jsTiLJ5lYQNVWFvt59lvEMAK1CiI/aKlDsvNiTHVHwzakraSuXb/mFPYZgDb7PplrQ
         0jNh4O1ViJO6jyNl/ozrn8ATMXR/3c6V9Qf3kFhNEkCdQp7iOx4tZRn0S3rrGo5sMQrA
         N/ctPmSK9xvpbOkvt8q4o3YmiKgc9UWvM8iU+m7TZ2C6bh2Tfk2E2rQDpXW5IHoHM7zt
         O5lCpVXhcXbJiUs1ILqaHnS8hj2Bp2lLXG9AWyIZ3G+7A35hrM+0JI+ZA139+1t5fpeT
         hc88wA+gW4srOuEhN3MlRgjZoqfuGsPoWV0QaAOnAdAGkb29usK1yadaWKXZjDI/7FCB
         QxXA==
X-Gm-Message-State: AOAM532QBkjAmgIjsQ0WqIQMERu49//jk51QZabHLYj1nMUIydlyQ/Hm
        uWh5VmjyrqWflK1JN+tuCszjGFlpEUbQlIy3Cv8=
X-Google-Smtp-Source: ABdhPJxEXwxPD9HCS0xX2D9hXVuShXMTtSYEYJv+5co192dSqq+P4ihRC+SXnBF4gedGBl4o+tHhKw6of/f5oU1Ds3Y=
X-Received: by 2002:a54:4f89:: with SMTP id g9mr866460oiy.71.1632342488655;
 Wed, 22 Sep 2021 13:28:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210916131739.1260552-1-kuba@kernel.org> <20210916150707.GA1611532@bjorn-Precision-5520>
 <YURb1bzc3L4gNI9Q@hirez.programming.kicks-ass.net> <YURhL33YyXRMkdC6@hirez.programming.kicks-ass.net>
 <87v92x775x.ffs@tglx> <82c1b753-586d-dadf-54de-6509e70a00ea@intel.com> <87y27p65tz.ffs@tglx>
In-Reply-To: <87y27p65tz.ffs@tglx>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 22 Sep 2021 22:27:57 +0200
Message-ID: <CAJZ5v0iFoz=mjkMmtM3knUAVsbAnAb1RSr4WQ1jLHXSJa4R2Nw@mail.gmail.com>
Subject: Re: [PATCH] x86/intel: Disable HPET on another Intel Coffee Lake platform
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
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
        Tom Lendacky <thomas.lendacky@amd.com>,
        "rafael@kernel.org" <rafael@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 21, 2021 at 10:18 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Tue, Sep 21 2021 at 20:05, Rafael J. Wysocki wrote:
> > On 9/19/2021 2:14 AM, Thomas Gleixner wrote:
> >> What's the proper way to figure out whether PC10 is supported?
> >
> > I can't say without research.  I think it'd be sufficient to check if
> > C10 is supported, because asking for it is the only way to get PC10.
>
> Do we have a common function for that or do I need to implement the
> gazillionst CPUID query for that?

intel_idle has intel_idle_verify_cstate() that works on MWAIT
substates from CPUID.  It looks like this could be reused.

> > However, even if it is supported, the problem is not there until the
> > kernel asks for C10.  So instead, I'd disable the TSC watchdog on the
> > first attempt to ask the processor for C10 from the cpuidle code and I'd
> > do that from the relevant drivers (intel_idle and ACPI idle).
> >
> > There would be no TSC watchdog for the C10 users, but wouldn't that be a
> > fair game?
>
> Not really because that makes any other HPET usage broken as well and we
> can't pull the rug under that. So we are better off to disable it
> upfront.

Allright.

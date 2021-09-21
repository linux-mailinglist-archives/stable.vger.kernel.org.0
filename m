Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB222413B28
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 22:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbhIUUTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 16:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhIUUTe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 16:19:34 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EB7C061574;
        Tue, 21 Sep 2021 13:18:05 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1632255480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=67IOLtaPIvhIQA7RM1tao77N2A9CpuqkDUMxead9pQ4=;
        b=fXVUDpwUHEEgXy4ijPZP4BpMAgzgO/DbBvnqiVfv6uKQYlfkdcTInp6b32XLUoITTIuLQH
        dpWAhgR7vAiQ0ABLXeplqggdVcKrTPkhn5wclzIgIueJ0drY53n3g0MkpMvNExsPLA144K
        SRdByQtzdMlHYaXKdGLdmFX5LOR06nahNhYzerwhiYALhMcMe7x6sm8ynj8MxRTrX1vgyZ
        XLeUqSomOBmF/M1fMiMd0LeJ9EK9+pPL7GCNMQUcI6oeNi8cK5PPVuA74EZnaVrCn5a/Sc
        RD9NBiqRPhRkDMAHeG6wz5jEl5bu+LXPYOK2nrMPkBZsGJ7addceb3bVipdQ3A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1632255480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=67IOLtaPIvhIQA7RM1tao77N2A9CpuqkDUMxead9pQ4=;
        b=g8KM/A8yhw2AEFLMKDT3/nmqyCSgFiiaJUKJe5aEtlFS02a7w08qNLUAmfL5vwhjkYTNWy
        6FCoIGlYDzbiBGBw==
To:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Bjorn Helgaas <helgaas@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, x86@kernel.org,
        jose.souza@intel.com, hpa@zytor.com, bp@alien8.de,
        mingo@redhat.com, kai.heng.feng@canonical.com, bhelgaas@google.com,
        linux-pci@vger.kernel.org, rudolph@fb.com, xapienz@fb.com,
        bmilton@fb.com, stable@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "rafael@kernel.org" <rafael@kernel.org>
Subject: Re: [PATCH] x86/intel: Disable HPET on another Intel Coffee Lake
 platform
In-Reply-To: <82c1b753-586d-dadf-54de-6509e70a00ea@intel.com>
References: <20210916131739.1260552-1-kuba@kernel.org>
 <20210916150707.GA1611532@bjorn-Precision-5520>
 <YURb1bzc3L4gNI9Q@hirez.programming.kicks-ass.net>
 <YURhL33YyXRMkdC6@hirez.programming.kicks-ass.net> <87v92x775x.ffs@tglx>
 <82c1b753-586d-dadf-54de-6509e70a00ea@intel.com>
Date:   Tue, 21 Sep 2021 22:18:00 +0200
Message-ID: <87y27p65tz.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 21 2021 at 20:05, Rafael J. Wysocki wrote:
> On 9/19/2021 2:14 AM, Thomas Gleixner wrote:
>> What's the proper way to figure out whether PC10 is supported?
>
> I can't say without research.=C2=A0 I think it'd be sufficient to check i=
f=20
> C10 is supported, because asking for it is the only way to get PC10.

Do we have a common function for that or do I need to implement the
gazillionst CPUID query for that?

> However, even if it is supported, the problem is not there until the=20
> kernel asks for C10.=C2=A0 So instead, I'd disable the TSC watchdog on th=
e=20
> first attempt to ask the processor for C10 from the cpuidle code and I'd=
=20
> do that from the relevant drivers (intel_idle and ACPI idle).
>
> There would be no TSC watchdog for the C10 users, but wouldn't that be a=
=20
> fair game?

Not really because that makes any other HPET usage broken as well and we
can't pull the rug under that. So we are better off to disable it
upfront.

Thanks,

        tglx

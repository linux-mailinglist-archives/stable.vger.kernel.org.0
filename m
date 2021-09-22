Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD6A41534F
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 00:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238296AbhIVWXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 18:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238293AbhIVWXK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 18:23:10 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B33C061574;
        Wed, 22 Sep 2021 15:21:39 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1632349298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0A6qByAjupG5ZLznnStIKLY1X8Qel1/Sug5VuQBE2dA=;
        b=FAC6stJzb16S5VN9VA4cYLEPKiuJ7YST9bvrH7P/nTQyc1a945nwPe5w0JdcdIimC42aAx
        na5h3WSbyuqP2qXbOiZexv6sd6CDjXaykK6U6TaZ2Tggf00yp/tXXxO31SVTXfJgnGslMP
        UskPRaNQaiyzxPsCNlNiBgKvQ3CrhyzPnhmYSdPuaf2f9ANa1S+vtLnrZX2GcY7AWZJMEo
        Wckz0X+XHumePRBRTI40zq2Zf4PKCWqUgvoGuMyK5sYd8ohbTWf2ilcv+uIwrqAYxMxwKh
        r1teJ5+OVdurfHwV9YEIzs2tKWRXhTCfk8IMBfmarnONrxMHzWj9Rrs3tQtpMw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1632349298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0A6qByAjupG5ZLznnStIKLY1X8Qel1/Sug5VuQBE2dA=;
        b=qTQwlYwfvHFWjde9GzRO44+mLYwFzGtg/y8pgV0QMduMbpkKkr7I/iGZA00lCEzfWPEFJg
        EAJLfoO6zE/c6JDw==
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        jose.souza@intel.com, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>, rudolph@fb.com,
        xapienz@fb.com, bmilton@fb.com, Stable <stable@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "rafael@kernel.org" <rafael@kernel.org>
Subject: Re: [PATCH] x86/intel: Disable HPET on another Intel Coffee Lake
 platform
In-Reply-To: <CAJZ5v0iFoz=mjkMmtM3knUAVsbAnAb1RSr4WQ1jLHXSJa4R2Nw@mail.gmail.com>
References: <20210916131739.1260552-1-kuba@kernel.org>
 <20210916150707.GA1611532@bjorn-Precision-5520>
 <YURb1bzc3L4gNI9Q@hirez.programming.kicks-ass.net>
 <YURhL33YyXRMkdC6@hirez.programming.kicks-ass.net> <87v92x775x.ffs@tglx>
 <82c1b753-586d-dadf-54de-6509e70a00ea@intel.com> <87y27p65tz.ffs@tglx>
 <CAJZ5v0iFoz=mjkMmtM3knUAVsbAnAb1RSr4WQ1jLHXSJa4R2Nw@mail.gmail.com>
Date:   Thu, 23 Sep 2021 00:21:37 +0200
Message-ID: <87sfxwgsjy.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 22 2021 at 22:27, Rafael J. Wysocki wrote:
> On Tue, Sep 21, 2021 at 10:18 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>> On Tue, Sep 21 2021 at 20:05, Rafael J. Wysocki wrote:
>> > On 9/19/2021 2:14 AM, Thomas Gleixner wrote:
>> >> What's the proper way to figure out whether PC10 is supported?
>> >
>> > I can't say without research.  I think it'd be sufficient to check if
>> > C10 is supported, because asking for it is the only way to get PC10.
>>
>> Do we have a common function for that or do I need to implement the
>> gazillionst CPUID query for that?
>
> intel_idle has intel_idle_verify_cstate() that works on MWAIT
> substates from CPUID.  It looks like this could be reused.

Not to me. That's some cpuidle/intel_idle specific check which depends
on cpuidle_state_table being set up which is not available during early
boot.

The question I was asking whether we have a central place where we can
retrieve such information w/o invoking CPUID over and over again and
applying voodoo checks on it.

Obviously we don't, which sucks.

Thanks,

        tglx


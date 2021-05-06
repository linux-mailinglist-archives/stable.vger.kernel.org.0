Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89D8375B0E
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 21:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbhEFTA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 15:00:57 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53778 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbhEFTA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 15:00:56 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lejDx-006IlB-FL; Thu, 06 May 2021 12:59:49 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lejDv-007wor-20; Thu, 06 May 2021 12:59:48 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        kexec@lists.infradead.org, stable@vger.kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20210506093122.28607-1-joro@8bytes.org>
        <20210506093122.28607-3-joro@8bytes.org>
        <m17dkb4v4k.fsf@fess.ebiederm.org> <YJQ4QTtvG76WpcNf@suse.de>
Date:   Thu, 06 May 2021 13:59:42 -0500
In-Reply-To: <YJQ4QTtvG76WpcNf@suse.de> (Joerg Roedel's message of "Thu, 6 May
        2021 20:41:05 +0200")
Message-ID: <m1o8dn1ye9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lejDv-007wor-20;;;mid=<m1o8dn1ye9.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+QSetsVGHHRPIqFsnfIS69iprRKQZBDtk=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.2 required=8.0 tests=ALL_TRUSTED,BAYES_40,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMNoVowels,
        XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        * -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
        *      [score: 0.3011]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Joerg Roedel <jroedel@suse.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1515 ms - load_scoreonly_sql: 0.07 (0.0%),
        signal_user_changed: 11 (0.7%), b_tie_ro: 10 (0.6%), parse: 0.96
        (0.1%), extract_message_metadata: 13 (0.9%), get_uri_detail_list: 1.98
        (0.1%), tests_pri_-1000: 6 (0.4%), tests_pri_-950: 1.32 (0.1%),
        tests_pri_-900: 1.14 (0.1%), tests_pri_-90: 132 (8.7%), check_bayes:
        122 (8.1%), b_tokenize: 10 (0.7%), b_tok_get_all: 10 (0.7%),
        b_comp_prob: 3.3 (0.2%), b_tok_touch_all: 95 (6.2%), b_finish: 0.98
        (0.1%), tests_pri_0: 1335 (88.1%), check_dkim_signature: 0.59 (0.0%),
        check_dkim_adsp: 2.4 (0.2%), poll_dns_idle: 0.57 (0.0%), tests_pri_10:
        3.1 (0.2%), tests_pri_500: 8 (0.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 2/2] x86/kexec/64: Forbid kexec when running as an SEV-ES guest
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Joerg Roedel <jroedel@suse.de> writes:

> On Thu, May 06, 2021 at 12:42:03PM -0500, Eric W. Biederman wrote:
>> I don't understand this.
>> 
>> Fundamentally kexec is about doing things more or less inspite of
>> what the firmware is doing.
>> 
>> I don't have any idea what a SEV-ES is.  But the normal x86 boot doesn't
>> do anything special.  Is cross cpu IPI emulation buggy?
>
> Under SEV-ES the normal SIPI-based sequence to re-initialize a CPU does
> not work anymore. An SEV-ES guest is a special virtual machine where the
> hardware encrypts the guest memory and the guest register state. The
> hypervisor can't make any modifications to the guests registers at
> runtime. Therefore it also can't emulate a SIPI sequence and reset the
> vCPU.
>
> The guest kernel has to reset the vCPU itself and hand it over from the
> old kernel to the kexec'ed kernel. This isn't currently implemented and
> therefore kexec needs to be disabled when running as an SEV-ES guest.
>
> Implementing this also requires an extension to the guest-hypervisor
> protocol (the GHCB Spec[1]) which is only available in version 2. So a
> guest running on a hypervisor supporting only version 1 will never
> properly support kexec.

Why does it need that?

Would it not make sense to instead teach kexec how to pass a cpu from
one kernel to another.  We could use that everywhere.

Even the kexec-on-panic case should work as even in that case we have
to touch the cpus as they go down.

The hardware simply worked well enough that it hasn't mattered enough
for us to do something like that, but given that we need to do something
anyway.  It seems like it would make most sense do something that
will work everywhere, and does not introduce unnecessary dependencies
on hypervisors.

>> What is the actual problem you are trying to avoid?
>
> Currently, if someone tries kexec in an SEV-ES guest, the kexec'ed
> kernel will only be able to bring up the boot CPU, not the others. The
> others will wake up with the old kernels CPU state in the new kernels
> memory and do undefined things, most likely triple-fault because their
> page-table is not existent anymore.
>
> So since kexec currently does not work as expected under SEV-ES, it is
> better to hide it until everything is implemented so it can do what the
> user expects.

I can understand temporarily disabling the functionality.

>> And yes for a temporary hack the suggestion of putting code into
>> machine_kexec_prepare seems much more reasonable so we don't have to
>> carry special case infrastructure for the forseeable future.
>
> As I said above, for protocol version 1 it will stay disabled, so it is
> not only a temporary hack.

Why does bringing up a cpu need hypervisor support?

I understand why we can't do what we do currently, but that doesn't seem
to preclude doing something without hypervisor support.

Eric

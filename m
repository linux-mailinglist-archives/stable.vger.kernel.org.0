Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F5844356C
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 19:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbhKBSUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 14:20:32 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56482 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235044AbhKBSU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 14:20:28 -0400
Received: from in01.mta.xmission.com ([166.70.13.51]:49648)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mhyLz-00AIEV-OE; Tue, 02 Nov 2021 12:17:47 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:37066 helo=email.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mhyLo-006iWW-Cc; Tue, 02 Nov 2021 12:17:42 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, kexec@lists.infradead.org, stable@vger.kernel.org,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
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
References: <20210913155603.28383-1-joro@8bytes.org>
        <20210913155603.28383-2-joro@8bytes.org> <YYARccITlowHABg1@zn.tnic>
        <87pmrjbmy9.fsf@disp2133> <YYFupTJjUljpuZgL@suse.de>
Date:   Tue, 02 Nov 2021 13:17:26 -0500
In-Reply-To: <YYFupTJjUljpuZgL@suse.de> (Joerg Roedel's message of "Tue, 2 Nov
        2021 18:00:21 +0100")
Message-ID: <87k0hq777t.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mhyLo-006iWW-Cc;;;mid=<87k0hq777t.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19ZFP83sW/GDuonSMarVsicvRtUXK4AeQY=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: ***
X-Spam-Status: No, score=3.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,TR_XM_BayesUnsub,T_TM2_M_HEADER_IN_MSG,
        T_TooManySym_01,T_XMDrugObfuBody_08,XMSubLong,XM_B_Unsub
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4991]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.5 XM_B_Unsub Unsubscribe in body of email but missing unsubscribe
        *       header
        *  1.0 T_XMDrugObfuBody_08 obfuscated drug references
        *  1.5 TR_XM_BayesUnsub High bayes score with no unsubscribe header
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Joerg Roedel <jroedel@suse.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 504 ms - load_scoreonly_sql: 0.08 (0.0%),
        signal_user_changed: 12 (2.4%), b_tie_ro: 10 (2.1%), parse: 1.32
        (0.3%), extract_message_metadata: 15 (2.9%), get_uri_detail_list: 1.89
        (0.4%), tests_pri_-1000: 7 (1.4%), tests_pri_-950: 1.35 (0.3%),
        tests_pri_-900: 1.14 (0.2%), tests_pri_-90: 111 (22.1%), check_bayes:
        98 (19.4%), b_tokenize: 10 (1.9%), b_tok_get_all: 12 (2.3%),
        b_comp_prob: 3.1 (0.6%), b_tok_touch_all: 70 (13.8%), b_finish: 1.06
        (0.2%), tests_pri_0: 337 (66.9%), check_dkim_signature: 0.60 (0.1%),
        check_dkim_adsp: 2.7 (0.5%), poll_dns_idle: 0.82 (0.2%), tests_pri_10:
        2.2 (0.4%), tests_pri_500: 12 (2.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v2 01/12] kexec: Allow architecture code to opt-out at runtime
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Joerg Roedel <jroedel@suse.de> writes:

> Hi again,
>
> On Mon, Nov 01, 2021 at 04:11:42PM -0500, Eric W. Biederman wrote:
>> I seem to remember the consensus when this was reviewed that it was
>> unnecessary and there is already support for doing something like
>> this at a more fine grained level so we don't need a new kexec hook.
>
> Forgot to state to problem again which these patches solve:
>
> Currently a Linux kernel running as an SEV-ES guest has no way to
> successfully kexec into a new kernel. The normal SIPI sequence to reset
> the non-boot VCPUs does not work in SEV-ES guests and special code is
> needed in Linux to safely hand over the VCPUs from one kernel to the
> next. What happens currently is that the kexec'ed kernel will just hang.
>
> The code which implements the VCPU hand-over is also included in this
> patch-set, but it requires a certain level of Hypervisor support which
> is not available everywhere.
>
> To make it clear to the user that kexec will not work in their
> environment, it is best to disable the respected syscalls. This is what
> the hook is needed for.

Note this is environmental.  This is the equivalent of a driver for a
device without some feature.

The kernel already has machine_kexec_prepare, which is perfectly capable
of detecting this is a problem and causing kexec_load to fail.  Which
is all that is required.

We don't need a new hook and a new code path to test for one
architecture.

So when we can reliably cause the system call to fail with a specific
error code I don't think it makes sense to make clutter up generic code
because of one architecture's design mistakes.


My honest preference would be to go farther and have a
firmware/hypervisor/platform independent rendezvous for the cpus so we
don't have to worry about what bugs the code under has implemented for
this special case.  Because frankly there when there are layers of
software if a bug can slip through it always seems to and causes
problems.


But definitely there is no reason to add another generic hook when the
existing hook is quite good enough.

Eric


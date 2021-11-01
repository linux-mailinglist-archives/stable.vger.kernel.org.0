Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF145442269
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 22:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhKAVOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 17:14:55 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38738 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhKAVOy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 17:14:54 -0400
Received: from in01.mta.xmission.com ([166.70.13.51]:44908)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mhebJ-0082VH-1q; Mon, 01 Nov 2021 15:12:17 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:34474 helo=email.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mhebH-002zh6-PG; Mon, 01 Nov 2021 15:12:16 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Borislav Petkov <bp@alien8.de>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        kexec@lists.infradead.org, Joerg Roedel <jroedel@suse.de>,
        stable@vger.kernel.org, hpa@zytor.com,
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
References: <20210913155603.28383-1-joro@8bytes.org>
        <20210913155603.28383-2-joro@8bytes.org> <YYARccITlowHABg1@zn.tnic>
Date:   Mon, 01 Nov 2021 16:11:42 -0500
In-Reply-To: <YYARccITlowHABg1@zn.tnic> (Borislav Petkov's message of "Mon, 1
        Nov 2021 17:10:25 +0100")
Message-ID: <87pmrjbmy9.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mhebH-002zh6-PG;;;mid=<87pmrjbmy9.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/dOcje8rMk6fFebgEu/saSTasGNFo4jXQ=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa08.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,TR_XM_BayesUnsub,T_TM2_M_HEADER_IN_MSG,
        T_TooManySym_01,XMSubLong,XM_B_Unsub autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4982]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa08 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.5 XM_B_Unsub Unsubscribe in body of email but missing unsubscribe
        *       header
        *  1.5 TR_XM_BayesUnsub High bayes score with no unsubscribe header
X-Spam-DCC: XMission; sa08 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Borislav Petkov <bp@alien8.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 611 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 14 (2.3%), b_tie_ro: 12 (2.0%), parse: 0.91
        (0.1%), extract_message_metadata: 17 (2.8%), get_uri_detail_list: 1.38
        (0.2%), tests_pri_-1000: 11 (1.8%), tests_pri_-950: 1.41 (0.2%),
        tests_pri_-900: 1.43 (0.2%), tests_pri_-90: 131 (21.5%), check_bayes:
        112 (18.4%), b_tokenize: 8 (1.3%), b_tok_get_all: 8 (1.3%),
        b_comp_prob: 2.8 (0.5%), b_tok_touch_all: 88 (14.4%), b_finish: 1.62
        (0.3%), tests_pri_0: 416 (68.0%), check_dkim_signature: 0.64 (0.1%),
        check_dkim_adsp: 3.1 (0.5%), poll_dns_idle: 1.11 (0.2%), tests_pri_10:
        3.8 (0.6%), tests_pri_500: 11 (1.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v2 01/12] kexec: Allow architecture code to opt-out at runtime
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Borislav Petkov <bp@alien8.de> writes:

> On Mon, Sep 13, 2021 at 05:55:52PM +0200, Joerg Roedel wrote:
>> From: Joerg Roedel <jroedel@suse.de>
>> 
>> Allow a runtime opt-out of kexec support for architecture code in case
>> the kernel is running in an environment where kexec is not properly
>> supported yet.
>> 
>> This will be used on x86 when the kernel is running as an SEV-ES
>> guest. SEV-ES guests need special handling for kexec to hand over all
>> CPUs to the new kernel. This requires special hypervisor support and
>> handling code in the guest which is not yet implemented.
>> 
>> Cc: stable@vger.kernel.org # v5.10+
>> Signed-off-by: Joerg Roedel <jroedel@suse.de>
>> ---
>>  include/linux/kexec.h |  1 +
>>  kernel/kexec.c        | 14 ++++++++++++++
>>  kernel/kexec_file.c   |  9 +++++++++
>>  3 files changed, 24 insertions(+)
>
> I guess I can take this through the tip tree along with the next one.

I seem to remember the consensus when this was reviewed that it was
unnecessary and there is already support for doing something like
this at a more fine grained level so we don't need a new kexec hook.

Eric


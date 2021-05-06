Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB50A37598D
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 19:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbhEFRnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 13:43:19 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47818 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236042AbhEFRnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 13:43:18 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lei0n-005md5-4q; Thu, 06 May 2021 11:42:09 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1lei0m-0003nZ-2F; Thu, 06 May 2021 11:42:08 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, kexec@lists.infradead.org,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org,
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
References: <20210506093122.28607-1-joro@8bytes.org>
        <20210506093122.28607-3-joro@8bytes.org>
Date:   Thu, 06 May 2021 12:42:03 -0500
In-Reply-To: <20210506093122.28607-3-joro@8bytes.org> (Joerg Roedel's message
        of "Thu, 6 May 2021 11:31:22 +0200")
Message-ID: <m17dkb4v4k.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lei0m-0003nZ-2F;;;mid=<m17dkb4v4k.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18K6SvQ88nM/nPpaU9bp8QcNl7ZXSm1Ea8=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMNoVowels,
        XMSubLong autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Joerg Roedel <joro@8bytes.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 608 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 4.3 (0.7%), b_tie_ro: 2.8 (0.5%), parse: 1.46
        (0.2%), extract_message_metadata: 11 (1.9%), get_uri_detail_list: 1.16
        (0.2%), tests_pri_-1000: 6 (0.9%), tests_pri_-950: 1.07 (0.2%),
        tests_pri_-900: 0.84 (0.1%), tests_pri_-90: 182 (30.0%), check_bayes:
        168 (27.7%), b_tokenize: 7 (1.2%), b_tok_get_all: 26 (4.3%),
        b_comp_prob: 2.5 (0.4%), b_tok_touch_all: 130 (21.3%), b_finish: 0.82
        (0.1%), tests_pri_0: 246 (40.5%), check_dkim_signature: 0.37 (0.1%),
        check_dkim_adsp: 2.6 (0.4%), poll_dns_idle: 140 (23.0%), tests_pri_10:
        2.5 (0.4%), tests_pri_500: 148 (24.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 2/2] x86/kexec/64: Forbid kexec when running as an SEV-ES guest
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Joerg Roedel <joro@8bytes.org> writes:

> From: Joerg Roedel <jroedel@suse.de>
>
> For now, kexec is not supported when running as an SEV-ES guest. Doing
> so requires additional hypervisor support and special code to hand
> over the CPUs to the new kernel in a safe way.
>
> Until this is implemented, do not support kexec in SEV-ES guests.

I don't understand this.

Fundamentally kexec is about doing things more or less inspite of
what the firmware is doing.

I don't have any idea what a SEV-ES is.  But the normal x86 boot doesn't
do anything special.  Is cross cpu IPI emulation buggy?

If this is a move in your face hypervisor like Xen is sometimes I can
see perhaps needing a little bit of different work during bootup.
Perhaps handing back a cpu on system shutdown and asking for more cpus
on system boot up.

What is the actual problem you are trying to avoid?

And yes for a temporary hack the suggestion of putting code into
machine_kexec_prepare seems much more reasonable so we don't have to
carry special case infrastructure for the forseeable future.

Eric


> Cc: stable@vger.kernel.org # v5.10+
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kernel/machine_kexec_64.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
> index c078b0d3ab0e..f902cc9cc634 100644
> --- a/arch/x86/kernel/machine_kexec_64.c
> +++ b/arch/x86/kernel/machine_kexec_64.c
> @@ -620,3 +620,11 @@ void arch_kexec_pre_free_pages(void *vaddr, unsigned int pages)
>  	 */
>  	set_memory_encrypted((unsigned long)vaddr, pages);
>  }
> +
> +/*
> + * Kexec is not supported in SEV-ES guests yet
> + */
> +bool arch_kexec_supported(void)
> +{
> +	return !sev_es_active();
> +}

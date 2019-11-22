Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60A48107950
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 21:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfKVUPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 15:15:38 -0500
Received: from mga12.intel.com ([192.55.52.136]:54647 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbfKVUPi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 15:15:38 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 12:15:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="197731025"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 22 Nov 2019 12:15:38 -0800
Date:   Fri, 22 Nov 2019 12:15:38 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jmattson@google.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] KVM: x86: fix presentation of TSX feature in
 ARCH_CAPABILITIES
Message-ID: <20191122201537.GD31235@linux.intel.com>
References: <1574101067-5638-1-git-send-email-pbonzini@redhat.com>
 <1574101067-5638-2-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1574101067-5638-2-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 18, 2019 at 07:17:43PM +0100, Paolo Bonzini wrote:
> KVM does not implement MSR_IA32_TSX_CTRL, so it must not be presented
> to the guests.  It is also confusing to have !ARCH_CAP_TSX_CTRL_MSR &&
> !RTM && ARCH_CAP_TAA_NO: lack of MSR_IA32_TSX_CTRL suggests TSX was not
> hidden (it actually was), yet the value says that TSX is not vulnerable
> to microarchitectural data sampling.  Fix both.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5d530521f11d..6ea735d632e9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1327,12 +1327,18 @@ static u64 kvm_get_arch_capabilities(void)
>  	 * If TSX is disabled on the system, guests are also mitigated against
>  	 * TAA and clear CPU buffer mitigation is not required for guests.
>  	 */
> -	if (boot_cpu_has_bug(X86_BUG_TAA) && boot_cpu_has(X86_FEATURE_RTM) &&
> -	    (data & ARCH_CAP_TSX_CTRL_MSR))
> +	if (!boot_cpu_has(X86_FEATURE_RTM))
> +		data &= ~ARCH_CAP_TAA_NO;
> +	else if (!boot_cpu_has_bug(X86_BUG_TAA))
> +		data |= ARCH_CAP_TAA_NO;
> +	else if (data & ARCH_CAP_TSX_CTRL_MSR)
>  		data &= ~ARCH_CAP_MDS_NO;
>  
> +	/* KVM does not emulate MSR_IA32_TSX_CTRL.  */
> +	data &= ~ARCH_CAP_TSX_CTRL_MSR;
>  	return data;
>  }
> +EXPORT_SYMBOL_GPL(kvm_get_arch_capabilities);

Whoever backports this patch should drop this spurious addition of
EXPORT_SYMBOL_GPL, unless they also want to backport the cleanup :-).

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1967316811E
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 16:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbgBUPFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 10:05:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:12778 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728910AbgBUPFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 10:05:12 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Feb 2020 07:05:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,468,1574150400"; 
   d="scan'208";a="254843543"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 21 Feb 2020 07:05:12 -0800
Date:   Fri, 21 Feb 2020 07:05:12 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 009/191] KVM: nVMX: Use correct root level for
 nested EPT shadow page tables
Message-ID: <20200221150512.GB12665@linux.intel.com>
References: <20200221072250.732482588@linuxfoundation.org>
 <20200221072252.173149129@linuxfoundation.org>
 <20200221102949.GA14608@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221102949.GA14608@duo.ucw.cz>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 21, 2020 at 11:29:49AM +0100, Pavel Machek wrote:
> Hi!
> 
> > Hardcode the EPT page-walk level for L2 to be 4 levels, as KVM's MMU
> > currently also hardcodes the page walk level for nested EPT to be 4
> > levels.  The L2 guest is all but guaranteed to soft hang on its first
> > instruction when L1 is using EPT, as KVM will construct 4-level page
> > tables and then tell hardware to use 5-level page tables.
> 
> I don't get it. 7/191 reverts the patch, then 9/191 reverts the
> revert. Can we simply drop both 7 and 9, for exactly the same result?
>
> (Patch 8 is a unused file, so it does not change the picture).

Patch 07 is reverting this patch from the same unused file, 
arch/x86/kvm/vmx/vmx.c[*].  The reason patch 07 looks like a normal diff is
that a prior patch in 4.19.105 created the unused file (which is what's
reverted by patch 08 here).

Patch 09 reintroduces the fix for the correct file, arch/x86/kvm/vmx.c.

[*] In upstream, vmx.c now lives in arch/x86/kvm/vmx/, but in 4.19 and
    earlier it lives in arch/x86/kvm/.

> 
> Best regards,
> 								Pavel
> 
> > +++ b/arch/x86/kvm/vmx.c
> > @@ -5302,6 +5302,9 @@ static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
> >  
> >  static int get_ept_level(struct kvm_vcpu *vcpu)
> >  {
> > +	/* Nested EPT currently only supports 4-level walks. */
> > +	if (is_guest_mode(vcpu) && nested_cpu_has_ept(get_vmcs12(vcpu)))
> > +		return 4;
> >  	if (cpu_has_vmx_ept_5levels() && (cpuid_maxphyaddr(vcpu) > 48))
> >  		return 5;
> >  	return 4;
> > -- 
> > 2.20.1
> > 
> > 
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html



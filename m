Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D11275C5E
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 17:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgIWPtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 11:49:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:25321 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgIWPtf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Sep 2020 11:49:35 -0400
IronPort-SDR: Z4FDFOqQefa5p1Z2fwTncdWjwbAxI2LrMmjkyH2ez1VbEuSx5lPual10u8jIYtX+lqZuvk/vny
 QW2gMHleVhpA==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="158279840"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="158279840"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 08:49:34 -0700
IronPort-SDR: 0TTf0Awuc+w+XFmc26Xf3fgzWgftKmq8omL9NCwmEonlX2go+YgG9pSX6o5CXEiS5LaKfHWBmY
 jL7YUjQ1FeTA==
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="322630842"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 08:49:34 -0700
Date:   Wed, 23 Sep 2020 08:49:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH] KVM: nVMX: Morph notification vector IRQ on nested
 VM-Enter to pending PI
Message-ID: <20200923154933.GA31972@linux.intel.com>
References: <20200812175129.12172-1-sean.j.christopherson@intel.com>
 <20200826135402.AC1B3221E2@mail.kernel.org>
 <454c167d-687a-d4cb-3170-b32886904739@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <454c167d-687a-d4cb-3170-b32886904739@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 23, 2020 at 04:44:01PM +0200, Paolo Bonzini wrote:
> Queued, thanks.
> 
> I cannot think of a "nicer" way to do this, we could perhaps move
> 
> +		vmx->nested.pi_pending = true;
> +		kvm_make_request(KVM_REQ_EVENT, vcpu);
> +		kvm_apic_clear_irr(vcpu, vmx->nested.posted_intr_nv);
> 
> to a separate function (possibly with the IRR clear made conditional, so
> that we can reuse the function for regular posted interrupt injection)
> but that is it.

Ya, I played around with similar approaches and didn't particular like any
of them :-/

For the record, I suspect there may be additional issues with a doubly nested
scenario, i.e. when running L3 and L2 is using the self-IPI method for
triggering posted interrupts.  I sort of tested once, and it appeared to be
broken, but it's entirely possible that there was an issue somewhere else in
my stack (L0, L1 and L2 all had non-trivial KVM changes), and I haven't yet
had time to dig in.  That, and I suspect I'm the only person that would care
about L3 functioning properly in this scenario :-)

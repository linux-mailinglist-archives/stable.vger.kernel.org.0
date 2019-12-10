Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3C3A118D96
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 17:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfLJQ1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 11:27:33 -0500
Received: from mga07.intel.com ([134.134.136.100]:48633 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbfLJQ1d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 11:27:33 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 08:27:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,300,1571727600"; 
   d="scan'208";a="215490311"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 10 Dec 2019 08:27:32 -0800
Date:   Tue, 10 Dec 2019 08:27:31 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Nadav Amit <nadav.amit@gmail.com>,
        Doug Reiland <doug.reiland@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH 3.16 31/72] KVM: x86: Manually calculate reserved bits
 when loading PDPTRS
Message-ID: <20191210162731.GA16120@linux.intel.com>
References: <lsq.1575813164.154362148@decadent.org.uk>
 <lsq.1575813165.887619822@decadent.org.uk>
 <20191209154913.GB4042@linux.intel.com>
 <0e0b5aca785e41cdb0819820dfed1059683f5f58.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e0b5aca785e41cdb0819820dfed1059683f5f58.camel@decadent.org.uk>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 10, 2019 at 04:16:44PM +0000, Ben Hutchings wrote:
> The 3.16, 4.4, and 4.9 branches have slightly different conditions in
> kvm_set_cr3():
> 
> 	if (is_long_mode(vcpu)) {
> 		if (cr3 & CR3_L_MODE_RESERVED_BITS)
> 			return 1;
> 	} else if (is_pae(vcpu) && is_paging(vcpu) &&
> 		   !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
> 		return 1;
> 
> So load_pdptrs() already won't be called if is_long_mode() returns
> true, and this fix shouldn't be needed.

Argh, glad you double checked!  I looked at 3.16.y, but apparently I didn't
actually read the code...

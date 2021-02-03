Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C27F30E53B
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 22:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbhBCVza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 16:55:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:42392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229897AbhBCVz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 16:55:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A29A664F6C;
        Wed,  3 Feb 2021 21:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612389289;
        bh=Qiz8MokgGBvGwkrU9ihniujcsOk/Nkcte47kBrXcYkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B+WwauRu+ZWiuFTJALuFrywN0e9jHN59j51oBYr/Vmcf8Jibicp09+UjpgHkpLAf2
         bBh7dN/pixZMx3Fn5PeNVvn4phhOc5jnIC5Saav6I8qPfEAF2GYVoP557i+jtnnK9X
         QWiQ6zXquX8PGxbfOT/OVtZAUNURamgC0QSNrtS236dekOPZtlrpWwI0c7LI7Ztqjb
         5oqMYfrtnGgcFu8zRsDp59pNKkNKZx4mB/4GYbtTMRS2MhjMw1cZpcVjcDYeAnAjFs
         WmfA47qr2hMbyIodJI/8I4nBhorsekjO0qibvaUKpDqcRI61jSJfobbHSdAf8dyKs8
         d80ZhK1pL2Q6g==
Date:   Wed, 3 Feb 2021 23:54:42 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org, stable@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] x86/sgx: Fix use-after-free in
 sgx_mmu_notifier_release()
Message-ID: <YBsbojMEeq3pCNhy@kernel.org>
References: <20210128125823.18660-1-jarkko@kernel.org>
 <9dd2a962-2328-8784-9aed-b913502e1102@intel.com>
 <fa43948ba860d6ac99adabad3d8b6ff11f5d2239.camel@kernel.org>
 <8df884af-825e-bae0-f0c3-c3e97f48d138@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8df884af-825e-bae0-f0c3-c3e97f48d138@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 03, 2021 at 07:46:48AM -0800, Dave Hansen wrote:
> On 1/30/21 11:20 AM, Jarkko Sakkinen wrote:
> ...
> > Example scenario would such that all removals "side-channel" through
> > the notifier callback. Then mmu_notifier_unregister() gets called
> > exactly zero times. No MMU notifier srcu sync would be then happening.
> > 
> > NOTE: There's bunch of other examples, I'm just giving one.
> 
> Could you flesh this out a bit?  I don't quite understand the scenario
> from what you describe above.
> 
> In any case, I'm open to other implementations that fix the race we know
> about.  If you think you have a better fix, I'm happy to review it and
> make sure it closes the other race.

I'll bake up a new patch. Generally speaking, I think why this has been so
difficult, is because of a chicken-egg-problem. The whole issue should be
sorted when a new entry is first added to the mm_list, i.e. increase the
refcount for each added entry.

/Jarkko

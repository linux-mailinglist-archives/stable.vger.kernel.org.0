Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEBC447554
	for <lists+stable@lfdr.de>; Sun,  7 Nov 2021 20:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhKGTp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Nov 2021 14:45:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230364AbhKGTpZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Nov 2021 14:45:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B5A260FE8;
        Sun,  7 Nov 2021 19:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636314162;
        bh=LuLjGJGRrEpXf/URA8wRsWotsM2/2iMdP4iGfBZKpxc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Np2qyfnBYepSgmfVFgvoL3sE9y9AvPz9VHDiJwhS+4+v42wq+DlTP0uzCL4TCovax
         kl9u4EAoFTfmlpi0gRRsZc6VfifYj+MCYvyJrjwtIyHJigFhOwa2/g3OzTaivdFnIJ
         I0IWCfksIousu482xkQcnWIMn8zW+S6cb7epqLxVIzw4b5rvLVgwnssK7/dnjL4QGQ
         Spm+UlgBIcFMUt9w/OUTUSUm99nWrSpzHFqNRfjiQsnt2syrneUmLHJOYiq2RSrEVF
         AKZIO1mhqVLTRVbPUHvEUhURZ3OXpdiQyHVBowW/v7JOpgn+I+Pnq9Q7vhRy6XG2Rp
         IIS4GNJqhppHA==
Date:   Sun, 7 Nov 2021 21:42:39 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>,
        reinette.chatre@intel.com, tony.luck@intel.com,
        nathaniel@profian.com, stable@vger.kernel.org,
        Borislav Petkov <bp@suse.de>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Free backing memory after faulting the enclave
 page
Message-ID: <YYgsL7xSxnsjqIlu@iki.fi>
References: <20211103232238.110557-1-jarkko@kernel.org>
 <6831ed3c-c5b1-64f7-2ad7-f2d686224b7e@intel.com>
 <e88d6d580354aadaa8eaa5ee6fa703f021786afb.camel@kernel.org>
 <d2191571-30a5-c2aa-e8ed-0a380e9daeac@intel.com>
 <55eb8f3649590289a0f2b1ebe7583b6da3ff70ee.camel@kernel.org>
 <c6f5356b-a56a-e057-ef74-74e1169a844b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c6f5356b-a56a-e057-ef74-74e1169a844b@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 08:29:49AM -0700, Dave Hansen wrote:
> On 11/4/21 8:25 AM, Jarkko Sakkinen wrote:
> > On Thu, 2021-11-04 at 08:13 -0700, Dave Hansen wrote:
> >> On 11/4/21 8:04 AM, Jarkko Sakkinen wrote:
> >>>> Do we also need to deal with truncating the PCMD?  (For those watching
> >>>> along at home, there are two things SGX swaps to RAM: the actual page
> >>>> data and also some metadata that ensures page integrity and helps
> >>>> prevent things like rolling back to old versions of swapped pages)
> >>> Yes.
> >>>
> >>> This can be achieved by iterating through all of the enclave pages,
> >>> which share the same shmem page for storing their PCMD's, as the one
> >>> being faulted back. If none of those pages is swapped, the PCMD page can
> >>> safely truncated.
> >> I was thinking we could just read the page.  If it's all 0's, truncate it.
> > Hmm... did ELDU zero PCMD as a side-effect?
> 
> I don't think so, but there's nothing stopping us from doing it ourselves.

Ok.

> > It should be fairly effecient just to check the pages by using
> > encl->page_tree.
> 
> That sounds more complicated and slower than what I suggested.  You
> could even just check the refcount on the page.  I _think_ page cache
> pages have a refcount of 2.  So, look for the refcount that means "no
> more PCMD in this page", and just free it if so.

Umh, so... there is total 32 PCMD's per one page.

/Jarkko

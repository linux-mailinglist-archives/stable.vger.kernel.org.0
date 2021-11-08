Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727F0449CDF
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 21:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238347AbhKHUKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 15:10:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234723AbhKHUKX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 15:10:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B3D460234;
        Mon,  8 Nov 2021 20:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636402058;
        bh=+TD1fN8FSklZENvT6tfgRagmfN0EK9eQFnFwDCXYWFs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FtLzVKB0aBa0jebB9kEtYoZPI/36f0SnxT0K6bTM8yb3LPFgG0WGIFT79U+qn4uY/
         WjbmdJejH6SB3MExQjiLSskSjgAwh/wNcFPhBAqulrshtDatEWjs8CIJjq6lJUo4zb
         /tcUHkWCOcxLAgEtSLuzgfGgS+cTrGC5HFo6+KrRlLiIdRwC0ZIdSHjn/yCUe4MI1R
         OMQbRvEkm31XOptb7YJRZSmHeSnoDCSGV7va99O2muxkoEYPaiERx/+i/CBg7fZtF2
         DaCkMJWgAGU/6Wl/0b/SEuWr0Se1KY+r6adrzVQibvFqKL5BUbUo0Mz5I7A0ccuJD/
         VrlV8/Qc9X2QQ==
Date:   Mon, 8 Nov 2021 22:07:35 +0200
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
Message-ID: <YYmDh8eFHxo2vmgW@iki.fi>
References: <20211103232238.110557-1-jarkko@kernel.org>
 <6831ed3c-c5b1-64f7-2ad7-f2d686224b7e@intel.com>
 <e88d6d580354aadaa8eaa5ee6fa703f021786afb.camel@kernel.org>
 <d2191571-30a5-c2aa-e8ed-0a380e9daeac@intel.com>
 <55eb8f3649590289a0f2b1ebe7583b6da3ff70ee.camel@kernel.org>
 <c6f5356b-a56a-e057-ef74-74e1169a844b@intel.com>
 <YYgsL7xSxnsjqIlu@iki.fi>
 <7a5d6dab-4d06-40b3-d9c7-09c991b856cd@intel.com>
 <186120e4754fa0b583d5f4cb31aa49ccd5795d09.camel@kernel.org>
 <08a34922-2115-7154-e21d-de23e3354034@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <08a34922-2115-7154-e21d-de23e3354034@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 07, 2021 at 10:34:02PM -0800, Dave Hansen wrote:
> On 11/7/21 2:28 PM, Jarkko Sakkinen wrote:
> >> When you place PCMD in a page, you do a get_page().  The refcount goes
> >> up by one.  So, a PCMD page with one PCMD will (I think) have a refcount
> >> of 3.  If you totally fill it up with 31 *more* PCMD entries, it will
> >> have a refcount of 34.  You do *not* do a put_page() on the PCMD page at
> >> the end of the allocation phase.
> >>
> >> When the backing storage is freed, you drop the refcount.  So, going
> >> from 32 PCMD entries to 31 entries in a page, you go from 34->33.
> >>
> >> When that refcount drops to 2, you know there is no more data in the
> >> page that's useful.  At that point you can truncate it out of the
> >> backing storage.
> >>
> >> There's no reason to scan the page, or a boatload of other metadata.
> >> Just keep a refcount.  Just use the *existing* 'struct page' refcount.
> > Right! Thank you, I'll use this approach, and check that the refcount
> > actually behaves that way you described.
> 
> Thinking about this a bit more...  We don't want to use the normal
> get/put_page() refcount for this.  If we do, it will pin the page while
> there is any data in it, preventing it from being reclaimed (swapped).
> 
> That isn't to say that we can't keep *a* refcount, just that we can't
> use the page refcount for this.
> 
> I still like the idea of just scanning the whole page for zeros.

I can try that route first. I like the property in zeroing that it has
predicatable O(1) cost.

/Jarkko

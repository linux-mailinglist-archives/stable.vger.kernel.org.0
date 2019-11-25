Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D654109390
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 19:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbfKYSef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 13:34:35 -0500
Received: from mga17.intel.com ([192.55.52.151]:16672 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbfKYSef (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 13:34:35 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Nov 2019 10:34:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,242,1571727600"; 
   d="scan'208";a="206225556"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 25 Nov 2019 10:34:34 -0800
Date:   Mon, 25 Nov 2019 10:34:34 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, dan.j.williams@intel.com,
        david@redhat.com, kilobyte@angband.pl, pbonzini@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: MMU: Do not treat ZONE_DEVICE pages
 as being reserved" failed to apply to 4.19-stable tree
Message-ID: <20191125183434.GG12178@linux.intel.com>
References: <1574090560219@kroah.com>
 <20191125174359.GI5861@sasha-vm>
 <20191125180136.GE12178@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191125180136.GE12178@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 25, 2019 at 10:01:36AM -0800, Sean Christopherson wrote:
> On Mon, Nov 25, 2019 at 12:43:59PM -0500, Sasha Levin wrote:
> > On Mon, Nov 18, 2019 at 04:22:40PM +0100, gregkh@linuxfoundation.org wrote:
> > >
> > >The patch below does not apply to the 4.19-stable tree.

...

> > >Reported-by: Adam Borowski <kilobyte@angband.pl>
> > >Analyzed-by: David Hildenbrand <david@redhat.com>
> > >Acked-by: Dan Williams <dan.j.williams@intel.com>
> > >Cc: stable@vger.kernel.org
> > >Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
> > >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > >Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > 
> > I also took e7912386ede8 ("KVM: x86: reintroduce pte_list_remove, but
> > including mmu_spte_clear_track_bits") and queued both for 4.19-4.9.
> 
> I don't think that will work, you'd also have to pull in commit 8daf346226b2
> ("KVM: x86: rename pte_list_remove to __pte_list_remove").  And e7912386ede8
> in particular isn't stable material.
> 
> I'll send a proper backport for 4.19 and earlier, the conflicts should be
> easy to resolve.

I have a silly backporting question regarding SOBs.  Should I add a second
SOB for myself, reorder the SOBs, or leave it as is?  E.g. (A) is the most
correct from a chronological handling perspective, but having two SOBs
feels weird.

  Option A:
    Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
    Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
    [sean: backport to 4.x; resolve conflict in mmu.c]
    Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

  Option B:
    Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
    [sean: backport to 4.x; resolve conflict in mmu.c]
    Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

  Option C:
    Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
    Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB3B3109334
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 19:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbfKYSBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 13:01:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:48573 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbfKYSBz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 13:01:55 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Nov 2019 10:01:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,242,1571727600"; 
   d="scan'208";a="198548773"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 25 Nov 2019 10:01:36 -0800
Date:   Mon, 25 Nov 2019 10:01:36 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, dan.j.williams@intel.com,
        david@redhat.com, kilobyte@angband.pl, pbonzini@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: MMU: Do not treat ZONE_DEVICE pages
 as being reserved" failed to apply to 4.19-stable tree
Message-ID: <20191125180136.GE12178@linux.intel.com>
References: <1574090560219@kroah.com>
 <20191125174359.GI5861@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191125174359.GI5861@sasha-vm>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 25, 2019 at 12:43:59PM -0500, Sasha Levin wrote:
> On Mon, Nov 18, 2019 at 04:22:40PM +0100, gregkh@linuxfoundation.org wrote:
> >
> >The patch below does not apply to the 4.19-stable tree.
> >If someone wants it applied there, or to any other stable or longterm
> >tree, then please email the backport, including the original git commit
> >id to <stable@vger.kernel.org>.
> >
> >thanks,
> >
> >greg k-h
> >
> >------------------ original commit in Linus's tree ------------------
> >
> >From a78986aae9b2988f8493f9f65a587ee433e83bc3 Mon Sep 17 00:00:00 2001
> >From: Sean Christopherson <sean.j.christopherson@intel.com>
> >Date: Mon, 11 Nov 2019 14:12:27 -0800
> >Subject: [PATCH] KVM: MMU: Do not treat ZONE_DEVICE pages as being reserved
> >
> >Explicitly exempt ZONE_DEVICE pages from kvm_is_reserved_pfn() and
> >instead manually handle ZONE_DEVICE on a case-by-case basis.  For things
> >like page refcounts, KVM needs to treat ZONE_DEVICE pages like normal
> >pages, e.g. put pages grabbed via gup().  But for flows such as setting
> >A/D bits or shifting refcounts for transparent huge pages, KVM needs to
> >to avoid processing ZONE_DEVICE pages as the flows in question lack the
> >underlying machinery for proper handling of ZONE_DEVICE pages.
> >
> >This fixes a hang reported by Adam Borowski[*] in dev_pagemap_cleanup()
> >when running a KVM guest backed with /dev/dax memory, as KVM straight up
> >doesn't put any references to ZONE_DEVICE pages acquired by gup().
> >
> >Note, Dan Williams proposed an alternative solution of doing put_page()
> >on ZONE_DEVICE pages immediately after gup() in order to simplify the
> >auditing needed to ensure is_zone_device_page() is called if and only if
> >the backing device is pinned (via gup()).  But that approach would break
> >kvm_vcpu_{un}map() as KVM requires the page to be pinned from map() 'til
> >unmap() when accessing guest memory, unlike KVM's secondary MMU, which
> >coordinates with mmu_notifier invalidations to avoid creating stale
> >page references, i.e. doesn't rely on pages being pinned.
> >
> >[*] http://lkml.kernel.org/r/20190919115547.GA17963@angband.pl
> >
> >Reported-by: Adam Borowski <kilobyte@angband.pl>
> >Analyzed-by: David Hildenbrand <david@redhat.com>
> >Acked-by: Dan Williams <dan.j.williams@intel.com>
> >Cc: stable@vger.kernel.org
> >Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
> >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> I also took e7912386ede8 ("KVM: x86: reintroduce pte_list_remove, but
> including mmu_spte_clear_track_bits") and queued both for 4.19-4.9.

I don't think that will work, you'd also have to pull in commit 8daf346226b2
("KVM: x86: rename pte_list_remove to __pte_list_remove").  And e7912386ede8
in particular isn't stable material.

I'll send a proper backport for 4.19 and earlier, the conflicts should be
easy to resolve.

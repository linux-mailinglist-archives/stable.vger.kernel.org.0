Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6CD162D56
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 18:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgBRRr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 12:47:27 -0500
Received: from mga12.intel.com ([192.55.52.136]:6857 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbgBRRr0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 12:47:26 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 09:47:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,456,1574150400"; 
   d="scan'208";a="235606998"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 18 Feb 2020 09:47:25 -0800
Date:   Tue, 18 Feb 2020 09:47:25 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, pbonzini@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: x86/mmu: Fix struct guest_walker
 arrays for 5-level" failed to apply to 5.4-stable tree
Message-ID: <20200218174725.GB28156@linux.intel.com>
References: <1581966871164161@kroah.com>
 <20200218174451.GT1734@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218174451.GT1734@sasha-vm>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 12:44:51PM -0500, Sasha Levin wrote:
> On Mon, Feb 17, 2020 at 08:14:31PM +0100, gregkh@linuxfoundation.org wrote:
> >
> >The patch below does not apply to the 5.4-stable tree.
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
> >From f6ab0107a4942dbf9a5cf0cca3f37e184870a360 Mon Sep 17 00:00:00 2001
> >From: Sean Christopherson <sean.j.christopherson@intel.com>
> >Date: Fri, 7 Feb 2020 09:37:42 -0800
> >Subject: [PATCH] KVM: x86/mmu: Fix struct guest_walker arrays for 5-level
> >paging
> >
> >Define PT_MAX_FULL_LEVELS as PT64_ROOT_MAX_LEVEL, i.e. 5, to fix shadow
> >paging for 5-level guest page tables.  PT_MAX_FULL_LEVELS is used to
> >size the arrays that track guest pages table information, i.e. using a
> >"max levels" of 4 causes KVM to access garbage beyond the end of an
> >array when querying state for level 5 entries.  E.g. FNAME(gpte_changed)
> >will read garbage and most likely return %true for a level 5 entry,
> >soft-hanging the guest because FNAME(fetch) will restart the guest
> >instead of creating SPTEs because it thinks the guest PTE has changed.
> >
> >Note, KVM doesn't yet support 5-level nested EPT, so PT_MAX_FULL_LEVELS
> >gets to stay "4" for the PTTYPE_EPT case.
> >
> >Fixes: 855feb673640 ("KVM: MMU: Add 5 level EPT & Shadow page table support.")
> >Cc: stable@vger.kernel.org
> >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> File name is different in 5.4 and 4.19. Fixed and queued up for both.

Thanks!  Backporting the non-trivial conflicts is on my todo list,
unfortunately my todo list is rather long right now...

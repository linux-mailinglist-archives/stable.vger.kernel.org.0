Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 949D1F8527
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 01:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfKLAZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 19:25:33 -0500
Received: from mga14.intel.com ([192.55.52.115]:58943 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbfKLAZc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 19:25:32 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Nov 2019 16:25:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,294,1569308400"; 
   d="scan'208";a="229125802"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 11 Nov 2019 16:25:31 -0800
Date:   Mon, 11 Nov 2019 16:25:31 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Thomas Lamprecht <t.lamprecht@proxmox.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nadav Amit <nadav.amit@gmail.com>,
        Doug Reiland <doug.reiland@intel.com>,
        Peter Xu <peterx@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 4.19 167/211] KVM: x86: Manually calculate reserved bits
 when loading PDPTRS
Message-ID: <20191112002530.GB7431@linux.intel.com>
References: <20191003154447.010950442@linuxfoundation.org>
 <20191003154525.870373223@linuxfoundation.org>
 <68d02406-b9cc-2fc1-848c-5d272d9a3350@proxmox.com>
 <20191111173757.GB11805@linux.intel.com>
 <20191111174859.GB1083018@kroah.com>
 <20191111175719.GD11805@linux.intel.com>
 <20191111180820.GB1088065@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111180820.GB1088065@kroah.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 07:08:20PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Nov 11, 2019 at 09:57:19AM -0800, Sean Christopherson wrote:
> > On Mon, Nov 11, 2019 at 06:48:59PM +0100, Greg Kroah-Hartman wrote:
> > > Thanks for figuring this out, can you send us a patch that we can apply
> > > to fix this issue in the stable tree?
> > 
> > Can do.  A custom backport will be need for 4.20 and earlier, not 4.19 and
> > earlier.  I misremembered when we did the VMX refactoring.
> > 
> > For 5.0, 5.1 and 5.2, commit bf03d4f93347 can be applied directly.
> 
> 5.0, 5.1, and 5.2 are all long end-of-life, they are not getting any
> updates and no one should be using them, so nothing to worry about
> there.

Backports sent for 4.14 and 4.19.  4.9 and 4.4 aren't affected as the bug
was introduced in 4.14. by commit d1cd3ce90044 ("KVM: MMU: check guest CR3
reserved bits based on its physical address width.").

I did send patches for 4.9 and 4.4 for another PAE bug fix that I ran into
while backporting; commit d35b34a9a70e ("kvm: mmu: Don't read PDPTEs when
paging is not enabled").  I'm not aware of bug reports, but the patch is
quite safe and should have been tagged for stable.

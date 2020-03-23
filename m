Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 702F418F71C
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 15:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgCWOkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 10:40:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:36173 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgCWOkc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Mar 2020 10:40:32 -0400
IronPort-SDR: Qpl0iO+boptv/rFvsCLtEjQES3Wx5TAqXIPorZycf/k0cIsNiCEdpgsToA0JxOFdnrtrQYjqbw
 +o3jOC4ppSrQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 07:40:31 -0700
IronPort-SDR: a0XCa+e1GQIxpO/K/RToaMSSO1oaOTImJsmySbWz2YU8TW1xDo40/Phqv/W3fNuNgQ8un+lC8s
 3W5AZzlHSq2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,296,1580803200"; 
   d="scan'208";a="419518847"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 23 Mar 2020 07:40:31 -0700
Date:   Mon, 23 Mar 2020 07:40:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org,
        arei.gonglei@huawei.com, weidong.huang@huawei.com,
        weifuqiang@huawei.com, kvm@vger.kernel.org, linux-mm@kvack.org,
        Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/hugetlb: fix a addressing exception caused by
 huge_pte_offset()
Message-ID: <20200323144030.GA28711@linux.intel.com>
References: <1582342427-230392-1-git-send-email-longpeng2@huawei.com>
 <51a25d55-de49-4c0a-c994-bf1a8cfc8638@oracle.com>
 <5700f44e-9df9-1b12-bc29-68e0463c2860@huawei.com>
 <e16fe81b-5c4c-e689-2f48-214f2025df2f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e16fe81b-5c4c-e689-2f48-214f2025df2f@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 22, 2020 at 07:54:32PM -0700, Mike Kravetz wrote:
> On 3/22/20 7:03 PM, Longpeng (Mike, Cloud Infrastructure Service Product Dept.) wrote:
> > 
> > On 2020/3/22 7:38, Mike Kravetz wrote:
> >> On 2/21/20 7:33 PM, Longpeng(Mike) wrote:
> >>> From: Longpeng <longpeng2@huawei.com>
> I have not looked closely at the generated code for lookup_address_in_pgd.
> It appears that it would dereference p4d, pud and pmd multiple times.  Sean
> seemed to think there was something about the calling context that would
> make issues like those seen with huge_pte_offset less likely to happen.  I
> do not know if this is accurate or not.

Only for KVM's calls to lookup_address_in_mm(), I can't speak to other
calls that funnel into to lookup_address_in_pgd().

KVM uses a combination of tracking and blocking mmu_notifier calls to ensure
PTE changes/invalidations between gup() and lookup_address_in_pgd() cause a
restart of the faulting instruction, and that pending changes/invalidations
are blocked until installation of the pfn in KVM's secondary MMU completes.

kvm_mmu_page_fault():

	mmu_seq = kvm->mmu_notifier_seq;
	smp_rmb();

	pfn = gup(hva);

	spin_lock(&kvm->mmu_lock);
	smp_rmb();
	if (kvm->mmu_notifier_seq != mmu_seq)
		goto out_unlock: // Restart guest, i.e. retry the fault

	lookup_address_in_mm(hva, ...);

	...

  out_unlock:
	spin_unlock(&kvm->mmu_lock);


kvm_mmu_notifier_change_pte() / kvm_mmu_notifier_invalidate_range_end():

	spin_lock(&kvm->mmu_lock);
	kvm->mmu_notifier_seq++;
	smp_wmb();
	spin_unlock(&kvm->mmu_lock);


> Let's remove the two READ_ONCE calls and move this patch forward.  We can
> look closer at lookup_address_in_pgd and generate another patch if that needs
> to be fixed as well.
> 
> Thanks
> -- 
> Mike Kravetz

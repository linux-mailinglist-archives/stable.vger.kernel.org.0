Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1099F198B65
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 06:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbgCaEoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 00:44:08 -0400
Received: from mga14.intel.com ([192.55.52.115]:37576 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725792AbgCaEoI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 00:44:08 -0400
IronPort-SDR: 2Jj4mYTuKR1IKYZo/mSbhlfoNPXSP+OwO6Vijveof4BohgpdDN8ZYUdF364C0Ud0NSU9wDc+yY
 lH+8SzoiarsQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 21:44:08 -0700
IronPort-SDR: U35DPnDdXQC0+U8wOsG0mql8zgaoob+DoFc2SFAMgXkPC8HCw4lOq5EaV46mmGVhw9OJZKfUGF
 DdMth3AxoPsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,327,1580803200"; 
   d="scan'208";a="248933070"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 30 Mar 2020 21:44:08 -0700
Date:   Mon, 30 Mar 2020 21:44:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     akpm@linux-foundation.org, jgg@ziepe.ca, longpeng2@huawei.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        willy@infradead.org, Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: +
 mm-hugetlb-fix-a-addressing-exception-caused-by-huge_pte_offset.patch added
 to -mm tree
Message-ID: <20200331044408.GW24988@linux.intel.com>
References: <20200328221008.c6KdUoTLQ%akpm@linux-foundation.org>
 <eea7c1f8-a2e4-5af1-acc4-3eb21a076d37@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eea7c1f8-a2e4-5af1-acc4-3eb21a076d37@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 30, 2020 at 08:35:29PM -0700, Mike Kravetz wrote:
> On 3/28/20 3:10 PM, akpm@linux-foundation.org wrote:
> > The patch titled
> >      Subject: mm/hugetlb: fix a addressing exception caused by huge_pte_offset
> > has been added to the -mm tree.  Its filename is
> >      mm-hugetlb-fix-a-addressing-exception-caused-by-huge_pte_offset.patch
> > 
> > This patch should soon appear at
> >     http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-a-addressing-exception-caused-by-huge_pte_offset.patch
> > and later at
> >     http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-a-addressing-exception-caused-by-huge_pte_offset.patch
> > 
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> > 
> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> > 
> > The -mm tree is included into linux-next and is updated
> > there every 3-4 working days
> > 
> > ------------------------------------------------------
> > From: Longpeng <longpeng2@huawei.com>
> > Subject: mm/hugetlb: fix a addressing exception caused by huge_pte_offset
> 
> This patch is what caused the BUG reported on i386 non-PAE kernel here:
> 
> https://lore.kernel.org/linux-mm/CA+G9fYsJgZhhWLMzUxu_ZQ+THdCcJmFbHQ2ETA_YPP8M6yxOYA@mail.gmail.com/
> 
> As a clue, when building in this environment I get:
> 
>   CC      mm/hugetlb.o
> mm/hugetlb.c: In function ‘huge_pte_offset’:
> cc1: warning: function may return address of local variable [-Wreturn-local-addr]
> mm/hugetlb.c:5361:14: note: declared here
>   pud_t *pud, pud_entry;
>               ^~~~~~~~~
> cc1: warning: function may return address of local variable [-Wreturn-local-addr]
> mm/hugetlb.c:5361:14: note: declared here
> cc1: warning: function may return address of local variable [-Wreturn-local-addr]
> mm/hugetlb.c:5360:14: note: declared here
>   p4d_t *p4d, p4d_entry;
>               ^~~~~~~~~
> 
> I'm shutting down for the night and will look into it more tomorrow if
> someone else does not beat me to it.

Non-PAE uses ModeB / PSE paging, which only has 2-level page tables.  The
non-existent levels get folded in and pmd_offset/pud_offset() return the
passed in pointer instead of accessing a table, e.g.:

static inline pmd_t * pmd_offset(pud_t * pud, unsigned long address)
{
	return (pmd_t *)pud;
}

The bug probably only manifests with PSE paging because it can have huge
pages in the top-level table, i.e. is the only mode that can get a false
positive.

This is arguably a bug in pmd_huge/pud_hug(), seems like they should
unconditionally return false if the relevant level doesn't exist.

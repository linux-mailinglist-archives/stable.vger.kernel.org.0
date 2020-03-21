Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81FE918E54C
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 23:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbgCUWqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 18:46:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726859AbgCUWqq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 18:46:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C425E20754;
        Sat, 21 Mar 2020 22:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584830805;
        bh=pBP/6b4ajfKJCuF6Edxia1qiK6WLfxFlX24bBcuc9dY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yg0udSPDLvx9DBCpAS4miIQcR5my3Wgw5OgVsuwCeEHl3PEU5nW/yxpZ1ta/O3PqT
         2VkvG93i+WOHoL0LiinoUqBAndeB6sqyl9BMeBmJxGy7RZmu+3jGlmTBVQ75eFy86N
         HjQsE/5wuMkFKDW1r/OxKU9b0IbpsHSa7H5C78H0=
Date:   Sat, 21 Mar 2020 15:46:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     "Longpeng (Mike)" <longpeng2@huawei.com>,
        Matthew Wilcox <willy@infradead.org>, Qian Cai <cai@lca.pw>,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org,
        arei.gonglei@huawei.com, weidong.huang@huawei.com,
        weifuqiang@huawei.com, kvm@vger.kernel.org, linux-mm@kvack.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/hugetlb: fix a addressing exception caused by
 huge_pte_offset()
Message-Id: <20200321154644.bcbedca64f620d3cbe215231@linux-foundation.org>
In-Reply-To: <1b61f55a-d825-5721-2bfe-5e0efc9c9c2d@oracle.com>
References: <C4ED630A-FAD8-4998-A0A3-9C36F3303379@lca.pw>
        <f274b368-6fdb-2ae3-160e-fd8b105b9ac4@huawei.com>
        <20200222170222.GJ24185@bombadil.infradead.org>
        <dfbfbf46-483a-808f-d197-388f75569d9c@huawei.com>
        <1b61f55a-d825-5721-2bfe-5e0efc9c9c2d@oracle.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Feb 2020 13:41:46 -0800 Mike Kravetz <mike.kravetz@oracle.com> wrote:

> > Secondly, huge_pte_offset in mm/hugetlb.c is for ARCH_WANT_GENERAL_HUGETLB, many
> > architectures use it, can you make sure there is no issue on all the
> > architectures using it with all the version of gcc ?
> > 
> > Thirdly, there are several places use READ_ONCE to access the page table in mm/*
> > (e.g. gup_pmd_range), they're also generical for all architectures, and they're
> > much more like unnecessary than here, so why there can use but not here? What's
> > more, you can read this commit 688272809.
> 
> Apologies for the late reply.
> 
> In commit 20a004e7 the message says that "Whilst there are some scenarios
> where this cannot happen ... the overhead of using READ_ONCE/WRITE_ONCE
> everywhere is minimal and makes the code an awful lot easier to reason about."
> Therefore, a decision was made to ALWAYS use READ_ONCE in the arm64 code
> whether or not it was absolutely necessary.  Therefore, I do not think
> we can assume all the READ_ONCE additions made in 20a004e7 are necessary.
> Then the question remains, it it necessary in two statements above?
> I do not believe it is necessary.  Why?  In the statements,
> 	if (!pgd_present(*pgd))
> and
> 	if (!p4d_present(*p4d))
> the variables are only accessed and dereferenced once.  I can not imagine
> any way in which the compiler could perform multiple accesses of the variable.
> 
> I do believe the READ_ONCE in code accessing the pud and pmd is necessary.
> This is because the variables (pud_entry or pmd_entry) are accessed more than
> once.  And, I could imagine some strange compiler optimization where it would
> dereference the pud or pmd pointer more than once.  For this same reason
> (multiple accesses), I believe the READ_ONCE was added in commit 688272809.
> 
> I am no expert in this area, so corrections/comments appreciated.
> 
> BTW, I still think there may be races present in lookup_address_in_pgd().
> Multiple dereferences of a p4d, pud and pmd are done.

Based on Mike's observations I shall drop this patch.  If we still
believe it is needed, please enhance the changelog, resend and let's
take another look.


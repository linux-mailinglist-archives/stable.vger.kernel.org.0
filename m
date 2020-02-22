Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA11A169094
	for <lists+stable@lfdr.de>; Sat, 22 Feb 2020 18:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgBVRCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 12:02:43 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:54650 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgBVRCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Feb 2020 12:02:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=SY35JLLv+vBVjF2AfSVM5A43C4jm9v1brv6q5yWkRzU=; b=cC5CpFYDWqcMFhwSbiePfLpJKa
        kwoTL5cYHcxmTKP4DMbY102XnLlQ1/AzXURwUHkNRRfyLgSJvx1zzHEhf3reZhSBiyR3e8zzxZAoe
        lVTUiNE3CXPjPBQntPEKui5NqJqN+VkYowNZbqQ1iFWjRy61gEIz7SI8cJH/Gf816sEfp7aV5upTJ
        mQzDU8DQZuG0Cz9vLDeWs37a/PRueidkzItJknwFV3xw3PrAsaobmY+hCTKsyAtHlJnVxOo7NEXsl
        umj5CTV59yw67b98GLGClqC66/erz7kWsWGm1tYystlInM0vFwwgmk85tI/OwDg0x2lSuGmpjJ9TR
        qVbURNWA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5YAY-0005UU-St; Sat, 22 Feb 2020 17:02:22 +0000
Date:   Sat, 22 Feb 2020 09:02:22 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     "Longpeng (Mike)" <longpeng2@huawei.com>
Cc:     Qian Cai <cai@lca.pw>, akpm@linux-foundation.org,
        mike.kravetz@oracle.com, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org, arei.gonglei@huawei.com,
        weidong.huang@huawei.com, weifuqiang@huawei.com,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/hugetlb: fix a addressing exception caused by
 huge_pte_offset()
Message-ID: <20200222170222.GJ24185@bombadil.infradead.org>
References: <C4ED630A-FAD8-4998-A0A3-9C36F3303379@lca.pw>
 <f274b368-6fdb-2ae3-160e-fd8b105b9ac4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f274b368-6fdb-2ae3-160e-fd8b105b9ac4@huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 22, 2020 at 02:33:10PM +0800, Longpeng (Mike) wrote:
> 在 2020/2/22 13:23, Qian Cai 写道:
> >> On Feb 21, 2020, at 10:34 PM, Longpeng(Mike) <longpeng2@huawei.com> wrote:
> >>
> >> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> >> index dd8737a..90daf37 100644
> >> --- a/mm/hugetlb.c
> >> +++ b/mm/hugetlb.c
> >> @@ -4910,28 +4910,30 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
> >> {
> >>    pgd_t *pgd;
> >>    p4d_t *p4d;
> >> -    pud_t *pud;
> >> -    pmd_t *pmd;
> >> +    pud_t *pud, pud_entry;
> >> +    pmd_t *pmd, pmd_entry;
> >>
> >>    pgd = pgd_offset(mm, addr);
> >> -    if (!pgd_present(*pgd))
> >> +    if (!pgd_present(READ_ONCE(*pgd)))
> >>        return NULL;
> >>    p4d = p4d_offset(pgd, addr);
> >> -    if (!p4d_present(*p4d))
> >> +    if (!p4d_present(READ_ONCE(*p4d)))
> >>        return NULL;
> > 
> > What’s the point of READ_ONCE() on those two places?
> > 
> As explained in the commit messages, it's for safe(e.g. avoid the compilier
> mischief). You can also find the same usage in the ARM64's huge_pte_offset() in
> arch/arm64/mm/hugetlbpage.c

I rather agree with Qian; if we need something like READ_ONCE() here,
why don't we always need it as part of pgd_present()?  It seems like an
unnecessary burden for every user.

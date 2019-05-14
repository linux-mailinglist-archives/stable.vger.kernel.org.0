Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 225711C7EA
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 13:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbfENLn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 07:43:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36168 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfENLn6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 07:43:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BhD3OnVLQKwBnDmageAbFQrzsjIjd55x6Z/qXnxU1kc=; b=OcAcBuO+E2YaqxTh3wmNWEvgt
        2g29keOO2R7/iXEpa20Ny/fs7AIjc/V3rlYKvWyJ61CCBW5dDp7aRqQVXg/upu4BdfdrtNfW5sDmx
        DwyT4egWskNMSnKAovv3pM52FDdLby2NbIqXpuKIG5a6XdOtPlCDgCBJLlndATU44YwRY8ZUAnMFv
        EFbhmIs+bNDjyydTm6CYE1cHqnX3nCrIL18yxSjPeNmgpLuMJ8TXgETsY23iduPliKI/nC4uLiYDy
        vYGNTdy6oga4h32Cv0/AFpgyMz4F4dpmGQ/V3d5gz9MPIux5zNPOABopjcu1/56rtQNUuPj/h8U1d
        3Ab6xsRhA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQVqT-0007fJ-Vr; Tue, 14 May 2019 11:43:46 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8D0FC2029F877; Tue, 14 May 2019 13:43:43 +0200 (CEST)
Date:   Tue, 14 May 2019 13:43:43 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nadav Amit <namit@vmware.com>
Cc:     Yang Shi <yang.shi@linux.alibaba.com>,
        Will Deacon <will.deacon@arm.com>,
        "jstancek@redhat.com" <jstancek@redhat.com>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [v2 PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Message-ID: <20190514114343.GN2589@hirez.programming.kicks-ass.net>
References: <45c6096e-c3e0-4058-8669-75fbba415e07@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45c6096e-c3e0-4058-8669-75fbba415e07@email.android.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 14, 2019 at 02:01:34AM +0000, Nadav Amit wrote:
> > diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> > index 99740e1dd273..cc251422d307 100644
> > --- a/mm/mmu_gather.c
> > +++ b/mm/mmu_gather.c
> > @@ -251,8 +251,9 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
> >         * forcefully if we detect parallel PTE batching threads.
> >         */
> >        if (mm_tlb_flush_nested(tlb->mm)) {
> > +             tlb->fullmm = 1;
> >                __tlb_reset_range(tlb);
> > -             __tlb_adjust_range(tlb, start, end - start);
> > +             tlb->freed_tables = 1;
> >        }
> >
> >        tlb_flush_mmu(tlb);
> 
> 
> I think that this should have set need_flush_all and not fullmm.

Difficult, mmu_gather::need_flush_all is arch specific and not everybody
implements it.

And while mmu_gather::fullmm isn't strictly correct either; we can
(ab)use it here, because at tlb_finish_mmu() time the differences don't
matter anymore.


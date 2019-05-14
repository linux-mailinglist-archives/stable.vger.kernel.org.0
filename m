Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0393D1C7FB
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 13:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbfENLtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 07:49:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36228 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfENLtb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 07:49:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3byTOZ1Myj651NO5kaGAKud48ExIes5ZKoTARDnqAyo=; b=TIFvPOXmwezpA+bbGIElqbOPS
        66JUG+655NExwAETL/RzqvHaEYb3sfEKCH39v0eO2yBmUTwYhhKH/0qL2WXRI5bXdAScd2g51vxcW
        j+x5oGqRAo10u1XTDs7HX1CnF5hZQV5X1VTev28CWBcT9QTCeaOuYHYwKqr3HKXig1DGDS6VFgy42
        RH/v87y5MT3GWzAE7LaMPmD9eIFEkoMxeWIxz42MzdhwF9Yssn9pmMDRWrYEdskVe+PLq6DpHyUHV
        e4J0yibV60gN14RFX4NVqZp2TchwE2LNQZo3HGwTZbX7QiOEstYFh4hSbDe1/RAkI+LDyDilLes/f
        YS2aaM9pQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQVvs-0007hN-GB; Tue, 14 May 2019 11:49:20 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 441122029F877; Tue, 14 May 2019 13:49:19 +0200 (CEST)
Date:   Tue, 14 May 2019 13:49:19 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nadav Amit <namit@vmware.com>
Cc:     Jan Stancek <jstancek@redhat.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Will Deacon <will.deacon@arm.com>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [v2 PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Message-ID: <20190514114919.GO2589@hirez.programming.kicks-ass.net>
References: <45c6096e-c3e0-4058-8669-75fbba415e07@email.android.com>
 <914836977.22577826.1557818139522.JavaMail.zimbra@redhat.com>
 <9E536319-815D-4425-B4B6-8786D415442C@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9E536319-815D-4425-B4B6-8786D415442C@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 14, 2019 at 07:21:33AM +0000, Nadav Amit wrote:
> > On May 14, 2019, at 12:15 AM, Jan Stancek <jstancek@redhat.com> wrote:

> > Replacing fullmm with need_flush_all, brings the problem back / reproducer hangs.
> 
> Maybe setting need_flush_all does not have the right effect, but setting
> fullmm and then calling __tlb_reset_range() when the PTEs were already
> zapped seems strange.
> 
> fullmm is described as:
> 
>         /*
>          * we are in the middle of an operation to clear
>          * a full mm and can make some optimizations
>          */
> 
> And this not the case.

Correct; starting with fullmm would be wrong. For instance
tlb_start_vma() would do the wrong thing because it assumes the whole mm
is going away. But we're at tlb_finish_mmu() time and there the
difference doesn't matter anymore.

But yes, that's a wee abuse.


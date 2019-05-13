Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B91A1B4EB
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 13:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbfEMLaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 07:30:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53710 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfEMLaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 May 2019 07:30:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tSqs9AMTThdU8qxkTIlNJvkPD11kfEkOfLcrJZGQml0=; b=mKtDdwldcN/kKtSFZ0OV1rUjFo
        L0YIrcHbDGvnobIZdBJsGGRK/3OtPHsv+pwLV+N1crHBYJixbIy69FalNoT/p/4bcCN1cV5IHVsPx
        1dNG/4Vk/9aCZc92b8CJgD+YNhgSRAcPNl3KZ/TLk9E74FIR2Az+lbD+LU+GGH7oobSmE/E+yuxCj
        3pUqBNcyeOrlFbqTfaU5n1OAQ1KlarZ24EXN5aLfmwf9029FrgMZyw06lw2T8ATqOEKpW1Zl5e5dr
        XA37mg6cSNUgXrYFzhKxP6jHEXXxL378IkxE64xhKU9bPeNOsQZxvzCakjNE7FqeoqOM0Usnku0qB
        J1UbWAYw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQ99k-0006em-4j; Mon, 13 May 2019 11:30:08 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E04FD2029F87D; Mon, 13 May 2019 13:30:06 +0200 (CEST)
Date:   Mon, 13 May 2019 13:30:06 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nadav Amit <namit@vmware.com>
Cc:     Yang Shi <yang.shi@linux.alibaba.com>,
        "jstancek@redhat.com" <jstancek@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Nick Piggin <npiggin@gmail.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Message-ID: <20190513113006.GP2623@hirez.programming.kicks-ass.net>
References: <1557264889-109594-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190509083726.GA2209@brain-police>
 <20190509103813.GP2589@hirez.programming.kicks-ass.net>
 <F22533A7-016F-4506-809A-7E86BAF24D5A@vmware.com>
 <20190509182435.GA2623@hirez.programming.kicks-ass.net>
 <04668E51-FD87-4D53-A066-5A35ABC3A0D6@vmware.com>
 <20190509191120.GD2623@hirez.programming.kicks-ass.net>
 <7DA60772-3EE3-4882-B26F-2A900690DA15@vmware.com>
 <20190513083606.GL2623@hirez.programming.kicks-ass.net>
 <75FD46B2-2E0C-41F2-9308-AB68C8780E33@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <75FD46B2-2E0C-41F2-9308-AB68C8780E33@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 13, 2019 at 09:11:38AM +0000, Nadav Amit wrote:
> BTW: sometimes you don’t see the effect of these full TLB flushes as much in
> VMs. I encountered a strange phenomenon at the time - INVLPG for an
> arbitrary page cause my Haswell machine flush the entire TLB, when the
> INVLPG was issued inside a VM. It took me quite some time to analyze this
> problem. Eventually Intel told me that’s part of what is called “page
> fracturing” - if the host uses 4k pages in the EPT, they (usually) need to
> flush the entire TLB for any INVLPG. That’s happens since they don’t know
> the size of the flushed page.

Cute... if only they'd given us an interface to tell them... :-)

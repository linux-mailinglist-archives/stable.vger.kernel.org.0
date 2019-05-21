Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5D1525AB9
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 01:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfEUXS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 19:18:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbfEUXS1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 19:18:27 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A07CF217D9;
        Tue, 21 May 2019 23:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558480707;
        bh=OqZTLBGMOxuOEC5Xxc6vRFdatZp8Y6uYyV+vbDmpUTw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yTbP1ahdfFWzH7+xIWDO3zK+bnX+jdec5gDJ+S/QtXR2kr6MEbshxQ6mcMgnmMNGy
         gn2nS3dR3xPTuzc8voQ3m6rV/qgZf9Cl8sN876UHucJAhZtf+5WgXTAQKk4R571MbI
         7ZTGPXgAWWaaaW5Wme4VZ07yTB531bWnJZwnlzWI=
Date:   Tue, 21 May 2019 16:18:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     jstancek@redhat.com, peterz@infradead.org, will.deacon@arm.com,
        npiggin@gmail.com, aneesh.kumar@linux.ibm.com, namit@vmware.com,
        minchan@kernel.org, mgorman@suse.de, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [v3 PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Message-Id: <20190521161826.029782de0750c8f5cd2e5dd6@linux-foundation.org>
In-Reply-To: <1558322252-113575-1-git-send-email-yang.shi@linux.alibaba.com>
References: <1558322252-113575-1-git-send-email-yang.shi@linux.alibaba.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 May 2019 11:17:32 +0800 Yang Shi <yang.shi@linux.alibaba.com> wrote:

> A few new fields were added to mmu_gather to make TLB flush smarter for
> huge page by telling what level of page table is changed.
> 
> __tlb_reset_range() is used to reset all these page table state to
> unchanged, which is called by TLB flush for parallel mapping changes for
> the same range under non-exclusive lock (i.e. read mmap_sem).  Before
> commit dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in
> munmap"), the syscalls (e.g. MADV_DONTNEED, MADV_FREE) which may update
> PTEs in parallel don't remove page tables.  But, the forementioned
> commit may do munmap() under read mmap_sem and free page tables.  This
> may result in program hang on aarch64 reported by Jan Stancek.  The
> problem could be reproduced by his test program with slightly modified
> below.
> 
> ...
> 
> Use fullmm flush since it yields much better performance on aarch64 and
> non-fullmm doesn't yields significant difference on x86.
> 
> The original proposed fix came from Jan Stancek who mainly debugged this
> issue, I just wrapped up everything together.

Thanks.  I'll add

Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")

to this.

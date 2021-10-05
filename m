Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E073423460
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 01:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236956AbhJEXRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 19:17:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236931AbhJEXRe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 19:17:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E69926120F;
        Tue,  5 Oct 2021 23:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633475743;
        bh=szEPXPJ8X7viHNp/RVsKgl6R1nk0IdsK/88slQMYcVg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xu6H9CpKaSGrCpUh59EyIcZJLp6lp04Ho01eCWaDXv2I8EGgSs/ZWs91kJ4KlQODu
         0wmV8khmYZLA5VRkTRcDSq0x95MXvZTt1aDFLORXy5an5BSeEpIxrsFRjkt8rcc+cO
         z77F1J9ZFYZOZXRLOph/nVFq0ODyEfkOipLdGmzE=
Date:   Tue, 5 Oct 2021 16:15:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Barry Song <song.bao.hua@hisilicon.com>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64/hugetlb: fix CMA gigantic page order for non-4K
 PAGE_SIZE
Message-Id: <20211005161542.176a63eb7e197d795c5196d9@linux-foundation.org>
In-Reply-To: <3747d914-c687-b983-c624-e3418b4d2448@oracle.com>
References: <20211005202529.213812-1-mike.kravetz@oracle.com>
        <20211005135435.341477bb4b50b84202c32450@linux-foundation.org>
        <3747d914-c687-b983-c624-e3418b4d2448@oracle.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 5 Oct 2021 14:28:03 -0700 Mike Kravetz <mike.kravetz@oracle.com> wrote:

> On 10/5/21 1:54 PM, Andrew Morton wrote:
> > On Tue,  5 Oct 2021 13:25:29 -0700 Mike Kravetz <mike.kravetz@oracle.com> wrote:
> > 
> >> For non-4K PAGE_SIZE configs, the largest gigantic huge page size is
> >> CONT_PMD_SHIFT order.
> > 
> > What are the user visible effects of this bug?
> > 
> > 
> 
> Sorry,
> I only recently got easy access to arm64 platforms.  This is what I saw
> as a user:
> 
> The largest gigantic huge page size on arm64 with 64K PAGE_SIZE 64K is
> 16G.  Therefore, one should be able to specify 'hugetlb_cma=16G' on the
> kernel command line so that 1 gigantic page can be allocated from CMA.
> However, when adding such an option the following message is produced:
> 
> hugetlb_cma: cma area should be at least 8796093022208 MiB
> 
> This is because the calculation for non-4K gigantic page order is
> incorrect in the arm64 specific routine arm64_hugetlb_cma_reserve().

Cool, thanks.

> Would you like me to send a new version with this in the commit message?
> Or, is it easier for you to just add it?

I assumed that it would be merged via the same path as the offending
abb7962adc80.  Catalin's arm tree, it appears.


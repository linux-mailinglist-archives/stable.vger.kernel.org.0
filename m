Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182931CF85D
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 17:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbgELPEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 11:04:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbgELPEu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 11:04:50 -0400
Received: from localhost (unknown [73.114.22.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEEF120736;
        Tue, 12 May 2020 15:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589295890;
        bh=bbz1pgGMMIdgRS4iDDatMZEmbjiD/iAuKKgNndmcPdo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KBpJCbm3u3FNX0eFPn6g7bxqfbyJVcGgUPES0UsMkzFtgc1GEYLRzOTKfU/r8VzOK
         hgol6prcfN5iSzNDsttFvHAJIsW8ytnDQ27oZPCS/nJPf4oBFYO6k2XVRmTN5QKpFJ
         dCk3ZAk12P5T4X4PXqRWWv0u8HUf7PW1Do5+NmTA=
Date:   Tue, 12 May 2020 11:04:44 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     mark.rutland@arm.com, catalin.marinas@arm.com,
        kyrylo.tkachov@arm.com, stable@vger.kernel.org, will@kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: hugetlb: avoid potential NULL
 dereference" failed to apply to 4.4-stable tree
Message-ID: <20200512150444.GR13035@sasha-vm>
References: <158928280312186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <158928280312186@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 12, 2020 at 01:26:43PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.4-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 027d0c7101f50cf03aeea9eebf484afd4920c8d3 Mon Sep 17 00:00:00 2001
>From: Mark Rutland <mark.rutland@arm.com>
>Date: Tue, 5 May 2020 13:59:30 +0100
>Subject: [PATCH] arm64: hugetlb: avoid potential NULL dereference
>MIME-Version: 1.0
>Content-Type: text/plain; charset=UTF-8
>Content-Transfer-Encoding: 8bit
>
>The static analyzer in GCC 10 spotted that in huge_pte_alloc() we may
>pass a NULL pmdp into pte_alloc_map() when pmd_alloc() returns NULL:
>
>|   CC      arch/arm64/mm/pageattr.o
>|   CC      arch/arm64/mm/hugetlbpage.o
>|                  from arch/arm64/mm/hugetlbpage.c:10:
>| arch/arm64/mm/hugetlbpage.c: In function ‘huge_pte_alloc’:
>| ./arch/arm64/include/asm/pgtable-types.h:28:24: warning: dereference of NULL ‘pmdp’ [CWE-690] [-Wanalyzer-null-dereference]
>| ./arch/arm64/include/asm/pgtable.h:436:26: note: in expansion of macro ‘pmd_val’
>| arch/arm64/mm/hugetlbpage.c:242:10: note: in expansion of macro ‘pte_alloc_map’
>|     |arch/arm64/mm/hugetlbpage.c:232:10:
>|     |./arch/arm64/include/asm/pgtable-types.h:28:24:
>| ./arch/arm64/include/asm/pgtable.h:436:26: note: in expansion of macro ‘pmd_val’
>| arch/arm64/mm/hugetlbpage.c:242:10: note: in expansion of macro ‘pte_alloc_map’
>
>This can only occur when the kernel cannot allocate a page, and so is
>unlikely to happen in practice before other systems start failing.
>
>We can avoid this by bailing out if pmd_alloc() fails, as we do earlier
>in the function if pud_alloc() fails.
>
>Fixes: 66b3923a1a0f ("arm64: hugetlb: add support for PTE contiguous bit")
>Signed-off-by: Mark Rutland <mark.rutland@arm.com>
>Reported-by: Kyrill Tkachov <kyrylo.tkachov@arm.com>
>Cc: <stable@vger.kernel.org> # 4.5.x-
>Cc: Will Deacon <will@kernel.org>
>Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

There was a context conflict with 441a62780687 ("arm64/hugetlb: Use
macros for contiguous huge page sizes"). I've fixed it and queued the
patch for 4.14 and 4.9.
-- 
Thanks,
Sasha

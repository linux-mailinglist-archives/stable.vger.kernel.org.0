Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4683A2C0D67
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 15:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbgKWOWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 09:22:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbgKWOWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 09:22:43 -0500
Received: from gaia (unknown [95.146.230.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8647E20782;
        Mon, 23 Nov 2020 14:22:40 +0000 (UTC)
Date:   Mon, 23 Nov 2020 14:22:37 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        Yu Zhao <yuzhao@google.com>, Minchan Kim <minchan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/6] arm64: pgtable: Ensure dirty bit is preserved across
 pte_wrprotect()
Message-ID: <20201123142237.GF17833@gaia>
References: <20201120143557.6715-1-will@kernel.org>
 <20201120143557.6715-3-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120143557.6715-3-will@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 20, 2020 at 02:35:53PM +0000, Will Deacon wrote:
> With hardware dirty bit management, calling pte_wrprotect() on a writable,
> dirty PTE will lose the dirty state and return a read-only, clean entry.

My assumption at the time was that the caller of pte_wrprotect() already
moved the 'dirty' information to the underlying page. Most
pte_wrprotect() calls also do a pte_mkclean(). However, it doesn't seem
to always be the case (soft-dirty but we don't support it yet).

I was worried that we may inadvertently set the dirty bit when doing a
pte_wrprotect() on a freshly created pte (not read from memory, for
example __split_huge_pmd_locked()) but I think all our __P* and __S*
attributes start with a PTE_RDONLY, therefore the pte_hw_dirty() returns
false. A test for mm/debug_vm_pgtable.c, something like:

	for (i = 0, i < ARRAY_SIZE(protection_map); i++) {
		pte = pfn_pte(pfn, protection_map(i));
		WARN_ON(pte_dirty(pte_wrprotect(pte));
	}

(I'll leave this to Anshuman ;))

> Move the logic from ptep_set_wrprotect() into pte_wrprotect() to ensure that
> the dirty bit is preserved for writable entries, as this is required for
> soft-dirty bit management if we enable it in the future.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Will Deacon <will@kernel.org>

I think this could go back as far as the hardware AF/DBM support (v4.3):

Fixes: 2f4b829c625e ("arm64: Add support for hardware updates of the access and dirty pte bits")

If you limit this fix to 4.14, you probably don't need additional
commits. Otherwise, at least this one:

3bbf7157ac66 ("arm64: Convert pte handling from inline asm to using (cmp)xchg")

and a slightly more intrusive:

73e86cb03cf2 ("arm64: Move PTE_RDONLY bit handling out of set_pte_at()")

We also had some attempts at fixing ptep_set_wrprotect():

64c26841b349 ("arm64: Ignore hardware dirty bit updates in ptep_set_wrprotect()")

Fixed subsequently by:

8781bcbc5e69 ("arm64: mm: Fix pte_mkclean, pte_mkdirty semantics")

I have a hope that at some point we'll understand how this all works ;).

For this patch:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

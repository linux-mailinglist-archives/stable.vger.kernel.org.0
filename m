Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC942C0DB7
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 15:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbgKWObz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 09:31:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729794AbgKWOby (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 09:31:54 -0500
Received: from gaia (unknown [95.146.230.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74C3820781;
        Mon, 23 Nov 2020 14:31:52 +0000 (UTC)
Date:   Mon, 23 Nov 2020 14:31:49 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Minchan Kim <minchan@kernel.org>
Cc:     Will Deacon <will@kernel.org>, kernel-team@android.com,
        Yu Zhao <yuzhao@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/6] arm64: pgtable: Ensure dirty bit is preserved across
 pte_wrprotect()
Message-ID: <20201123143149.GG17833@gaia>
References: <20201120143557.6715-1-will@kernel.org>
 <20201120143557.6715-3-will@kernel.org>
 <20201120170903.GC3377168@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120170903.GC3377168@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 20, 2020 at 09:09:03AM -0800, Minchan Kim wrote:
> On Fri, Nov 20, 2020 at 02:35:53PM +0000, Will Deacon wrote:
> > With hardware dirty bit management, calling pte_wrprotect() on a writable,
> > dirty PTE will lose the dirty state and return a read-only, clean entry.
> > 
> > Move the logic from ptep_set_wrprotect() into pte_wrprotect() to ensure that
> > the dirty bit is preserved for writable entries, as this is required for
> > soft-dirty bit management if we enable it in the future.
> > 
> > Cc: <stable@vger.kernel.org>
> 
> It this stable material if it would be a problem once ARM64 supports
> softdirty in future?

I don't think so. Arm64 did not have a hardware dirty mechanism from the
start, it was added later but in a way as to coexist with other CPUs or
peripherals that don't support it. So instead of setting a PTE_DIRTY bit
as one would expect, the CPU clears the PTE_RDONLY on write access to a
writable PTE (the PTE_DBM/PTE_WRITE bit set). So our pte_wrprotect()
needs to set PTE_RDONLY and clear PTE_DBM (PTE_WRITE) but !PTE_RDONLY is
our only information of a pte having been dirtied, so we have to
transfer it to a software PTE_DIRTY bit. This is different from a
soft-dirty pte bit if we add it in the future.

-- 
Catalin

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06262C0B9C
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389208AbgKWN17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:27:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731562AbgKWN16 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 08:27:58 -0500
Received: from gaia (unknown [95.146.230.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D14220782;
        Mon, 23 Nov 2020 13:27:55 +0000 (UTC)
Date:   Mon, 23 Nov 2020 13:27:52 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        Yu Zhao <yuzhao@google.com>, Minchan Kim <minchan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/6] arm64: pgtable: Fix pte_accessible()
Message-ID: <20201123132752.GE17833@gaia>
References: <20201120143557.6715-1-will@kernel.org>
 <20201120143557.6715-2-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120143557.6715-2-will@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 20, 2020 at 02:35:52PM +0000, Will Deacon wrote:
> pte_accessible() is used by ptep_clear_flush() to figure out whether TLB
> invalidation is necessary when unmapping pages for reclaim. Although our
> implementation is correct according to the architecture, returning true
> only for valid, young ptes in the absence of racing page-table
> modifications, this is in fact flawed due to lazy invalidation of old
> ptes in ptep_clear_flush_young() where we elide the expensive DSB
> instruction for completing the TLB invalidation.
> 
> Rather than penalise the aging path, adjust pte_accessible() to return
> true for any valid pte, even if the access flag is cleared.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 76c714be0e5e ("arm64: pgtable: implement pte_accessible()")
> Reported-by: Yu Zhao <yuzhao@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

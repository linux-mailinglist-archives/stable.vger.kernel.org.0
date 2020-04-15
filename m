Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE491AA30D
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505803AbgDONDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:03:44 -0400
Received: from foss.arm.com ([217.140.110.172]:45100 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503773AbgDONDm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 09:03:42 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D188A1063;
        Wed, 15 Apr 2020 06:03:41 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 62CF53F6C4;
        Wed, 15 Apr 2020 06:03:40 -0700 (PDT)
Date:   Wed, 15 Apr 2020 14:03:37 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, vincenzo.frascino@arm.com,
        will@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] arm64: vdso: don't free unallocated pages
Message-ID: <20200415130337.GC28304@C02TD0UTHF1T.local>
References: <20200414104252.16061-1-mark.rutland@arm.com>
 <20200414104252.16061-2-mark.rutland@arm.com>
 <20200415101310.GC6526@gaia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415101310.GC6526@gaia>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 11:13:11AM +0100, Catalin Marinas wrote:
> On Tue, Apr 14, 2020 at 11:42:48AM +0100, Mark Rutland wrote:
> > The aarch32_vdso_pages[] array never has entries allocated in the C_VVAR
> > or C_VDSO slots, and as the array is zero initialized these contain
> > NULL.
> > 
> > However in __aarch32_alloc_vdso_pages() when
> > aarch32_alloc_kuser_vdso_page() fails we attempt to free the page whose
> > struct page is at NULL, which is obviously nonsensical.
> > 
> > This patch removes the erroneous page freeing.
> > 
> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: stable@vger.kernel.org
> 
> I presume the cc stable should be limited to:
> 
> Fixes: 7c1deeeb0130 ("arm64: compat: VDSO setup for compat layer")
> Cc: <stable@vger.kernel.org> # 5.3.x-
> 
> I'll fix it up locally.

Yes, and thanks!

Mark.

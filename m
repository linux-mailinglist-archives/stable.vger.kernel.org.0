Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F0B1A9A3A
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 12:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896372AbgDOKOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 06:14:08 -0400
Received: from foss.arm.com ([217.140.110.172]:41466 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896362AbgDOKNg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 06:13:36 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19A131063;
        Wed, 15 Apr 2020 03:13:14 -0700 (PDT)
Received: from gaia (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4191E3F68F;
        Wed, 15 Apr 2020 03:13:13 -0700 (PDT)
Date:   Wed, 15 Apr 2020 11:13:11 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, vincenzo.frascino@arm.com,
        will@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] arm64: vdso: don't free unallocated pages
Message-ID: <20200415101310.GC6526@gaia>
References: <20200414104252.16061-1-mark.rutland@arm.com>
 <20200414104252.16061-2-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414104252.16061-2-mark.rutland@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 11:42:48AM +0100, Mark Rutland wrote:
> The aarch32_vdso_pages[] array never has entries allocated in the C_VVAR
> or C_VDSO slots, and as the array is zero initialized these contain
> NULL.
> 
> However in __aarch32_alloc_vdso_pages() when
> aarch32_alloc_kuser_vdso_page() fails we attempt to free the page whose
> struct page is at NULL, which is obviously nonsensical.
> 
> This patch removes the erroneous page freeing.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: stable@vger.kernel.org

I presume the cc stable should be limited to:

Fixes: 7c1deeeb0130 ("arm64: compat: VDSO setup for compat layer")
Cc: <stable@vger.kernel.org> # 5.3.x-

I'll fix it up locally.

-- 
Catalin

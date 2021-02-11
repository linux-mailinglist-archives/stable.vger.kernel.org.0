Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6383F318853
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 11:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhBKKiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 05:38:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230311AbhBKKgP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 05:36:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCA6D64E8B;
        Thu, 11 Feb 2021 10:35:31 +0000 (UTC)
Date:   Thu, 11 Feb 2021 10:35:29 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Luis Machado <luis.machado@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Steven Price <steven.price@arm.com>, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        David Spickett <david.spickett@linaro.org>
Subject: Re: [PATCH] arm64: mte: Allow PTRACE_PEEKMTETAGS access to the zero
 page
Message-ID: <20210211103528.GA12106@arm.com>
References: <20210210180316.23654-1-catalin.marinas@arm.com>
 <0916e89e-46b5-6002-7f9d-5d1df9e3e205@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0916e89e-46b5-6002-7f9d-5d1df9e3e205@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 10, 2021 at 03:52:18PM -0300, Luis Machado wrote:
> On 2/10/21 3:03 PM, Catalin Marinas wrote:
> > The ptrace(PTRACE_PEEKMTETAGS) implementation checks whether the user
> > page has valid tags (mapped with PROT_MTE) by testing the PG_mte_tagged
> > page flag. If this bit is cleared, ptrace(PTRACE_PEEKMTETAGS) returns
> > -EIO.
> > 
> > A newly created (PROT_MTE) mapping points to the zero page which had its
> > tags zeroed during cpu_enable_mte(). If there were no prior writes to
> > this mapping, ptrace(PTRACE_PEEKMTETAGS) fails with -EIO since the zero
> > page does not have the PG_mte_tagged flag set.
> > 
> > Set PG_mte_tagged on the zero page when its tags are cleared during
> > boot. In addition, to avoid ptrace(PTRACE_PEEKMTETAGS) succeeding on
> > !PROT_MTE mappings pointing to the zero page, change the
> > __access_remote_tags() check to (vm_flags & VM_MTE) instead of
> > PG_mte_tagged.
> > 
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Fixes: 34bfeea4a9e9 ("arm64: mte: Clear the tags when a page is mapped in user-space with PROT_MTE")
> > Cc: <stable@vger.kernel.org> # 5.10.x
> > Cc: Will Deacon <will@kernel.org>
> > Reported-by: Luis Machado <luis.machado@linaro.org>
[...]
> Thanks. I gave this a try and it works as expected. So memory that is
> PROT_MTE but has not been accessed yet can be inspected with PEEKMTETAGS
> without getting an EIO back.

Thanks. I assume I can add your tested-by.

-- 
Catalin

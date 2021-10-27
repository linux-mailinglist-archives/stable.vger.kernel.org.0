Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C17243CE84
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 18:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238116AbhJ0QTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 12:19:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhJ0QTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 12:19:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3618B60E76;
        Wed, 27 Oct 2021 16:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635351430;
        bh=v9grbAI3FqILUGkhSIP/vSoCHHwEZ9+rzbFCCMlHXt0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HvLJllQ7zhY2L5pvjRiZzVDgl+lbFR18tGeBCo8QHsJLRY5IlUCCWz6LLokuIPQ9R
         Vp3gfEDrVK2uoh/XoNZkJvljDcDxx28AJUsyv/ygbEHwAHMVZFr5m/5pEUMiyodeqF
         wmKrgvodNGrKZV745B6BFhINSskRX71blVzPsvG0=
Date:   Wed, 27 Oct 2021 18:17:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chen Huang <chenhuang5@huawei.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org, linux-mm@kvack.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 5.10.y] arm64: Avoid premature usercopy failure
Message-ID: <YXl7hEc9TA4ikpSe@kroah.com>
References: <20211027014047.2317325-1-chenhuang5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027014047.2317325-1-chenhuang5@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 27, 2021 at 01:40:47AM +0000, Chen Huang wrote:
> From: Robin Murphy <robin.murphy@arm.com>
> 
> commit 295cf156231ca3f9e3a66bde7fab5e09c41835e0 upstream.
> 
> Al reminds us that the usercopy API must only return complete failure
> if absolutely nothing could be copied. Currently, if userspace does
> something silly like giving us an unaligned pointer to Device memory,
> or a size which overruns MTE tag bounds, we may fail to honour that
> requirement when faulting on a multi-byte access even though a smaller
> access could have succeeded.
> 
> Add a mitigation to the fixup routines to fall back to a single-byte
> copy if we faulted on a larger access before anything has been written
> to the destination, to guarantee making *some* forward progress. We
> needn't be too concerned about the overall performance since this should
> only occur when callers are doing something a bit dodgy in the first
> place. Particularly broken userspace might still be able to trick
> generic_perform_write() into an infinite loop by targeting write() at
> an mmap() of some read-only device register where the fault-in load
> succeeds but any store synchronously aborts such that copy_to_user() is
> genuinely unable to make progress, but, well, don't do that...
> 
> CC: stable@vger.kernel.org
> Reported-by: Chen Huang <chenhuang5@huawei.com>
> Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> Link: https://lore.kernel.org/r/dc03d5c675731a1f24a62417dba5429ad744234e.1626098433.git.robin.murphy@arm.com
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Chen Huang <chenhuang5@huawei.com>
> ---
>  arch/arm64/lib/copy_from_user.S | 13 ++++++++++---
>  arch/arm64/lib/copy_in_user.S   | 21 ++++++++++++++-------
>  arch/arm64/lib/copy_to_user.S   | 14 +++++++++++---
>  3 files changed, 35 insertions(+), 13 deletions(-)

Both now queued up, thanks.

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722DF31BB07
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 15:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhBOO0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 09:26:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229944AbhBOO0g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 09:26:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4EB164DE0;
        Mon, 15 Feb 2021 14:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613399156;
        bh=VLx4SMURe+dTaWK2GGi0cUaLWF95Wu6xCUIc8/Ee1K4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nd6HlopJjhZhXiExQnObWRElqDsLWS3iWkhoHtfh2NSpQ0EXD46mY2ZfFs0i8t4T0
         ZmFkC3iaGw19vVa1TyDufu5rTnRznxv022Vi2OYIP3Pkx0f40S5xbIzqijdGFbYc1x
         hkUz7PkqiEI01fDz43zUBitWWhJ855w8Y4N5uP+0=
Date:   Mon, 15 Feb 2021 15:25:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     stable@vger.kernel.org, Will Deacon <will@kernel.org>
Subject: Re: [PATCH stable-5.10.y] arm64: mte: Allow PTRACE_PEEKMTETAGS
 access to the zero page
Message-ID: <YCqEcRmqhtOmfLp6@kroah.com>
References: <20210215131303.15395-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210215131303.15395-1-catalin.marinas@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 15, 2021 at 01:13:03PM +0000, Catalin Marinas wrote:
> commit 68d54ceeec0e5fee4fb8048e6a04c193f32525ca upstream.
> 
> The ptrace(PTRACE_PEEKMTETAGS) implementation checks whether the user
> page has valid tags (mapped with PROT_MTE) by testing the PG_mte_tagged
> page flag. If this bit is cleared, ptrace(PTRACE_PEEKMTETAGS) returns
> -EIO.
> 
> A newly created (PROT_MTE) mapping points to the zero page which had its
> tags zeroed during cpu_enable_mte(). If there were no prior writes to
> this mapping, ptrace(PTRACE_PEEKMTETAGS) fails with -EIO since the zero
> page does not have the PG_mte_tagged flag set.
> 
> Set PG_mte_tagged on the zero page when its tags are cleared during
> boot. In addition, to avoid ptrace(PTRACE_PEEKMTETAGS) succeeding on
> !PROT_MTE mappings pointing to the zero page, change the
> __access_remote_tags() check to (vm_flags & VM_MTE) instead of
> PG_mte_tagged.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Fixes: 34bfeea4a9e9 ("arm64: mte: Clear the tags when a page is mapped in user-space with PROT_MTE")
> Cc: <stable@vger.kernel.org> # 5.10.x
> Cc: Will Deacon <will@kernel.org>
> Reported-by: Luis Machado <luis.machado@linaro.org>
> Tested-by: Luis Machado <luis.machado@linaro.org>
> Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Link: https://lore.kernel.org/r/20210210180316.23654-1-catalin.marinas@arm.com
> ---
>  arch/arm64/kernel/cpufeature.c | 6 +-----
>  arch/arm64/kernel/mte.c        | 3 ++-
>  2 files changed, 3 insertions(+), 6 deletions(-)

Thanks, now queued up.

greg k-h

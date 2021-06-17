Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050DD3AAA8C
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 06:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhFQExQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 00:53:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229673AbhFQExO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Jun 2021 00:53:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 720B16023D;
        Thu, 17 Jun 2021 04:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623905467;
        bh=zhj/r02l03A3GGfq/13KwbHx9LGSapVvInAka2yMdDA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tyWMMcsKO83TGp2IXYb21OvpqgvfvItq86/osfFc1CmmVgqOrYyg4qe1op5rQ1dUz
         YjbNg5SDFz1KNnOz0xHNFN8pUkUXz9ZM6wH9X/kQOxDn2A5dPAyPolbWDLj6n0I84O
         6tPhkdooNG8sswZHsI7WEZ8BKqqUiIw98o17b6wA=
Date:   Thu, 17 Jun 2021 06:51:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Aman Priyadarshi <apeureka@amazon.de>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Alexander Graf <graf@amazon.de>,
        Mark Rutland <mark.rutland@arm.com>, stable@vger.kernel.org,
        Ali Saidi <alisaidi@amazon.com>
Subject: Re: [PATCH] arm64: perf: Disable PMU while processing counter
 overflows
Message-ID: <YMrUt+Vhs5exEqVt@kroah.com>
References: <YMoQ1MZgsL2hF2EL@kroah.com>
 <20210616192859.21708-1-apeureka@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616192859.21708-1-apeureka@amazon.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 09:28:59PM +0200, Aman Priyadarshi wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> [ Upstream commit 3cce50dfec4a5b0414c974190940f47dd32c6dee ]
> 
> The arm64 PMU updates the event counters and reprograms the
> counters in the overflow IRQ handler without disabling the
> PMU. This could potentially cause skews in for group counters,
> where the overflowed counters may potentially loose some event
> counts, while they are reprogrammed. To prevent this, disable
> the PMU while we process the counter overflows and enable it
> right back when we are done.
> 
> This patch also moves the PMU stop/start routines to avoid a
> forward declaration.
> 
> Suggested-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Aman Priyadarshi <apeureka@amazon.de>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/kernel/perf_event.c | 50 +++++++++++++++++++---------------
>  1 file changed, 28 insertions(+), 22 deletions(-)

What stable tree(s) do you want this applied to?

thanks,

greg k-h

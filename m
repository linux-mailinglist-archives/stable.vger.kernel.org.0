Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C12D3A9E45
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 16:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbhFPO52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 10:57:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234237AbhFPO51 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 10:57:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31B3C6105A;
        Wed, 16 Jun 2021 14:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623855318;
        bh=1wuRfE4Qki4l98r85PwYXI83uKL9FCU6hh9nRtEANw8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lme05jvrzlnJSbj75GU0eNefYhsWVPYshLP5a10R+eLrKsY9IGXh8mi1kPMjkobOt
         orW9HfU4w+cgUDc1zJBy4aoBqNtTkF5BMDdOBOGXfPVYKTmXOhMn+3kFpVQ7IIbkfW
         hmNAKcglSACqtTcWRUKC9emSbEXYKCeWGAOxUkxU=
Date:   Wed, 16 Jun 2021 16:55:16 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Aman Priyadarshi <apeureka@amazon.de>
Cc:     stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Alexander Graf <graf@amazon.com>,
        Ali Saidi <alisaidi@amazon.com>
Subject: Re: [v4.14.y] 3cce50dfec4a arm64: perf: Disable PMU while processing
 counter overflows
Message-ID: <YMoQ1MZgsL2hF2EL@kroah.com>
References: <61660ade9bedf601e2fdbd12c5fade05d910526d.camel@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61660ade9bedf601e2fdbd12c5fade05d910526d.camel@amazon.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 01:09:49PM +0200, Aman Priyadarshi wrote:
> Hi Greg,
> 
> Following the conversation with Marc, we discovered that an
> important fix for ARM PMU is not backported to 4.14.y tree, it affects
> counter value and give out nonsensical result.
> 
> Can you please include the following commit?
> ```
> commit 3cce50dfec4a5b0414c974190940f47dd32c6dee
> Author: Suzuki K Poulose <suzuki.poulose@arm.com>
> Date:   Tue Jul 10 09:58:03 2018 +0100
> 
>     arm64: perf: Disable PMU while processing counter overflows
>     
>     The arm64 PMU updates the event counters and reprograms the
>     counters in the overflow IRQ handler without disabling the
>     PMU. This could potentially cause skews in for group counters,
>     where the overflowed counters may potentially loose some event
>     counts, while they are reprogrammed. To prevent this, disable
>     the PMU while we process the counter overflows and enable it
>     right back when we are done.
>     
>     This patch also moves the PMU stop/start routines to avoid a
>     forward declaration.
>     
>     Suggested-by: Mark Rutland <mark.rutland@arm.com>
>     Cc: Will Deacon <will.deacon@arm.com>
>     Acked-by: Mark Rutland <mark.rutland@arm.com>
>     Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>     Signed-off-by: Will Deacon <will.deacon@arm.com>
> ```

It does not apply cleanly so you will have to provide a working backport
for us.

> For more details:
> 
> https://lists.cs.columbia.edu/pipermail/kvmarm/2021-June/047471.html


lore.kernel.org is your friend :)

thanks,

greg k-h

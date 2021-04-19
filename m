Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B541B36412B
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 14:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbhDSMBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 08:01:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232272AbhDSMBy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 08:01:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A3F66023E;
        Mon, 19 Apr 2021 12:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618833683;
        bh=mnHUtff+VuAPhbk5Pbx5r+Qb0vj43frhxKcHoJT4dSg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jm4JzOcAEuUzOnLVDeaqBpnXEzoL0ZwKCi9q95ZigKpBXZMPAQmOOTqPy1MPE0H33
         DPxMYLuaLLLjv5RT59hxVXzar2rX5o8XzIcGTYK5STYi5/YL9KgIqiHDYs8m6u8S8L
         tY0633NbXsag2O+CSybHYeocv+0JzD+UcC//wMws=
Date:   Mon, 19 Apr 2021 14:01:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH stable 5.10.x] arm64: mte: Ensure TIF_MTE_ASYNC_FAULT is
 set atomically
Message-ID: <YH1xER3D4Ly+fAWQ@kroah.com>
References: <20210419102849.2526-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419102849.2526-1-catalin.marinas@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 11:28:49AM +0100, Catalin Marinas wrote:
> commit 2decad92f4731fac9755a083fcfefa66edb7d67d upstream.
> 
> The entry from EL0 code checks the TFSRE0_EL1 register for any
> asynchronous tag check faults in user space and sets the
> TIF_MTE_ASYNC_FAULT flag. This is not done atomically, potentially
> racing with another CPU calling set_tsk_thread_flag().
> 
> Replace the non-atomic ORR+STR with an STSET instruction. While STSET
> requires ARMv8.1 and an assembler that understands LSE atomics, the MTE
> feature is part of ARMv8.5 and already requires an updated assembler.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Fixes: 637ec831ea4f ("arm64: mte: Handle synchronous and asynchronous tag check faults")
> Cc: <stable@vger.kernel.org> # 5.10.x

Thanks, now queued up.

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7B24A2FDC
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 14:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242473AbiA2Ntt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 08:49:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36220 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243176AbiA2Nts (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 08:49:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D4A960C84
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 13:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30641C340E5;
        Sat, 29 Jan 2022 13:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643464187;
        bh=MjvX0llIuTZMv75y4Kk6Gj9TnFiHSEJv3b4FKV8Z8lA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mNeL94fD9HrH5R3N0D24jE/SLfoyWF/zPKGt0U58NGK+tG3fsypRaK0JBEHo5YzJH
         78XqTi3dOTub7WepMXZ8OJdV5mW5eNfhPJGJzLsUKCuXtJ793+DgrpD/tU2iiv76td
         Rz1BZfENtVoGxOBpRZvlqKlganceIUWP9umcHhsI=
Date:   Sat, 29 Jan 2022 14:49:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     stable@vger.kernel.org,
        D Scott Phillips <scott@os.amperecomputing.com>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH stable-5.10] arm64: errata: Fix exec handling in erratum
 1418040 workaround
Message-ID: <YfVF+E0j34bHRLNg@kroah.com>
References: <20220129133827.1981620-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220129133827.1981620-1-catalin.marinas@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 29, 2022 at 01:38:27PM +0000, Catalin Marinas wrote:
> From: D Scott Phillips <scott@os.amperecomputing.com>
> 
> commit 38e0257e0e6f4fef2aa2966b089b56a8b1cfb75c upstream.
> 
> The erratum 1418040 workaround enables CNTVCT_EL1 access trapping in EL0
> when executing compat threads. The workaround is applied when switching
> between tasks, but the need for the workaround could also change at an
> exec(), when a non-compat task execs a compat binary or vice versa. Apply
> the workaround in arch_setup_new_exec().
> 
> This leaves a small window of time between SET_PERSONALITY and
> arch_setup_new_exec where preemption could occur and confuse the old
> workaround logic that compares TIF_32BIT between prev and next. Instead, we
> can just read cntkctl to make sure it's in the state that the next task
> needs. I measured cntkctl read time to be about the same as a mov from a
> general-purpose register on N1. Update the workaround logic to examine the
> current value of cntkctl instead of the previous task's compat state.
> 
> Fixes: d49f7d7376d0 ("arm64: Move handling of erratum 1418040 into C code")
> Cc: <stable@vger.kernel.org> # 5.9.x
> Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20211220234114.3926-1-scott@os.amperecomputing.com
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/kernel/process.c | 39 +++++++++++++++----------------------
>  1 file changed, 16 insertions(+), 23 deletions(-)

Thanks, both backports now queued up.

greg k-h

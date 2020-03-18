Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 921EB189FAC
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 16:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgCRPbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 11:31:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgCRPbx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 11:31:53 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F290420724;
        Wed, 18 Mar 2020 15:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584545512;
        bh=Uu+FaKlz6C/u1MN0wmedhgsAC9iNCwix5cQ7NwBI2L8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qoa0N7uwvHaXCcuDRLEed18m7ysX8o7HTBb5EI3MfpnEnMIyaCrB1bhxSYasmjnUA
         DMoWtzu1jdPV4dlvnDQn3TRHjOrZ/M3Z85wqt/5N0GRjK4cCeJ2g7quiXHM0aUXPnd
         iVg4G4SexdM/Vah7CefY4rEym9VJ4luqJ+ywnd9s=
Date:   Wed, 18 Mar 2020 11:31:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     kim.phillips@amd.com, bp@suse.de, peterz@infradead.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] perf/amd/uncore: Replace manual sampling
 check with" failed to apply to 4.19-stable tree
Message-ID: <20200318153150.GE4189@sasha-vm>
References: <158436358921825@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158436358921825@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 16, 2020 at 01:59:49PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From f967140dfb7442e2db0868b03b961f9c59418a1b Mon Sep 17 00:00:00 2001
>From: Kim Phillips <kim.phillips@amd.com>
>Date: Wed, 11 Mar 2020 14:13:21 -0500
>Subject: [PATCH] perf/amd/uncore: Replace manual sampling check with
> CAP_NO_INTERRUPT flag
>
>Enable the sampling check in kernel/events/core.c::perf_event_open(),
>which returns the more appropriate -EOPNOTSUPP.
>
>BEFORE:
>
>  $ sudo perf record -a -e instructions,l3_request_g1.caching_l3_cache_accesses true
>  Error:
>  The sys_perf_event_open() syscall returned with 22 (Invalid argument) for event (l3_request_g1.caching_l3_cache_accesses).
>  /bin/dmesg | grep -i perf may provide additional information.
>
>With nothing relevant in dmesg.
>
>AFTER:
>
>  $ sudo perf record -a -e instructions,l3_request_g1.caching_l3_cache_accesses true
>  Error:
>  l3_request_g1.caching_l3_cache_accesses: PMU Hardware doesn't support sampling/overflow-interrupts. Try 'perf stat'
>
>Fixes: c43ca5091a37 ("perf/x86/amd: Add support for AMD NB and L2I "uncore" counters")
>Signed-off-by: Kim Phillips <kim.phillips@amd.com>
>Signed-off-by: Borislav Petkov <bp@suse.de>
>Acked-by: Peter Zijlstra <peterz@infradead.org>
>Cc: stable@vger.kernel.org
>Link: https://lkml.kernel.org/r/20200311191323.13124-1-kim.phillips@amd.com

I've worked around not having PERF_PMU_CAP_NO_EXCLUDE on older kernels
and queued this patch for 4.19-4.4.

-- 
Thanks,
Sasha

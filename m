Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB6310695F
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 10:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfKVJ6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 04:58:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:42230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbfKVJ6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 04:58:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E26D020707;
        Fri, 22 Nov 2019 09:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574416688;
        bh=Cuc/IiXzyQEEw80jQjdU7jZhygmXvO8znC+p5H9OQLw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aZOZIyR+dvY6bOrR8vOgdbyYClJax1rGIKfP45kPORPGSVn5jkiDHColtsP5IAwZB
         47nVbkg93iTHw7fLQDsNkPAD06jW2aTVgYLTXVt/secLN2grNIcdkJAHUZBDb80SqJ
         1CGhsgzJpqbNOJeQXNy79Bt4r6ZnYGdWT5USQ7jE=
Date:   Fri, 22 Nov 2019 10:58:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Will Deacon <will@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        catalin.marinas@arm.com, mark.rutland@arm.com,
        pasha.tatashin@soleen.com
Subject: Re: [PATCH] [Backport to stable 4.9.y] arm64: uaccess: Ensure PAN is
 re-enabled after unhandled uaccess fault
Message-ID: <20191122095805.GA1882462@kroah.com>
References: <20191122095116.12244-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122095116.12244-1-will@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 09:51:16AM +0000, Will Deacon wrote:
> From: Pavel Tatashin <pasha.tatashin@soleen.com>
> 
> commit 94bb804e1e6f0a9a77acf20d7c70ea141c6c821e upstream.
> 
> A number of our uaccess routines ('__arch_clear_user()' and
> '__arch_copy_{in,from,to}_user()') fail to re-enable PAN if they
> encounter an unhandled fault whilst accessing userspace.
> 
> For CPUs implementing both hardware PAN and UAO, this bug has no effect
> when both extensions are in use by the kernel.
> 
> For CPUs implementing hardware PAN but not UAO, this means that a kernel
> using hardware PAN may execute portions of code with PAN inadvertently
> disabled, opening us up to potential security vulnerabilities that rely
> on userspace access from within the kernel which would usually be
> prevented by this mechanism. In other words, parts of the kernel run the
> same way as they would on a CPU without PAN implemented/emulated at all.
> 
> For CPUs not implementing hardware PAN and instead relying on software
> emulation via 'CONFIG_ARM64_SW_TTBR0_PAN=y', the impact is unfortunately
> much worse. Calling 'schedule()' with software PAN disabled means that
> the next task will execute in the kernel using the page-table and ASID
> of the previous process even after 'switch_mm()', since the actual
> hardware switch is deferred until return to userspace. At this point, or
> if there is a intermediate call to 'uaccess_enable()', the page-table
> and ASID of the new process are installed. Sadly, due to the changes
> introduced by KPTI, this is not an atomic operation and there is a very
> small window (two instructions) where the CPU is configured with the
> page-table of the old task and the ASID of the new task; a speculative
> access in this state is disastrous because it would corrupt the TLB
> entries for the new task with mappings from the previous address space.
> 
> As Pavel explains:
> 
>   | I was able to reproduce memory corruption problem on Broadcom's SoC
>   | ARMv8-A like this:
>   |
>   | Enable software perf-events with PERF_SAMPLE_CALLCHAIN so userland's
>   | stack is accessed and copied.
>   |
>   | The test program performed the following on every CPU and forking
>   | many processes:
>   |
>   |	unsigned long *map = mmap(NULL, PAGE_SIZE, PROT_READ|PROT_WRITE,
>   |				  MAP_SHARED | MAP_ANONYMOUS, -1, 0);
>   |	map[0] = getpid();
>   |	sched_yield();
>   |	if (map[0] != getpid()) {
>   |		fprintf(stderr, "Corruption detected!");
>   |	}
>   |	munmap(map, PAGE_SIZE);
>   |
>   | From time to time I was getting map[0] to contain pid for a
>   | different process.
> 
> Ensure that PAN is re-enabled when returning after an unhandled user
> fault from our uaccess routines.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> Tested-by: Mark Rutland <mark.rutland@arm.com>
> Cc: <stable@vger.kernel.org>
> Fixes: 338d4f49d6f7 ("arm64: kernel: Add support for Privileged Access Never")
> Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
> [will: rewrote commit message]
> [will: backport for 4.9.y stable kernels]

Thanks for this and the 4.4.y backport, both now queued up.

greg k-h

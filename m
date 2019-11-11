Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5091DF763A
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 15:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfKKOTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 09:19:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726878AbfKKOTS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 09:19:18 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D4B021925;
        Mon, 11 Nov 2019 14:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573481957;
        bh=E/I97ioM7GSv4iV6Y1iXJv0l7s/c6f2i+DE0hdIUElU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d0k9EkPg47OcifkfinAQ3mD/xCWQZtI3Jo4XCptQpce+C2kAsUmE8LlngRx5RlnNq
         ZN4NPilUyH6ViLAhI+TfQ0HNMDhi+wfR1arBj7tB7SG+OqPs8aTZbtjv5cWAnCSsbY
         ZR+u/f3G+M7/DSOWenNIACJep61zKMJUZ6ay/gJE=
Date:   Mon, 11 Nov 2019 09:19:16 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     chenhc@lemote.com, arnd@arndb.de, luto@kernel.org,
        paul.burton@mips.com, tglx@linutronix.de,
        vincenzo.frascino@arm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] timekeeping/vsyscall: Update VDSO data
 unconditionally" failed to apply to 5.3-stable tree
Message-ID: <20191111141916.GE8496@sasha-vm>
References: <1573453837131100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1573453837131100@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 07:30:37AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.3-stable tree.
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
>From 52338415cf4d4064ae6b8dd972dadbda841da4fa Mon Sep 17 00:00:00 2001
>From: Huacai Chen <chenhc@lemote.com>
>Date: Thu, 24 Oct 2019 11:28:29 +0800
>Subject: [PATCH] timekeeping/vsyscall: Update VDSO data unconditionally
>
>The update of the VDSO data is depending on __arch_use_vsyscall() returning
>True. This is a leftover from the attempt to map the features of various
>architectures 1:1 into generic code.
>
>The usage of __arch_use_vsyscall() in the actual vsyscall implementations
>got dropped and replaced by the requirement for the architecture code to
>return U64_MAX if the global clocksource is not usable in the VDSO.
>
>But the __arch_use_vsyscall() check in the update code stayed which causes
>the VDSO data to be stale or invalid when an architecture actually
>implements that function and returns False when the current clocksource is
>not usable in the VDSO.
>
>As a consequence the VDSO implementations of clock_getres(), time(),
>clock_gettime(CLOCK_.*_COARSE) operate on invalid data and return bogus
>information.
>
>Remove the __arch_use_vsyscall() check from the VDSO update function and
>update the VDSO data unconditionally.
>
>[ tglx: Massaged changelog and removed the now useless implementations in
>  	asm-generic/ARM64/MIPS ]
>
>Fixes: 44f57d788e7deecb50 ("timekeeping: Provide a generic update_vsyscall() implementation")
>Signed-off-by: Huacai Chen <chenhc@lemote.com>
>Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>Cc: Andy Lutomirski <luto@kernel.org>
>Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
>Cc: Arnd Bergmann <arnd@arndb.de>
>Cc: Paul Burton <paul.burton@mips.com>
>Cc: linux-mips@vger.kernel.org
>Cc: linux-arm-kernel@lists.infradead.org
>Cc: stable@vger.kernel.org
>Link: https://lkml.kernel.org/r/1571887709-11447-1-git-send-email-chenhc@lemote.com

I've dropped the mips bits because we don't have 24640f233b46 ("mips:
Add support for generic vDSO") on 5.3 and queued it up.

-- 
Thanks,
Sasha

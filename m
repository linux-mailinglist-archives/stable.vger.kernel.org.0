Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95348141F17
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 17:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgASQgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 11:36:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:33960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbgASQgi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Jan 2020 11:36:38 -0500
Received: from localhost (96-81-74-198-static.hfc.comcastbusiness.net [96.81.74.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A720720679;
        Sun, 19 Jan 2020 16:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579451797;
        bh=/bx+yN8jpdYywV4f+8wcmgyIsGt1frYX136HUJoVIa0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AIkCSJcZUwzjDHryMOhZ02Q5eIuAD8hCiWxnCYL1IuXirc6P2zHSEDAnG+fDGwCQY
         KHViFD1zPG5uDNNoBL25Qa+oaBb5+hrf2F3Xlz/CTQWMQz1KoSxUX3q05gi7HConYW
         GIU9kULURMtoyvLTtnKmJPekd4KkN7Mr5XvtXMek=
Date:   Sun, 19 Jan 2020 11:36:35 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     arnd@arndb.de, jkosina@suse.cz, tglx@linutronix.de,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] cpu/SMT: Fix x86 link error without
 CONFIG_SYSFS" failed to apply to 4.19-stable tree
Message-ID: <20200119163635.GU1706@sasha-vm>
References: <1579444808186154@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1579444808186154@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 19, 2020 at 03:40:08PM +0100, gregkh@linuxfoundation.org wrote:
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
>From dc8d37ed304eeeea47e65fb9edc1c6c8b0093386 Mon Sep 17 00:00:00 2001
>From: Arnd Bergmann <arnd@arndb.de>
>Date: Tue, 10 Dec 2019 20:56:04 +0100
>Subject: [PATCH] cpu/SMT: Fix x86 link error without CONFIG_SYSFS
>
>When CONFIG_SYSFS is disabled, but CONFIG_HOTPLUG_SMT is enabled,
>the kernel fails to link:
>
>arch/x86/power/cpu.o: In function `hibernate_resume_nonboot_cpu_disable':
>(.text+0x38d): undefined reference to `cpuhp_smt_enable'
>arch/x86/power/hibernate.o: In function `arch_resume_nosmt':
>hibernate.c:(.text+0x291): undefined reference to `cpuhp_smt_enable'
>hibernate.c:(.text+0x29c): undefined reference to `cpuhp_smt_disable'
>
>Move the exported functions out of the #ifdef section into its
>own with the correct conditions.
>
>The patch that caused this is marked for stable backports, so
>this one may need to be backported as well.
>
>Fixes: ec527c318036 ("x86/power: Fix 'nosmt' vs hibernation triple fault during resume")
>Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>Reviewed-by: Jiri Kosina <jkosina@suse.cz>
>Cc: stable@vger.kernel.org
>Link: https://lore.kernel.org/r/20191210195614.786555-1-arnd@arndb.de

I'm not actually seeing this failure on 4.19 and older, so I won't try
and figure this out.

$ grep 'CONFIG_HOTPLUG_SMT\|CONFIG_SYSFS' .config
# CONFIG_SYSFS_SYSCALL is not set
CONFIG_HOTPLUG_SMT=y
# CONFIG_SYSFS is not set
$ make -j
[...]
Kernel: arch/x86/boot/bzImage is ready  (#1)

-- 
Thanks,
Sasha

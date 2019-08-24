Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB7A19BECD
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 18:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727679AbfHXQap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Aug 2019 12:30:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbfHXQap (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Aug 2019 12:30:45 -0400
Received: from localhost (unknown [8.46.76.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E87272133F;
        Sat, 24 Aug 2019 16:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566664243;
        bh=+JuKxCOgJyBntCQvY6U3JY+tJ2pkpRKpi7Kas9YX6aQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2JCsvY6KrYzxYIpv+m8WMh+iSkH0tmAKK2RhzWqbs9T4ahODOuEjgejLGapr5RUd9
         tffZ1z1dcUGfhiBbn+/plVU7AmJxYa08G3zby2VydzN3K4cMa8xutpmhkbQBEWLw7d
         dmhrbql6MJj0ka0EGuC9P5zWcopoMB8TBOVm/uo0=
Date:   Sat, 24 Aug 2019 09:50:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     linux-tip-commits@vger.kernel.org,
        "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Chen Yu <yu.c.chen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [tip: x86/urgent] x86/CPU/AMD: Clear RDRAND CPUID bit on AMD
 family 15h/16h
Message-ID: <20190824135028.GJ1581@sasha-vm>
References: <7543af91666f491547bd86cebb1e17c66824ab9f.1566229943.git.thomas.lendacky@amd.com>
 <156652264945.9541.4969272027980914591.tip-bot2@tip-bot2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <156652264945.9541.4969272027980914591.tip-bot2@tip-bot2>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 23, 2019 at 01:10:49AM -0000, tip-bot2 for Tom Lendacky wrote:
>The following commit has been merged into the x86/urgent branch of tip:
>
>Commit-ID:     c49a0a80137c7ca7d6ced4c812c9e07a949f6f24
>Gitweb:        https://git.kernel.org/tip/c49a0a80137c7ca7d6ced4c812c9e07a949f6f24
>Author:        Tom Lendacky <thomas.lendacky@amd.com>
>AuthorDate:    Mon, 19 Aug 2019 15:52:35
>Committer:     Borislav Petkov <bp@suse.de>
>CommitterDate: Mon, 19 Aug 2019 19:42:52 +02:00
>
>x86/CPU/AMD: Clear RDRAND CPUID bit on AMD family 15h/16h
>
>There have been reports of RDRAND issues after resuming from suspend on
>some AMD family 15h and family 16h systems. This issue stems from a BIOS
>not performing the proper steps during resume to ensure RDRAND continues
>to function properly.
>
>RDRAND support is indicated by CPUID Fn00000001_ECX[30]. This bit can be
>reset by clearing MSR C001_1004[62]. Any software that checks for RDRAND
>support using CPUID, including the kernel, will believe that RDRAND is
>not supported.
>
>Update the CPU initialization to clear the RDRAND CPUID bit for any family
>15h and 16h processor that supports RDRAND. If it is known that the family
>15h or family 16h system does not have an RDRAND resume issue or that the
>system will not be placed in suspend, the "rdrand=force" kernel parameter
>can be used to stop the clearing of the RDRAND CPUID bit.
>
>Additionally, update the suspend and resume path to save and restore the
>MSR C001_1004 value to ensure that the RDRAND CPUID setting remains in
>place after resuming from suspend.
>
>Note, that clearing the RDRAND CPUID bit does not prevent a processor
>that normally supports the RDRAND instruction from executing it. So any
>code that determined the support based on family and model won't #UD.
>
>Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>Signed-off-by: Borislav Petkov <bp@suse.de>
>Cc: Andrew Cooper <andrew.cooper3@citrix.com>
>Cc: Andrew Morton <akpm@linux-foundation.org>
>Cc: Chen Yu <yu.c.chen@intel.com>
>Cc: "H. Peter Anvin" <hpa@zytor.com>
>Cc: Ingo Molnar <mingo@redhat.com>
>Cc: Jonathan Corbet <corbet@lwn.net>
>Cc: Josh Poimboeuf <jpoimboe@redhat.com>
>Cc: Juergen Gross <jgross@suse.com>
>Cc: Kees Cook <keescook@chromium.org>
>Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
>Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
>Cc: Nathan Chancellor <natechancellor@gmail.com>
>Cc: Paolo Bonzini <pbonzini@redhat.com>
>Cc: Pavel Machek <pavel@ucw.cz>
>Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
>Cc: <stable@vger.kernel.org>
>Cc: Thomas Gleixner <tglx@linutronix.de>
>Cc: "x86@kernel.org" <x86@kernel.org>
>Link: https://lkml.kernel.org/r/7543af91666f491547bd86cebb1e17c66824ab9f.1566229943.git.thomas.lendacky@amd.com
>---
> Documentation/admin-guide/kernel-parameters.txt |  7 +-
> arch/x86/include/asm/msr-index.h                |  1 +-
> arch/x86/kernel/cpu/amd.c                       | 66 +------------
> arch/x86/power/cpu.c                            | 86 ++--------------
> 4 files changed, 13 insertions(+), 147 deletions(-)
>
>diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>index 4c19719..47d981a 100644
>--- a/Documentation/admin-guide/kernel-parameters.txt
>+++ b/Documentation/admin-guide/kernel-parameters.txt
>@@ -4090,13 +4090,6 @@
> 			Run specified binary instead of /init from the ramdisk,
> 			used for early userspace startup. See initrd.
>
>-	rdrand=		[X86]
>-			force - Override the decision by the kernel to hide the
>-				advertisement of RDRAND support (this affects
>-				certain AMD processors because of buggy BIOS
>-				support, specifically around the suspend/resume
>-				path).
>-

Why is this being removed (along with supporting code)?

--
Thanks,
Sasha

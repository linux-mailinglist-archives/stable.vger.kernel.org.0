Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAE4E111FA9
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbfLCWln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:41:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727693AbfLCWlm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:41:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52584207DD;
        Tue,  3 Dec 2019 22:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412901;
        bh=dWq0ySzyJnxJdJhCQJbxx49QxdxOFKU1fwd+oyAFV/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ty5SlETn7UoXOIsw6AN0zZy2r6Ph+Dll53tqaY79WUXocAbaN3S66qa8CmI7LJqQq
         t4IgdPM/ThS++ftJyH86k6wi3WdzvZch/Nff3oki/N/EziOTAN7cYLD7K0bnf/DLAw
         YI/c6y8H55Y7S8NLg+zAjn9UTmC4JR7CPyRG55mQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Zhivich <mzhivich@akamai.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 060/135] x86/tsc: Respect tsc command line paraemeter for clocksource_tsc_early
Date:   Tue,  3 Dec 2019 23:35:00 +0100
Message-Id: <20191203213022.231008467@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Zhivich <mzhivich@akamai.com>

[ Upstream commit 63ec58b44fcc05efd1542045abd7faf056ac27d9 ]

The introduction of clocksource_tsc_early broke the functionality of
"tsc=reliable" and "tsc=nowatchdog" command line parameters, since
clocksource_tsc_early is unconditionally registered with
CLOCK_SOURCE_MUST_VERIFY and thus put on the watchdog list.

This can cause the TSC to be declared unstable during boot:

  clocksource: timekeeping watchdog on CPU0: Marking clocksource
               'tsc-early' as unstable because the skew is too large:
  clocksource: 'refined-jiffies' wd_now: fffb7018 wd_last: fffb6e9d
               mask: ffffffff
  clocksource: 'tsc-early' cs_now: 68a6a7070f6a0 cs_last: 68a69ab6f74d6
               mask: ffffffffffffffff
  tsc: Marking TSC unstable due to clocksource watchdog

The corresponding elapsed times are cs_nsec=1224152026 and wd_nsec=378942392, so
the watchdog differs from TSC by 0.84 seconds.

This happens when HPET is not available and jiffies are used as the TSC
watchdog instead and the jiffies update is not happening due to lost timer
interrupts in periodic mode, which can happen e.g. with expensive debug
mechanisms enabled or under massive overload conditions in virtualized
environments.

Before the introduction of the early TSC clocksource the command line
parameters "tsc=reliable" and "tsc=nowatchdog" could be used to work around
this issue.

Restore the behaviour by disabling the watchdog if requested on the kernel
command line.

[ tglx: Clarify changelog ]

Fixes: aa83c45762a24 ("x86/tsc: Introduce early tsc clocksource")
Signed-off-by: Michael Zhivich <mzhivich@akamai.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20191024175945.14338-1-mzhivich@akamai.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/tsc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 57d87f79558f2..04dd3cc6c6edd 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1505,6 +1505,9 @@ void __init tsc_init(void)
 		return;
 	}
 
+	if (tsc_clocksource_reliable || no_tsc_watchdog)
+		clocksource_tsc_early.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
+
 	clocksource_register_khz(&clocksource_tsc_early, tsc_khz);
 	detect_art();
 }
-- 
2.20.1




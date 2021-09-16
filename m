Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293FC40E686
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343945AbhIPRWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351994AbhIPRUK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AB6B61BA3;
        Thu, 16 Sep 2021 16:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810526;
        bh=50YXhMmBJBhR55rbNXd7AEWdWQP1PFZ8gTBGr6jGd08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4DfzvMCQZK+4o/XobWxP6DYZDlByYXbHchGmd3W61If22msZ55lsgdAbNta50oLy
         zXmKsMPw887RzgcJAAVoeybKyUSsqNjVeB1IcWvMYtetCqxEirXM+SCLmgImfKydBx
         Ae17UnsA75ovUAwk91BYuaggFrZc6Gio7JuLM/WE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ani Sinha <ani@anisinha.ca>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 174/432] x86/hyperv: fix for unwanted manipulation of sched_clock when TSC marked unstable
Date:   Thu, 16 Sep 2021 17:58:43 +0200
Message-Id: <20210916155816.639918053@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ani Sinha <ani@anisinha.ca>

[ Upstream commit c445535c3efbfb8cb42d098e624d46ab149664b7 ]

Marking TSC as unstable has a side effect of marking sched_clock as
unstable when TSC is still being used as the sched_clock. This is not
desirable. Hyper-V ultimately uses a paravirtualized clock source that
provides a stable scheduler clock even on systems without TscInvariant
CPU capability. Hence, mark_tsc_unstable() call should be called _after_
scheduler clock has been changed to the paravirtualized clocksource. This
will prevent any unwanted manipulation of the sched_clock. Only TSC will
be correctly marked as unstable.

Signed-off-by: Ani Sinha <ani@anisinha.ca>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Tested-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20210713030522.1714803-1-ani@anisinha.ca
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mshyperv.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index c890d67a64ad..ba54c44a64e2 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -375,8 +375,6 @@ static void __init ms_hyperv_init_platform(void)
 	if (ms_hyperv.features & HV_ACCESS_TSC_INVARIANT) {
 		wrmsrl(HV_X64_MSR_TSC_INVARIANT_CONTROL, 0x1);
 		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
-	} else {
-		mark_tsc_unstable("running on Hyper-V");
 	}
 
 	/*
@@ -437,6 +435,13 @@ static void __init ms_hyperv_init_platform(void)
 	/* Register Hyper-V specific clocksource */
 	hv_init_clocksource();
 #endif
+	/*
+	 * TSC should be marked as unstable only after Hyper-V
+	 * clocksource has been initialized. This ensures that the
+	 * stability of the sched_clock is not altered.
+	 */
+	if (!(ms_hyperv.features & HV_ACCESS_TSC_INVARIANT))
+		mark_tsc_unstable("running on Hyper-V");
 }
 
 static bool __init ms_hyperv_x2apic_available(void)
-- 
2.30.2




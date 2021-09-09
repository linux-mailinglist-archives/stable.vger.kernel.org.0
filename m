Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCBE405083
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353298AbhIIM2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349230AbhIIMYS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:24:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E724F61B06;
        Thu,  9 Sep 2021 11:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188286;
        bh=UWOSj+0dV3ODPeSKP/0a/hFg/2YrWllal63cm9OEM6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDvXPuoWpYK/zm3zWMrVDPmfsyQyWQxlbRybwo+3ae7HutaXoCF2tzkyb6/H5TPbD
         43NSGhctye/rUFCZtJJtFw6LmY7pXib0GnpZey/nmMxCQRQGSdnjeD2CRFOm+1TIwD
         BdQ3ugBPswbdkKrz9Ly98+45d9pn6vUT0m4MWNm2GXFqqKivyL0hRu5LJqWBA2l7aH
         X/cUQBX7mCPSaWYEnXcyjMZ14mhI+jwIgTFA7qTeUaux9AP40FYlqK1+oYAEI7jzeW
         itvZOZlHBqB5ItVQqX0anlO1TNLK4MmbadhVPiw/9ZVx0+1LrNiIHCdrPIUJW8fqci
         BmA4HPpQelbkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ani Sinha <ani@anisinha.ca>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 006/176] x86/hyperv: fix for unwanted manipulation of sched_clock when TSC marked unstable
Date:   Thu,  9 Sep 2021 07:48:28 -0400
Message-Id: <20210909115118.146181-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 6cc50ab07bde..65d11711cd7b 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -322,8 +322,6 @@ static void __init ms_hyperv_init_platform(void)
 	if (ms_hyperv.features & HV_ACCESS_TSC_INVARIANT) {
 		wrmsrl(HV_X64_MSR_TSC_INVARIANT_CONTROL, 0x1);
 		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
-	} else {
-		mark_tsc_unstable("running on Hyper-V");
 	}
 
 	/*
@@ -382,6 +380,13 @@ static void __init ms_hyperv_init_platform(void)
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
 
 const __initconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
-- 
2.30.2


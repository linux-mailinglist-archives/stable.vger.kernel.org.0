Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC909F664B
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbfKJCnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:43:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:40280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728134AbfKJCnE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:43:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB5AF215EA;
        Sun, 10 Nov 2019 02:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353784;
        bh=qkicH2MlqzIN3/RdNN9n93QUaq2lEpRbMdN3DpJxfkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCzAYOLkjU2oPjPejUfUqvqRxPjiimvtKaHhvyUnd3DZV4Ef0/S6atpcQ3MW0+cQ7
         uyBvmBmSGIlLFCFTX6LIClH/a6txS48SAtOKqWzeVCIQS0YZad+BbmRcFmjgxrACyz
         0KD6OBp384K1l65rNyVYNB/h4Z8zSFKjLUo6EST0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matthew Whitehead <tedheadster@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Borislav Petkov <bp@suse.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 087/191] x86/CPU: Change query logic so CPUID is enabled before testing
Date:   Sat,  9 Nov 2019 21:38:29 -0500
Message-Id: <20191110024013.29782-87-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Whitehead <tedheadster@gmail.com>

[ Upstream commit 2893cc8ff892fa74972d8dc0e1d0dc65116daaa3 ]

Presently we check first if CPUID is enabled. If it is not already
enabled, then we next call identify_cpu_without_cpuid() and clear
X86_FEATURE_CPUID.

Unfortunately, identify_cpu_without_cpuid() is the function where CPUID
becomes _enabled_ on Cyrix 6x86/6x86L CPUs.

Reverse the calling sequence so that CPUID is first enabled, and then
check a second time to see if the feature has now been activated.

[ bp: Massage commit message and remove trailing whitespace. ]

Suggested-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Matthew Whitehead <tedheadster@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20180921212041.13096-3-tedheadster@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index b33fdfa0ff49e..04622625f8e22 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1104,6 +1104,9 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 	memset(&c->x86_capability, 0, sizeof c->x86_capability);
 	c->extended_cpuid_level = 0;
 
+	if (!have_cpuid_p())
+		identify_cpu_without_cpuid(c);
+
 	/* cyrix could have cpuid enabled via c_identify()*/
 	if (have_cpuid_p()) {
 		cpu_detect(c);
@@ -1121,7 +1124,6 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 		if (this_cpu->c_bsp_init)
 			this_cpu->c_bsp_init(c);
 	} else {
-		identify_cpu_without_cpuid(c);
 		setup_clear_cpu_cap(X86_FEATURE_CPUID);
 	}
 
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBDBBA6C7
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393305AbfIVSw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:52:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393285AbfIVSw4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:52:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C574021479;
        Sun, 22 Sep 2019 18:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178375;
        bh=CguQhBGjD/VMo7E6gLNngt9pIJo06htO8RE80jx/QE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCgo2s51pnPQ40JDwPUBpZ2LStRdLbQh8NIMlGfGLqmvwiGbvZwpW77B7lEBGVjPV
         2Hi6SdOzUwtbsSV6+ZR/RKMXCyEjnimTFeZ5qzwTW6ER6Bsa1mWGghZ6y+PgsBt8GC
         mWzMlmvAaGXVnm0tKFBk0YBzkJSk9Oi6Ua8u7YiE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neil Horman <nhorman@tuxdriver.com>, djuran@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 125/185] x86/apic/vector: Warn when vector space exhaustion breaks affinity
Date:   Sun, 22 Sep 2019 14:48:23 -0400
Message-Id: <20190922184924.32534-125-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>

[ Upstream commit 743dac494d61d991967ebcfab92e4f80dc7583b3 ]

On x86, CPUs are limited in the number of interrupts they can have affined
to them as they only support 256 interrupt vectors per CPU. 32 vectors are
reserved for the CPU and the kernel reserves another 22 for internal
purposes. That leaves 202 vectors for assignement to devices.

When an interrupt is set up or the affinity is changed by the kernel or the
administrator, the vector assignment code attempts to honor the requested
affinity mask. If the vector space on the CPUs in that affinity mask is
exhausted the code falls back to a wider set of CPUs and assigns a vector
on a CPU outside of the requested affinity mask silently.

While the effective affinity is reflected in the corresponding
/proc/irq/$N/effective_affinity* files the silent breakage of the requested
affinity can lead to unexpected behaviour for administrators.

Add a pr_warn() when this happens so that adminstrators get at least
informed about it in the syslog.

[ tglx: Massaged changelog and made the pr_warn() more informative ]

Reported-by: djuran@redhat.com
Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: djuran@redhat.com
Link: https://lkml.kernel.org/r/20190822143421.9535-1-nhorman@tuxdriver.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/apic/vector.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index fdacb864c3dd4..2c5676b0a6e7f 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -398,6 +398,17 @@ static int activate_reserved(struct irq_data *irqd)
 		if (!irqd_can_reserve(irqd))
 			apicd->can_reserve = false;
 	}
+
+	/*
+	 * Check to ensure that the effective affinity mask is a subset
+	 * the user supplied affinity mask, and warn the user if it is not
+	 */
+	if (!cpumask_subset(irq_data_get_effective_affinity_mask(irqd),
+			    irq_data_get_affinity_mask(irqd))) {
+		pr_warn("irq %u: Affinity broken due to vector space exhaustion.\n",
+			irqd->irq);
+	}
+
 	return ret;
 }
 
-- 
2.20.1


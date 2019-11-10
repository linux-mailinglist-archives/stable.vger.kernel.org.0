Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0624FF6511
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfKJDEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:04:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729196AbfKJCqz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:46:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C936215EA;
        Sun, 10 Nov 2019 02:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354015;
        bh=YRs4s1sjG7eJRwKwYyVft9OLeY3xfnyFEOZciMSfYyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6CuTPV3mueLXK1kRbKj7r96Ewau8R6IrT3QVmzV6J27eq9/q5e14z2kDithOHawo
         MYO/htHsymzwaYfFS4q5nIsTc9XEXF6M2ANbY5hvA/bC0FebkU0Tg/nlQBQs6S1sY4
         ek4wx667Gyj7n7vT71kgM+8+u184x7aNQIjAweR8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 039/109] x86/mce-inject: Reset injection struct after injection
Date:   Sat,  9 Nov 2019 21:44:31 -0500
Message-Id: <20191110024541.31567-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit 7401a633c34adc7aefd3edfec60074cb0475a3e8 ]

Clear the MCE struct which is used for collecting the injection details
after injection.

Also, populate it with more details from the machine.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20180905081954.10391-1-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mcheck/mce-inject.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 8fec687b3e44e..f12141ba9a76d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -108,6 +108,9 @@ static void setup_inj_struct(struct mce *m)
 	memset(m, 0, sizeof(struct mce));
 
 	m->cpuvendor = boot_cpu_data.x86_vendor;
+	m->time	     = ktime_get_real_seconds();
+	m->cpuid     = cpuid_eax(1);
+	m->microcode = boot_cpu_data.microcode;
 }
 
 /* Update fake mce registers on current CPU. */
@@ -576,6 +579,9 @@ static int inj_bank_set(void *data, u64 val)
 	m->bank = val;
 	do_inject();
 
+	/* Reset injection struct */
+	setup_inj_struct(&i_mce);
+
 	return 0;
 }
 
-- 
2.20.1


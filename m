Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611B839A376
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 16:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbhFCOkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 10:40:12 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46932 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbhFCOkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 10:40:11 -0400
Date:   Thu, 03 Jun 2021 14:38:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622731105;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=K3H1VW0CtTFXD8tm4bdGBxZU4YlnE9uQpzD1S0GM66w=;
        b=j/Pysq5tXzTafupxE/YZsotxBKxFxnWrra5eL3d3OwHzWEVkLmjmuNDpHSDGqGdE6DWzWE
        Ij3vdEWT/jwaYp4OKRGD4sQbMYqBxUIrAaTNnZmjsOITb+5PmF2xgLubiRUheP5tz9Rkv5
        AZyoxhcZksVsgQ55ce7MDILITF/y2keHXbihBioh1hOF6041g6zkbLeO3qdkqXfWuc/uaq
        ouZRsVdbdR8ugPFCrJeyStJTdCc4dOj4EBwYbdhrY9ongT6F0XOEO6JRpymTwIOsOF9xtz
        nziJ/xAohNWpjfC6LYUNb99JloF6Qu9H+MhTzK/4+Vu1t9YtEsmcy4QbdH0fug==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622731105;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=K3H1VW0CtTFXD8tm4bdGBxZU4YlnE9uQpzD1S0GM66w=;
        b=i7l2iD1Cgh3n1CixfmzD5V0SC8cQVUviMYctoujIvuFNhPkfPfekxEeeOV7hXWNRmsvdu8
        6ZwDSw3GVUpiJWDA==
From:   "tip-bot2 for Borislav Petkov" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] dmaengine: idxd: Use cpu_feature_enabled()
Cc:     Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <162273110504.29796.3198479463944415248.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     74b2fc882d380d8fafc2a26f01d401c2a7beeadb
Gitweb:        https://git.kernel.org/tip/74b2fc882d380d8fafc2a26f01d401c2a7beeadb
Author:        Borislav Petkov <bp@suse.de>
AuthorDate:    Wed, 02 Jun 2021 12:07:52 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Thu, 03 Jun 2021 16:32:59 +02:00

dmaengine: idxd: Use cpu_feature_enabled()

When testing x86 feature bits, use cpu_feature_enabled() so that
build-disabled features can remain off, regardless of what CPUID says.

Fixes: 8e50d392652f ("dmaengine: idxd: Add shared workqueue support")
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Acked-By: Vinod Koul <vkoul@kernel.org>
Cc: <stable@vger.kernel.org>
---
 drivers/dma/idxd/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 2a926be..776fd44 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -745,12 +745,12 @@ static int __init idxd_init_module(void)
 	 * If the CPU does not support MOVDIR64B or ENQCMDS, there's no point in
 	 * enumerating the device. We can not utilize it.
 	 */
-	if (!boot_cpu_has(X86_FEATURE_MOVDIR64B)) {
+	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
 		pr_warn("idxd driver failed to load without MOVDIR64B.\n");
 		return -ENODEV;
 	}
 
-	if (!boot_cpu_has(X86_FEATURE_ENQCMD))
+	if (!cpu_feature_enabled(X86_FEATURE_ENQCMD))
 		pr_warn("Platform does not have ENQCMD(S) support.\n");
 	else
 		support_enqcmd = true;

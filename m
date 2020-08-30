Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9814256F79
	for <lists+stable@lfdr.de>; Sun, 30 Aug 2020 19:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgH3RWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Aug 2020 13:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgH3RWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Aug 2020 13:22:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C4BC061573;
        Sun, 30 Aug 2020 10:22:10 -0700 (PDT)
Date:   Sun, 30 Aug 2020 17:21:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598808116;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=kxjzaFHv2FrCYmgeO7dK+Bq6890QjPkWk7t2pW/woHg=;
        b=jlr40h3smz45wYwGUBsah83bWF2mophW6S/CQm1FZTlEZsXWQnIYkhv7+AIeX6T9FRTjwc
        mU8TxEAjd7e4mFCoe6x/36RVJ6p54V9daOl28lTjss7NdA9m86l6j/iRRESHhO91CJwn7t
        e6EjCtNRKNtl0W12GAN4NdJ1Adzg/ck6/9YJKKET/FvbDvoe5o780b4Yuk/HwD6t//RWIV
        PPonBV+E56ORARADx9u6gwsjYoXLIQPf/XcTLVeRHnSeY62jshRh8on8bzxEqTKSfbhCuL
        4zBYHLXjVF8IAuECAGvQlaNCBeCEKNQy/0MlIsOr849lBEwvHlG8NzwwsXrUmA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598808116;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=kxjzaFHv2FrCYmgeO7dK+Bq6890QjPkWk7t2pW/woHg=;
        b=YYMqeDlRw+ImYZGZDNm2fN/IN0p3yV3hFKvTC3i0hV+FJDPAQZlOI/LLn5uD8h9ARcQH4a
        f6R9unvG10QB/yDw==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] genirq/matrix: Deal with the sillyness of
 for_each_cpu() on UP
Cc:     kernel test robot <rong.a.chen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <159880811534.20229.17365970881693987724.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     784a0830377d0761834e385975bc46861fea9fa0
Gitweb:        https://git.kernel.org/tip/784a0830377d0761834e385975bc46861fea9fa0
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Sun, 30 Aug 2020 19:07:53 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Sun, 30 Aug 2020 19:17:28 +02:00

genirq/matrix: Deal with the sillyness of for_each_cpu() on UP

Most of the CPU mask operations behave the same way, but for_each_cpu() and
it's variants ignore the cpumask argument and claim that CPU0 is always in
the mask. This is historical, inconsistent and annoying behaviour.

The matrix allocator uses for_each_cpu() and can be called on UP with an
empty cpumask. The calling code does not expect that this succeeds but
until commit e027fffff799 ("x86/irq: Unbreak interrupt affinity setting")
this went unnoticed. That commit added a WARN_ON() to catch cases which
move an interrupt from one vector to another on the same CPU. The warning
triggers on UP.

Add a check for the cpumask being empty to prevent this.

Fixes: 2f75d9e1c905 ("genirq: Implement bitmap matrix allocator")
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
 kernel/irq/matrix.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/irq/matrix.c b/kernel/irq/matrix.c
index 30cc217..651a4ad 100644
--- a/kernel/irq/matrix.c
+++ b/kernel/irq/matrix.c
@@ -380,6 +380,13 @@ int irq_matrix_alloc(struct irq_matrix *m, const struct cpumask *msk,
 	unsigned int cpu, bit;
 	struct cpumap *cm;
 
+	/*
+	 * Not required in theory, but matrix_find_best_cpu() uses
+	 * for_each_cpu() which ignores the cpumask on UP .
+	 */
+	if (cpumask_empty(msk))
+		return -EINVAL;
+
 	cpu = matrix_find_best_cpu(m, msk);
 	if (cpu == UINT_MAX)
 		return -ENOSPC;

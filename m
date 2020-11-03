Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282672A54E9
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388345AbgKCVPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:15:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:54496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388986AbgKCVMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:12:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C87B2206B5;
        Tue,  3 Nov 2020 21:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437934;
        bh=jX58UfIJGWVQV/mjB3kASkMntzspVbtxFRc6eguK0yM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=burbNLa+BpNZC013Jb+FQtWhJr/Khr9E4muJkoxjz6natpdhpjA7K1j0j+Yp7FCUU
         LUoOP5wGefvH4ittSwbRnlKPv7barnjmPN7TDpER4xZRja3UiJjIYQzZI0iQr4krQB
         7qjjOzbLQKtYNuFI/n1/D2GrvQcyEvWDeMncm9FA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 093/125] powerpc: Warn about use of smt_snooze_delay
Date:   Tue,  3 Nov 2020 21:37:50 +0100
Message-Id: <20201103203210.486354161@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

commit a02f6d42357acf6e5de6ffc728e6e77faf3ad217 upstream.

It's not done anything for a long time. Save the percpu variable, and
emit a warning to remind users to not expect it to do anything.

This uses pr_warn_once instead of pr_warn_ratelimit as testing
'ppc64_cpu --smt=off' on a 24 core / 4 SMT system showed the warning
to be noisy, as the online/offline loop is slow.

Fixes: 3fa8cad82b94 ("powerpc/pseries/cpuidle: smt-snooze-delay cleanup.")
Cc: stable@vger.kernel.org # v3.14
Signed-off-by: Joel Stanley <joel@jms.id.au>
Acked-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200902000012.3440389-1-joel@jms.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/sysfs.c |   42 +++++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -28,29 +28,27 @@
 
 static DEFINE_PER_CPU(struct cpu, cpu_devices);
 
-/*
- * SMT snooze delay stuff, 64-bit only for now
- */
-
 #ifdef CONFIG_PPC64
 
-/* Time in microseconds we delay before sleeping in the idle loop */
-static DEFINE_PER_CPU(long, smt_snooze_delay) = { 100 };
+/*
+ * Snooze delay has not been hooked up since 3fa8cad82b94 ("powerpc/pseries/cpuidle:
+ * smt-snooze-delay cleanup.") and has been broken even longer. As was foretold in
+ * 2014:
+ *
+ *  "ppc64_util currently utilises it. Once we fix ppc64_util, propose to clean
+ *  up the kernel code."
+ *
+ * powerpc-utils stopped using it as of 1.3.8. At some point in the future this
+ * code should be removed.
+ */
 
 static ssize_t store_smt_snooze_delay(struct device *dev,
 				      struct device_attribute *attr,
 				      const char *buf,
 				      size_t count)
 {
-	struct cpu *cpu = container_of(dev, struct cpu, dev);
-	ssize_t ret;
-	long snooze;
-
-	ret = sscanf(buf, "%ld", &snooze);
-	if (ret != 1)
-		return -EINVAL;
-
-	per_cpu(smt_snooze_delay, cpu->dev.id) = snooze;
+	pr_warn_once("%s (%d) stored to unsupported smt_snooze_delay, which has no effect.\n",
+		     current->comm, current->pid);
 	return count;
 }
 
@@ -58,9 +56,9 @@ static ssize_t show_smt_snooze_delay(str
 				     struct device_attribute *attr,
 				     char *buf)
 {
-	struct cpu *cpu = container_of(dev, struct cpu, dev);
-
-	return sprintf(buf, "%ld\n", per_cpu(smt_snooze_delay, cpu->dev.id));
+	pr_warn_once("%s (%d) read from unsupported smt_snooze_delay\n",
+		     current->comm, current->pid);
+	return sprintf(buf, "100\n");
 }
 
 static DEVICE_ATTR(smt_snooze_delay, 0644, show_smt_snooze_delay,
@@ -68,16 +66,10 @@ static DEVICE_ATTR(smt_snooze_delay, 064
 
 static int __init setup_smt_snooze_delay(char *str)
 {
-	unsigned int cpu;
-	long snooze;
-
 	if (!cpu_has_feature(CPU_FTR_SMT))
 		return 1;
 
-	snooze = simple_strtol(str, NULL, 10);
-	for_each_possible_cpu(cpu)
-		per_cpu(smt_snooze_delay, cpu) = snooze;
-
+	pr_warn("smt-snooze-delay command line option has no effect\n");
 	return 1;
 }
 __setup("smt-snooze-delay=", setup_smt_snooze_delay);



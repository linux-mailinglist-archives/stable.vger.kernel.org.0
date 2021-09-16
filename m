Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE6C40D99B
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 14:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239429AbhIPMQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 08:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239402AbhIPMQv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 08:16:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B069260F4A;
        Thu, 16 Sep 2021 12:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631794530;
        bh=rz5k0hYsdQxkImQLlVTRzPLIrr+RM9Jwg9dmqvFdIkY=;
        h=Subject:To:Cc:From:Date:From;
        b=R44n1Z+yDdT0QbUCplaxioptEMU4yWK3ptfaAf8jHAnA7wyKkFG/N4BdcRgrB0aJr
         g4tMqnj0XjR2bzDSOr0RXlJZ2QjGSAgJC4DzRCPPXGIHj0zpJbx2Kor2rncI5EWWL2
         40a/PYrAhNIiLMPOtdARH/jexfeSjVXAq1dy55e8=
Subject: FAILED: patch "[PATCH] cpufreq: powernv: Fix init_chip_info initialization in" failed to apply to 4.4-stable tree
To:     psampat@linux.ibm.com, ego@linux.vnet.ibm.com, mpe@ellerman.id.au,
        shirisha.ganta1@ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Sep 2021 14:15:27 +0200
Message-ID: <163179452773121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f34ee9cb2c5ac5af426fee6fa4591a34d187e696 Mon Sep 17 00:00:00 2001
From: "Pratik R. Sampat" <psampat@linux.ibm.com>
Date: Wed, 28 Jul 2021 17:35:00 +0530
Subject: [PATCH] cpufreq: powernv: Fix init_chip_info initialization in
 numa=off

In the numa=off kernel command-line configuration init_chip_info() loops
around the number of chips and attempts to copy the cpumask of that node
which is NULL for all iterations after the first chip.

Hence, store the cpu mask for each chip instead of derving cpumask from
node while populating the "chips" struct array and copy that to the
chips[i].mask

Fixes: 053819e0bf84 ("cpufreq: powernv: Handle throttling due to Pmax capping at chip level")
Cc: stable@vger.kernel.org # v4.3+
Reported-by: Shirisha Ganta <shirisha.ganta1@ibm.com>
Signed-off-by: Pratik R. Sampat <psampat@linux.ibm.com>
Reviewed-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
[mpe: Rename goto label to out_free_chip_cpu_mask]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210728120500.87549-2-psampat@linux.ibm.com

diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
index 005600cef273..6fbb46b2f6da 100644
--- a/drivers/cpufreq/powernv-cpufreq.c
+++ b/drivers/cpufreq/powernv-cpufreq.c
@@ -36,6 +36,7 @@
 #define MAX_PSTATE_SHIFT	32
 #define LPSTATE_SHIFT		48
 #define GPSTATE_SHIFT		56
+#define MAX_NR_CHIPS		32
 
 #define MAX_RAMP_DOWN_TIME				5120
 /*
@@ -1046,12 +1047,20 @@ static int init_chip_info(void)
 	unsigned int *chip;
 	unsigned int cpu, i;
 	unsigned int prev_chip_id = UINT_MAX;
+	cpumask_t *chip_cpu_mask;
 	int ret = 0;
 
 	chip = kcalloc(num_possible_cpus(), sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
+	/* Allocate a chip cpu mask large enough to fit mask for all chips */
+	chip_cpu_mask = kcalloc(MAX_NR_CHIPS, sizeof(cpumask_t), GFP_KERNEL);
+	if (!chip_cpu_mask) {
+		ret = -ENOMEM;
+		goto free_and_return;
+	}
+
 	for_each_possible_cpu(cpu) {
 		unsigned int id = cpu_to_chip_id(cpu);
 
@@ -1059,22 +1068,25 @@ static int init_chip_info(void)
 			prev_chip_id = id;
 			chip[nr_chips++] = id;
 		}
+		cpumask_set_cpu(cpu, &chip_cpu_mask[nr_chips-1]);
 	}
 
 	chips = kcalloc(nr_chips, sizeof(struct chip), GFP_KERNEL);
 	if (!chips) {
 		ret = -ENOMEM;
-		goto free_and_return;
+		goto out_free_chip_cpu_mask;
 	}
 
 	for (i = 0; i < nr_chips; i++) {
 		chips[i].id = chip[i];
-		cpumask_copy(&chips[i].mask, cpumask_of_node(chip[i]));
+		cpumask_copy(&chips[i].mask, &chip_cpu_mask[i]);
 		INIT_WORK(&chips[i].throttle, powernv_cpufreq_work_fn);
 		for_each_cpu(cpu, &chips[i].mask)
 			per_cpu(chip_info, cpu) =  &chips[i];
 	}
 
+out_free_chip_cpu_mask:
+	kfree(chip_cpu_mask);
 free_and_return:
 	kfree(chip);
 	return ret;


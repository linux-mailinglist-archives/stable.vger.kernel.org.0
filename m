Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8C01B2CCD
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 18:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgDUQhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 12:37:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42024 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgDUQhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 12:37:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03LGYLjh065604;
        Tue, 21 Apr 2020 16:37:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=sKlZEENumxidy8zW0gTcKPlHQj/gVbQX4p/wtrhNzKM=;
 b=TDWQTy1BSNU5OzuTPNDh3xuaHFDSwrCafaM8HhwNOqHMe0GD7zQ/IMT7h1dr232yO0zP
 R/jnTKrRUcv43uvf97yd82N2uAd2kHad9XZWhp+U28Nj3fD1CP3mAFv4TjIa1UUFAyJE
 7fMiODhz7G4r7zs/7c57XXfffTKLmANlrHpR2Yag5x5IRW2hVld4YstPHUTpjkSOsIWD
 nPPjzKwrK14UEkzsp7w2yEm5CAqeRoa2Fva2kFddzMjObUCgGkFvfrDYg5vOle79643e
 rFOlwe2SUHMaWO/TDF9bZCDMqGWI78GcI2xwD/6Tv9I7ivOsqJlCgv8ynaPCzBlCo6nx mQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30grpgjhtq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 16:37:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03LGWFW2031201;
        Tue, 21 Apr 2020 16:35:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30gb1gfevs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 16:35:04 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03LGZ1tI024746;
        Tue, 21 Apr 2020 16:35:01 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 09:35:00 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] padata: add separate cpuhp node for CPUHP_PADATA_DEAD
Date:   Tue, 21 Apr 2020 12:34:55 -0400
Message-Id: <20200421163455.2177998-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=2 spamscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004210127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=2 bulkscore=0 clxscore=1011
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004210127
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Removing the pcrypt module triggers this:

  general protection fault, probably for non-canonical
    address 0xdead000000000122
  CPU: 5 PID: 264 Comm: modprobe Not tainted 5.6.0+ #2
  Hardware name: QEMU Standard PC
  RIP: 0010:__cpuhp_state_remove_instance+0xcc/0x120
  Call Trace:
   padata_sysfs_release+0x74/0xce
   kobject_put+0x81/0xd0
   padata_free+0x12/0x20
   pcrypt_exit+0x43/0x8ee [pcrypt]

padata instances wrongly use the same hlist node for the online and dead
states, so __padata_free()'s second cpuhp remove call chokes on the node
that the first poisoned.

cpuhp multi-instance callbacks only walk forward in cpuhp_step->list and
the same node is linked in both the online and dead lists, so the list
corruption that results from padata_alloc() adding the node to a second
list without removing it from the first doesn't cause problems as long
as no instances are freed.

Avoid the issue by giving each state its own node.

Fixes: 894c9ef9780c ("padata: validate cpumask without removed CPU during offline")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org # v5.4+
---
 include/linux/padata.h |  6 ++++--
 kernel/padata.c        | 14 ++++++++------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index a0d8b41850b2..693cae9bfe66 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -139,7 +139,8 @@ struct padata_shell {
 /**
  * struct padata_instance - The overall control structure.
  *
- * @node: Used by CPU hotplug.
+ * @cpu_online_node: Linkage for CPU online callback.
+ * @cpu_dead_node: Linkage for CPU offline callback.
  * @parallel_wq: The workqueue used for parallel work.
  * @serial_wq: The workqueue used for serial work.
  * @pslist: List of padata_shell objects attached to this instance.
@@ -150,7 +151,8 @@ struct padata_shell {
  * @flags: padata flags.
  */
 struct padata_instance {
-	struct hlist_node		 node;
+	struct hlist_node		cpu_online_node;
+	struct hlist_node		cpu_dead_node;
 	struct workqueue_struct		*parallel_wq;
 	struct workqueue_struct		*serial_wq;
 	struct list_head		pslist;
diff --git a/kernel/padata.c b/kernel/padata.c
index a6afa12fb75e..aae789896616 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -703,7 +703,7 @@ static int padata_cpu_online(unsigned int cpu, struct hlist_node *node)
 	struct padata_instance *pinst;
 	int ret;
 
-	pinst = hlist_entry_safe(node, struct padata_instance, node);
+	pinst = hlist_entry_safe(node, struct padata_instance, cpu_online_node);
 	if (!pinst_has_cpu(pinst, cpu))
 		return 0;
 
@@ -718,7 +718,7 @@ static int padata_cpu_dead(unsigned int cpu, struct hlist_node *node)
 	struct padata_instance *pinst;
 	int ret;
 
-	pinst = hlist_entry_safe(node, struct padata_instance, node);
+	pinst = hlist_entry_safe(node, struct padata_instance, cpu_dead_node);
 	if (!pinst_has_cpu(pinst, cpu))
 		return 0;
 
@@ -734,8 +734,9 @@ static enum cpuhp_state hp_online;
 static void __padata_free(struct padata_instance *pinst)
 {
 #ifdef CONFIG_HOTPLUG_CPU
-	cpuhp_state_remove_instance_nocalls(CPUHP_PADATA_DEAD, &pinst->node);
-	cpuhp_state_remove_instance_nocalls(hp_online, &pinst->node);
+	cpuhp_state_remove_instance_nocalls(CPUHP_PADATA_DEAD,
+					    &pinst->cpu_dead_node);
+	cpuhp_state_remove_instance_nocalls(hp_online, &pinst->cpu_online_node);
 #endif
 
 	WARN_ON(!list_empty(&pinst->pslist));
@@ -939,9 +940,10 @@ static struct padata_instance *padata_alloc(const char *name,
 	mutex_init(&pinst->lock);
 
 #ifdef CONFIG_HOTPLUG_CPU
-	cpuhp_state_add_instance_nocalls_cpuslocked(hp_online, &pinst->node);
+	cpuhp_state_add_instance_nocalls_cpuslocked(hp_online,
+						    &pinst->cpu_online_node);
 	cpuhp_state_add_instance_nocalls_cpuslocked(CPUHP_PADATA_DEAD,
-						    &pinst->node);
+						    &pinst->cpu_dead_node);
 #endif
 
 	put_online_cpus();

base-commit: ae83d0b416db002fe95601e7f97f64b59514d936
-- 
2.26.0


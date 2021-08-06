Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE093E252C
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243933AbhHFISE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:18:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243998AbhHFIQk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:16:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A80F61205;
        Fri,  6 Aug 2021 08:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237776;
        bh=5Abe2X7deOpV8qBiC/8PkTAVKIbX3prv6qZg1VjtK3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cj2/I7uev1BNNOEE4n2WQdONbrN0bsCNSiCIXCZE+iGvFu2gRmG5BLzMfyV2RPapQ
         hjkREHMTO4bJ4WEXy/pU4HQwBkoZSZzxbw8jcCGY3BK6d0X30OFqswiEy2kZfC2Efv
         VSyNeOHM9rjbz0qQnAvhISf1Tl1x1V9HU19gZ7Xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jordan <daniel.m.jordan@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 4.19 16/16] padata: add separate cpuhp node for CPUHP_PADATA_DEAD
Date:   Fri,  6 Aug 2021 10:15:07 +0200
Message-Id: <20210806081111.662287213@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081111.144943357@linuxfoundation.org>
References: <20210806081111.144943357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

commit 3c2214b6027ff37945799de717c417212e1a8c54 upstream.

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
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/padata.h |    6 ++++--
 kernel/padata.c        |   14 ++++++++------
 2 files changed, 12 insertions(+), 8 deletions(-)

--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -138,7 +138,8 @@ struct parallel_data {
 /**
  * struct padata_instance - The overall control structure.
  *
- * @cpu_notifier: cpu hotplug notifier.
+ * @cpu_online_node: Linkage for CPU online callback.
+ * @cpu_dead_node: Linkage for CPU offline callback.
  * @wq: The workqueue in use.
  * @pd: The internal control structure.
  * @cpumask: User supplied cpumasks for parallel and serial works.
@@ -150,7 +151,8 @@ struct parallel_data {
  * @flags: padata flags.
  */
 struct padata_instance {
-	struct hlist_node		 node;
+	struct hlist_node		cpu_online_node;
+	struct hlist_node		cpu_dead_node;
 	struct workqueue_struct		*wq;
 	struct parallel_data		*pd;
 	struct padata_cpumask		cpumask;
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -748,7 +748,7 @@ static int padata_cpu_online(unsigned in
 	struct padata_instance *pinst;
 	int ret;
 
-	pinst = hlist_entry_safe(node, struct padata_instance, node);
+	pinst = hlist_entry_safe(node, struct padata_instance, cpu_online_node);
 	if (!pinst_has_cpu(pinst, cpu))
 		return 0;
 
@@ -763,7 +763,7 @@ static int padata_cpu_dead(unsigned int
 	struct padata_instance *pinst;
 	int ret;
 
-	pinst = hlist_entry_safe(node, struct padata_instance, node);
+	pinst = hlist_entry_safe(node, struct padata_instance, cpu_dead_node);
 	if (!pinst_has_cpu(pinst, cpu))
 		return 0;
 
@@ -779,8 +779,9 @@ static enum cpuhp_state hp_online;
 static void __padata_free(struct padata_instance *pinst)
 {
 #ifdef CONFIG_HOTPLUG_CPU
-	cpuhp_state_remove_instance_nocalls(CPUHP_PADATA_DEAD, &pinst->node);
-	cpuhp_state_remove_instance_nocalls(hp_online, &pinst->node);
+	cpuhp_state_remove_instance_nocalls(CPUHP_PADATA_DEAD,
+					    &pinst->cpu_dead_node);
+	cpuhp_state_remove_instance_nocalls(hp_online, &pinst->cpu_online_node);
 #endif
 
 	padata_stop(pinst);
@@ -964,9 +965,10 @@ static struct padata_instance *padata_al
 	mutex_init(&pinst->lock);
 
 #ifdef CONFIG_HOTPLUG_CPU
-	cpuhp_state_add_instance_nocalls_cpuslocked(hp_online, &pinst->node);
+	cpuhp_state_add_instance_nocalls_cpuslocked(hp_online,
+						    &pinst->cpu_online_node);
 	cpuhp_state_add_instance_nocalls_cpuslocked(CPUHP_PADATA_DEAD,
-						    &pinst->node);
+						    &pinst->cpu_dead_node);
 #endif
 	return pinst;
 



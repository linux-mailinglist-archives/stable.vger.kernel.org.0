Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342E81FB93C
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732097AbgFPQCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:02:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732675AbgFPPvc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:51:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A4BF208D5;
        Tue, 16 Jun 2020 15:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322691;
        bh=L76k6lpG4J3TwlEea5e1sll8MrwfcXXQlPvtKlzCZ7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=frz5NOtZbLs2nbRRwKooRzT3x9OFLBIc7bTwNhvYup/5OAb0e4V5kgC3liRktEYAP
         UT+MKm2f3v7v2R8yQJs1WJKAMr1IgmpUn+OPwzeXmbCWqwQbDPtjfAtw4RYBZGM1E/
         1MeVtnoabSA56ChuOXYnofmwc9G9zb/tanTaySSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jordan <daniel.m.jordan@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 036/161] padata: add separate cpuhp node for CPUHP_PADATA_DEAD
Date:   Tue, 16 Jun 2020 17:33:46 +0200
Message-Id: <20200616153108.101239616@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

[ Upstream commit 3c2214b6027ff37945799de717c417212e1a8c54 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index 62082597d4a2..fee14ae90d96 100644
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
-- 
2.25.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8280F15FC0A
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 02:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbgBOBa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 20:30:26 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45228 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727572AbgBOBa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 20:30:26 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01F1PvL3051691;
        Sat, 15 Feb 2020 01:30:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=W4WBnCPJdshCN1zK9DcIDCHmcoScNhw42HD6f1pSjl4=;
 b=ha24+qV2PVvVm93+t3rJ2QVyg6UWP4NiCFZ/3wvXzHa1rsyjqPa9qAVpGs5HKhIlXZAe
 9/iEnbd3oJDFgve0ke/XBPNDkJT2STYctWeoFLd/BwQNijoXiK/Rd6AVAAvnHTGPio+P
 Lcz4nT1TdxCF/Nl0/wJcSD37dItHy69WCtg+d7MHfkSKw6QTMr1kV+liEKsalOGdUyOw
 cJJVEIKgI4H97p+Dzw2epdeFH/AjuTnWasdKDre87NtdbrbyX9Iw5R0Jrgn6GLesIX7U
 pSak1MD5ACUbuRU4Lkd6f6FsLN+pKuUPBvDA5b9GyDLrcL/hMUdyIx/NalcLylhBKVo0 OQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2y2p3t4ab6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 Feb 2020 01:30:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01F1RjaO007150;
        Sat, 15 Feb 2020 01:30:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2y4k3fmn3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 Feb 2020 01:30:11 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01F1U94I010653;
        Sat, 15 Feb 2020 01:30:09 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 14 Feb 2020 17:30:09 -0800
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org, Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v2 4.4] padata: Remove broken queue flushing
Date:   Fri, 14 Feb 2020 20:30:01 -0500
Message-Id: <20200215013001.892060-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151832.123934030@linuxfoundation.org>
References: <20200213151832.123934030@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9531 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=2 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002150008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9531 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 suspectscore=2 mlxlogscore=999 priorityscore=1501 clxscore=1015
 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002150008
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 07928d9bfc81640bab36f5190e8725894d93b659 ]

The function padata_flush_queues is fundamentally broken because
it cannot force padata users to complete the request that is
underway.  IOW padata has to passively wait for the completion
of any outstanding work.

As it stands flushing is used in two places.  Its use in padata_stop
is simply unnecessary because nothing depends on the queues to
be flushed afterwards.

The other use in padata_replace is more substantial as we depend
on it to free the old pd structure.  This patch instead uses the
pd->refcnt to dynamically free the pd structure once all requests
are complete.

Fixes: 2b73b07ab8a4 ("padata: Flush the padata queues actively")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[dj: leave "pd->pinst = pinst" assignment in padata_alloc_pd()]
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 kernel/padata.c | 45 ++++++++++++---------------------------------
 1 file changed, 12 insertions(+), 33 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 282b489a286d..0d7ec5fd520b 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -33,6 +33,8 @@
 
 #define MAX_OBJ_NUM 1000
 
+static void padata_free_pd(struct parallel_data *pd);
+
 static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
 {
 	int cpu, target_cpu;
@@ -300,6 +302,7 @@ static void padata_serial_worker(struct work_struct *serial_work)
 	struct padata_serial_queue *squeue;
 	struct parallel_data *pd;
 	LIST_HEAD(local_list);
+	int cnt;
 
 	local_bh_disable();
 	squeue = container_of(serial_work, struct padata_serial_queue, work);
@@ -309,6 +312,8 @@ static void padata_serial_worker(struct work_struct *serial_work)
 	list_replace_init(&squeue->serial.list, &local_list);
 	spin_unlock(&squeue->serial.lock);
 
+	cnt = 0;
+
 	while (!list_empty(&local_list)) {
 		struct padata_priv *padata;
 
@@ -318,9 +323,12 @@ static void padata_serial_worker(struct work_struct *serial_work)
 		list_del_init(&padata->list);
 
 		padata->serial(padata);
-		atomic_dec(&pd->refcnt);
+		cnt++;
 	}
 	local_bh_enable();
+
+	if (atomic_sub_and_test(cnt, &pd->refcnt))
+		padata_free_pd(pd);
 }
 
 /**
@@ -443,7 +451,7 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 	setup_timer(&pd->timer, padata_reorder_timer, (unsigned long)pd);
 	atomic_set(&pd->seq_nr, -1);
 	atomic_set(&pd->reorder_objects, 0);
-	atomic_set(&pd->refcnt, 0);
+	atomic_set(&pd->refcnt, 1);
 	pd->pinst = pinst;
 	spin_lock_init(&pd->lock);
 
@@ -468,31 +476,6 @@ static void padata_free_pd(struct parallel_data *pd)
 	kfree(pd);
 }
 
-/* Flush all objects out of the padata queues. */
-static void padata_flush_queues(struct parallel_data *pd)
-{
-	int cpu;
-	struct padata_parallel_queue *pqueue;
-	struct padata_serial_queue *squeue;
-
-	for_each_cpu(cpu, pd->cpumask.pcpu) {
-		pqueue = per_cpu_ptr(pd->pqueue, cpu);
-		flush_work(&pqueue->work);
-	}
-
-	del_timer_sync(&pd->timer);
-
-	if (atomic_read(&pd->reorder_objects))
-		padata_reorder(pd);
-
-	for_each_cpu(cpu, pd->cpumask.cbcpu) {
-		squeue = per_cpu_ptr(pd->squeue, cpu);
-		flush_work(&squeue->work);
-	}
-
-	BUG_ON(atomic_read(&pd->refcnt) != 0);
-}
-
 static void __padata_start(struct padata_instance *pinst)
 {
 	pinst->flags |= PADATA_INIT;
@@ -506,10 +489,6 @@ static void __padata_stop(struct padata_instance *pinst)
 	pinst->flags &= ~PADATA_INIT;
 
 	synchronize_rcu();
-
-	get_online_cpus();
-	padata_flush_queues(pinst->pd);
-	put_online_cpus();
 }
 
 /* Replace the internal control structure with a new one. */
@@ -530,8 +509,8 @@ static void padata_replace(struct padata_instance *pinst,
 	if (!cpumask_equal(pd_old->cpumask.cbcpu, pd_new->cpumask.cbcpu))
 		notification_mask |= PADATA_CPU_SERIAL;
 
-	padata_flush_queues(pd_old);
-	padata_free_pd(pd_old);
+	if (atomic_dec_and_test(&pd_old->refcnt))
+		padata_free_pd(pd_old);
 
 	if (notification_mask)
 		blocking_notifier_call_chain(&pinst->cpumask_change_notifier,
-- 
2.25.0


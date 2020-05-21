Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C1F1DD899
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 22:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgEUUnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 16:43:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58536 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728547AbgEUUnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 16:43:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LKfWwv111166;
        Thu, 21 May 2020 20:43:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=O2Rb4G05GHKpw4BdRRx8tzqBwdu9RDoYJEASuKBzZnk=;
 b=XrV+YCVml3R7mjomPf40ukEYwEs9triP4gR3O6ut7dmzSHBfQpq8q6Z/GyTHHgDy2Rpq
 JxD7KdCYrtEVx9c/e82hL1riBmkteV3kuffCVYN+IEZexgCwD8dIqeTnangFRYv9Vdh9
 Fo5HnSBk+kIQcIysLbR0L+X5thjR8LOWLtAp9WnBR92tDv+arPm0ZiysU2E0QNUZB+ou
 kXfH7RVDSgfXXWGna5oirQ/QwvI6+H8Djjpg5vH9axwzHjmEniZeYQuHNq19XrY+Rj3G
 A6xwhIZQTHxjXvxb3iTyZFvTqgoW3G/1farwTMaExgRSrrI9BcZQVPZAm/HRt5yyQL1c rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31501rh5y8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 May 2020 20:43:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LKYWIl010776;
        Thu, 21 May 2020 20:41:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 314gm9wjfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 May 2020 20:40:59 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04LKevft029901;
        Thu, 21 May 2020 20:40:57 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 13:40:57 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Ben Hutchings <ben@decadent.org.uk>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [stable-4.19 2/3] padata: initialize pd->cpu with effective cpumask
Date:   Thu, 21 May 2020 16:40:50 -0400
Message-Id: <20200521204051.1952184-2-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521204051.1952184-1-daniel.m.jordan@oracle.com>
References: <20200521204051.1952184-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005210152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 cotscore=-2147483648
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005210153
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ec9c7d19336ee98ecba8de80128aa405c45feebb ]

Exercising CPU hotplug on a 5.2 kernel with recent padata fixes from
cryptodev-2.6.git in an 8-CPU kvm guest...

    # modprobe tcrypt alg="pcrypt(rfc4106(gcm(aes)))" type=3
    # echo 0 > /sys/devices/system/cpu/cpu1/online
    # echo c > /sys/kernel/pcrypt/pencrypt/parallel_cpumask
    # modprobe tcrypt mode=215

...caused the following crash:

    BUG: kernel NULL pointer dereference, address: 0000000000000000
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    PGD 0 P4D 0
    Oops: 0000 [#1] SMP PTI
    CPU: 2 PID: 134 Comm: kworker/2:2 Not tainted 5.2.0-padata-base+ #7
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-<snip>
    Workqueue: pencrypt padata_parallel_worker
    RIP: 0010:padata_reorder+0xcb/0x180
    ...
    Call Trace:
     padata_do_serial+0x57/0x60
     pcrypt_aead_enc+0x3a/0x50 [pcrypt]
     padata_parallel_worker+0x9b/0xe0
     process_one_work+0x1b5/0x3f0
     worker_thread+0x4a/0x3c0
     ...

In padata_alloc_pd, pd->cpu is set using the user-supplied cpumask
instead of the effective cpumask, and in this case cpumask_first picked
an offline CPU.

The offline CPU's reorder->list.next is NULL in padata_reorder because
the list wasn't initialized in padata_init_pqueues, which only operates
on CPUs in the effective mask.

Fix by using the effective mask in padata_alloc_pd.

Fixes: 6fc4dbcf0276 ("padata: Replace delayed timer with immediate workqueue in padata_reorder")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 kernel/padata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 47dc31ce15ac..e9b8d517fd4b 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -451,7 +451,7 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 	atomic_set(&pd->refcnt, 1);
 	pd->pinst = pinst;
 	spin_lock_init(&pd->lock);
-	pd->cpu = cpumask_first(pcpumask);
+	pd->cpu = cpumask_first(pd->cpumask.pcpu);
 	INIT_WORK(&pd->reorder_work, invoke_padata_reorder);
 
 	return pd;
-- 
2.26.2


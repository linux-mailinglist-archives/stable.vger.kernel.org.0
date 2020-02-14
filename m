Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD66415F548
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388695AbgBNS2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:28:51 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51334 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387718AbgBNS2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 13:28:51 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01EINruc167222;
        Fri, 14 Feb 2020 18:28:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=QGPSHfePG9y20E4OZXeMQypsFtYM/sre+7FquWnrs2w=;
 b=H0nzw+KLXeLE+5ztK5ogzivadOTbtV8GQ8X3km41dHPJ4yNggp0nuSCoU4EmIyJbimuz
 FrXFimbSg/1JVOkrVobuD3FRYLe6SH+EwqxvE2zr8Fsvl5HF7KRZAmTkVqiAsSEJf0DM
 7nIjxJ+ryEcTWWIWk7Q7M/FfCIYYo6tJu4cqid/1YHtWo229rvnPls85R0qtZhVRdzzm
 yHjS5kccsabmi0Rn9MD9Corom6xAXXJjHcFrisyLx9ImAcTbPYVI22K5yWyoIUUG6t5q
 4QlNFUKD7VaHinwc4tYp+EwU4/SnMQ/FO5ULBvj47vDn+zmPgopFy+5nUZgJlmyq77II QA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2y2p3t2x6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 18:28:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01EIRhe7110676;
        Fri, 14 Feb 2020 18:28:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2y5dthh82k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 18:28:33 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01EISU5N003303;
        Fri, 14 Feb 2020 18:28:30 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 14 Feb 2020 10:28:30 -0800
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH for 4.19-stable] padata: fix null pointer deref of pd->pinst
Date:   Fri, 14 Feb 2020 13:28:21 -0500
Message-Id: <20200214182821.337706-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9531 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002140137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9531 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002140137
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The 4.19 backport dc34710a7aba ("padata: Remove broken queue flushing")
removed padata_alloc_pd()'s assignment to pd->pinst, resulting in:

    Unable to handle kernel NULL pointer dereference ...
    ...
    pc : padata_reorder+0x144/0x2e0
    ...
    Call trace:
     padata_reorder+0x144/0x2e0
     padata_do_serial+0xc8/0x128
     pcrypt_aead_enc+0x60/0x70 [pcrypt]
     padata_parallel_worker+0xd8/0x138
     process_one_work+0x1bc/0x4b8
     worker_thread+0x164/0x580
     kthread+0x134/0x138
     ret_from_fork+0x10/0x18

This happened because the backport was based on an enhancement that
moved this assignment but isn't in 4.19:

  bfde23ce200e ("padata: unbind parallel jobs from specific CPUs")

Simply restore the assignment to fix the crash.

Fixes: dc34710a7aba ("padata: Remove broken queue flushing")
Reported-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
---
 kernel/padata.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/padata.c b/kernel/padata.c
index 11c5f9c8779e..cfab62923c45 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -510,6 +510,7 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 	atomic_set(&pd->seq_nr, -1);
 	atomic_set(&pd->reorder_objects, 0);
 	atomic_set(&pd->refcnt, 1);
+	pd->pinst = pinst;
 	spin_lock_init(&pd->lock);
 
 	return pd;
-- 
2.25.0


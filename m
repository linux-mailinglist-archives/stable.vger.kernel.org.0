Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F31C614BD9F
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 17:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgA1QYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 11:24:36 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46736 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbgA1QYg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 11:24:36 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00SGEEiZ038187;
        Tue, 28 Jan 2020 16:24:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=ZWdf7sG5Xw7ejFplB1oAzj7ALcivlmGZ3sLaK7nXF7U=;
 b=XTLx96RMtWLPWR1Mfszf621kniFGf/Svj9QHnW5RD6RJ7lB0a7ZGc+1Xo6jePDsHv1bO
 MKzaVgXId9G6x4Nk7cFzT1emmIW9o6sQc6P8JdctbvGjo5ADSfKjdyN6B6HfhwIqcGgz
 NoJUTckWMlXNDuFcNWXBNjFeCVc6dJa5KyxV8aFgdb+9iBueBZtj5cKN/i8Z8Ny8gBTG
 RwFZvhSMahTCPAIxSPEbgJIm2LHkCwritMQ/AKIiGjecv83+F6yX7NgBVgcYrBdSy5+z
 awR+9RorLo7dj+fcjbSEmk9gnYnt/U4l8Wcbf2AO6Ig62/pGi4I66X5I2n9oQR1TW5M8 jg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xrd3u7eet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 16:24:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00SGEKaq191045;
        Tue, 28 Jan 2020 16:24:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xta8j2tyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 16:24:19 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00SGOG3B026765;
        Tue, 28 Jan 2020 16:24:17 GMT
Received: from bostrovs-us.us.oracle.com (/10.152.32.65)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jan 2020 08:24:16 -0800
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
To:     xen-devel@lists.xenproject.org
Cc:     jgg@mellanox.com, jgross@suse.com, linux-kernel@vger.kernel.org,
        ilpo.jarvinen@cs.helsinki.fi, stable@vger.kernel.org
Subject: [PATCH] xen/gntdev: Do not use mm notifiers with autotranslating guests
Date:   Tue, 28 Jan 2020 11:24:19 -0500
Message-Id: <1580228659-6086-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9514 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001280126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9514 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001280126
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit d3eeb1d77c5d ("xen/gntdev: use mmu_interval_notifier_insert")
missed a test for use_ptemod when calling mmu_interval_read_begin(). Fix
that.

Fixes: d3eeb1d77c5d ("xen/gntdev: use mmu_interval_notifier_insert")
CC: stable@vger.kernel.org # 5.5
Reported-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
Tested-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 drivers/xen/gntdev.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 4fc83e3f5ad3..0258415ca0b2 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -1006,19 +1006,19 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 	}
 	mutex_unlock(&priv->lock);
 
-	/*
-	 * gntdev takes the address of the PTE in find_grant_ptes() and passes
-	 * it to the hypervisor in gntdev_map_grant_pages(). The purpose of
-	 * the notifier is to prevent the hypervisor pointer to the PTE from
-	 * going stale.
-	 *
-	 * Since this vma's mappings can't be touched without the mmap_sem,
-	 * and we are holding it now, there is no need for the notifier_range
-	 * locking pattern.
-	 */
-	mmu_interval_read_begin(&map->notifier);
-
 	if (use_ptemod) {
+		/*
+		 * gntdev takes the address of the PTE in find_grant_ptes() and
+		 * passes it to the hypervisor in gntdev_map_grant_pages(). The
+		 * purpose of the notifier is to prevent the hypervisor pointer
+		 * to the PTE from going stale.
+		 *
+		 * Since this vma's mappings can't be touched without the
+		 * mmap_sem, and we are holding it now, there is no need for
+		 * the notifier_range locking pattern.
+		 */
+		mmu_interval_read_begin(&map->notifier);
+
 		map->pages_vm_start = vma->vm_start;
 		err = apply_to_page_range(vma->vm_mm, vma->vm_start,
 					  vma->vm_end - vma->vm_start,
-- 
2.17.1


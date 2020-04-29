Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF631BE664
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 20:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgD2Skm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 14:40:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60342 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgD2Skm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 14:40:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03TIdLu3003073
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 18:40:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=jbcOaLedyblHDgvXAB77hjgrPDytmblEa+/5JWW1l1w=;
 b=dgBugU5fAxSH0zNlz2Q2zxz0NjqowY1Ev8louvl4waOVOHTD2XHARe38hSsHpiLNlzVx
 rS+ITZ5Hi8EFEWt4EOexJGhdEFZrrHEejf/6l+BLs+vzTH2qzUPPsV0q55EZV/L+tgYW
 cg38VpIKIbuq7KcxBnUsrqj7P0zoGCKLgjCx3SQ74gS5ncRhtVaslaGvVkStT3dkstOx
 J3ZXaqWcCJwWaUOoZDDMWjDIJVJnqmspmuuF21+bWztwPu1wHzg8afQ6Yir/2Tx+iNIh
 hGIlxhYSvaw9ZJMWaAyzeOtelUPDZVdvEtRPpvjXfvjWNXT36d0SD4L4ImVsUDhrLZ3W Ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30p2p0cwjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 18:40:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03TIbBfb118082
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 18:40:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30my0hshfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 18:40:40 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03TIedlX003293
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 18:40:39 GMT
Received: from localhost (/10.135.188.124)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 11:40:39 -0700
From:   Tom Saeger <tom.saeger@oracle.com>
To:     stable@vger.kernel.org
Cc:     Tom Saeger <tom.saeger@oracle.com>
Subject: [PATCH 5.4] bcache: initialize 'sb_page' in register_bcache()
Date:   Wed, 29 Apr 2020 18:38:17 +0000
Message-Id: <041443374fde130be3bc864b6ac8ffba6640c2b0.1588184799.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=1 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1011
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=1 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004290141
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 393b8509be33 (bcache: rework error unwinding in register_bcache)

introduced compile warning:
warning: 'sb_page' may be used uninitialized in this function [-Wmaybe-uninitialized]

Use 'sb_page' initialization prior to 393b8509be33.

Fixes: 393b8509be33 (bcache: rework error unwinding in register_bcache)
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---

This addresses warning only seen in 5.4.22+.  Upstream avoids
this in a different way.

Compile test case:

cp arch/arm64/configs/defconfig .config
./scripts/config -e BCACHE
make ARCH=arm64 olddefconfig
make ARCH=arm64 -j $(nproc)

Regards,
--Tom


 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 658b0f4a01f5..25cbc9e2f8e3 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2376,7 +2376,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	char *path = NULL;
 	struct cache_sb *sb;
 	struct block_device *bdev = NULL;
-	struct page *sb_page;
+	struct page *sb_page = NULL;
 	ssize_t ret;
 
 	ret = -EBUSY;
-- 
2.25.1


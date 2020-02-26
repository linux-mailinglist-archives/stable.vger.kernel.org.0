Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8695516F942
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 09:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgBZILp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 03:11:45 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:58022 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727341AbgBZILp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Feb 2020 03:11:45 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 63636B788565C2E2F043;
        Wed, 26 Feb 2020 16:11:41 +0800 (CST)
Received: from architecture4.huawei.com (10.160.196.180) by smtp.huawei.com
 (10.3.19.204) with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 26 Feb
 2020 16:11:35 +0800
From:   Gao Xiang <gaoxiang25@huawei.com>
To:     Chao Yu <yuchao0@huawei.com>, <linux-erofs@lists.ozlabs.org>
CC:     LKML <linux-kernel@vger.kernel.org>, Miao Xie <miaoxie@huawei.com>,
        "Gao Xiang" <gaoxiang25@huawei.com>, <stable@vger.kernel.org>
Subject: [PATCH v2 1/3] erofs: correct the remaining shrink objects
Date:   Wed, 26 Feb 2020 16:10:06 +0800
Message-ID: <20200226081008.86348-1-gaoxiang25@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.160.196.180]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The remaining count should not include successful
shrink attempts.

Fixes: e7e9a307be9d ("staging: erofs: introduce workstation for decompression")
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
---

Changes since v1:
 - Add "Fixes:" tags respectively suggested by Eric. I'd suggest
   no rush to backport PATCH 2/3 and 3/3 since it's not quite
   sure whether they behave well for normal images for now and
   I will backport them manually later since they have no impact
   on system stability with corrupted images;

 - Fix PATCH 2/3 to exclude legacy (no decompression inplace
   support, < v5.3) images.

 fs/erofs/utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/utils.c b/fs/erofs/utils.c
index fddc5059c930..df42ea552a44 100644
--- a/fs/erofs/utils.c
+++ b/fs/erofs/utils.c
@@ -286,7 +286,7 @@ static unsigned long erofs_shrink_scan(struct shrinker *shrink,
 		spin_unlock(&erofs_sb_list_lock);
 		sbi->shrinker_run_no = run_no;
 
-		freed += erofs_shrink_workstation(sbi, nr);
+		freed += erofs_shrink_workstation(sbi, nr - freed);
 
 		spin_lock(&erofs_sb_list_lock);
 		/* Get the next list element before we move this one */
-- 
2.17.1


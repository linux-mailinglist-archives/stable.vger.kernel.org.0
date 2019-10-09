Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD7B5D0C38
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 12:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbfJIKJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 06:09:44 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38146 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726734AbfJIKJn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 06:09:43 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B5AFF2616F53D8CF01C0;
        Wed,  9 Oct 2019 18:09:41 +0800 (CST)
Received: from architecture4.huawei.com (10.140.130.215) by smtp.huawei.com
 (10.3.19.212) with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 9 Oct 2019
 18:09:35 +0800
From:   Gao Xiang <gaoxiang25@huawei.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, Chao Yu <yuchao0@huawei.com>
CC:     <linux-erofs@lists.ozlabs.org>, Miao Xie <miaoxie@huawei.com>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: [PATCH for-4.19 2/4] staging: erofs: some compressed cluster should be submitted for corrupted images
Date:   Wed, 9 Oct 2019 18:12:37 +0800
Message-ID: <20191009101239.195587-2-gaoxiang25@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191009101239.195587-1-gaoxiang25@huawei.com>
References: <20191009101239.195587-1-gaoxiang25@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.140.130.215]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit ee45197c807895e156b2be0abcaebdfc116487c8 upstream.

As reported by erofs_utils fuzzer, a logical page can belong
to at most 2 compressed clusters, if one compressed cluster
is corrupted, but the other has been ready in submitting chain.

The chain needs to submit anyway in order to keep the page
working properly (page unlocked with PG_error set, PG_uptodate
not set).

Let's fix it now.

Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Link: https://lore.kernel.org/r/20190819103426.87579-2-gaoxiang25@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Gao Xiang: Manually backport to v4.19.y stable. ]
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index ad6fe6d9d00a..fc44f5ce670b 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1335,19 +1335,18 @@ static int z_erofs_vle_normalaccess_readpage(struct file *file,
 	err = z_erofs_do_read_page(&f, page, &pagepool);
 	(void)z_erofs_vle_work_iter_end(&f.builder);
 
-	if (err) {
+	/* if some compressed cluster ready, need submit them anyway */
+	z_erofs_submit_and_unzip(&f, &pagepool, true);
+
+	if (err)
 		errln("%s, failed to read, err [%d]", __func__, err);
-		goto out;
-	}
 
-	z_erofs_submit_and_unzip(&f, &pagepool, true);
-out:
 	if (f.m_iter.mpage != NULL)
 		put_page(f.m_iter.mpage);
 
 	/* clean up the remaining free pages */
 	put_pages_list(&pagepool);
-	return 0;
+	return err;
 }
 
 static inline int __z_erofs_vle_normalaccess_readpages(
-- 
2.17.1


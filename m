Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE398131D92
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 03:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbgAGC02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 21:26:28 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9117 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727295AbgAGC01 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jan 2020 21:26:27 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 540A6F32E3153190C524;
        Tue,  7 Jan 2020 10:26:25 +0800 (CST)
Received: from architecture4.huawei.com (10.160.196.180) by smtp.huawei.com
 (10.3.19.210) with Microsoft SMTP Server (TLS) id 14.3.439.0; Tue, 7 Jan 2020
 10:26:19 +0800
From:   Gao Xiang <gaoxiang25@huawei.com>
To:     Chao Yu <yuchao0@huawei.com>
CC:     <linux-erofs@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>, "Chao Yu" <chao@kernel.org>,
        Miao Xie <miaoxie@huawei.com>, Fang Wei <fangwei1@huawei.com>,
        Gao Xiang <gaoxiang25@huawei.com>, <stable@vger.kernel.org>
Subject: [PATCH] erofs: fix out-of-bound read for shifted uncompressed block
Date:   Tue, 7 Jan 2020 10:25:46 +0800
Message-ID: <20200107022546.19432-1-gaoxiang25@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.160.196.180]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

rq->out[1] should be valid before accessing. Otherwise,
in very rare cases, out-of-bound dirty onstack rq->out[1]
can equal to *in and lead to unintended memmove behavior.

Fixes: 7fc45dbc938a ("staging: erofs: introduce generic decompression backend")
Cc: <stable@vger.kernel.org> # v5.3+
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
---
 fs/erofs/decompressor.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 2890a67a1ded..5779a15c2cd6 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -306,24 +306,22 @@ static int z_erofs_shifted_transform(const struct z_erofs_decompress_req *rq,
 	}
 
 	src = kmap_atomic(*rq->in);
-	if (!rq->out[0]) {
-		dst = NULL;
-	} else {
+	if (rq->out[0]) {
 		dst = kmap_atomic(rq->out[0]);
 		memcpy(dst + rq->pageofs_out, src, righthalf);
+		kunmap_atomic(dst);
 	}
 
-	if (rq->out[1] == *rq->in) {
-		memmove(src, src + righthalf, rq->pageofs_out);
-	} else if (nrpages_out == 2) {
-		if (dst)
-			kunmap_atomic(dst);
+	if (nrpages_out == 2) {
 		DBG_BUGON(!rq->out[1]);
-		dst = kmap_atomic(rq->out[1]);
-		memcpy(dst, src + righthalf, rq->pageofs_out);
+		if (rq->out[1] == *rq->in) {
+			memmove(src, src + righthalf, rq->pageofs_out);
+		} else {
+			dst = kmap_atomic(rq->out[1]);
+			memcpy(dst, src + righthalf, rq->pageofs_out);
+			kunmap_atomic(dst);
+		}
 	}
-	if (dst)
-		kunmap_atomic(dst);
 	kunmap_atomic(src);
 	return 0;
 }
-- 
2.17.1


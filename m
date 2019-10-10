Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBE1D241F
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388887AbfJJItP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387852AbfJJItO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:49:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D2E921BE5;
        Thu, 10 Oct 2019 08:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697354;
        bh=eOqJJYWi5gKKm+VNaiyCcYT8uePCyikSSZ5h372H0lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mzo6nUcuul9mUGhZp80xb7v+b2AonYNnLjZ2APXvUlNbCBP+G8nzD0kVZaY7kHoH5
         lnXBAcjGfvWz3C37YLQgSi4WLWX4cBXu0bHpYsBg9EKP/TLu22njyT9ABrd7xDzGLE
         umBZ6BhpDMHfwfM55XsWYLoNubkpwRl1wwq3qzZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Chao Yu <yuchao0@huawei.com>
Subject: [PATCH 4.19 111/114] staging: erofs: detect potential multiref due to corrupted images
Date:   Thu, 10 Oct 2019 10:36:58 +0200
Message-Id: <20191010083614.153173033@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <gaoxiang25@huawei.com>

commit e12a0ce2fa69798194f3a8628baf6edfbd5c548f upstream.

As reported by erofs-utils fuzzer, currently, multiref
(ondisk deduplication) hasn't been supported for now,
we should forbid it properly.

Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Link: https://lore.kernel.org/r/20190821140152.229648-1-gaoxiang25@huawei.com
[ Gao Xiang: Since earlier kernels don't define EFSCORRUPTED,
             let's use EIO instead. ]
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/erofs/unzip_vle.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -857,6 +857,7 @@ repeat:
 	for (i = 0; i < nr_pages; ++i)
 		pages[i] = NULL;
 
+	err = 0;
 	z_erofs_pagevec_ctor_init(&ctor,
 		Z_EROFS_VLE_INLINE_PAGEVECS, work->pagevec, 0);
 
@@ -878,8 +879,17 @@ repeat:
 			pagenr = z_erofs_onlinepage_index(page);
 
 		DBG_BUGON(pagenr >= nr_pages);
-		DBG_BUGON(pages[pagenr]);
 
+		/*
+		 * currently EROFS doesn't support multiref(dedup),
+		 * so here erroring out one multiref page.
+		 */
+		if (pages[pagenr]) {
+			DBG_BUGON(1);
+			SetPageError(pages[pagenr]);
+			z_erofs_onlinepage_endio(pages[pagenr]);
+			err = -EIO;
+		}
 		pages[pagenr] = page;
 	}
 	sparsemem_pages = i;
@@ -889,7 +899,6 @@ repeat:
 	overlapped = false;
 	compressed_pages = grp->compressed_pages;
 
-	err = 0;
 	for (i = 0; i < clusterpages; ++i) {
 		unsigned pagenr;
 
@@ -915,7 +924,12 @@ repeat:
 			pagenr = z_erofs_onlinepage_index(page);
 
 			DBG_BUGON(pagenr >= nr_pages);
-			DBG_BUGON(pages[pagenr]);
+			if (pages[pagenr]) {
+				DBG_BUGON(1);
+				SetPageError(pages[pagenr]);
+				z_erofs_onlinepage_endio(pages[pagenr]);
+				err = -EIO;
+			}
 			++sparsemem_pages;
 			pages[pagenr] = page;
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04A46F65F8
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfKJCnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:43:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:42488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728417AbfKJCns (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:43:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93AAB21D7E;
        Sun, 10 Nov 2019 02:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353827;
        bh=6QOu04gevsHMOBxWy6PWqmiXuBC1YuqReUNHXNe1Ai4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0iC4JpUeJKiD+FY4MqinLp2bWnWJ9ZlzfpEpS5LjawaImZimLZ2GQKXnvK6lDKFSa
         i6lxYrjepVLwnRdxPqo/t2DixG449ZPvjvXYO98Ek9Opu2GpwLrDleY6hbZPp/KRW5
         8RwI9Ofe2kVWr4Xes3hVVx+17/kZKEdikcqfFfxw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhong jiang <zhongjiang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 122/191] misc: genwqe: should return proper error value.
Date:   Sat,  9 Nov 2019 21:39:04 -0500
Message-Id: <20191110024013.29782-122-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhong jiang <zhongjiang@huawei.com>

[ Upstream commit 02241995b004faa7d9ff628e97f24056190853f8 ]

The function should return -EFAULT when copy_from_user fails. Even
though the caller does not distinguish them. but we should keep backward
compatibility.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/genwqe/card_utils.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
index f68435df76d48..22301bba8c495 100644
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -298,7 +298,7 @@ static int genwqe_sgl_size(int num_pages)
 int genwqe_alloc_sync_sgl(struct genwqe_dev *cd, struct genwqe_sgl *sgl,
 			  void __user *user_addr, size_t user_size, int write)
 {
-	int rc;
+	int ret = -ENOMEM;
 	struct pci_dev *pci_dev = cd->pci_dev;
 
 	sgl->fpage_offs = offset_in_page((unsigned long)user_addr);
@@ -318,7 +318,7 @@ int genwqe_alloc_sync_sgl(struct genwqe_dev *cd, struct genwqe_sgl *sgl,
 	if (get_order(sgl->sgl_size) > MAX_ORDER) {
 		dev_err(&pci_dev->dev,
 			"[%s] err: too much memory requested!\n", __func__);
-		return -ENOMEM;
+		return ret;
 	}
 
 	sgl->sgl = __genwqe_alloc_consistent(cd, sgl->sgl_size,
@@ -326,7 +326,7 @@ int genwqe_alloc_sync_sgl(struct genwqe_dev *cd, struct genwqe_sgl *sgl,
 	if (sgl->sgl == NULL) {
 		dev_err(&pci_dev->dev,
 			"[%s] err: no memory available!\n", __func__);
-		return -ENOMEM;
+		return ret;
 	}
 
 	/* Only use buffering on incomplete pages */
@@ -339,7 +339,7 @@ int genwqe_alloc_sync_sgl(struct genwqe_dev *cd, struct genwqe_sgl *sgl,
 		/* Sync with user memory */
 		if (copy_from_user(sgl->fpage + sgl->fpage_offs,
 				   user_addr, sgl->fpage_size)) {
-			rc = -EFAULT;
+			ret = -EFAULT;
 			goto err_out;
 		}
 	}
@@ -352,7 +352,7 @@ int genwqe_alloc_sync_sgl(struct genwqe_dev *cd, struct genwqe_sgl *sgl,
 		/* Sync with user memory */
 		if (copy_from_user(sgl->lpage, user_addr + user_size -
 				   sgl->lpage_size, sgl->lpage_size)) {
-			rc = -EFAULT;
+			ret = -EFAULT;
 			goto err_out2;
 		}
 	}
@@ -374,7 +374,8 @@ int genwqe_alloc_sync_sgl(struct genwqe_dev *cd, struct genwqe_sgl *sgl,
 	sgl->sgl = NULL;
 	sgl->sgl_dma_addr = 0;
 	sgl->sgl_size = 0;
-	return -ENOMEM;
+
+	return ret;
 }
 
 int genwqe_setup_sgl(struct genwqe_dev *cd, struct genwqe_sgl *sgl,
-- 
2.20.1


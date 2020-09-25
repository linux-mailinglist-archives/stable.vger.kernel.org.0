Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABC1278E39
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbgIYQUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728861AbgIYQUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:17 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53CDC0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:17 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b3so3083901ybg.23
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=QKY9oJOaRIHpAGVT0DQuniaD4UoON0riEenGF0pOJvE=;
        b=LzuWru2rfMWXjmQhITR84ElJysOjN8K6nOXusZNxg902X24cz3ek/FtDMBKt9FSgXa
         ZTBhnR24rqBM50IghYU7zJnm9KzBOQmbKntt5P+mbWv3BrHeod0kutZeSPIqIkxB1uTx
         /FwKKfmyePEROjnkpa3WzP+nLyKuWUdFtC62TNZDrb5ToIArEWZAa0fa3R0HrPHIAYZy
         GQ4kTQq1ZnqoVtUdakFwuovVXbeakzakMGgwiNVlJinW4NO8aCgBS6jSRGBoX0aKumzk
         mInyoKXJSegCOWER9LsKU75awAEDxE1JZ4sLrx9CgD74QjHiikp9ZhQ7vNjPpTdh0baT
         90lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QKY9oJOaRIHpAGVT0DQuniaD4UoON0riEenGF0pOJvE=;
        b=FVSK72Izl9UgszRjKSXgQseVa44vzeE8ip8aD2Yg2Kc53eIsZAlJPEbCSdp/mmLaHF
         MioVC5BCfT5+oz9kadnIcg02tl9AVitsYzkKlok6h4+VOxeU2nshFyG8mGVe1IFtJwEh
         Q16cvXgqZmRm8p05Rt7MSQBiGQV+/qfj4F3ESMSzGq9t0jI6t40q6q6SCqJLbi+8Q8vq
         7B0x9Uzq0JiArdq5h/3p/XuwIaa18c7ZHaiMti8p40blgcsA2fFOAsU+zrgxFA0d5TvG
         n2wI5kYOdRidza/YnBHO29XAOFQT474jYzxiCNZ42mdql25dK3by7j3CqY7vWDvnStN/
         qyJA==
X-Gm-Message-State: AOAM531H77n5h53TytvfFo6d2EUQ9GM/d1x5dF2tGP1NF5Uj+VTurXtg
        8onrZWyYh2TuYnalL7+xvRCJkd5MVwPvEog69P/3xdvdJc/PDz+X3TfNAWH8O5z6QOPqoBdvK+J
        KZ8+Stlp9iM+TIKiD9knDPehkxJYqlE1F0uOBU84l756cGE4DY09rRO02Lga/wQ==
X-Google-Smtp-Source: ABdhPJyMo4w6b7rnuGWNqdSRQpB1KWfKzeALhjlus7QESb3CBHfqdp1BXMN8hB8yfKQnLVHq3rCi9VQulAg=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a25:df8d:: with SMTP id w135mr6656059ybg.194.1601050816800;
 Fri, 25 Sep 2020 09:20:16 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:19:01 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-16-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 15/30 for 5.4] dma-direct: consolidate the error handling in dma_direct_alloc_pages
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

upstream 3d0fc341c4bb66b2c41c0d1ec954a6d300e100b7 commit.

Use a goto label to merge two error return cases.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 kernel/dma/direct.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 210ea469028c..5343afbb8af3 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -203,11 +203,8 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 		ret = dma_common_contiguous_remap(page, PAGE_ALIGN(size),
 				dma_pgprot(dev, PAGE_KERNEL, attrs),
 				__builtin_return_address(0));
-		if (!ret) {
-			dma_free_contiguous(dev, page, size);
-			return ret;
-		}
-
+		if (!ret)
+			goto out_free_pages;
 		memset(ret, 0, size);
 		goto done;
 	}
@@ -220,8 +217,7 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 		 * so log an error and fail.
 		 */
 		dev_info(dev, "Rejecting highmem page from CMA.\n");
-		dma_free_contiguous(dev, page, size);
-		return NULL;
+		goto out_free_pages;
 	}
 
 	ret = page_address(page);
@@ -241,6 +237,9 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 	else
 		*dma_handle = phys_to_dma(dev, page_to_phys(page));
 	return ret;
+out_free_pages:
+	dma_free_contiguous(dev, page, size);
+	return NULL;
 }
 
 void dma_direct_free_pages(struct device *dev, size_t size, void *cpu_addr,
-- 
2.28.0.618.gf4bc123cb7-goog


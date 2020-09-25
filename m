Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3AA278E3E
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729594AbgIYQU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbgIYQU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:26 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B4DC0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:26 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id e13so2681326pgk.6
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=e06FdFQ0PIqy4dZ4zt926BnYxEIbdPgCQlSxDBI9oMo=;
        b=UigxdEL/247+XP6z01JfIl3kCMca2t9gihOV8zP1Sdef1/e2s/aSDK3QxSgbsWEdOQ
         vXBZ4S1nslSec2e3lu5pzxmaz9JdGpO2HETd2uIwFfFkBLIS8TYoIQ/fVkslsqYCb132
         84wnbE7sbkHq3wB3nTyCeA1vAqtV3jH5csppVQgd2UBHMnxYb0/dq6iGGkNa+1lD2DVS
         wmWWUupXnnr6ZC8dzTjBUbyLGzLieskVuP/XWxxAqeSYQygc4OAAVZo3t2n9c5gg4L7T
         wzTnFSdoC9w1TCyAf+BlYBC3lXk4YMZjLHZCaStmFF2znIEnnm9FhGSE3Va2qtZfA01b
         sMJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=e06FdFQ0PIqy4dZ4zt926BnYxEIbdPgCQlSxDBI9oMo=;
        b=Pz8SgQ3xvJRYgMk/VlQbl5xQ4hMrplo6t2NAQrm0WG55Dp/JXiOEbyJVINAfrsFp93
         jIdXoIH7xdwPMHMwIh8yO57E4WivTk6U3ra4Zi1YaBP/ZKelBhMsppxux5eD35O9cXjf
         5Ea4ETQ6c+ARSF0DOSLc7B+S++AVZLTQcRgdxjEQJh3VuuKdXiY1eRZD3Mq2l5qVoyjG
         PdqmX2YvvVOO4ynQ5oWc6OI4RVJCHdcWKne4R8OXVK7B/Be4zNGxShNkw+1QruHJv17h
         3Glycv20AcHOc4lRjESf6B3/spjNpk2xDNzjdOyQXanT+Tr3bXy1dYdSD5/ME5X2T1is
         dicg==
X-Gm-Message-State: AOAM530L0hGcsuckIabOBWoH/mnjvM0okPQwISmmbrkRXVWcFJM5d+ef
        W9AhvTZbtsk8g98O8W1jMXru6CAEBPNTWs2rWjViWHi5nMUrNzjar5TbHXwnx3OjuvnFxO2WZKH
        k/4Py1KvUlF431Bhd33ZqRZr/vi7pCv+yTOmdTYPYEDv1VXBZmZ8MbGpu/jNaQA==
X-Google-Smtp-Source: ABdhPJzXA8j6nDJO4zrI8c03gXGiqZo9Z/GSkTyRV0nnwKVkpk0629xDjv0B8py/lxGQOUSa0S7BhSB/7/k=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a17:90a:8a82:: with SMTP id
 x2mr323799pjn.177.1601050825530; Fri, 25 Sep 2020 09:20:25 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:19:06 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-21-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 20/30 for 5.4] dma-direct: check return value when encrypting
 or decrypting memory
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Rientjes <rientjes@google.com>

upstream 56fccf21d1961a06e2a0c96ce446ebf036651062 commit.

__change_page_attr() can fail which will cause set_memory_encrypted() and
set_memory_decrypted() to return non-zero.

If the device requires unencrypted DMA memory and decryption fails, simply
free the memory and fail.

If attempting to re-encrypt in the failure path and that encryption fails,
there is no alternative other than to leak the memory.

Fixes: c10f07aa27da ("dma/direct: Handle force decryption for DMA coherent buffers in common code")
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 kernel/dma/direct.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index b4a5b7076399..ac611b4f65b9 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -172,6 +172,7 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 {
 	struct page *page;
 	void *ret;
+	int err;
 
 	size = PAGE_ALIGN(size);
 
@@ -224,8 +225,12 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 	}
 
 	ret = page_address(page);
-	if (force_dma_unencrypted(dev))
-		set_memory_decrypted((unsigned long)ret, 1 << get_order(size));
+	if (force_dma_unencrypted(dev)) {
+		err = set_memory_decrypted((unsigned long)ret,
+					   1 << get_order(size));
+		if (err)
+			goto out_free_pages;
+	}
 
 	memset(ret, 0, size);
 
@@ -244,9 +249,13 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 	return ret;
 
 out_encrypt_pages:
-	if (force_dma_unencrypted(dev))
-		set_memory_encrypted((unsigned long)page_address(page),
-				     1 << get_order(size));
+	if (force_dma_unencrypted(dev)) {
+		err = set_memory_encrypted((unsigned long)page_address(page),
+					   1 << get_order(size));
+		/* If memory cannot be re-encrypted, it must be leaked */
+		if (err)
+			return NULL;
+	}
 out_free_pages:
 	dma_free_contiguous(dev, page, size);
 	return NULL;
-- 
2.28.0.618.gf4bc123cb7-goog


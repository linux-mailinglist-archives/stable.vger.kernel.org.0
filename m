Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9F33547F5
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 23:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239844AbhDEVDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 17:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235325AbhDEVDD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 17:03:03 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73757C061788
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 14:02:56 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 7so9712571pfn.4
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 14:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=So0y7ATR8dilmlW63jQBY7ay+ZwzZlkrRYrCdkKLLbU=;
        b=X8/vBvJnQMoDX/ifymsVwoTeaE4Ii6TeIAFVqohOdcnMQaor8/enlFx/LVAQxAtkHG
         P+72m/kEheBHoq9wgZOiveIF9/bT/CdK1yWbXBwmGc/LJlDvt2kezPiDH1emkG1tcqiO
         49eFmO2sYdeCscZBIYfOjFxk6aV8qvRytoppmKNSX7CFyEc1xil8SWjAgyT05AlCSf9g
         BP2NoxXlbYRFxpDIl0JwUSADccjtk6uOgxlvkszQhM9cxlf8zBkznOi+GX2iMFMG11oa
         +/HtOriVUm0W7HEQUt3sEO8mx+LDORClbBvnphlKOJRvYzoTEpMxbxHqUU6mfAfPh6o7
         kQGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=So0y7ATR8dilmlW63jQBY7ay+ZwzZlkrRYrCdkKLLbU=;
        b=B7R1tZNJAQA1W51PSR9qH6Ly/CARaVxm+5MNAfI+GynA5vZB2ueV6V5u+kZj6K1roZ
         QFD/EFJS1ne5sQoIqOqB/1kqHP0WXqGEYzTzpHKuyd0viOhGIrOiILDEW8ZpZxGFl/6Z
         lWBrPCB4K3qR2eN7m/jUCsY82rwpqmo2H6T/nz69rp157N9CIIACxSQilr7cCZe8h+wq
         4tXRIfmTXcyYrboXxZEVD/O1HL0rUBDzXnmn8/3RvESjqX2EEFUxm90OBn4QBhUMubFT
         l8tWk2DAEr+cleXXEmW+IEx2HiDAXHBTgkUbT2Ph5VL7zZHzFqv4EBHQ5eLn8GL+ev6d
         L+FQ==
X-Gm-Message-State: AOAM531DGVRtb8EVln3hASGij1+TkNQEYtnUFmOhCPYWAg/mQkJINebV
        FtHpPmNndJYim6eMBdanTqvvVw5ubx8Jhqp9com3+mGtXhHGsYwAqKCPkGzWvIkDs5JV0ttOn5F
        BM1Kv55YYDk4ilhr9pkhFafflXMzJLmP/iLKlUz2UWavoF+vlNRJbE1SgBnk=
X-Google-Smtp-Source: ABdhPJw2DloO8Hr1zFVBSe0cv6N9mz20hDNSskphrsT00OEoVmG/Sw/SELpAT87Q6rYAkAc95XDEVc7WvA==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:90a:9281:: with SMTP id
 n1mr990606pjo.146.1617656575946; Mon, 05 Apr 2021 14:02:55 -0700 (PDT)
Date:   Mon,  5 Apr 2021 21:02:23 +0000
In-Reply-To: <20210405210230.1707074-1-jxgao@google.com>
Message-Id: <20210405210230.1707074-2-jxgao@google.com>
Mime-Version: 1.0
References: <20210405210230.1707074-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v5.10 1/8] driver core: add a min_align_mask field to struct  device_dma_parameters
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

'commit 36950f2da1ea ("driver core: add a min_align_mask field to struct device_dma_parameters")'

Some devices rely on the address offset in a page to function
correctly (NVMe driver as an example). These devices may use
a different page size than the Linux kernel. The address offset
has to be preserved upon mapping, and in order to do so, we
need to record the page_offset_mask first.

Signed-off-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/device.h      |  1 +
 include/linux/dma-mapping.h | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/device.h b/include/linux/device.h
index 5ed101be7b2e..cfa8ead48f1e 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -291,6 +291,7 @@ struct device_dma_parameters {
 	 * sg limitations.
 	 */
 	unsigned int max_segment_size;
+	unsigned int min_align_mask;
 	unsigned long segment_boundary_mask;
 };
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 956151052d45..a7d70cdee25e 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -500,6 +500,22 @@ static inline int dma_set_seg_boundary(struct device *dev, unsigned long mask)
 	return -EIO;
 }
 
+static inline unsigned int dma_get_min_align_mask(struct device *dev)
+{
+	if (dev->dma_parms)
+		return dev->dma_parms->min_align_mask;
+	return 0;
+}
+
+static inline int dma_set_min_align_mask(struct device *dev,
+		unsigned int min_align_mask)
+{
+	if (WARN_ON_ONCE(!dev->dma_parms))
+		return -EIO;
+	dev->dma_parms->min_align_mask = min_align_mask;
+	return 0;
+}
+
 static inline int dma_get_cache_alignment(void)
 {
 #ifdef ARCH_DMA_MINALIGN
-- 
2.27.0


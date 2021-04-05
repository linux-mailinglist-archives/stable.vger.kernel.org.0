Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D083547CD
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 22:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237176AbhDEUvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 16:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbhDEUvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 16:51:41 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB25C061756
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 13:51:35 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id a7so9133620qvx.10
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 13:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4ujRwH9Qeuahg6XyCisDR/+nn3aKqKkfKtyFiwVo0Ew=;
        b=U0S+Rbmuytjl9vY109aRcK4G9ITSuo53CM7KH7C14TsjTuMH4nMcs67cgym7Gf/kGY
         wnJMvD+1o/1aM1MOttfvJ4UtFdqyYBE4axpK1BYYpAVo5aMfXVH5wzJMNr4RN05WXG2w
         d7g9HEo4iEx0Nhox2lAHWzYqBrBIG/eYCbhbnC/+s7WMpWKA0W01LCvHprPBRRK2o+1J
         Xp91181rwAIxE8EMtLlp4umyQGxTCrNWSWVu51DRjx0ifqyu3Oawk4S/24kVBLU5jCe3
         b5yQsE0cU6ccLsF+21HlawBXDynzGmpiJvs5lYPiF/T26Xo3JI4HyUNnX1X84EiYri7L
         2vZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4ujRwH9Qeuahg6XyCisDR/+nn3aKqKkfKtyFiwVo0Ew=;
        b=dr03IAYqsueB9FJV5w2MtxoRIYCqHJ4y01/22ge7MBbhY5/PMawWaOIByuorwvQ7j3
         +G9ObSWwtIXiZUFM7/vMqHPNVb5lkJGQREwt4nIjFJKGncLeG5qPhoez0E/Peit3eCJe
         ezHN10K5xsKWTJcn6cshUD+PA309QZeLjPd26+adSzws3p/BJctwD2/BaRVfiFfmi5Bu
         KcbA5jp32k8T0fD7p6QH3XX5cjcvPGGKvducT/W3z9qGkvytnSZx4AlyK1CaM4hvODjm
         r41smZxkkZvf6LgDo8PKgmFWbKtBa20GFaaEYXYknTjNMyCgnkfd1/rllEP1EYhHjQI2
         om9A==
X-Gm-Message-State: AOAM5323CzzUqCptK6bar/RQoJleVQvT8fEbbbOKGcV9n62OGy6Lwxjg
        XhQydd8IWxITY3YYIh9SoCuDuAEdaLagieYEHYvuHvcZ7HKe6e2YxadsZZccc50/zT6SKTeatMj
        CJQsgTreVZ6J4FVbHq6c0Esp5iZE1GXZ0ssy3pmzjAsox8Rl/rI8i79FsufA=
X-Google-Smtp-Source: ABdhPJwCcuAP2WemT26qijszPemYWKEidSpmP4N04qkCuXHxYqlTJ+CYRon9nNowT0Ihh74s24tNf+V6qQ==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a05:6214:204:: with SMTP id
 i4mr25546301qvt.47.1617655894411; Mon, 05 Apr 2021 13:51:34 -0700 (PDT)
Date:   Mon,  5 Apr 2021 20:51:02 +0000
In-Reply-To: <20210405205109.1700468-1-jxgao@google.com>
Message-Id: <20210405205109.1700468-2-jxgao@google.com>
Mime-Version: 1.0
References: <20210405205109.1700468-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH 5.4 1/8] driver core: add a min_align_mask field to struct device_dma_parameters
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
index 297239a08bb7..2d30a6d7249e 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -993,6 +993,7 @@ struct device_dma_parameters {
 	 * sg limitations.
 	 */
 	unsigned int max_segment_size;
+	unsigned int min_align_mask;
 	unsigned long segment_boundary_mask;
 };
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 4a1c4fca475a..c996cd2e72f8 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -747,6 +747,22 @@ static inline int dma_set_seg_boundary(struct device *dev, unsigned long mask)
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


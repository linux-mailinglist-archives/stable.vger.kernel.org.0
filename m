Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3A3355D12
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 22:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245575AbhDFUoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 16:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347218AbhDFUoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 16:44:23 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A083C06174A
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 13:44:15 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id s10so8755129pgm.13
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 13:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EEgE3J6Q6/d1IUHulSii9b9HuL7xNfgGM0g8cwzu4dc=;
        b=MHmLKdrElRkUCKIp30lYZHkiGI1d77rj4xKWnWAmzpy8BTgDAw0YD+fhPCjj1M3VCV
         odsJ+voMlmy+o7ZygQQ64mDrDCQjPIYSMC2LJupuRg/OdCnoq/wtALDgyaVEKYUyAbr6
         gI1NaeT0aO3x8v8ZA9qj34mlRR+xb+SaXiNkRKYszmpycM4bUvQvOueqi6pkrwzyg5Bn
         OD74S4QBptSrSnSvVLqPD+vgzYvDLTyGPmlJ5Som/TEn/QkvqrzgXraJin+ft8AG+yqM
         VV3y9LgQUhOWuuxs1T57GZwm+YUxgRhldvncgA2cWOaMtPScGj2U1sMX9o2xkfefPPso
         JDzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EEgE3J6Q6/d1IUHulSii9b9HuL7xNfgGM0g8cwzu4dc=;
        b=A/tOSlpfrelMaieYo3C3nbgdmk6YgOhYfjIwz/uR/3TD4kgI03aGO2ubuthBho7zkY
         RUlvy/HfQoNqM2vXY5ML4axLui5krW9c6P3aGtm66CFQLtPsqjXIfx5llNJnMFPxs4AA
         +uwS5lvfFoT3X02iUL2muVOnq1qe6hKpriWbxrloTWvsg92+GODmUSLWV5uGKccsGtP4
         51lRGmNMFc6VfHstqPxlis9ZUxsJ90O3RgfhFWw0a+8Pm4MvthLEB8VB9mgx9fSOzIRj
         rItdpQcN1cxjCv7d0Q+V10gkcjfQCCNFwf75Ji7GexJTYGCAV6aPsB5NyG9uU1J7BSbt
         09Xg==
X-Gm-Message-State: AOAM5300LWjbc5GmV5/lrBoSzOLp2I1PG8zeMHlrBpNE3fy5ZAeBB8Dv
        zB0QgRv32DQQOkkw1V8XWdw7b017kfpEyeiZKUzoVdY93Oi50kFT4wM7nlr3Ag+sxEVzE3GsqG9
        9pZkiWm4bBB/aOEY6D9NcL2BUeJcrVXXMaM6m0fIPd6y1aTa8xP1E3dUm5R0=
X-Google-Smtp-Source: ABdhPJxhD8rcEPMIuwC7Akf4wgfXx/M0H5NNniONaqJ0nCIXm3MdRsAyDZnp1qCiv+dh0eyrOJLMPZf+IQ==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:902:b210:b029:e6:33b4:cd9e with SMTP id
 t16-20020a170902b210b02900e633b4cd9emr62781plr.67.1617741854775; Tue, 06 Apr
 2021 13:44:14 -0700 (PDT)
Date:   Tue,  6 Apr 2021 20:43:20 +0000
In-Reply-To: <20210406204326.1932888-1-jxgao@google.com>
Message-Id: <20210406204326.1932888-2-jxgao@google.com>
Mime-Version: 1.0
References: <20210406204326.1932888-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH V2 v5.4 1/8] driver core: add a min_align_mask field to struct device_dma_parameters
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>, Christoph Hellwig <hch@lst.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jianxiong Gao <jxgao@google.com>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jianxiong Gao <jxgao@google.com>
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


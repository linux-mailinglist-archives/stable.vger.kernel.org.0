Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F8B3882A6
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 00:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244015AbhERWUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 18:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236372AbhERWUZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 18:20:25 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE810C061573
        for <stable@vger.kernel.org>; Tue, 18 May 2021 15:19:06 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id c9-20020a2580c90000b02904f86395a96dso15288506ybm.19
        for <stable@vger.kernel.org>; Tue, 18 May 2021 15:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mkQF18aWGux+JejyD+9KKDXzwMixHAHLYJ3SJnYtrV4=;
        b=r5YnfSc6jtX0sUXvZ6Mj2OoScWEcSEy0BmBxHHWhBE9AUI0uDAqHWSll6cco2Xaayy
         YJNrcaFY4zdB1Sl5yh37hRPHxhNPQfuAxHwBv6ofXeYX31KpQrZyB+z6agBN5zzHAnZe
         WAfW0QfWEyN9VEBIRe+3+0Uy5cxNWzFKQ9TlVEOU0lhXNg0p96Owq6TJ0fn1yJtKMagy
         LM73KRXCUOFw8VO65cphE087h9CaQIQb0mvTq6cR19oO3TsUefam6JZM0BqJN7qXZGo1
         Emf33iYwrQyjcHtRMX7QIqn3IaIX14Kl5Ru4bqoYSi8989V7FFr7Tx4f5lCLvdlVcclh
         mK+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mkQF18aWGux+JejyD+9KKDXzwMixHAHLYJ3SJnYtrV4=;
        b=TVHNWx3pymMJRVr4vTR1QuzfsoC9nBNKF7vwo9w2JIZ7Bw8CXw+FWBs9KGtYmVdvB+
         yWDSp6LM3jjSdt2HKUnvskkY3pwRgSLQgVPYBZ9yhKi60Ot7rUl6Kw6B+ZLgHSt8z/ZN
         8uWclJc7TQKiGEytnkAj2hWA+R27xIwLtXDG7VgLVo8N68nA/gbmDdAKRqmZ4aqmqYGx
         K92oNUyI8/XIIlttZ1WPWgQWPxnDI0bybi3yMDRZalD2Bh3ia7Na5mW3dmmaly6pmutd
         0v5NbMfERthNllq69rYjLhS2f8UQrWBCGQZDunaKiHlBPiufpbhVBALFsv48CklWiMBf
         Qfqg==
X-Gm-Message-State: AOAM5333NfQH63s1vDv87pHoORw6GwclXXFxhawLY0muYSCLE8tkG8B0
        j6CjkWrNeqpKhm6grICQJxYyGtgdCwOzEJHokHYDXfqWKr4ltssdj3xK2QDSTAW5dLlfTcWtGd0
        M4o2oQdlsZC54nXdu2EwUq1zBxDpE2dq02GemcmLcle1MKBoqsrdPVze9u9Y=
X-Google-Smtp-Source: ABdhPJzXgrZx4+5kVxoHRommxvnXtjDdhz3gSj06qNQzXsre0m3mC5n3nCyfg06AQ/W4QKh3YwskuAtpcw==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a05:6902:1024:: with SMTP id
 x4mr11430493ybt.95.1621376346071; Tue, 18 May 2021 15:19:06 -0700 (PDT)
Date:   Tue, 18 May 2021 22:18:11 +0000
In-Reply-To: <20210518221818.2963918-1-jxgao@google.com>
Message-Id: <20210518221818.2963918-2-jxgao@google.com>
Mime-Version: 1.0
References: <20210518221818.2963918-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH 5.4 v2 1/9] driver core: add a min_align_mask field to struct device_dma_parameters
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org, hch@lst.de, marcorr@google.com,
        sashal@kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some devices rely on the address offset in a page to function
correctly (NVMe driver as an example). These devices may use
a different page size than the Linux kernel. The address offset
has to be preserved upon mapping, and in order to do so, we
need to record the page_offset_mask first.

Signed-off-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Upstream: 36950f2da1ea4cb683be174f6f581e25b2d33e71
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
index 4d450672b7d6..953e1e3078f7 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -751,6 +751,22 @@ static inline int dma_set_seg_boundary(struct device *dev, unsigned long mask)
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
2.31.1.751.gd2f1c929bd-goog


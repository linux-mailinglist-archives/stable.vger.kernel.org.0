Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4465D36EEF4
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 19:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbhD2Rf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 13:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbhD2Rf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 13:35:27 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025F1C06138B
        for <stable@vger.kernel.org>; Thu, 29 Apr 2021 10:34:41 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 198-20020a6218cf0000b029026162e35700so19947520pfy.10
        for <stable@vger.kernel.org>; Thu, 29 Apr 2021 10:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=d9Ug1vJdGwT7JEpa/Q1lrf3n1XthbZHDTFGnEVZVuEo=;
        b=l5r2t2QKf4Qmldlj6gP8bbKWzONteI/TtfTUQJQtlqyhbELiuWyP60oEPZCKoYYfvS
         op1wD8M5SJPZGienblXzYr7kNZl7KJW3akIB1dvAA1e0tBxieiW+3dpatPVLosit3mwr
         bJV970pM5awt22ucvF8cA4pO4CMK1AIS+fANHHP7RV16cTGWCrZgSEj0a2/ZwQ8ne/KC
         cmbtZkjvrMgVQE4v1Jt1pH1wwJjOlqLzalL43OJeB65C+5xBI5n+saZXh6IjWlMMiO4F
         RkTlatx4G2Zz+YO8F79m0kQuRATWXzfR0J41rSu+O/tpWP8bKfSTQc7NiZeIMbp8ZuJY
         5hrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=d9Ug1vJdGwT7JEpa/Q1lrf3n1XthbZHDTFGnEVZVuEo=;
        b=IeOlDrSVg7fa+L66PyAUH3hGmy+seAYbcq+mr6cSKsCLJ5v4bEdiwAu9Gpo9I+XWrh
         CWeqtH74UZ406RRojHrMPHu2RgliJX4FrS+zHMt0qNpmLbzrf0onkVUzpoDCuv6N1Z5D
         Svg8jRQDn8IGTmGI9s/75SB1OIqIdoCXA95YKw/9IwSMLT4yKrkwOni5+xHxHXRcWfFB
         XLPxhCdjV9eSB7kBXOj21uRHRITZq8C5jr0SyT9kXuPh5iUGdQ7HuZueo9m7CqAQR4NV
         dqmD/1pSYALAr+Lc+ZAGXMdvehB92N1ekUqTiVYY0u93j3VOviBnQW4LFw7+CV2DEaEJ
         Zm5w==
X-Gm-Message-State: AOAM531P806sxTfw9TfaxW7o27vW7/8vrygaYrJhsKAq7o0Fj9iGYjNn
        qMPEVyJA9jVLQSrz9xdwZklkRMLNilvaMHMY6RL3NgB9HaBtJ5hjGXCLusCsz/Lp22AgDyFvbDh
        C30zmEdT/184oXJfuwCkktRRZ4LkHSp9WdLwxQagfWIj8QSPXbLVx7Mki6+g=
X-Google-Smtp-Source: ABdhPJw8du8nqTXUu01/xF1RzEU1XCuoZ3oMYKOhM5rZA2URx1HksnjrfrLJuqrysKi9X9cfehtQE6WLMA==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:90a:174c:: with SMTP id
 12mr812783pjm.1.1619717679088; Thu, 29 Apr 2021 10:34:39 -0700 (PDT)
Date:   Thu, 29 Apr 2021 17:33:07 +0000
In-Reply-To: <20210429173315.1252465-1-jxgao@google.com>
Message-Id: <20210429173315.1252465-2-jxgao@google.com>
Mime-Version: 1.0
References: <20210429173315.1252465-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v2 5.10 1/9] driver core: add a min_align_mask field to struct device_dma_parameters
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

commit: 36950f2da1ea4cb683be174f6f581e25b2d33e71

Some devices rely on the address offset in a page to function
correctly (NVMe driver as an example). These devices may use
a different page size than the Linux kernel. The address offset
has to be preserved upon mapping, and in order to do so, we
need to record the page_offset_mask first.

Signed-off-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/linux/device.h      |  1 +
 include/linux/dma-mapping.h | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/device.h b/include/linux/device.h
index 2b39de35525a..75a24b32fee8 100644
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
2.31.1.498.g6c1eba8ee3d-goog


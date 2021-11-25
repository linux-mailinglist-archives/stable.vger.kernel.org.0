Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C752545DC40
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 15:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354444AbhKYO0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 09:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353983AbhKYOYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 09:24:06 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC99C06175F
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 06:20:08 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id l16so11999108wrp.11
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 06:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yXyzv4xc6JEENsX2VRvqFajJbPhShqE522YAFNSvC7o=;
        b=m5icG+/ztw6q17Flo7iL+KvoQsGnKhcsCd5WhloLdRfpcr+LkgqBb2Alg6pd/91ljE
         cs7TQKFMDG7czlBV2B+dgXWSj75OKCiR3ySBdc8OsThPQpsQDCif63J5W0mn8w1JpM4Q
         AtVchfPWflm2wpr1YwVrvKwaJ2OQQW9+7Uw2DUnE9rL1V7axwuJHmXlStpGwMdB3p7z/
         ohr7+yuTiV+4dVl5oV6o6IhjXv2eK3R2ZO2z/8icrHwmXNt+SM7cLfulZIguTEYdVg0S
         oIfX9XsoCXxgCgSsXvZR3pk726upjkcAEyOiS/Mm/Pw+O4edXallitm4AsEQQC/CsjCD
         OgqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yXyzv4xc6JEENsX2VRvqFajJbPhShqE522YAFNSvC7o=;
        b=sZnOwwNZTwsA7JoOjgkgzcKNMk6nBCRK4YA22UvjDXzBxN9h8B76b5NM0QsEDbP1wM
         xfoAj61i6Zi6gRceJ1eETwlbhEaEp8SDbeG4QndhxnRmpAP2vIndJIDnf9hR4zi45M6m
         eMM0EPHjoxBNjKEYdEpcTvpDBZXIa8rzV9elHw0emjWHSwvTRo3nFemOO2xoqZnvJEeL
         WnwYklgnESWPNuFerQPkXVkZTEFk2wI12e32EWA58oHN9xClwZYjq2F2SpQNcmhJFOzw
         8fWFBvKEx38ZESlbJOArh/K/evuPFMau8k/ZLH43gGRy0Y98OnZSMWBQGmWmHhvPmpZg
         dTrA==
X-Gm-Message-State: AOAM53177GzV87RqUiKh7Wz6gFhIreIih57sbenO46NUZSHLpnLgxi8j
        KCIyJgH8l1Kv6HQXtn9jSRf5rw==
X-Google-Smtp-Source: ABdhPJyIUGRu2b/x8WdFkz1IO8k3zg926zgxQQenrKYRNupwjfFjhV3sxsOWiqeIKdxHtE6KG3Q8SQ==
X-Received: by 2002:adf:f352:: with SMTP id e18mr7108423wrp.39.1637850007575;
        Thu, 25 Nov 2021 06:20:07 -0800 (PST)
Received: from localhost.localdomain ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id o12sm4447026wrc.85.2021.11.25.06.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 06:20:07 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, labbott@redhat.com,
        sumit.semwal@linaro.org, arve@android.com, riandrews@android.com,
        devel@driverdev.osuosl.org
Subject: [PATCH 1/1] staging: ion: Prevent incorrect reference counting behavour
Date:   Thu, 25 Nov 2021 14:20:04 +0000
Message-Id: <20211125142004.686650-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Supply additional checks in order to prevent unexpected results.

Fixes: b892bf75b2034 ("ion: Switch ion to use dma-buf")
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
Should be back-ported from v4.9 and earlier.

 drivers/staging/android/ion/ion.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 806e9b30b9dc8..402b74f5d7e69 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -29,6 +29,7 @@
 #include <linux/export.h>
 #include <linux/mm.h>
 #include <linux/mm_types.h>
+#include <linux/overflow.h>
 #include <linux/rbtree.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
@@ -509,6 +510,10 @@ static void *ion_handle_kmap_get(struct ion_handle *handle)
 	void *vaddr;
 
 	if (handle->kmap_cnt) {
+		if (check_add_overflow(handle->kmap_cnt,
+				       (unsigned int) 1, &handle->kmap_cnt))
+			return ERR_PTR(-EOVERFLOW);
+
 		handle->kmap_cnt++;
 		return buffer->vaddr;
 	}
-- 
2.34.0.rc2.393.gf8c9666880-goog


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82ADE45D9B6
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 13:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240128AbhKYMHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 07:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240198AbhKYMFy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 07:05:54 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515B5C061759
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 04:02:43 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id y196so5345035wmc.3
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 04:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zsARScXN7590D6bLDv6wWFi6yhd0pHvccxAh6T7cVAQ=;
        b=n+tiHgtMEA8zfGbtImvDoJ1ycHk00t2ODuMNcI2bFQYosoUO1aP4Ey/nMeromm6+L3
         KoSTDQm1BIQjoL2CcpqhY1ULnl+ooyAuNt1k47k8PoQnJZO5h7VIJVUQk1NcbdqYyYRu
         jgEu7zxN3Lq8ARnH8ax9xXf3qbAwnwhR32qIzsXwsUoCtpEPblBmToMIg/5Ly+bePfM2
         TkoLViUFd60Ye4t6M932bwesqGaDnTrUg4wPcUm8Vfn6wgyXOrqlcfFcXxSHw/CgaiWH
         D/OTFevmMFf5/RpmNtUFwp04x2TcZDizQfIZVl842OWC9Qio7MgBlOqwX3d7D8CFPTeY
         lokA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zsARScXN7590D6bLDv6wWFi6yhd0pHvccxAh6T7cVAQ=;
        b=sSVFu2nT1ZnkLLQEOYyKpIGOje3P6QuKmvjo2bXnxmFqbS0XgvHOjGwSHXQ/evyRH1
         /5vZoOEakAwPPUdXzTlAI8k5+xTcLuBqqHmy3nZSsM/sS1K1Psf2liwOOiEp5/yWeAye
         iqD34/qlNOfokcfG3qzcuy02hMQsZmomISDAxBiF6Npeh/VRG7bhugYLz9kGr7bMh9fV
         Gdq69nRXKvRcWkL/9pvWj9wkP8ryVaESeuMWX1PoeFHD+lUahFR0+P2n0EDxt2mvQ/O6
         BjL+tZJGHNdyl4HNyGu2bPtJT4AlavOybkA24VZiZnbYSV30MlzVW+pYRnEjmsw2eO/s
         KEqw==
X-Gm-Message-State: AOAM533bih0L2hrjlYfl8TixdhgxlDfBNRsN+VS+Jfa4yHVr+C6OdmSu
        IU5sAcCPoHvsFl7DHWjhWyyD7w==
X-Google-Smtp-Source: ABdhPJw2DxV7co2ofmEA4CJ0u6dScH8VmjMKNfJ5iLU3WQR5EzyS3785FbsfzwzcTNPwtzBrLi0RgQ==
X-Received: by 2002:a1c:a301:: with SMTP id m1mr6770684wme.118.1637841761830;
        Thu, 25 Nov 2021 04:02:41 -0800 (PST)
Received: from localhost.localdomain ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id b14sm3455691wrd.24.2021.11.25.04.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 04:02:41 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, labbott@redhat.com,
        sumit.semwal@linaro.org, arve@android.com, riandrews@android.com,
        devel@driverdev.osuosl.org
Subject: [PATCH 1/1] staging: ion: Prevent incorrect reference counting behavour
Date:   Thu, 25 Nov 2021 12:02:34 +0000
Message-Id: <20211125120234.67987-1-lee.jones@linaro.org>
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
 drivers/staging/android/ion/ion.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 806e9b30b9dc8..30f359faba575 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -509,6 +509,9 @@ static void *ion_handle_kmap_get(struct ion_handle *handle)
 	void *vaddr;
 
 	if (handle->kmap_cnt) {
+		if (handle->kmap_cnt + 1 < handle->kmap_cnt)
+			return ERR_PTR(-EOVERFLOW);
+
 		handle->kmap_cnt++;
 		return buffer->vaddr;
 	}
-- 
2.34.0.rc2.393.gf8c9666880-goog


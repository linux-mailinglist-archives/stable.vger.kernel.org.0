Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4B313F5EA
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436939AbgAPS7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:59:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388923AbgAPRGY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:06:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F47A20730;
        Thu, 16 Jan 2020 17:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194383;
        bh=Oa+7Q3cW1yJ21jr6jVTw65O+99L2WuNePPKyUKSbhzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XtWKSIhUkVZlpQoYep1g8Pd4Kjg1bOlnC7ZhNuOKHye8D1zBK8aTGDJXvY210Yvog
         QFUNzSXOLqYMqOUTAv+itk1wDVzdv5T9Lda8luq0KfzHO/3Sb0FUqeeIridHVap0Ku
         V1qHfATH/SsqIH2I4DeHiweuqBhC4KrpJcLxnr6g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 313/671] coresight: catu: fix clang build warning
Date:   Thu, 16 Jan 2020 11:59:11 -0500
Message-Id: <20200116170509.12787-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 59d63de076607a9334b11628b5c3ddda1d8f56cd ]

Clang points out a syntax error, as the etr_catu_buf_ops structure is
declared 'static' before the type is known:

In file included from drivers/hwtracing/coresight/coresight-tmc-etr.c:12:
drivers/hwtracing/coresight/coresight-catu.h:116:40: warning: tentative definition of variable with internal linkage has incomplete non-array type 'const struct etr_buf_operations' [-Wtentative-definition-incomplete-type]
static const struct etr_buf_operations etr_catu_buf_ops;
                                       ^
drivers/hwtracing/coresight/coresight-catu.h:116:21: note: forward declaration of 'struct etr_buf_operations'
static const struct etr_buf_operations etr_catu_buf_ops;

This seems worth fixing in the code, so replace pointer to the empty
constant structure with a NULL pointer. We need an extra NULL pointer
check here, but the result should be better object code otherwise,
avoiding the silly empty structure.

Fixes: 434d611cddef ("coresight: catu: Plug in CATU as a backend for ETR buffer")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
[Fixed line over 80 characters]
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-catu.h    | 5 -----
 drivers/hwtracing/coresight/coresight-tmc-etr.c | 5 +++--
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-catu.h b/drivers/hwtracing/coresight/coresight-catu.h
index 1b281f0dcccc..1d2ad183fd92 100644
--- a/drivers/hwtracing/coresight/coresight-catu.h
+++ b/drivers/hwtracing/coresight/coresight-catu.h
@@ -109,11 +109,6 @@ static inline bool coresight_is_catu_device(struct coresight_device *csdev)
 	return true;
 }
 
-#ifdef CONFIG_CORESIGHT_CATU
 extern const struct etr_buf_operations etr_catu_buf_ops;
-#else
-/* Dummy declaration for the CATU ops */
-static const struct etr_buf_operations etr_catu_buf_ops;
-#endif
 
 #endif
diff --git a/drivers/hwtracing/coresight/coresight-tmc-etr.c b/drivers/hwtracing/coresight/coresight-tmc-etr.c
index 2d6f428176ff..3b684687b5a7 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etr.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etr.c
@@ -747,7 +747,8 @@ static inline void tmc_etr_disable_catu(struct tmc_drvdata *drvdata)
 static const struct etr_buf_operations *etr_buf_ops[] = {
 	[ETR_MODE_FLAT] = &etr_flat_buf_ops,
 	[ETR_MODE_ETR_SG] = &etr_sg_buf_ops,
-	[ETR_MODE_CATU] = &etr_catu_buf_ops,
+	[ETR_MODE_CATU] = IS_ENABLED(CONFIG_CORESIGHT_CATU)
+						? &etr_catu_buf_ops : NULL,
 };
 
 static inline int tmc_etr_mode_alloc_buf(int mode,
@@ -761,7 +762,7 @@ static inline int tmc_etr_mode_alloc_buf(int mode,
 	case ETR_MODE_FLAT:
 	case ETR_MODE_ETR_SG:
 	case ETR_MODE_CATU:
-		if (etr_buf_ops[mode]->alloc)
+		if (etr_buf_ops[mode] && etr_buf_ops[mode]->alloc)
 			rc = etr_buf_ops[mode]->alloc(drvdata, etr_buf,
 						      node, pages);
 		if (!rc)
-- 
2.20.1


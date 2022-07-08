Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C608256B542
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 11:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236956AbiGHJTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 05:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237594AbiGHJTx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 05:19:53 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00372B275
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 02:19:51 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id n10so4390313wrc.4
        for <stable@vger.kernel.org>; Fri, 08 Jul 2022 02:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PptGorTxjueK0BkpVkd4NY/mKFPaLMQm6cTbjHqcrCE=;
        b=SHTU0z8s/x67zbarXNuW2mDWM561kcaRaygDJ4oSRjSCV/zaKc5TJOgOCQlLwBgdBf
         4sOUniqCTUuXD/7qNpEfcogaZljao5lviAo86VkoMi8Viag4HamiRVhuMSENoiJurKF7
         Hum7JIYIi3tW6qk9RvKYHtIG/HA3X6BVpfEGKXpkbYbq7HCqXXhXviSOWouZCyRG23rc
         LJKOg2Or9BSYPHf2Rl7X5udN8yEED8Q4eZBtgrUwAUkcio0Wc+9mfruLAivgIekd/D1c
         fLsw6HkFPY8vuhYrrso+xSK5FFrTTz71qE2kevQptWyNF3iiRSyw1VDUmQMo2R19XEBo
         QnkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PptGorTxjueK0BkpVkd4NY/mKFPaLMQm6cTbjHqcrCE=;
        b=oQg3IWhHFeNlUft6Uniok8o3Utz+KD2/218lMu1ezWYN9jgJF7h1jf3encIOshL/Ar
         5tKUEJX5qS79kzWfOr3orFde7Smdt6734PDqZUhNSurRFE/F0umreAfsOXUcdQhYESmY
         pZhHrHH/ARl7wTrvm6VaCmK/UC/Y27mLD8GEAx5EU6EaHZOqFoWRHr75UKl6uwMau/zv
         ubWX7kyVx40hwnyr3BjLJaP8aAoOUsXBD0oMaNVRz6tyA3aLLBWqTriTkqSNm7FRIKtL
         c7tVMvEwZYzG1B272d1ke19DdrwNyRnXOZVYu+igxZnleFec/6rdnMcf8g5qgcLYVzqJ
         UEmw==
X-Gm-Message-State: AJIora92AkscgH0f00Cic7HgfvE5rYiBICr6WtE+5omGUZm3xHNTKSE/
        xgImyA+JmdOVI4I+GmJh7GyWoA==
X-Google-Smtp-Source: AGRyM1uWv/iV+kj/F3IZZvcq3KKQwo17/HCdoCPv6stWzqiggs21mnV4sgPoJvMFYTSDJUxj4Cs/Sg==
X-Received: by 2002:a5d:4d0b:0:b0:21d:819e:5765 with SMTP id z11-20020a5d4d0b000000b0021d819e5765mr2271137wrt.232.1657271990382;
        Fri, 08 Jul 2022 02:19:50 -0700 (PDT)
Received: from srini-hackbase.lan (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.gmail.com with ESMTPSA id ba15-20020a0560001c0f00b0021bae66362esm37943490wrb.58.2022.07.08.02.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 02:19:49 -0700 (PDT)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     vkoul@kernel.org
Cc:     yung-chuan.liao@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, alsa-devel@alsa-project.org,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] soundwire: qcom: fix max auto-enumeration devices
Date:   Fri,  8 Jul 2022 10:19:47 +0100
Message-Id: <20220708091947.5610-1-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Controller only supports up to max of 1-11 device ids via auto-enumeration,
and it has only those many registers.

In the existing code, we can protentially cross this boundary and read incorrect
registers.

Cc: stable@vger.kernel.org
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: a6e6581942ca ("soundwire: qcom: add auto enumeration support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
Thanks to Dan for reporting an overflow issue, which turned out to be
another issue, where we could read registers that do not belong to
auto-enumeration devid.
Either way this fixes both issues, one reported by Dan and other
incorrect register access.

Thanks,
Srini

 drivers/soundwire/qcom.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
index 9df970eeca45..dd1365a44458 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -119,6 +119,8 @@
 #define MAX_FIFO_RD_RETRY 3
 #define SWR_OVERFLOW_RETRY_COUNT 30
 #define SWRM_LINK_STATUS_RETRY_CNT 100
+/* devid 1 - 11 */
+#define SWRM_MAX_AUTO_ENUM_DEVICES	11
 
 enum {
 	MASTER_ID_WSA = 1,
@@ -479,7 +481,7 @@ static int qcom_swrm_enumerate(struct sdw_bus *bus)
 	int i;
 	char *buf1 = (char *)&val1, *buf2 = (char *)&val2;
 
-	for (i = 1; i <= SDW_MAX_DEVICES; i++) {
+	for (i = 1; i <= SWRM_MAX_AUTO_ENUM_DEVICES; i++) {
 		/* do not continue if the status is Not Present  */
 		if (!ctrl->status[i])
 			continue;
-- 
2.25.1


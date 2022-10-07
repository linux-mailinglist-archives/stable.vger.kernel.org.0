Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE305F7D74
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 20:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiJGShM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 14:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiJGShL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 14:37:11 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0CE3056A
        for <stable@vger.kernel.org>; Fri,  7 Oct 2022 11:37:11 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id v186so5604058pfv.11
        for <stable@vger.kernel.org>; Fri, 07 Oct 2022 11:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8YFBjhQwnQmAiDW8abu9G0FtK8V2MZOwtPyAAcWx5QI=;
        b=X7KyRfk8JUEn7w8LC/ty3NJbOtACw8DUqzRIIt0WQ6FSPvRndJgdgH9VtSlWn/c+bo
         7ci8OaY+pQ/ah6dVLZ2NgO6EunFor+aYezmT8fA6QiGNgleDLTuTiBcKD/h7l64QPwfP
         RB7Rg8toxJtJKh43XeIxAeKVL7u1cQZ2EaJ1c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8YFBjhQwnQmAiDW8abu9G0FtK8V2MZOwtPyAAcWx5QI=;
        b=p/xXQfSUrnId6sfpAzWMESI4BN68FqFpD7X+q8+o/HDf/Zad74PT2+gEV2ELdeyVd0
         T7dpgu38gbegmjnY9frzEwYQpfuvvfmL0jiJFyFZKNyQ+6Jnzjf1HIyfKgU2KHzeJmcY
         iLIKknI2FgWUcj1Kspys7NdnzhqYqR1CGtFWI0PmktqAh+fiO44HnFtN6kxXOrxDyzmn
         9GOJC1TOI7CmifBQBIkpXwtbWW/Si4X6miV2Vk7eiqN6WBn9K4eYmoO8IztylHB5BW4y
         gbwAUcct4v/lQl9wSfDxOB3EUVdN0MjMAE3beVjnZ/QFAC/lCVUtpXJF/FQCRYSQjmUy
         Yufg==
X-Gm-Message-State: ACrzQf1JQ+XRI6FnnQvZ6gHmPTXMnYLNeXa0/lSA1L7DbgFmbQBQoMOF
        2rg/G5wDJ6ojOwVbP9yr3Kq2U+VXAckWcg==
X-Google-Smtp-Source: AMsMyM7gJW/sVQSveB00s9Qp0ixmgfgnp2i73jJLD0IzvRpdmYgzLwCEffC7Wy5yxRIYxR/w0x9yiA==
X-Received: by 2002:a05:6a00:114c:b0:528:2c7a:6302 with SMTP id b12-20020a056a00114c00b005282c7a6302mr6550926pfm.37.1665167830194;
        Fri, 07 Oct 2022 11:37:10 -0700 (PDT)
Received: from localhost ([2620:15c:9d:2:70f:fd22:577c:8b7d])
        by smtp.gmail.com with UTF8SMTPSA id c12-20020a17090a4d0c00b001f559e00473sm4898017pjg.43.2022.10.07.11.37.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Oct 2022 11:37:09 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [5.19.y PATCH 2/2] mmc: core: Terminate infinite loop in SD-UHS voltage switch
Date:   Fri,  7 Oct 2022 11:36:47 -0700
Message-Id: <20221007183647.2775030-2-briannorris@chromium.org>
X-Mailer: git-send-email 2.38.0.rc2.412.g84df46c1b4-goog
In-Reply-To: <20221007183647.2775030-1-briannorris@chromium.org>
References: <20221007183647.2775030-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e9233917a7e53980664efbc565888163c0a33c3f upstream.

This loop intends to retry a max of 10 times, with some implicit
termination based on the SD_{R,}OCR_S18A bit. Unfortunately, the
termination condition depends on the value reported by the SD card
(*rocr), which may or may not correctly reflect what we asked it to do.

Needless to say, it's not wise to rely on the card doing what we expect;
we should at least terminate the loop regardless. So, check both the
input and output values, so we ensure we will terminate regardless of
the SD card behavior.

Note that SDIO learned a similar retry loop in commit 0797e5f1453b
("mmc: core: Fixup signal voltage switch"), but that used the 'ocr'
result, and so the current pre-terminating condition looks like:

    rocr & ocr & R4_18V_PRESENT

(i.e., it doesn't have the same bug.)

This addresses a number of crash reports seen on ChromeOS that look
like the following:

    ... // lots of repeated: ...
    <4>[13142.846061] mmc1: Skipping voltage switch
    <4>[13143.406087] mmc1: Skipping voltage switch
    <4>[13143.964724] mmc1: Skipping voltage switch
    <4>[13144.526089] mmc1: Skipping voltage switch
    <4>[13145.086088] mmc1: Skipping voltage switch
    <4>[13145.645941] mmc1: Skipping voltage switch
    <3>[13146.153969] INFO: task halt:30352 blocked for more than 122 seconds.
    ...

Fixes: f2119df6b764 ("mmc: sd: add support for signal voltage switch procedure")
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20220914014010.2076169-1-briannorris@chromium.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
Should also apply cleanly to 4.14.y and newer.

 drivers/mmc/core/sd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 3f331ae0a129..21bfe3448dec 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -870,7 +870,8 @@ int mmc_sd_get_cid(struct mmc_host *host, u32 ocr, u32 *cid, u32 *rocr)
 	 * the CCS bit is set as well. We deliberately deviate from the spec in
 	 * regards to this, which allows UHS-I to be supported for SDSC cards.
 	 */
-	if (!mmc_host_is_spi(host) && rocr && (*rocr & SD_ROCR_S18A)) {
+	if (!mmc_host_is_spi(host) && (ocr & SD_OCR_S18R) &&
+	    rocr && (*rocr & SD_ROCR_S18A)) {
 		err = mmc_set_uhs_voltage(host, pocr);
 		if (err == -EAGAIN) {
 			retries--;
-- 
2.38.0.rc2.412.g84df46c1b4-goog


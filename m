Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78435F7D73
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 20:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiJGShI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 14:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJGShH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 14:37:07 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401933056A
        for <stable@vger.kernel.org>; Fri,  7 Oct 2022 11:37:06 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y8so5596833pfp.13
        for <stable@vger.kernel.org>; Fri, 07 Oct 2022 11:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=05qDuJ+1jR2jBT/c8cjavw3zHGfNDcV93qKEAoWzeyI=;
        b=Rc2P0toDBCVdOO+cRU372LBYIx0D+t0FRt1PHgd18pvTUEKZ4SdRRk3kmdTUB/UCIZ
         9MJfnvpSIH1oWigW10LtM11/OH4v/5dnUkA8bxf8jCP4fYLK3KmsAv9Dpa0dNv7Za6z3
         gwA0mTHi/4KwvEd4qPQBIyiJlfyRzmnq8k/sA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=05qDuJ+1jR2jBT/c8cjavw3zHGfNDcV93qKEAoWzeyI=;
        b=xIbzqTCvMfWnRpoVq1i1eNu7LcEMIBYepV7PT3iuT7reysJm99YnN95CfIV0f7cZC8
         tdkVSMbUmIM/K8om4bd49Hy/58RZTZWxTIJfToYoN6UQqCc/U3qy+Phj1tAbY2Iv4Ka6
         RBvTZLNKcCkNbKlyypfHQ7YPMVTiduglpMyXPt20d86n3gWzgiD3l7MR02UQTCJMr6t1
         gO0Q+N9zJV6GS8Ssko8EUDWb7mnxQlFPLvMJdj2/OPjYlHvVUz+S94KKCeeel+0vqacS
         DoP4vOmr44ZJQeNYsLVkQVVqI6Oh4kFWlC3uPrjFGdp8WxvcqKYH99E3dIW61/5fuWLU
         xcEg==
X-Gm-Message-State: ACrzQf3UuXDC7ag5UmwUhboCphCcvTPP/mig/COgSSpnqBb1pcpr0bdt
        Z4sugwu0we5Qjh80FQ0J8ocNeVJnO8LrIQ==
X-Google-Smtp-Source: AMsMyM4e1V/S542NFohAuWrK4uC/pENH/s3mQwwoAEbMtURY4qZwblzVawfLqUoZrFQ9Z4TJVd7acg==
X-Received: by 2002:a63:db42:0:b0:45c:9c73:d72e with SMTP id x2-20020a63db42000000b0045c9c73d72emr5566910pgi.181.1665167825260;
        Fri, 07 Oct 2022 11:37:05 -0700 (PDT)
Received: from localhost ([2620:15c:9d:2:70f:fd22:577c:8b7d])
        by smtp.gmail.com with UTF8SMTPSA id w2-20020a626202000000b0053e8f4a10c1sm1928659pfb.217.2022.10.07.11.37.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Oct 2022 11:37:04 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [5.19.y PATCH 1/2] mmc: core: Replace with already defined values for readability
Date:   Fri,  7 Oct 2022 11:36:46 -0700
Message-Id: <20221007183647.2775030-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.38.0.rc2.412.g84df46c1b4-goog
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

From: ChanWoo Lee <cw9316.lee@samsung.com>

commit e427266460826bea21b70f9b2bb29decfb2c2620 upstream.

SD_ROCR_S18A is already defined and is used to check the rocr value, so
let's replace with already defined values for readability.

Signed-off-by: ChanWoo Lee <cw9316.lee@samsung.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220706004840.24812-1-cw9316.lee@samsung.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
Included to make subsequent cherry-pick cleaner and easier to read.
Should also apply cleanly to 4.14.y and newer.

 drivers/mmc/core/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 5e4e2d2182d9..3f331ae0a129 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -870,7 +870,7 @@ int mmc_sd_get_cid(struct mmc_host *host, u32 ocr, u32 *cid, u32 *rocr)
 	 * the CCS bit is set as well. We deliberately deviate from the spec in
 	 * regards to this, which allows UHS-I to be supported for SDSC cards.
 	 */
-	if (!mmc_host_is_spi(host) && rocr && (*rocr & 0x01000000)) {
+	if (!mmc_host_is_spi(host) && rocr && (*rocr & SD_ROCR_S18A)) {
 		err = mmc_set_uhs_voltage(host, pocr);
 		if (err == -EAGAIN) {
 			retries--;
-- 
2.38.0.rc2.412.g84df46c1b4-goog


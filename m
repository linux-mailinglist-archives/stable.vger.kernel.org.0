Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF9450CDE7
	for <lists+stable@lfdr.de>; Sun, 24 Apr 2022 00:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237279AbiDWWTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Apr 2022 18:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiDWWTe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Apr 2022 18:19:34 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3C614DEA4;
        Sat, 23 Apr 2022 15:16:35 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id ks6so22816992ejb.1;
        Sat, 23 Apr 2022 15:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SeT9VKBABGE3+M59+/LdCRTy+y0q+UOFIghRmJw7JEU=;
        b=ghEvrTo/Mw/dGr730gI9vebowZJO7rKTe/+ShB6UWGyegdMld1T8uMV4Je5P9dfyw2
         FF0/6gg7Pq8QIUkYjBJaAQToDMVr6y4Lk1yxvod3bAS+Z+yeSYR0mkj1Ai1qNYJLf23P
         0Cl7H1phs9RQtEd6La3Pjydygqw1rO1bvXGsopDhNMx1mBVK1s7ZPA/ebq/SQNddFPzN
         YjDBj+/wdKcy/GbiazuxWlDGrXea9t7I+Runba6n1mF7NYeuABbsjkM0x6tOFQ8/0D03
         UbciJXa8UhsSA5BC/dFwoJQmOpQ7+/wtz/zu7SDUka5/NlXyHhQMQVPIdW2Zg4BDBBPI
         OSpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SeT9VKBABGE3+M59+/LdCRTy+y0q+UOFIghRmJw7JEU=;
        b=bmGBOJH/lc/gwK4IRA/YMT63SDG3Xo24+OzlPIAT7O2UQpqKyYlv/hQceUTvYA1uHU
         zxOhRsVOVgXZLlXuwlFk64NxyiBoQw91Q2On7CUwKa4Um4oHA8xvobAton4fbIh+7KDn
         /AAIYjttwqHprdduPSoeagS/A+9OKRLhMCtGQg1F3lvk9yDgGRUEiTuxs9AH6PqSm+vz
         oOy8NW9mslWfm+vDamBgYviH0v07ZdmRjjqX2/OrkZI06Z14PeCf3/mszF6gpe1Bdgez
         O4HhMocc+u2VdlfvBbYvbM6nb7FJlHMn5wbBz2cvwTR2QYha2rd75dSHO64gys9K1Cp4
         55hA==
X-Gm-Message-State: AOAM5327vzHFSRnN4QsAISBeWtJ9+j6BOTuaFtCdDRFLavwTM42JdEeR
        XCYQ0xRg53w5QaQTxON1Bt8=
X-Google-Smtp-Source: ABdhPJwhbEa7xhj18dQkE7o4UxIXO6J5D9LIESZfSOfibr5uduO1+Zize1piovEhzJALerxZ5LhLoA==
X-Received: by 2002:a17:906:c0d6:b0:6ca:457e:f1b7 with SMTP id bn22-20020a170906c0d600b006ca457ef1b7mr9540974ejb.399.1650752194502;
        Sat, 23 Apr 2022 15:16:34 -0700 (PDT)
Received: from linux.. (p5dd1ed70.dip0.t-ipconnect.de. [93.209.237.112])
        by smtp.gmail.com with ESMTPSA id s1-20020a056402036100b004240a3fc6b4sm2669484edw.82.2022.04.23.15.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 15:16:34 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     ulf.hansson@linaro.org, adrian.hunter@intel.com,
        linus.walleij@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     beanhuo@micron.com, stable <stable@vger.kernel.org>
Subject: [PATCH v1 2/2] mmc: core: Allows to override the timeout value for ioctl() path
Date:   Sun, 24 Apr 2022 00:16:23 +0200
Message-Id: <20220423221623.1074556-3-huobean@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220423221623.1074556-1-huobean@gmail.com>
References: <20220423221623.1074556-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Occasionally, user-land applications initiate longer timeout values for certain commands
through ioctl() system call. But so far we are still using a fixed timeout of 10 seconds
in mmc_poll_for_busy() on the ioctl() path, even if a custom timeout is specified in the
userspace application. This patch allows custom timeout values to override this default
timeout values on the ioctl path.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/mmc/core/block.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index b35e7a95798b..6cb701aa1abc 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -609,11 +609,11 @@ static int __mmc_blk_ioctl_cmd(struct mmc_card *card, struct mmc_blk_data *md,
 
 	if (idata->rpmb || (cmd.flags & MMC_RSP_R1B) == MMC_RSP_R1B) {
 		/*
-		 * Ensure RPMB/R1B command has completed by polling CMD13
-		 * "Send Status".
+		 * Ensure RPMB/R1B command has completed by polling CMD13 "Send Status". Here we
+		 * allow to override the default timeout value if a custom timeout is specified.
 		 */
-		err = mmc_poll_for_busy(card, MMC_BLK_TIMEOUT_MS, false,
-					MMC_BUSY_IO);
+		err = mmc_poll_for_busy(card, idata->ic.cmd_timeout_ms ? : MMC_BLK_TIMEOUT_MS,
+					false, MMC_BUSY_IO);
 	}
 
 	return err;
-- 
2.34.1


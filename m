Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE5F52AA15
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 20:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348825AbiEQSJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 14:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351893AbiEQSJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 14:09:18 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D256F50B0E;
        Tue, 17 May 2022 11:09:16 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id l14so7216891pjk.2;
        Tue, 17 May 2022 11:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NitEEt9lv1RnCtUE5yy6vc9OX+05AmwrbwfqCcJlYBk=;
        b=ddOkwGZtVLkZdLmz8EEVVJzO0uzs3q6uSMLh1vbMAC4Urd7qA5pF3i4eEpPv13EVkD
         SZA+g4ti400dVFWQZ/ucVPllkDgaVgpcINgA5L6ym5twcm3/KSWwC5sLYUind52LLEd2
         1yOyoOvwaTnzc5qGym812TsKBuBg7mMVlDIHXkzzGpoSjERzcNwcZYtvLox0gxBrg7na
         Fh0/+NLKmrY7DaeGrTOsxRODeqTf5AZwAKb4WoFMhPGIE+bZODajYQR7XOJdkZG+PaO+
         8ZVFNCNDlwQQglkgu7B8RBnVNHu/tXGGrMB/yPznZGXpiuGOqN5fzmcUCO8Meg7hHsWO
         FBFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NitEEt9lv1RnCtUE5yy6vc9OX+05AmwrbwfqCcJlYBk=;
        b=75iByfTpxL57gqJNk3Gke/uUNT4/0qKpgV2wNM1JFWPhoD4KEoUn3N/HLD1zaAtgFt
         AvgnvxXu08mJdunspcKoiGb6rf9dZKTixElnAEO0LMszk/KnBa/cC502T8jdSR0ZbG1W
         N0BF++AVSlIAzt8kYvgFKgwMMdeUHu3L1xWPw7x6mXl8yezGmlNzXu3NAuAaOk+pYSpH
         0OUs7rO9GQOsu7QlgiNsVGQ7SOGBYSvHV4o6Y2pnvgK+IlDbRZ2OJrhoTEPmjU7zTDQF
         Qh/buurU9YRsmtGKGo1RsG02MjAh8ETLO3sMquIEzgATav9UtkDad8wfsIbkl9sa8xyd
         rWpw==
X-Gm-Message-State: AOAM530AZYW2hBrNZdyrUZeQJ/C0Mj/yenVOTzVGarF2/0vkuGTHh3GK
        dQkWzY4B4cRLPkfenjMgffQLCOvgHZc=
X-Google-Smtp-Source: ABdhPJxMRn66HsCjJwUG2dqVSdWDnit4HAxDSUO5nQ/2ICFqyl+Gysm4q0ec6mOzd+391d8LHyMsaw==
X-Received: by 2002:a17:90b:120c:b0:1df:3fb3:3565 with SMTP id gl12-20020a17090b120c00b001df3fb33565mr14526958pjb.106.1652810955809;
        Tue, 17 May 2022 11:09:15 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i5-20020a056a00224500b0050dc7628160sm46854pfu.58.2022.05.17.11.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 11:09:15 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Nishad Kamdar <nishadkamdar@gmail.com>,
        =?UTF-8?q?Christian=20L=C3=B6hle?= <CLoehle@hyperstone.com>,
        linux-mmc@vger.kernel.org (open list:MULTIMEDIA CARD (MMC), SECURE
        DIGITAL (SD) AND...), linux-kernel@vger.kernel.org (open list),
        alcooperx@gmail.com, kdasu.kdev@gmail.com
Subject: [PATCH stable 5.4 1/3] mmc: core: Specify timeouts for BKOPS and CACHE_FLUSH for eMMC
Date:   Tue, 17 May 2022 11:09:09 -0700
Message-Id: <20220517180911.246016-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220517180911.246016-1-f.fainelli@gmail.com>
References: <20220517180911.246016-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 24ed3bd01d6a844fd5e8a75f48d0a3d10ed71bf9 upstream

The timeout values used while waiting for a CMD6 for BKOPS or a CACHE_FLUSH
to complete, are not defined by the eMMC spec. However, a timeout of 10
minutes as is currently being used, is just silly for both of these cases.
Instead, let's specify more reasonable timeouts, 120s for BKOPS and 30s for
CACHE_FLUSH.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20200122142747.5690-2-ulf.hansson@linaro.org
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/mmc/core/mmc_ops.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 09311c2bd858..d8f419183144 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -19,7 +19,9 @@
 #include "host.h"
 #include "mmc_ops.h"
 
-#define MMC_OPS_TIMEOUT_MS	(10 * 60 * 1000) /* 10 minute timeout */
+#define MMC_OPS_TIMEOUT_MS		(10 * 60 * 1000) /* 10min*/
+#define MMC_BKOPS_TIMEOUT_MS		(120 * 1000) /* 120s */
+#define MMC_CACHE_FLUSH_TIMEOUT_MS	(30 * 1000) /* 30s */
 
 static const u8 tuning_blk_pattern_4bit[] = {
 	0xff, 0x0f, 0xff, 0x00, 0xff, 0xcc, 0xc3, 0xcc,
@@ -943,7 +945,7 @@ void mmc_run_bkops(struct mmc_card *card)
 	 * urgent levels by using an asynchronous background task, when idle.
 	 */
 	err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
-			EXT_CSD_BKOPS_START, 1, MMC_OPS_TIMEOUT_MS);
+			 EXT_CSD_BKOPS_START, 1, MMC_BKOPS_TIMEOUT_MS);
 	if (err)
 		pr_warn("%s: Error %d starting bkops\n",
 			mmc_hostname(card->host), err);
@@ -961,7 +963,8 @@ int mmc_flush_cache(struct mmc_card *card)
 
 	if (mmc_cache_enabled(card->host)) {
 		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
-				EXT_CSD_FLUSH_CACHE, 1, 0);
+				 EXT_CSD_FLUSH_CACHE, 1,
+				 MMC_CACHE_FLUSH_TIMEOUT_MS);
 		if (err)
 			pr_err("%s: cache flush error %d\n",
 					mmc_hostname(card->host), err);
-- 
2.25.1


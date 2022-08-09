Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11AB58E055
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 21:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242143AbiHITk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 15:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242433AbiHITkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 15:40:04 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CDE2559D
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 12:40:02 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id u24so1900181qku.2
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 12:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WQADmAbbPY4UNq4TbQtJ0wmwYjKdHy+t7oPSx2knkGw=;
        b=T3xk/rfIHpnSaArGMKToaLTdDcPztKs73hwbF/4oilTSRO/u+Y5EH66x921BEN+iwS
         n8Efv/cl0XGLh75r3nPSGiSRcCWOIMa4+iO2L2boSNmbA+An9VwgOdQ57BecRqDId3cr
         93aVbwUsrAk/jVP3NrBx8OlA8Som+xmHbXQmc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WQADmAbbPY4UNq4TbQtJ0wmwYjKdHy+t7oPSx2knkGw=;
        b=JbAbY1X8XxDmf+3eXGrle0hDdrsvaB9hk1ojsdPYupbfRzquYiN01IaGRjqlj4UaZG
         nz4SPguOQDpX8vd20l98S3Qg2tb4J3sTx7mizH4Y1bp/YTWNtW4RN7VolDApCElKRlvz
         xgFa+Q+vAlVwsjxsiL/fqzm5YnDRGmlZhq6uZZyo3XcsbpTPzoMkIOyPdIR1559gWcTX
         nE6fHMC9Bqd/j0p4fOY4ACrMF98mI8MxW1Rtu6pG9PoEf46C/ExlymJXiFwsO3OLLbIg
         1zaJW1k/R0PwfSpzUYdF0cl38DHTq3NXbkLBE790ZQcfPPoW8zP2TiVmseme3SILGNE1
         eA+A==
X-Gm-Message-State: ACgBeo3DviQvkDZCl4DbVCxnn+qymUYxbAvdwoDzlw9YuKx6ojUsDoqz
        BM4TjJ61MRSjUi3SKaqFhSFjLg==
X-Google-Smtp-Source: AA6agR7cXDV8AmvlDfc//mvJvsYopYmTCb0ttOe0pPue0GVYpv844ghBL+zy5oP8hZjjn1KCc1w4aQ==
X-Received: by 2002:a05:620a:c4f:b0:6b8:ea30:2d4a with SMTP id u15-20020a05620a0c4f00b006b8ea302d4amr18690230qki.717.1660074001883;
        Tue, 09 Aug 2022 12:40:01 -0700 (PDT)
Received: from trappist.c.googlers.com.com (128.174.85.34.bc.googleusercontent.com. [34.85.174.128])
        by smtp.gmail.com with ESMTPSA id w19-20020a05620a445300b006b9264191b5sm9562422qkp.32.2022.08.09.12.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 12:40:01 -0700 (PDT)
From:   Sven van Ashbrook <svenva@chromium.org>
To:     Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Hao Wu <hao.wu@rubrik.com>,
        Yi Chou <yich@google.com>,
        Andrey Pronin <apronin@chromium.org>,
        Sven van Ashbrook <svenva@chromium.org>,
        James Morris <james.morris@microsoft.com>
Cc:     stable@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tpm: fix potential race condition in suspend/resume
Date:   Tue,  9 Aug 2022 19:39:18 +0000
Message-Id: <20220809193921.544546-1-svenva@chromium.org>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Concurrent accesses to the tpm chip are prevented by allowing only a
single thread at a time to obtain a tpm chip reference through
tpm_try_get_ops(). However, the tpm's suspend function does not use
this mechanism, so when the tpm api is called by a kthread which
does not get frozen on suspend (such as the hw_random kthread)
it's possible that the tpm is used when already in suspend, or
in use while in the process of suspending.

This is seen on certain ChromeOS platforms - low-probability warnings
are generated during suspend. In this case, the tpm attempted to read data
from a tpm chip on an already-suspended bus.

  i2c_designware i2c_designware.1: Transfer while suspended

Fix:
1. prevent concurrent execution of tpm accesses and suspend/
   resume, by letting suspend/resume grab the tpm_mutex.
2. before commencing a tpm access, check if the tpm chip is already
   suspended. Fail with -EAGAIN if so.

Tested by running 6000 suspend/resume cycles back-to-back on a
ChromeOS "brya" device. The intermittent warnings reliably
disappear after applying this patch. No system issues were observed.

Cc: <stable@vger.kernel.org>
Fixes: e891db1a18bf ("tpm: turn on TPM on suspend for TPM 1.x")
Signed-off-by: Sven van Ashbrook <svenva@chromium.org>
---
 drivers/char/tpm/tpm-interface.c | 16 ++++++++++++++++
 include/linux/tpm.h              |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 1621ce818705..16ca490fd483 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -82,6 +82,11 @@ static ssize_t tpm_try_transmit(struct tpm_chip *chip, void *buf, size_t bufsiz)
 		return -E2BIG;
 	}
 
+	if (chip->is_suspended) {
+		dev_info(&chip->dev, "blocking transmit while suspended\n");
+		return -EAGAIN;
+	}
+
 	rc = chip->ops->send(chip, buf, count);
 	if (rc < 0) {
 		if (rc != -EPIPE)
@@ -394,6 +399,8 @@ int tpm_pm_suspend(struct device *dev)
 	if (!chip)
 		return -ENODEV;
 
+	mutex_lock(&chip->tpm_mutex);
+
 	if (chip->flags & TPM_CHIP_FLAG_ALWAYS_POWERED)
 		goto suspended;
 
@@ -411,6 +418,11 @@ int tpm_pm_suspend(struct device *dev)
 	}
 
 suspended:
+	if (!rc)
+		chip->is_suspended = true;
+
+	mutex_unlock(&chip->tpm_mutex);
+
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_pm_suspend);
@@ -426,6 +438,10 @@ int tpm_pm_resume(struct device *dev)
 	if (chip == NULL)
 		return -ENODEV;
 
+	mutex_lock(&chip->tpm_mutex);
+	chip->is_suspended = false;
+	mutex_unlock(&chip->tpm_mutex);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_pm_resume);
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index d7c67581929f..0fbc1a43ae80 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -131,6 +131,8 @@ struct tpm_chip {
 	int dev_num;		/* /dev/tpm# */
 	unsigned long is_open;	/* only one allowed */
 
+	bool is_suspended;
+
 	char hwrng_name[64];
 	struct hwrng hwrng;
 
-- 
2.37.1.559.g78731f0fdb-goog


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 229A47B43D
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 22:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387406AbfG3USk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 16:18:40 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34893 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387404AbfG3USk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 16:18:40 -0400
Received: by mail-pg1-f196.google.com with SMTP id s1so24328918pgr.2
        for <stable@vger.kernel.org>; Tue, 30 Jul 2019 13:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YXz01j4waUR9S2dYNnIz43Uiq6rONVnlIbBbZzfOuUA=;
        b=odc+UOlhJnRO633CxarMMpCJa3K7nn7sPN4vo/zMMwvZ3Sqe94dwoiHJBYQ9sLFnr/
         61FpfXknIovUl6N0CHObjFBbx7RjW3Q4ZQDusXaIv8/6uamu2tnkPy7BuE6x6yK68q7t
         WWtqnJzNLBKc5d/kJvE9OhggrO2vJgJBFTTEZAmBWkpkCvEFoEbYQ7v/PGuPaK7JwXr+
         dW3wlm8DfEN1akhMKJlovSX0yoa4e+sfWCTGwMxE8G87Gh1uyRVy9hH3RNXfyYLn/u9e
         JHfeDdJSriTUDABzv2BFEGIcMXfp4QUoQeYNd44qNlrN7YYgOcWEhsiW1vJWGpIDgoKt
         MIdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YXz01j4waUR9S2dYNnIz43Uiq6rONVnlIbBbZzfOuUA=;
        b=rNP9e3AHq1OWIyTCrX6Fl/HJ+klnfr7khxe1QA/VHs8JooICyb2PRuEDUk1tLVT8Zl
         X3NzNQWXC/MNSq87/lX6lEJrdGssak+u+WWW3U2yaqy484zIVDpgbLFnZiFc5q6zL7FX
         C5fef/qybPIdZLfc9AWElp2vbUiD1URoJjuQ4qFShl/DDaeZI18i6gDuFjFAAP4kiu5P
         WiZIaSAxUd1MdXSW/2IQtwh9SmMCEhYMB7ABibDV1SyOGgoGm2JHQQgOPhZRiSwaP+jk
         Ul4UL2akOEwR422WSLlv5PyjeDnBZJyyg2Z/miZON1osIctC7WxO0m3ZpOmEE1VQ3zwd
         iOqQ==
X-Gm-Message-State: APjAAAVQSJkK+eDIo3ooMUlmNTl5Soj5/KF0IQdP54hEcVUMHG+eSKDv
        RcI70dqLRjUIMcQxSzOQkpPT7Q==
X-Google-Smtp-Source: APXvYqxcEjzBikVqKeDzpCKoypwdQuYZZB22f/+VWVDsgVgZMiGXhYSTn9dznLTyossw/1nmuDmSLQ==
X-Received: by 2002:a17:90a:29c5:: with SMTP id h63mr113755109pjd.83.1564517919987;
        Tue, 30 Jul 2019 13:18:39 -0700 (PDT)
Received: from localhost.localdomain ([49.207.49.136])
        by smtp.gmail.com with ESMTPSA id r75sm88113177pfc.18.2019.07.30.13.18.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 30 Jul 2019 13:18:39 -0700 (PDT)
From:   Amit Pundir <amit.pundir@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Stable <stable@vger.kernel.org>,
        Abhishek Sahu <absahu@codeaurora.org>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH for-4.14.y 2/3] i2c: qup: fixed releasing dma without flush operation completion
Date:   Wed, 31 Jul 2019 01:48:32 +0530
Message-Id: <1564517913-17164-2-git-send-email-amit.pundir@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564517913-17164-1-git-send-email-amit.pundir@linaro.org>
References: <1564517913-17164-1-git-send-email-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhishek Sahu <absahu@codeaurora.org>

commit 7239872fb3400b21a8f5547257f9f86455867bd6 upstream.

The QUP BSLP BAM generates the following error sometimes if the
current I2C DMA transfer fails and the flush operation has been
scheduled

    “bam-dma-engine 7884000.dma: Cannot free busy channel”

If any I2C error comes during BAM DMA transfer, then the QUP I2C
interrupt will be generated and the flush operation will be
carried out to make I2C consume all scheduled DMA transfer.
Currently, the same completion structure is being used for BAM
transfer which has already completed without reinit. It will make
flush operation wait_for_completion_timeout completed immediately
and will proceed for freeing the DMA resources where the
descriptors are still in process.

Signed-off-by: Abhishek Sahu <absahu@codeaurora.org>
Acked-by: Sricharan R <sricharan@codeaurora.org>
Reviewed-by: Austin Christ <austinwc@codeaurora.org>
Reviewed-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
Cherry-picked from lede/openwrt tree
https://git.lede-project.org/?p=source.git.
Build tested for ARCH=arm64 + defconfig

It is part of a clean-up series but it holds
good on it's own as well. I think.
https://patchwork.ozlabs.org/cover/868855/

Cleanly apply on 4.9.y as well but since
lede stopped supporting v4.9.y, I'm not
sure if this patch is tested on v4.9.y at all.

 drivers/i2c/busses/i2c-qup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i2c/busses/i2c-qup.c b/drivers/i2c/busses/i2c-qup.c
index 08f8e0107642..8f6903ec7aec 100644
--- a/drivers/i2c/busses/i2c-qup.c
+++ b/drivers/i2c/busses/i2c-qup.c
@@ -844,6 +844,8 @@ static int qup_i2c_bam_do_xfer(struct qup_i2c_dev *qup, struct i2c_msg *msg,
 	}
 
 	if (ret || qup->bus_err || qup->qup_err) {
+		reinit_completion(&qup->xfer);
+
 		if (qup_i2c_change_state(qup, QUP_RUN_STATE)) {
 			dev_err(qup->dev, "change to run state timed out");
 			goto desc_err;
-- 
2.7.4


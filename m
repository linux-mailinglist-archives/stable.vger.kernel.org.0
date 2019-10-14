Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16296D61F0
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 14:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731719AbfJNMDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 08:03:32 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46240 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731138AbfJNMDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 08:03:32 -0400
Received: by mail-pl1-f193.google.com with SMTP id q24so7912997plr.13
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 05:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=1Ew6nvp+lIVXOTGUH+6CvvZJUmcbSc2ZNxvYMIXew0A=;
        b=gbq/HeQVGZN31YpkwxiGgPCoN0r2zdogqzMJXRrbQizFzp3Zvjk+eG3xHT2HVWlyy0
         yKoQjLIHCe0qcE5FvLMZysmpRQsx69QVdXF/tddh5HohWl0Q9NIf38blfmC7Fq1sjSB4
         Ak3m4KZd93vrdGL9HYEPKodz4Ztok0bUTTyZm+wZxQM50eY0SRrOTJ5y8sjU5rTa4x8b
         qjI0w9oaCrHmxwIQkCSGQ6VHgMZD1WhwXAtIPeAJ2dgILuIA5LDlGwYbcYJvI4X1XSxW
         Xja2s77OedE10WM4nb/YkRJYfY0zsnU21WFEINy2Vx9ymomKtOMPof4G46/fvr3Sr1tc
         Hmrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1Ew6nvp+lIVXOTGUH+6CvvZJUmcbSc2ZNxvYMIXew0A=;
        b=J73QInxaC+6fCrlyVp9kvpUALpfqn5CLJhDitF1W7DTLYWKy1JFLv5vpDfaAwZewWy
         lD4YagxBhZKNyhsDJCZFKUtDpirOhGf1tnYm4z/jNvNwpBp4FpXiEs2SAvB7w8k4XONF
         SsyI3rPoejeLY8YN4DF9KrHGkpW5l3EuYj1bbAjqssuFsc7Kh1OA1GpiHWzm6Icf0D//
         sPN90q0Vbe4JgVWBbHenERFpD6UWMRXIGhtm2Ay3Ak8WibSdMLT5Lx507Bi3jD057RMK
         lZD8VfR7uu3hu9fqwpbkYcZicjGCzu6u1Y0+cNezKBJXjRRHc5I2c4lCQnljYstz5tY7
         go3g==
X-Gm-Message-State: APjAAAW9OFsQD/wG6T1MSKJ5tae7GZye+n/tXJFRgus8ysc/L/L2TIHr
        jLAr5bkTyidRC4n/DygIaooM2Q==
X-Google-Smtp-Source: APXvYqwZdkrEAgTaWFnRP+/uhst6b4xYJs7GiVSruDMSpRCe0gbmmFgFtXUPYO/lBF0emiDvmKmAhA==
X-Received: by 2002:a17:902:9306:: with SMTP id bc6mr30065583plb.133.1571054611544;
        Mon, 14 Oct 2019 05:03:31 -0700 (PDT)
Received: from localhost.localdomain ([117.252.65.194])
        by smtp.gmail.com with ESMTPSA id q6sm25026813pgn.44.2019.10.14.05.03.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 14 Oct 2019 05:03:30 -0700 (PDT)
From:   Sumit Garg <sumit.garg@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     dsaxena@plexity.net, herbert@gondor.apana.org.au, mpm@selenic.com,
        romain.perier@free-electrons.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, daniel.thompson@linaro.org,
        ralph.siemsen@linaro.org, milan.stevanovic@se.com,
        ryan.harkin@linaro.org, linux-kernel@vger.kernel.org,
        Sumit Garg <sumit.garg@linaro.org>, stable@vger.kernel.org
Subject: [PATCH] hwrng: omap - Fix RNG wait loop timeout
Date:   Mon, 14 Oct 2019 17:32:45 +0530
Message-Id: <1571054565-6991-1-git-send-email-sumit.garg@linaro.org>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Existing RNG data read timeout is 200us but it doesn't cover EIP76 RNG
data rate which takes approx. 700us to produce 16 bytes of output data
as per testing results. So configure the timeout as 1000us to also take
account of lack of udelay()'s reliability.

Fixes: 383212425c92 ("hwrng: omap - Add device variant for SafeXcel IP-76 found in Armada 8K")
Cc: <stable@vger.kernel.org>
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
---
 drivers/char/hw_random/omap-rng.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index b27f396..e329f82 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -66,6 +66,13 @@
 #define OMAP4_RNG_OUTPUT_SIZE			0x8
 #define EIP76_RNG_OUTPUT_SIZE			0x10
 
+/*
+ * EIP76 RNG takes approx. 700us to produce 16 bytes of output data
+ * as per testing results. And to account for the lack of udelay()'s
+ * reliability, we keep the timeout as 1000us.
+ */
+#define RNG_DATA_FILL_TIMEOUT			100
+
 enum {
 	RNG_OUTPUT_0_REG = 0,
 	RNG_OUTPUT_1_REG,
@@ -176,7 +183,7 @@ static int omap_rng_do_read(struct hwrng *rng, void *data, size_t max,
 	if (max < priv->pdata->data_size)
 		return 0;
 
-	for (i = 0; i < 20; i++) {
+	for (i = 0; i < RNG_DATA_FILL_TIMEOUT; i++) {
 		present = priv->pdata->data_present(priv);
 		if (present || !wait)
 			break;
-- 
2.7.4


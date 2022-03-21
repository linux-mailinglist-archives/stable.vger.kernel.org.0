Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38454E28D6
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348557AbiCUOAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348847AbiCUN6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:58:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933521770A7;
        Mon, 21 Mar 2022 06:56:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3241DB81674;
        Mon, 21 Mar 2022 13:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C1FC340E8;
        Mon, 21 Mar 2022 13:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647870998;
        bh=5yEzG5mCcTVSwH9OiUgBrwqHfwd0OfKOqGsA5QmuISQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qff1XiLbwz28RP47e1aMgdGNUDTr6vs5BeLGVJDCEJltH/r+8PlFPZRogQlJvwoGW
         +dOq7TPsu78wyYXBRwwuy0oul3V+pOLQQUpt9GhqJT95Ftd3FlO21u89nflvVUvI+e
         BO0ebkxB6ajpkSY+E8Ub6JRFqTGxwmgteL+tQFZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Masney <bmasney@redhat.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andrew Halaney <ahalaney@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 45/57] crypto: qcom-rng - ensure buffer for generate is completely filled
Date:   Mon, 21 Mar 2022 14:52:26 +0100
Message-Id: <20220321133223.299042775@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.984120927@linuxfoundation.org>
References: <20220321133221.984120927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Masney <bmasney@redhat.com>

commit a680b1832ced3b5fa7c93484248fd221ea0d614b upstream.

The generate function in struct rng_alg expects that the destination
buffer is completely filled if the function returns 0. qcom_rng_read()
can run into a situation where the buffer is partially filled with
randomness and the remaining part of the buffer is zeroed since
qcom_rng_generate() doesn't check the return value. This issue can
be reproduced by running the following from libkcapi:

    kcapi-rng -b 9000000 > OUTFILE

The generated OUTFILE will have three huge sections that contain all
zeros, and this is caused by the code where the test
'val & PRNG_STATUS_DATA_AVAIL' fails.

Let's fix this issue by ensuring that qcom_rng_read() always returns
with a full buffer if the function returns success. Let's also have
qcom_rng_generate() return the correct value.

Here's some statistics from the ent project
(https://www.fourmilab.ch/random/) that shows information about the
quality of the generated numbers:

    $ ent -c qcom-random-before
    Value Char Occurrences Fraction
      0           606748   0.067416
      1            33104   0.003678
      2            33001   0.003667
    ...
    253   �        32883   0.003654
    254   �        33035   0.003671
    255   �        33239   0.003693

    Total:       9000000   1.000000

    Entropy = 7.811590 bits per byte.

    Optimum compression would reduce the size
    of this 9000000 byte file by 2 percent.

    Chi square distribution for 9000000 samples is 9329962.81, and
    randomly would exceed this value less than 0.01 percent of the
    times.

    Arithmetic mean value of data bytes is 119.3731 (127.5 = random).
    Monte Carlo value for Pi is 3.197293333 (error 1.77 percent).
    Serial correlation coefficient is 0.159130 (totally uncorrelated =
    0.0).

Without this patch, the results of the chi-square test is 0.01%, and
the numbers are certainly not random according to ent's project page.
The results improve with this patch:

    $ ent -c qcom-random-after
    Value Char Occurrences Fraction
      0            35432   0.003937
      1            35127   0.003903
      2            35424   0.003936
    ...
    253   �        35201   0.003911
    254   �        34835   0.003871
    255   �        35368   0.003930

    Total:       9000000   1.000000

    Entropy = 7.999979 bits per byte.

    Optimum compression would reduce the size
    of this 9000000 byte file by 0 percent.

    Chi square distribution for 9000000 samples is 258.77, and randomly
    would exceed this value 42.24 percent of the times.

    Arithmetic mean value of data bytes is 127.5006 (127.5 = random).
    Monte Carlo value for Pi is 3.141277333 (error 0.01 percent).
    Serial correlation coefficient is 0.000468 (totally uncorrelated =
    0.0).

This change was tested on a Nexus 5 phone (msm8974 SoC).

Signed-off-by: Brian Masney <bmasney@redhat.com>
Fixes: ceec5f5b5988 ("crypto: qcom-rng - Add Qcom prng driver")
Cc: stable@vger.kernel.org # 4.19+
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qcom-rng.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/crypto/qcom-rng.c
+++ b/drivers/crypto/qcom-rng.c
@@ -7,6 +7,7 @@
 #include <linux/acpi.h>
 #include <linux/clk.h>
 #include <linux/crypto.h>
+#include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
@@ -42,16 +43,19 @@ static int qcom_rng_read(struct qcom_rng
 {
 	unsigned int currsize = 0;
 	u32 val;
+	int ret;
 
 	/* read random data from hardware */
 	do {
-		val = readl_relaxed(rng->base + PRNG_STATUS);
-		if (!(val & PRNG_STATUS_DATA_AVAIL))
-			break;
+		ret = readl_poll_timeout(rng->base + PRNG_STATUS, val,
+					 val & PRNG_STATUS_DATA_AVAIL,
+					 200, 10000);
+		if (ret)
+			return ret;
 
 		val = readl_relaxed(rng->base + PRNG_DATA_OUT);
 		if (!val)
-			break;
+			return -EINVAL;
 
 		if ((max - currsize) >= WORD_SZ) {
 			memcpy(data, &val, WORD_SZ);
@@ -60,11 +64,10 @@ static int qcom_rng_read(struct qcom_rng
 		} else {
 			/* copy only remaining bytes */
 			memcpy(data, &val, max - currsize);
-			break;
 		}
 	} while (currsize < max);
 
-	return currsize;
+	return 0;
 }
 
 static int qcom_rng_generate(struct crypto_rng *tfm,
@@ -86,7 +89,7 @@ static int qcom_rng_generate(struct cryp
 	mutex_unlock(&rng->lock);
 	clk_disable_unprepare(rng->clk);
 
-	return 0;
+	return ret;
 }
 
 static int qcom_rng_seed(struct crypto_rng *tfm, const u8 *seed,



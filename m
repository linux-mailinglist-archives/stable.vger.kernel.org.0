Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B9F1217CB
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729651AbfLPSE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:04:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:41720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729647AbfLPSE0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:04:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2877B20700;
        Mon, 16 Dec 2019 18:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519465;
        bh=QBrHzF/bDur2YZKXK3pZ0+nH4CtHkNb06QOzdb7jU/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LhTxaiFez0aTjhncBod7a+3i3s4Koyc3B5SXAPBaOTZebf5u5fNeazRODa32P5WT/
         ExU0rEq/ejk5NUuJs+c4wXgCN8qd8DVBsN/HWfzPJohJJ+O1tJkweyyU68yxh536pc
         q8/2L2XlVj6Qf6mse8u3mW139U+6WX1uiby5tw4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 050/140] hwrng: omap - Fix RNG wait loop timeout
Date:   Mon, 16 Dec 2019 18:48:38 +0100
Message-Id: <20191216174802.353047701@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumit Garg <sumit.garg@linaro.org>

commit be867f987a4e1222114dd07a01838a17c26f3fff upstream.

Existing RNG data read timeout is 200us but it doesn't cover EIP76 RNG
data rate which takes approx. 700us to produce 16 bytes of output data
as per testing results. So configure the timeout as 1000us to also take
account of lack of udelay()'s reliability.

Fixes: 383212425c92 ("hwrng: omap - Add device variant for SafeXcel IP-76 found in Armada 8K")
Cc: <stable@vger.kernel.org>
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/hw_random/omap-rng.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

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
@@ -176,7 +183,7 @@ static int omap_rng_do_read(struct hwrng
 	if (max < priv->pdata->data_size)
 		return 0;
 
-	for (i = 0; i < 20; i++) {
+	for (i = 0; i < RNG_DATA_FILL_TIMEOUT; i++) {
 		present = priv->pdata->data_present(priv);
 		if (present || !wait)
 			break;



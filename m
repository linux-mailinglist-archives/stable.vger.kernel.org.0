Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32F171216E3
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730533AbfLPSJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:09:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:52646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730188AbfLPSJ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:09:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5E5C206B7;
        Mon, 16 Dec 2019 18:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519796;
        bh=QBrHzF/bDur2YZKXK3pZ0+nH4CtHkNb06QOzdb7jU/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZhIR+LP0UYnKwUljIK73GZJgLpq3mk3VJMrALT6w3bZ7NIghxu7kIzcnjq8CxQfa1
         H4pNM+UBLC3+is68JiuvK/MxpRK7xALN61FZlp8IjzlxJaUV6e3uUM0UQzcNGnR9ke
         /NXrioLc/qhdmK10s2uv2CLBIBshsxgHqirRnEZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.3 070/180] hwrng: omap - Fix RNG wait loop timeout
Date:   Mon, 16 Dec 2019 18:48:30 +0100
Message-Id: <20191216174830.209592374@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
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



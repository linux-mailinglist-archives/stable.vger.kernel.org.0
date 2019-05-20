Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4CC235D3
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390858AbfETMja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:39:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390464AbfETMd5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:33:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EC1A21479;
        Mon, 20 May 2019 12:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355636;
        bh=UH6JkK6X0kuRS9HGzftnJ0yrDm0rxbG8gjI3mS3bbjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=orcuSauuii3WoxygER1rmdg9cUHpBE7G28LruDxZ0GE6kWmQL5gh7vJNS0ZOLCvW5
         Bp86g67OWqfbdS8rG4uSQC8o/VDfIXa3BsyeW+jeQqQpuyC2SdlM+NKDOC37Im+kIv
         YToGMKv2HWPZtoW5qc5UAyCTtLxy/xuwC0tW/6/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.1 067/128] crypto: ccree - add function to handle cryptocell tee fips error
Date:   Mon, 20 May 2019 14:14:14 +0200
Message-Id: <20190520115254.337524887@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ofir Drang <ofir.drang@arm.com>

commit 897ab2316910a66bb048f1c9cefa25e6a592dcd7 upstream.

Adds function that checks if cryptocell tee fips error occurred
and in such case triggers system error through kernel panic.
Change fips function to use this new routine.

Signed-off-by: Ofir Drang <ofir.drang@arm.com>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccree/cc_fips.c |   23 +++++++++++++++--------
 drivers/crypto/ccree/cc_fips.h |    2 ++
 2 files changed, 17 insertions(+), 8 deletions(-)

--- a/drivers/crypto/ccree/cc_fips.c
+++ b/drivers/crypto/ccree/cc_fips.c
@@ -72,20 +72,28 @@ static inline void tee_fips_error(struct
 		dev_err(dev, "TEE reported error!\n");
 }
 
+/*
+ * This function check if cryptocell tee fips error occurred
+ * and in such case triggers system error
+ */
+void cc_tee_handle_fips_error(struct cc_drvdata *p_drvdata)
+{
+	struct device *dev = drvdata_to_dev(p_drvdata);
+
+	if (!cc_get_tee_fips_status(p_drvdata))
+		tee_fips_error(dev);
+}
+
 /* Deferred service handler, run as interrupt-fired tasklet */
 static void fips_dsr(unsigned long devarg)
 {
 	struct cc_drvdata *drvdata = (struct cc_drvdata *)devarg;
-	struct device *dev = drvdata_to_dev(drvdata);
-	u32 irq, state, val;
+	u32 irq, val;
 
 	irq = (drvdata->irq & (CC_GPR0_IRQ_MASK));
 
 	if (irq) {
-		state = cc_ioread(drvdata, CC_REG(GPR_HOST));
-
-		if (state != (CC_FIPS_SYNC_TEE_STATUS | CC_FIPS_SYNC_MODULE_OK))
-			tee_fips_error(dev);
+		cc_tee_handle_fips_error(drvdata);
 	}
 
 	/* after verifing that there is nothing to do,
@@ -113,8 +121,7 @@ int cc_fips_init(struct cc_drvdata *p_dr
 	dev_dbg(dev, "Initializing fips tasklet\n");
 	tasklet_init(&fips_h->tasklet, fips_dsr, (unsigned long)p_drvdata);
 
-	if (!cc_get_tee_fips_status(p_drvdata))
-		tee_fips_error(dev);
+	cc_tee_handle_fips_error(p_drvdata);
 
 	return 0;
 }
--- a/drivers/crypto/ccree/cc_fips.h
+++ b/drivers/crypto/ccree/cc_fips.h
@@ -18,6 +18,7 @@ int cc_fips_init(struct cc_drvdata *p_dr
 void cc_fips_fini(struct cc_drvdata *drvdata);
 void fips_handler(struct cc_drvdata *drvdata);
 void cc_set_ree_fips_status(struct cc_drvdata *drvdata, bool ok);
+void cc_tee_handle_fips_error(struct cc_drvdata *p_drvdata);
 
 #else  /* CONFIG_CRYPTO_FIPS */
 
@@ -30,6 +31,7 @@ static inline void cc_fips_fini(struct c
 static inline void cc_set_ree_fips_status(struct cc_drvdata *drvdata,
 					  bool ok) {}
 static inline void fips_handler(struct cc_drvdata *drvdata) {}
+static inline void cc_tee_handle_fips_error(struct cc_drvdata *p_drvdata) {}
 
 #endif /* CONFIG_CRYPTO_FIPS */
 



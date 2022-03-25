Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531364E71A5
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 11:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350623AbiCYKy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 06:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244096AbiCYKy2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 06:54:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD26ACC527
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 03:52:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A9B161750
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 10:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E018C340E9;
        Fri, 25 Mar 2022 10:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648205573;
        bh=ftHSDj1+Ygw94TwYEv6DtEKLPp7Ekhv3hnqujiYqdfU=;
        h=Subject:To:Cc:From:Date:From;
        b=YumlUZTlIoexuMJtklbd2OwyEetqyoqBIo7ygoXX0ruNSMoc/VP8bPsS1bI3g5YO5
         eoV1jkaDyCnpMJkjRMvfIu8ZGHkhV+/pIT4due1DjzNXE2TeFB47IvoLEzxH5NQQPQ
         9Xzo0lWUIFXBXdwDoNDnJ48+Pnllgh42+pg5o5WA=
Subject: FAILED: patch "[PATCH] crypto: qat - disable registration of algorithms" failed to apply to 5.10-stable tree
To:     giovanni.cabiddu@intel.com, herbert@gondor.apana.org.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Mar 2022 11:52:51 +0100
Message-ID: <1648205571218181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8893d27ffcaf6ec6267038a177cb87bcde4dd3de Mon Sep 17 00:00:00 2001
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Date: Fri, 4 Mar 2022 17:54:47 +0000
Subject: [PATCH] crypto: qat - disable registration of algorithms

The implementations of aead and skcipher in the QAT driver do not
support properly requests with the CRYPTO_TFM_REQ_MAY_BACKLOG flag set.
If the HW queue is full, the driver returns -EBUSY but does not enqueue
the request.
This can result in applications like dm-crypt waiting indefinitely for a
completion of a request that was never submitted to the hardware.

To avoid this problem, disable the registration of all crypto algorithms
in the QAT driver by setting the number of crypto instances to 0 at
configuration time.

Cc: stable@vger.kernel.org
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/qat/qat_4xxx/adf_drv.c b/drivers/crypto/qat/qat_4xxx/adf_drv.c
index a6c78b9c730b..fa4c350c1bf9 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_drv.c
@@ -75,6 +75,13 @@ static int adf_crypto_dev_config(struct adf_accel_dev *accel_dev)
 	if (ret)
 		goto err;
 
+	/* Temporarily set the number of crypto instances to zero to avoid
+	 * registering the crypto algorithms.
+	 * This will be removed when the algorithms will support the
+	 * CRYPTO_TFM_REQ_MAY_BACKLOG flag
+	 */
+	instances = 0;
+
 	for (i = 0; i < instances; i++) {
 		val = i;
 		bank = i * 2;
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 7234c4940fae..67c9588e89df 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -161,6 +161,13 @@ int qat_crypto_dev_config(struct adf_accel_dev *accel_dev)
 	if (ret)
 		goto err;
 
+	/* Temporarily set the number of crypto instances to zero to avoid
+	 * registering the crypto algorithms.
+	 * This will be removed when the algorithms will support the
+	 * CRYPTO_TFM_REQ_MAY_BACKLOG flag
+	 */
+	instances = 0;
+
 	for (i = 0; i < instances; i++) {
 		val = i;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_BANK_NUM, i);


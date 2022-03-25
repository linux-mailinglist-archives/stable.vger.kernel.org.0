Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC924E7710
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379087AbiCYP0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376521AbiCYPV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:21:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADF56C905;
        Fri, 25 Mar 2022 08:16:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3070F60AB7;
        Fri, 25 Mar 2022 15:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AFCC340E9;
        Fri, 25 Mar 2022 15:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221342;
        bh=xB09mWxvdIPI9n6hFFKfaWkT0NX9SojhxvqtWd6DOqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RD+K2c8n7XjfHcZ6haOhh4GfYsm13h8jBMOlIdzkreebhztKlmz1V/c+DQLQpqDj7
         hUl1OrOuqM/kqV9HGZmO8/TN/71FFcs5aazC9Mv5s8Ujoafui9o4K2xYpCTRrgYjk/
         hZ6ZBg/4gygM6vk4Wth2MtTv2pa4hv+d88j+4D5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 27/37] crypto: qat - disable registration of algorithms
Date:   Fri, 25 Mar 2022 16:14:28 +0100
Message-Id: <20220325150420.707670625@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150419.931802116@linuxfoundation.org>
References: <20220325150419.931802116@linuxfoundation.org>
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

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

commit 8893d27ffcaf6ec6267038a177cb87bcde4dd3de upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qat/qat_4xxx/adf_drv.c      |    7 +++++++
 drivers/crypto/qat/qat_common/qat_crypto.c |    7 +++++++
 2 files changed, 14 insertions(+)

--- a/drivers/crypto/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_drv.c
@@ -52,6 +52,13 @@ static int adf_crypto_dev_config(struct
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
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -136,6 +136,13 @@ int qat_crypto_dev_config(struct adf_acc
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



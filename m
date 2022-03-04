Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A714CDB6D
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 18:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240942AbiCDRzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 12:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbiCDRzk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 12:55:40 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BD01C469B;
        Fri,  4 Mar 2022 09:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646416492; x=1677952492;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ky+EBYxMHIUccuiPHDGLq5tdedRm2jVnYsGhmdAbGUo=;
  b=kbEo3Wx0TLlI2KqZS1znYhCMCZm8o6lHLsUyuYGX4pRjuHtje1jsNF+6
   T10dPa2zYJNDZ14XpnGVOVzzW2njEmOIc4Kip8qXuCr/ewKWv4KIRe24+
   lzA8w+Wo03ewPUoyR2lYrzp8HrYhrMfYhmUb1b/++KYOzO90OGXgkoDgc
   dpF7xm0ou6sQ8c94Gztcd2AGyR7FIxu9yGRavVpoX2TJzWCtAxfYBzwvT
   F86VZsBbLr1WZrtIToYVvfuxj+GR6viQiGrYtg9XQbYTGN9zAdxYPhdL/
   ticSK5F4ZVWx7EnmcqJvY7/xJJro4M92HeHZDHVzhNgVGlHCQ20dKTIKf
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="233985878"
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="233985878"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 09:54:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="511927888"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga006.jf.intel.com with ESMTP; 04 Mar 2022 09:54:50 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] crypto: qat - disable registration of algorithms
Date:   Fri,  4 Mar 2022 17:54:47 +0000
Message-Id: <20220304175447.19601-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/crypto/qat/qat_4xxx/adf_drv.c      | 7 +++++++
 drivers/crypto/qat/qat_common/qat_crypto.c | 7 +++++++
 2 files changed, 14 insertions(+)

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
-- 
2.35.1


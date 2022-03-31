Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA144EDD9E
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 17:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238383AbiCaPoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 11:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239282AbiCaPm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 11:42:29 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB175D66F;
        Thu, 31 Mar 2022 08:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648741042; x=1680277042;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0fWKPOzHGnKEYsF/rOLOD1zuA7oHxus2QAWrWbDy4m8=;
  b=n6A5fZgfg6TDC7ng3nnoqZqqJUYShidFyXWX3vpHC7pwRnlyU0SyN5l8
   ynWoge2NWgrADFR+aAYCduKw6MPA4wSK0WSaaikyvyBEGd6ubMQO3Rpng
   L2V4SslrFWBZiNQ78ppsi1ID2uz+GqNT4N9atv0Sq0I7jXjRRq7xgSTyg
   rgOF334r5mFxyb1JCrjyXNUAyogkOa/1xvJPVtgw4Cj3MmrzhhQGyX7e2
   imunI9O3GFl+4+Ic/HjM8WzwgCgAT8oxC6fjNQgIsYiW0hMRf0ha17EWd
   JFM+ZU82oXC0tHcK4kFAlxSDNJ0fjGTNwW2Nooo6kIu97+6RVTWEjKfCh
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="242022751"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="242022751"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 08:37:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="555124807"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga007.fm.intel.com with ESMTP; 31 Mar 2022 08:37:02 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 4/4] crypto: qat - re-enable registration of algorithms
Date:   Thu, 31 Mar 2022 16:36:52 +0100
Message-Id: <20220331153652.37020-5-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220331153652.37020-1-giovanni.cabiddu@intel.com>
References: <20220331153652.37020-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Re-enable the registration of algorithms after fixes to (1) use
pre-allocated buffers in the datapath and (2) support the
CRYPTO_TFM_REQ_MAY_BACKLOG flag.

This reverts commit 8893d27ffcaf6ec6267038a177cb87bcde4dd3de.

Cc: stable@vger.kernel.org
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
---
 drivers/crypto/qat/qat_4xxx/adf_drv.c      | 7 -------
 drivers/crypto/qat/qat_common/qat_crypto.c | 7 -------
 2 files changed, 14 deletions(-)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_drv.c b/drivers/crypto/qat/qat_4xxx/adf_drv.c
index fa4c350c1bf9..a6c78b9c730b 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_drv.c
@@ -75,13 +75,6 @@ static int adf_crypto_dev_config(struct adf_accel_dev *accel_dev)
 	if (ret)
 		goto err;
 
-	/* Temporarily set the number of crypto instances to zero to avoid
-	 * registering the crypto algorithms.
-	 * This will be removed when the algorithms will support the
-	 * CRYPTO_TFM_REQ_MAY_BACKLOG flag
-	 */
-	instances = 0;
-
 	for (i = 0; i < instances; i++) {
 		val = i;
 		bank = i * 2;
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 80d905ed102e..9341d892533a 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -161,13 +161,6 @@ int qat_crypto_dev_config(struct adf_accel_dev *accel_dev)
 	if (ret)
 		goto err;
 
-	/* Temporarily set the number of crypto instances to zero to avoid
-	 * registering the crypto algorithms.
-	 * This will be removed when the algorithms will support the
-	 * CRYPTO_TFM_REQ_MAY_BACKLOG flag
-	 */
-	instances = 0;
-
 	for (i = 0; i < instances; i++) {
 		val = i;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_BANK_NUM, i);
-- 
2.35.1


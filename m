Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162F64E978B
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 15:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243025AbiC1NJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 09:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243021AbiC1NJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 09:09:23 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299625EDC8;
        Mon, 28 Mar 2022 06:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648472854; x=1680008854;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6fBIW0WigUkIyxmAtnOgoxYDSIuhhXeJKC+xsr20AWM=;
  b=LxoYh/ivEETzf5f95kY+ZdjAngUf8tDEDj0NrxpjmuIrgxXZzS3gnU76
   5Ktkfbc9pNm6WeW7QSCHDIl+Td2OaFGKMhy0vZhYno743xfo8gq2bHjID
   FsrBDCDTvtQDVC0xFyqYcUI2RkEUm+H2N00i1k4xgnboAe4rmt9WCAkGU
   q5qw+EUXYZ6AkjRySfy3fY5uCMRcu11V1YrrSP7y8A3nnG04Q936PTvwY
   Wpzi7zpgevqDgeYMfIVS5vpkzCDl2mjWeqzmaJCDw1/ZImTpLLCPGDf57
   WejEQR4WRxoB/D5DtuNrSi3Yf2ZBJz6Al36BNWQ3BCiXoTlvAnXzRyeQi
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10299"; a="259179026"
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="259179026"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 06:07:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="563641172"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga008.jf.intel.com with ESMTP; 28 Mar 2022 06:07:31 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        stable@vger.kernel.org, Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH 4/4] crypto: qat - re-enable registration of algorithms
Date:   Mon, 28 Mar 2022 14:07:14 +0100
Message-Id: <20220328130714.31606-5-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220328130714.31606-1-giovanni.cabiddu@intel.com>
References: <20220328130714.31606-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 1558630927c6..7a9968aa01b2 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -191,13 +191,6 @@ int qat_crypto_dev_config(struct adf_accel_dev *accel_dev)
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


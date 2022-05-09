Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB73A51FE78
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 15:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbiEINkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 09:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236030AbiEINkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 09:40:45 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863B218B940;
        Mon,  9 May 2022 06:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652103410; x=1683639410;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DzSK5EtvSUu+rARESr34ozWVmZBIJIRsYnefuQZeksk=;
  b=j7YcHfuakaMD/OKV+5k1+iujncpMVBLmaWNlDsqOC4vd3ozHxpwcWqgu
   B3fQc66Lle+ccCSmBbSoI0WmOSi4p/JzW0hFJrLGXU7ww6n1nGIhxl7iQ
   X9pWJ4hOL1ByDyQw9+xK+TGSP9yhw0eD4yW4hYcQAS/1Bv/F7Tv3n3FmS
   fK8EcpbSF18hmxJ/xPj0vYU+Pv7ui5e9fh/ZBN4iNvhUDJHYrDEvrSxyi
   tEZNvPHzLSy/m2ff6MIGUdjF1VkNHiCUXT0eN6bzUDK6NmOq7ar+0d2Fy
   fi1d4EKlaxJ4Jky6lxQ3bBkfTCzW00sWlwqD56+MsME6rqoJN73J7f5fV
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10341"; a="248952429"
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="248952429"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 06:34:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="622967754"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga008.fm.intel.com with ESMTP; 09 May 2022 06:34:51 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        stable@vger.kernel.org,
        Marco Chiappero <marco.chiappero@intel.com>,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH v3 10/10] crypto: qat - re-enable registration of algorithms
Date:   Mon,  9 May 2022 14:34:17 +0100
Message-Id: <20220509133417.56043-11-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220509133417.56043-1-giovanni.cabiddu@intel.com>
References: <20220509133417.56043-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5AB04BE25E
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348247AbiBUJ11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:27:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349569AbiBUJ0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:26:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445501DA63;
        Mon, 21 Feb 2022 01:10:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D409260B1B;
        Mon, 21 Feb 2022 09:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A03C340E9;
        Mon, 21 Feb 2022 09:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434637;
        bh=8agQrglvWx4whqxjjqslS46mi/r1Jr37ohVeGNh+rPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmYTU9vtdTQXXsssa/YxGpmjbWlLoC53WMsAOT00JeCnczePjnfZewp1Djy8Vkjm2
         nKYLRHYRHWnIm0khYMTTtKq/18u/Nfk9MdhlFOFPLK0MenW6AIEFgUSO/jCBJoUUls
         H+NmbiabWiq0MIG0ucjwfjl0SSLRGqO24UGqc4bo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.15 076/196] iwlwifi: mvm: dont send SAR GEO command for 3160 devices
Date:   Mon, 21 Feb 2022 09:48:28 +0100
Message-Id: <20220221084933.478411606@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

commit 5f06f6bf8d816578c390a2b8a485d40adcca4749 upstream.

SAR GEO offsets are not supported on 3160 devices.  The code was
refactored and caused us to start sending the command anyway, which
causes a FW assertion failure.  Fix that only considering this feature
supported on FW API with major version is 17 if the device is not
3160.

Additionally, fix the caller of iwl_mvm_sar_geo_init() so that it
checks for the return value, which it was ignoring.

Reported-by: Len Brown <lenb@kernel.org>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Fixes: 78a19d5285d9 ("iwlwifi: mvm: Read the PPAG and SAR tables at INIT stage")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/iwlwifi.20220128144623.96f683a89b42.I14e2985bfd7ddd8a8d83eb1869b800c0e7f30db4@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c |   11 ++++++-----
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h |    3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  |    2 +-
 3 files changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Copyright (C) 2017 Intel Deutschland GmbH
- * Copyright (C) 2019-2021 Intel Corporation
+ * Copyright (C) 2019-2022 Intel Corporation
  */
 #include <linux/uuid.h>
 #include "iwl-drv.h"
@@ -814,10 +814,11 @@ bool iwl_sar_geo_support(struct iwl_fw_r
 	 * only one using version 36, so skip this version entirely.
 	 */
 	return IWL_UCODE_SERIAL(fwrt->fw->ucode_ver) >= 38 ||
-	       IWL_UCODE_SERIAL(fwrt->fw->ucode_ver) == 17 ||
-	       (IWL_UCODE_SERIAL(fwrt->fw->ucode_ver) == 29 &&
-		((fwrt->trans->hw_rev & CSR_HW_REV_TYPE_MSK) ==
-		 CSR_HW_REV_TYPE_7265D));
+		(IWL_UCODE_SERIAL(fwrt->fw->ucode_ver) == 17 &&
+		 fwrt->trans->hw_rev != CSR_HW_REV_TYPE_3160) ||
+		(IWL_UCODE_SERIAL(fwrt->fw->ucode_ver) == 29 &&
+		 ((fwrt->trans->hw_rev & CSR_HW_REV_TYPE_MSK) ==
+		  CSR_HW_REV_TYPE_7265D));
 }
 IWL_EXPORT_SYMBOL(iwl_sar_geo_support);
 
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2005-2014, 2018-2021 Intel Corporation
+ * Copyright (C) 2005-2014, 2018-2022 Intel Corporation
  * Copyright (C) 2013-2014 Intel Mobile Communications GmbH
  * Copyright (C) 2016 Intel Deutschland GmbH
  */
@@ -319,6 +319,7 @@ enum {
 #define CSR_HW_REV_TYPE_2x00		(0x0000100)
 #define CSR_HW_REV_TYPE_105		(0x0000110)
 #define CSR_HW_REV_TYPE_135		(0x0000120)
+#define CSR_HW_REV_TYPE_3160		(0x0000164)
 #define CSR_HW_REV_TYPE_7265D		(0x0000210)
 #define CSR_HW_REV_TYPE_NONE		(0x00001F0)
 #define CSR_HW_REV_TYPE_QNJ		(0x0000360)
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1572,7 +1572,7 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	ret = iwl_mvm_sar_init(mvm);
 	if (ret == 0)
 		ret = iwl_mvm_sar_geo_init(mvm);
-	else if (ret < 0)
+	if (ret < 0)
 		goto error;
 
 	iwl_mvm_tas_init(mvm);



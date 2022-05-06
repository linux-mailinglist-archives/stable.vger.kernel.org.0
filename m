Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA0651DAC7
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 16:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442324AbiEFOnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 10:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442330AbiEFOnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 10:43:24 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF106AA6A;
        Fri,  6 May 2022 07:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651847981; x=1683383981;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aC5KEN8QilAdacBpV4C3PKOAnFQSXsFdFkr96IIN3b0=;
  b=HCqvIidS3meWSv57JZp+tpPG+qGa8Z2V+2SuUcJtuc1KM9nC/GdgyaEQ
   im7vfRM+OoQa06X3A1SMFVV6CGal4cnkLGJeVoPwfLQTRUnyjNnHfdjKY
   xoZvKr/Wd7WMvFaNKHbjVSZ5++Lp0TpS/8k0jFKQKYaXGnUmmBTYjFL8O
   gNhc0qAKvNBYLViY9wQCYjYz/qa7mniTjIMZoMiw3xLbXBzdKsbTO6TJ0
   41RZ5wIDm897d6LhcT93tr1M6R31LhntryppuZtkRnqFyNPcEbg74QrKh
   PDbK6dGzbUWw4hiFvqwaVYWScTJTsTfu7xOVIiWbuHjGRZSDfurQOTTyO
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="248387509"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248387509"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 07:39:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="537914892"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga006.jf.intel.com with ESMTP; 06 May 2022 07:39:24 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        vdronov@redhat.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        stable@vger.kernel.org, Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH v2 09/11] crypto: qat - add param check for DH
Date:   Fri,  6 May 2022 15:39:01 +0100
Message-Id: <20220506143903.31776-10-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506143903.31776-1-giovanni.cabiddu@intel.com>
References: <20220506143903.31776-1-giovanni.cabiddu@intel.com>
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

Reject requests with a source buffer that is bigger than the size of the
key. This is to prevent a possible integer underflow that might happen
when copying the source scatterlist into a linear buffer.

Cc: stable@vger.kernel.org
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 947eeff181b4..7173a2a0a484 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -235,6 +235,10 @@ static int qat_dh_compute_value(struct kpp_request *req)
 		req->dst_len = ctx->p_size;
 		return -EOVERFLOW;
 	}
+
+	if (req->src_len > ctx->p_size)
+		return -EINVAL;
+
 	memset(msg, '\0', sizeof(*msg));
 	ICP_QAT_FW_PKE_HDR_VALID_FLAG_SET(msg->pke_hdr,
 					  ICP_QAT_FW_COMN_REQ_FLAG_SET);
-- 
2.35.1


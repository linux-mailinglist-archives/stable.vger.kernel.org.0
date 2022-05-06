Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8943851D35C
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 10:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389893AbiEFI1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 04:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390091AbiEFI1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 04:27:40 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C96168F90;
        Fri,  6 May 2022 01:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651825434; x=1683361434;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HVc2NpXhSGE3nt5pbdjx0IGAR6BOSPzjSJYfwgr/9o8=;
  b=UQ4+s2H65ezWM+sxV9xu86lDRSSBixPXOVxppzS7dxIexZmc0U9agZkh
   K74cunonP5tOAWdfEwBr23dJCrLUJj4bTGZzyd2MVoQUQqatJumJIS63C
   a3lxDdwJ7MIGThROGztC8+AvAncQ4eYYDNKqgqxAIe8AVLZRRBkMA0Cbe
   aXXu1GmCENgNfu0Z7bftx1D9/oQuI3Cbe7RWp5c1eT4D13TepJbVKeKPa
   c7SUbDvJAF1j+UyvEWXIDJ5EZINfnItC01CcJigFYPzDFZL7HPXsQM5qN
   xFzGZEoDGYiGTNKw4r7b/NImrLZGZ9KcuSYO0NzUKmogrplOu/iVXUi5M
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="328938505"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="328938505"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 01:23:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="563709033"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga007.jf.intel.com with ESMTP; 06 May 2022 01:23:51 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        vdronov@redhat.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        stable@vger.kernel.org, Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH 09/12] crypto: qat - add param check for DH
Date:   Fri,  6 May 2022 09:23:24 +0100
Message-Id: <20220506082327.21605-10-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506082327.21605-1-giovanni.cabiddu@intel.com>
References: <20220506082327.21605-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
index 2b2adeee5eee..b3badc5bd224 100644
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


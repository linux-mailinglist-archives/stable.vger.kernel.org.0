Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFF251FE77
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 15:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236025AbiEINkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 09:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235956AbiEINke (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 09:40:34 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D73F106A6A;
        Mon,  9 May 2022 06:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652103401; x=1683639401;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3C7nf/12hswH/vpZo9pijZ1VuHa7WMnXV2nf+Dogxq8=;
  b=dn7vlnbyBkqyKh3CZTQNMI27TwJHWhy6Brn0U62NwIIknhN0b1J8xWI7
   PUAmlBqftwmMfED8CcAWa/byD/KjTPArn0HB47xtqXEdogK8ZgQdPwfgD
   w/cJbBif18X7Mr7Pmk3UCvOyc8Gf8xbLTataJwT0TDIVDEmjEc4lk3PKT
   o6ZnTfDPXduzNQJXbCpd0g531gn8f6s+SpiZyJl3hOWjU2dsTIjnkXAjr
   4C8WitrP/Tb1uoQ/IRkZLF9pbr0pyIzhRDUdH2Ma89Ci8CW6rgkiq3wlI
   enYNfko0HlfTQdEQtpUt7Ovk29fQ304N9KKNCIEkXvtYH/+LZguzxmJ1F
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10341"; a="248952401"
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="248952401"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 06:34:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="622967601"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga008.fm.intel.com with ESMTP; 09 May 2022 06:34:46 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        stable@vger.kernel.org, Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH v3 08/10] crypto: qat - add param check for DH
Date:   Mon,  9 May 2022 14:34:15 +0100
Message-Id: <20220509133417.56043-9-giovanni.cabiddu@intel.com>
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
index 1021202b2fbd..ec094789a628 100644
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


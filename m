Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D9F4E736B
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 13:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240993AbiCYM2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 08:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359597AbiCYM22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 08:28:28 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FEF9AE6A
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 05:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648211152; x=1679747152;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FVSNKxvMNLx3VIbWThW4sAm55bESAEUzY7SC7M38HIg=;
  b=NTKkySTENKd1eyFNMi1use+LEXaTPnIm+N05kCxdocturM+LCuA9SbOQ
   Y+Tj94mVUARpOSlRoxDAUimE6u+/YGG/dNfk5fFbbciVcCtoeW5KZ2fDs
   8YN788EKKFhyd5SZ+1U0CzZ5KEXrSXbtO+Fk8K7cOOI2Lcz+A1rvueTSC
   nZHeSSJzH64BiOiByTnlkne3SnQFIrgiQEL/t9ruUfL0Nn8c5PWTEwBme
   fYhdDX/NaKgyIQc69hfW8wVDtzFQWQiJvHcH18n0WsPHPkgneqjEJyc6R
   60fJWr6zg6KJ4PzHKdPMoJf7AU8dHyCrGrfqSKKYy/vbA10WPhNURCOzk
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10296"; a="246098425"
X-IronPort-AV: E=Sophos;i="5.90,209,1643702400"; 
   d="scan'208";a="246098425"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2022 05:25:52 -0700
X-IronPort-AV: E=Sophos;i="5.90,209,1643702400"; 
   d="scan'208";a="617114119"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.76])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2022 05:25:50 -0700
Date:   Fri, 25 Mar 2022 12:25:44 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     herbert@gondor.apana.org.au
Subject: Re: FAILED: patch "[PATCH] crypto: qat - disable registration of
 algorithms" failed to apply to 4.9-stable tree
Message-ID: <Yj20vfqmn3xQ0D7Y@silpixa00400314>
References: <16482055719285@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16482055719285@kroah.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Mar 25, 2022 at 11:52:51AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
Below a backport that applies to kernels from 4.9 to 5.10.

---8<---
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Date: Fri, 4 Mar 2022 17:54:47 +0000
Subject: [PATCH] crypto: qat - disable registration of algorithms
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland

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
---
 drivers/crypto/qat/qat_common/qat_crypto.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 3852d31ce0a4..37a9f969c59c 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -170,6 +170,14 @@ int qat_crypto_dev_config(struct adf_accel_dev *accel_dev)
 		goto err;
 	if (adf_cfg_section_add(accel_dev, "Accelerator0"))
 		goto err;
+
+	/* Temporarily set the number of crypto instances to zero to avoid
+	 * registering the crypto algorithms.
+	 * This will be removed when the algorithms will support the
+	 * CRYPTO_TFM_REQ_MAY_BACKLOG flag
+	 */
+	instances = 0;
+
 	for (i = 0; i < instances; i++) {
 		val = i;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_BANK_NUM, i);
-- 
2.35.1

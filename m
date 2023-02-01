Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1464A686B00
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 17:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjBAQAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 11:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbjBAQAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 11:00:06 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C16273B;
        Wed,  1 Feb 2023 07:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675267195; x=1706803195;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0J/+bcc/kBvFoqYMM1Kp8Sv8LAgfC3hzyVRuwc24ypo=;
  b=fuePT1qEVBXeZlNmF3BLya8LJEKfTY89IFpGdAgBIiBg08iG1PEr7Hz3
   /GUE8b0fu+aDM/9oBU8ZoplSv6yfL2X19hB5prI8g7on2tMwNywox59sN
   HTDTgH/G8KUIpwEzWDQWQh4gddH4gqQMEni38AEFX4Opt2+FM5ZvvqOgm
   3fJTWRIUoXNru47Jbr2ndMjZ7OY4KvCYriFKLkbloOkoKicLGdCVXc3Tm
   e6JlUa27uYAmCwkWCRzV2l0R3E53TFYTedepTN4Ttd4Q9ufW+57PaxrN3
   Xoscm6G2oExyeTbhEIlQ+1wYg4ZOSwcg/ksCXSp2cjfIB8nHyUwfwmzxP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="414389921"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="414389921"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 07:59:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="695396360"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="695396360"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga008.jf.intel.com with ESMTP; 01 Feb 2023 07:59:50 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        stable@vger.kernel.org, Vladis Dronov <vdronov@redhat.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH] crypto: qat - fix out-of-bounds read
Date:   Wed,  1 Feb 2023 15:59:44 +0000
Message-Id: <20230201155944.23379-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When preparing an AER-CTR request, the driver copies the key provided by
the user into a data structure that is accessible by the firmware.
If the target device is QAT GEN4, the key size is rounded up by 16 since
a rounded up size is expected by the device.
If the key size is rounded up before the copy, the size used for copying
the key might be bigger than the size of the region containing the key,
causing an out-of-bounds read.

Fix by doing the copy first and then update the keylen.

This is to fix the following warning reported by KASAN:

	[  138.150574] BUG: KASAN: global-out-of-bounds in qat_alg_skcipher_init_com.isra.0+0x197/0x250 [intel_qat]
	[  138.150641] Read of size 32 at addr ffffffff88c402c0 by task cryptomgr_test/2340

	[  138.150651] CPU: 15 PID: 2340 Comm: cryptomgr_test Not tainted 6.2.0-rc1+ #45
	[  138.150659] Hardware name: Intel Corporation ArcherCity/ArcherCity, BIOS EGSDCRB1.86B.0087.D13.2208261706 08/26/2022
	[  138.150663] Call Trace:
	[  138.150668]  <TASK>
	[  138.150922]  kasan_check_range+0x13a/0x1c0
	[  138.150931]  memcpy+0x1f/0x60
	[  138.150940]  qat_alg_skcipher_init_com.isra.0+0x197/0x250 [intel_qat]
	[  138.151006]  qat_alg_skcipher_init_sessions+0xc1/0x240 [intel_qat]
	[  138.151073]  crypto_skcipher_setkey+0x82/0x160
	[  138.151085]  ? prepare_keybuf+0xa2/0xd0
	[  138.151095]  test_skcipher_vec_cfg+0x2b8/0x800

Fixes: 67916c951689 ("crypto: qat - add AES-CTR support for QAT GEN4 devices")
Cc: <stable@vger.kernel.org>
Reported-by: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index b4b9f0aa59b9..b61ada559158 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -435,8 +435,8 @@ static void qat_alg_skcipher_init_com(struct qat_alg_skcipher_ctx *ctx,
 	} else if (aes_v2_capable && mode == ICP_QAT_HW_CIPHER_CTR_MODE) {
 		ICP_QAT_FW_LA_SLICE_TYPE_SET(header->serv_specif_flags,
 					     ICP_QAT_FW_LA_USE_UCS_SLICE_TYPE);
-		keylen = round_up(keylen, 16);
 		memcpy(cd->ucs_aes.key, key, keylen);
+		keylen = round_up(keylen, 16);
 	} else {
 		memcpy(cd->aes.key, key, keylen);
 	}
-- 
2.39.1


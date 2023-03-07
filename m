Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61446AF21C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbjCGSud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbjCGSuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:50:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7AEA7295
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:38:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B601B819CD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54EC7C433EF;
        Tue,  7 Mar 2023 18:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214308;
        bh=XZMtCxacqirtNhf3V1gRSzefMyOtNwylM05BdngGa9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YolA8vQKJDCJZmnjhgqTtv2rAJ4QxBm+QeSgRuT8xI7/opvo0nfhgrRPnglYie2C7
         syS2LUNsl7i2A4RtX02PvlPRsK3QZslXnXS3mMML31+LW2K6kau8ZbDbiJ55pLTopg
         k5XP4RLu3OS1LQ3ewaENXCb6wM/6Y3gvRPv7GO80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladis Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 781/885] crypto: qat - fix out-of-bounds read
Date:   Tue,  7 Mar 2023 18:01:55 +0100
Message-Id: <20230307170035.861228234@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

commit f6044cc3030e139f60c281386f28bda6e3049d66 upstream.

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
Reviewed-by: Vladis Dronov <vdronov@redhat.com>
Tested-by: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qat/qat_common/qat_algs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -434,8 +434,8 @@ static void qat_alg_skcipher_init_com(st
 	} else if (aes_v2_capable && mode == ICP_QAT_HW_CIPHER_CTR_MODE) {
 		ICP_QAT_FW_LA_SLICE_TYPE_SET(header->serv_specif_flags,
 					     ICP_QAT_FW_LA_USE_UCS_SLICE_TYPE);
-		keylen = round_up(keylen, 16);
 		memcpy(cd->ucs_aes.key, key, keylen);
+		keylen = round_up(keylen, 16);
 	} else {
 		memcpy(cd->aes.key, key, keylen);
 	}



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8645A583102
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242995AbiG0RpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243287AbiG0Roi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:44:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD40B8B4AA;
        Wed, 27 Jul 2022 09:53:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCE7961777;
        Wed, 27 Jul 2022 16:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FA6C433D6;
        Wed, 27 Jul 2022 16:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940787;
        bh=EbbtSP81SB/eEVBWm1PY22sD8gJOWt3K2bKK1nSe17I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPNfKlV9t9oPpzU3mGGs4OZhzo9DSynFdiyNS0gXmg6rqlCANBEzEYO2+5G7th83u
         9axe0JYqKBaFQtgrs5c5OZLhHD9rK2WYh5WgqSTHlmHfByCWWXGJB2PNU8nt5MkDSY
         wly9H6oMcjLrOYY3cYUIaMI93b0oNWqnjW/kpsKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 149/158] crypto: qat - re-enable registration of algorithms
Date:   Wed, 27 Jul 2022 18:13:33 +0200
Message-Id: <20220727161027.319910171@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit d09144745959bf7852ccafd73243dd7d1eaeb163 ]

Re-enable the registration of algorithms after fixes to (1) use
pre-allocated buffers in the datapath and (2) support the
CRYPTO_TFM_REQ_MAY_BACKLOG flag.

This reverts commit 8893d27ffcaf6ec6267038a177cb87bcde4dd3de.

Cc: stable@vger.kernel.org
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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




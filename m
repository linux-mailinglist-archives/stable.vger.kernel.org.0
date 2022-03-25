Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3B74E75DD
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359599AbiCYPIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359522AbiCYPI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:08:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA31ECFBB0;
        Fri, 25 Mar 2022 08:06:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 602B061BCB;
        Fri, 25 Mar 2022 15:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1F0C340E9;
        Fri, 25 Mar 2022 15:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220812;
        bh=RuC+1rqugxNuew2WMFrSfKADvorEHXodJr0P7fQnOpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xu+LVYWoJ6MQxGv1Hsbk5P2/3tAl+iaRGgRUIXP4vNBwl/kCn+00D/lvwmiCEhfB/
         3+j3PKq6hLdL6gw8EMpPS3ETb5puPc1TjJad3roR6DeZS9gfDHgfhnI57vS2J1kS0Z
         AOSdWDd1ATLHbDx+ZUWcqOgi9MXCn89buInRAvD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 18/20] crypto: qat - disable registration of algorithms
Date:   Fri, 25 Mar 2022 16:04:56 +0100
Message-Id: <20220325150417.537257371@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150417.010265747@linuxfoundation.org>
References: <20220325150417.010265747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

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
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qat/qat_common/qat_crypto.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -170,6 +170,14 @@ int qat_crypto_dev_config(struct adf_acc
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



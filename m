Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF596BB0EC
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbjCOMXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbjCOMWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:22:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617D898E98
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:21:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28542B81DFF
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D737C433EF;
        Wed, 15 Mar 2023 12:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882882;
        bh=jtEzjHoclxcWP6RQsIcGoSkXaS5KK6N7uVcW2X9AVDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEKC7nRjTO21G2+h5erx+iGeKguYKVDWdIWVbCqsbqL9gSpULSGdzY6rChGttnhQQ
         UuxJOKkcaqwH7hrmlJhdn+Jf1JjQ2s+vurenCMZPg5qyewqPBKWy2fT+t1Q5DyjCMP
         yFJsSAe1LLdYzzG4vh+Nevm3D5XroQTZfGrt4mZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kang Chen <void0red@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Simon Horman <simon.horman@corigine.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/104] nfc: fdp: add null check of devm_kmalloc_array in fdp_nci_i2c_read_device_properties
Date:   Wed, 15 Mar 2023 13:12:07 +0100
Message-Id: <20230315115733.513688484@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
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

From: Kang Chen <void0red@gmail.com>

[ Upstream commit 11f180a5d62a51b484e9648f9b310e1bd50b1a57 ]

devm_kmalloc_array may fails, *fw_vsc_cfg might be null and cause
out-of-bounds write in device_property_read_u8_array later.

Fixes: a06347c04c13 ("NFC: Add Intel Fields Peak NFC solution driver")
Signed-off-by: Kang Chen <void0red@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230227093037.907654-1-void0red@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/fdp/i2c.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index 5e300788be525..808d73050afd0 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -249,6 +249,9 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
 					   len, sizeof(**fw_vsc_cfg),
 					   GFP_KERNEL);
 
+		if (!*fw_vsc_cfg)
+			goto alloc_err;
+
 		r = device_property_read_u8_array(dev, FDP_DP_FW_VSC_CFG_NAME,
 						  *fw_vsc_cfg, len);
 
@@ -262,6 +265,7 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
 		*fw_vsc_cfg = NULL;
 	}
 
+alloc_err:
 	dev_dbg(dev, "Clock type: %d, clock frequency: %d, VSC: %s",
 		*clock_type, *clock_freq, *fw_vsc_cfg != NULL ? "yes" : "no");
 }
-- 
2.39.2




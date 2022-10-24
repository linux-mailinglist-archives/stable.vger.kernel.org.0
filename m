Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6851960AC4E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbiJXOFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236083AbiJXOC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:02:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB218BEFBC;
        Mon, 24 Oct 2022 05:48:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FADC61290;
        Mon, 24 Oct 2022 12:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FCAC433C1;
        Mon, 24 Oct 2022 12:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615724;
        bh=aZ6ttHHGOGHia7odYA/3lZSLUuPnotEhC2sJFerxf8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ywnka5hwYp15AlE6pb13+hI+ZEhxtCkp4jcSssQqgUzT7TANgqE9UC1sRMAB1SPmn
         +3uI4aLlK87RMCE8YVaau2WBAReryBuzeopj+0wPtEV7ckd+ZZzDejirtXG/wARnfx
         Iqu8Nj8DZtQD9+akltBOcL4eSaBDm2/u2oPkD5I0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 329/530] slimbus: qcom-ngd-ctrl: allow compile testing without QCOM_RPROC_COMMON
Date:   Mon, 24 Oct 2022 13:31:13 +0200
Message-Id: <20221024113059.899441448@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit e291691c69776ad278cd39dec2306dd39d681a9f ]

The Qualcomm common remote-proc code (CONFIG_QCOM_RPROC_COMMON) has
necessary stubs, so it is not needed for compile testing.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220916122910.170730-5-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 42992cf187e4 ("slimbus: qcom-ngd: Add error handling in of_qcom_slim_ngd_register")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/slimbus/Kconfig b/drivers/slimbus/Kconfig
index 1235b7dc8496..2ed821f75816 100644
--- a/drivers/slimbus/Kconfig
+++ b/drivers/slimbus/Kconfig
@@ -22,7 +22,8 @@ config SLIM_QCOM_CTRL
 
 config SLIM_QCOM_NGD_CTRL
 	tristate "Qualcomm SLIMbus Satellite Non-Generic Device Component"
-	depends on HAS_IOMEM && DMA_ENGINE && NET && QCOM_RPROC_COMMON
+	depends on HAS_IOMEM && DMA_ENGINE && NET
+	depends on QCOM_RPROC_COMMON || COMPILE_TEST
 	depends on ARCH_QCOM || COMPILE_TEST
 	select QCOM_QMI_HELPERS
 	select QCOM_PDR_HELPERS
-- 
2.35.1




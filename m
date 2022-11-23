Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B29C6358CC
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236458AbiKWKCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235568AbiKWKB3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:01:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EB411DA30
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:53:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1316B81EE5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA16C433D7;
        Wed, 23 Nov 2022 09:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197211;
        bh=IswDgvgDFdImhSWTVyWNNPKWvKVLcSsoGzYPx58NVec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=slgCLXSMui5IcTAt5pXuRpGzN/uosUGqWdxqs/zfnFwnD8/Pbaih4Xk6231ic1M1f
         tf2DsQ2SmQWJWHlWEFgogEO4IBxDgFyCyOA5NaO0Ophe6CEySMIQroePSM1VhmzMuM
         vl6QJvSHxdUl0JmxXv7AoGDbfYj3yJJrvgfG6xtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Zheng Bin <zhengbin13@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.0 229/314] slimbus: qcom-ngd: Fix build error when CONFIG_SLIM_QCOM_NGD_CTRL=y && CONFIG_QCOM_RPROC_COMMON=m
Date:   Wed, 23 Nov 2022 09:51:14 +0100
Message-Id: <20221123084635.895573433@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Bin <zhengbin13@huawei.com>

commit e54fad8044db18cc400df8d01bfb86cada08b7cb upstream.

If CONFIG_SLIM_QCOM_NGD_CTRL=y, CONFIG_QCOM_RPROC_COMMON=m, COMPILE_TEST=y,
bulding fails:

drivers/slimbus/qcom-ngd-ctrl.o: In function `qcom_slim_ngd_ctrl_probe':
qcom-ngd-ctrl.c:(.text+0x330): undefined reference to `qcom_register_ssr_notifier'
qcom-ngd-ctrl.c:(.text+0x5fc): undefined reference to `qcom_unregister_ssr_notifier'
drivers/slimbus/qcom-ngd-ctrl.o: In function `qcom_slim_ngd_remove':
qcom-ngd-ctrl.c:(.text+0x90c): undefined reference to `qcom_unregister_ssr_notifier'

Make SLIM_QCOM_NGD_CTRL depends on QCOM_RPROC_COMMON || (COMPILE_TEST && !QCOM_RPROC_COMMON) to fix this.

Fixes: e291691c6977 ("slimbus: qcom-ngd-ctrl: allow compile testing without QCOM_RPROC_COMMON")
Cc: stable <stable@kernel.org>
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20221027095904.3388959-1-zhengbin13@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/slimbus/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/slimbus/Kconfig
+++ b/drivers/slimbus/Kconfig
@@ -23,7 +23,7 @@ config SLIM_QCOM_CTRL
 config SLIM_QCOM_NGD_CTRL
 	tristate "Qualcomm SLIMbus Satellite Non-Generic Device Component"
 	depends on HAS_IOMEM && DMA_ENGINE && NET && QCOM_RPROC_COMMON
-	depends on ARCH_QCOM || COMPILE_TEST
+	depends on ARCH_QCOM || (COMPILE_TEST && !QCOM_RPROC_COMMON)
 	select QCOM_QMI_HELPERS
 	select QCOM_PDR_HELPERS
 	help



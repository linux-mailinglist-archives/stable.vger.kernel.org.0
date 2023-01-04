Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4159D65D84A
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239697AbjADQN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239798AbjADQMY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:12:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B34FB845
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:12:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B51F6179B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36193C433F0;
        Wed,  4 Jan 2023 16:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848741;
        bh=4nrrJXL858AwMG/Or6LI0YK+dxhHAV2ABZYLuxgQFPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J9A+y4Hr4DKm4QPhjTCsUT4on0MxcKpgLdygpMoWqdlHV2d8jiiZGSnjmEPtD2qqd
         Gn92lAGNrYVra6I+2EPzhcFzMdLY1I9gjcouhF3S6gXtQDa605NUsJ/BWTdisdbkMr
         t0GRk3En9MvDvQOsI4Iedi+0yFgEyHtNZcRdl+ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.0 007/177] soc: qcom: Select REMAP_MMIO for ICC_BWMON driver
Date:   Wed,  4 Jan 2023 17:04:58 +0100
Message-Id: <20230104160507.878742315@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit a84160fbf4f2c8c5ffa588e19ea8f92eabd7ad17 upstream.

ICC_BWMON driver uses REGMAP_MMIO for accessing the hardware registers.
So select the dependency in Kconfig. Without this, there will be errors
while building the driver with COMPILE_TEST only:

ERROR: modpost: "__devm_regmap_init_mmio_clk" [drivers/soc/qcom/icc-bwmon.ko] undefined!
make[1]: *** [scripts/Makefile.modpost:126: Module.symvers] Error 1
make: *** [Makefile:1944: modpost] Error 2

Cc: <stable@vger.kernel.org> # 6.0
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Fixes: b9c2ae6cac40 ("soc: qcom: icc-bwmon: Add bandwidth monitoring driver")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221129072022.41962-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
index a6164b2d7b25..ae504c43d9e7 100644
--- a/drivers/soc/qcom/Kconfig
+++ b/drivers/soc/qcom/Kconfig
@@ -237,6 +237,7 @@ config QCOM_ICC_BWMON
 	tristate "QCOM Interconnect Bandwidth Monitor driver"
 	depends on ARCH_QCOM || COMPILE_TEST
 	select PM_OPP
+	select REGMAP_MMIO
 	help
 	  Sets up driver monitoring bandwidth on various interconnects and
 	  based on that voting for interconnect bandwidth, adjusting their
-- 
2.39.0




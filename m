Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F0A60884A
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbiJVIN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbiJVILl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:11:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EEB15FF6E;
        Sat, 22 Oct 2022 00:54:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27D3260B82;
        Sat, 22 Oct 2022 07:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1F6C433C1;
        Sat, 22 Oct 2022 07:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425292;
        bh=aZ6ttHHGOGHia7odYA/3lZSLUuPnotEhC2sJFerxf8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2IS2yTh9Hg4feIzT/XWF6X3FLmOo+Wf4YycPnBN/zxr+bMdVwel15TuwdQC/3fJS3
         H6smE36Nht0mhbUTzATTTrlK4hKYshzUyvjHxY0CZ+QTb13f6+SZfyWgJqDMNwagpY
         +Rq04PhB1tTq9L46PfYLfB7o9tx3ZzBZuAM0QSq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 452/717] slimbus: qcom-ngd-ctrl: allow compile testing without QCOM_RPROC_COMMON
Date:   Sat, 22 Oct 2022 09:25:31 +0200
Message-Id: <20221022072518.262727257@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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




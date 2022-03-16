Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794B54DB298
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356470AbiCPOSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356560AbiCPOSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:18:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4461068F9C;
        Wed, 16 Mar 2022 07:16:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDF7561320;
        Wed, 16 Mar 2022 14:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C52C340E9;
        Wed, 16 Mar 2022 14:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440204;
        bh=ELbDzZfXH9ZECfPFd++clsp1UZWSr25KTNjhJvscR3Y=;
        h=From:To:Cc:Subject:Date:From;
        b=DyzYMEcRCcyMlJfB/zOJj169tjgAaT73FYDbLS6HW2PK69Ygl8Y7vfoNxYwSygOy1
         2bAI9ouGZ+wnruRcrx3SliNOe7WPpSSI1hiJQsVc6qqYJ1JTezPGJdjzLMFExSfE2I
         /dXyD7U8EROsx4EmtWMeUhmxlSNKehEBPPMWMKn4ckzyN8cBO6z2OsUSfw7OgDi6hO
         ShYo2So4Pweb1RdFigznsk5i5gGdqshuOnJG+piy4SrkCZRl7OlXdxuVqofAlLYJNr
         0Fu7hIsz3FG2kkErqeO72DQhPc9YXLO11Gh8e8naZAXKcGZ0Ueq+Zg/h5/d2acu14I
         F7VGXWTLueaLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steev Klimaszewski <steev@kali.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 01/12] arm64: dts: qcom: c630: disable crypto due to serror
Date:   Wed, 16 Mar 2022 10:16:25 -0400
Message-Id: <20220316141636.248324-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steev Klimaszewski <steev@kali.org>

[ Upstream commit 382e3e0eb6a83f1cf73d4dfa3448ade1ed721f22 ]

Disable the crypto block due to it causing an SError in qce_start() on
the C630, which happens upon every boot when cryptomanager tests are
enabled.

Signed-off-by: Steev Klimaszewski <steev@kali.org>
[bjorn: Reworked commit message]
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211105035235.2392-1-steev@kali.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
index e080c317b5e3..08d0e67751ed 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -618,3 +618,8 @@ &wifi {
 
 	qcom,snoc-host-cap-8bit-quirk;
 };
+
+&crypto {
+	/* FIXME: qce_start triggers an SError */
+	status= "disable";
+};
-- 
2.34.1


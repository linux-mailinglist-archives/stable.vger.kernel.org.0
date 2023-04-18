Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1236E63EB
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbjDRMoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbjDRMo3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:44:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2330115621
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:44:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B496F63374
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA222C433EF;
        Tue, 18 Apr 2023 12:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821868;
        bh=Rs1Lf/6xerP0nhHasfHfonk7pLvC2yJ/RHmR/8sYeOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s7C6qmSI15Qwm21FUBOUmvQu3I6rxLhv5mIvR+5tGkxhQ6SdCFc0SQWHaj2EtfNV5
         3ONRS21n6UqD4/FQ7DSDj04Bz3Ukug5hnLrk7foFNm0dGX0xqB817DMikttpJar3+G
         cGJa64G013YV/I8TsUNiwp33IZVfHMt513VxNZZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luca Weiss <luca@z3ntu.xyz>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/134] ARM: dts: qcom: apq8026-lg-lenok: add missing reserved memory
Date:   Tue, 18 Apr 2023 14:22:07 +0200
Message-Id: <20230418120315.471983667@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit ecd240875e877d78fd03efbc62292f550872df3f ]

Turns out these two memory regions also need to be avoided, otherwise
weird things will happen when Linux tries to use this memory.

Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230308-lenok-reserved-memory-v1-1-b8bf6ff01207@z3ntu.xyz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-apq8026-lg-lenok.dts | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8026-lg-lenok.dts b/arch/arm/boot/dts/qcom-apq8026-lg-lenok.dts
index 193569f0ca5f7..4bdadb7681c30 100644
--- a/arch/arm/boot/dts/qcom-apq8026-lg-lenok.dts
+++ b/arch/arm/boot/dts/qcom-apq8026-lg-lenok.dts
@@ -26,6 +26,16 @@
 	};
 
 	reserved-memory {
+		sbl_region: sbl@2f00000 {
+			reg = <0x02f00000 0x100000>;
+			no-map;
+		};
+
+		external_image_region: external-image@3100000 {
+			reg = <0x03100000 0x200000>;
+			no-map;
+		};
+
 		adsp_region: adsp@3300000 {
 			reg = <0x03300000 0x1400000>;
 			no-map;
-- 
2.39.2




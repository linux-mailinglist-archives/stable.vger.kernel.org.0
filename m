Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3ED6AE82E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjCGRN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbjCGRND (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:13:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700432E0E6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:08:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12B44B8199A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAEDC433EF;
        Tue,  7 Mar 2023 17:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208888;
        bh=m+EHSwfo3jDBS0VphbMVYNo9H5tOGVMOr8aavdunq70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SOlRr9Hf5KP6fRXjMCAr+jjVzcvoVi5KfQD58VVVq3VSu8sFImbwECyZjSsmRTMit
         l/u3dEnTX0Z9EulnKkVi7TmLV/kVPj2tC59US1FiAkD+oiKb2OrJ2f7GF7GnH+irZd
         gn6G7bK/bHo6MVhXZMGxtgEjYaC0z5RBpGbv7tm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bjorn Andersson <quic_bjorande@quicinc.com>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0042/1001] arm64: dts: qcom: sc8280xp: Vote for CX in USB controllers
Date:   Tue,  7 Mar 2023 17:46:54 +0100
Message-Id: <20230307170023.957511542@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Bjorn Andersson <quic_bjorande@quicinc.com>

[ Upstream commit fe07640280cd29ac2997a617a1fb5487feef9387 ]

Running GCC_USB30_*_MASTER_CLK at 200MHz requires CX at nominal level,
not doing so results in occasional lockups. This was previously hidden
by the fact that the display stack incorrectly voted for CX (instead of
MMCX).

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230112135117.3836655-1-quic_bjorande@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index d1bc0e60cfd47..8363e82369854 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -1863,6 +1863,7 @@ usb_0: usb@a6f8800 {
 					  "ss_phy_irq";
 
 			power-domains = <&gcc USB30_PRIM_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			resets = <&gcc GCC_USB30_PRIM_BCR>;
 
@@ -1917,6 +1918,7 @@ usb_1: usb@a8f8800 {
 					  "ss_phy_irq";
 
 			power-domains = <&gcc USB30_SEC_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			resets = <&gcc GCC_USB30_SEC_BCR>;
 
-- 
2.39.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75056AE80C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjCGRMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjCGRMN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:12:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDD495BDC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:07:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB2396150E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C09C433EF;
        Tue,  7 Mar 2023 17:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208804;
        bh=KV6P2fIkaMMDodaEL1/VPBkZHfq1xa68lpgfaVJT79o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4FBQbQLFHHyJnvjgh+7e+2MH25eN2XgBw1Y6np9SCCgMsolcigdCoAxDdY2END0y
         T4tIlUfIdeP7kSV1Goxh+8P+Qo4Twsm8dRBad/QkY7qvGr0xq5lcfVVOJcNhizXD5t
         aKzgvLZLFN8KFByh2De+sA+cK3uOnb5lD0v/4vzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luca Weiss <luca.weiss@fairphone.com>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0016/1001] arm64: dts: qcom: sm6350: Fix up the ramoops node
Date:   Tue,  7 Mar 2023 17:46:28 +0100
Message-Id: <20230307170022.849496886@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 3b2ff50da499178cc418f4b319e279d1b52958ed ]

Fix up the ramoops node to make it match bindings and style:

- remove "removed-dma-pool"
- don't pad size to 8 hex digits
- change cc-size to ecc-size so that it's used
- increase ecc-size from to 16
- remove the zeroed ftrace-size

Fixes: 5f82b9cda61e ("arm64: dts: qcom: Add SM6350 device tree")
Reported-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221210102600.589028-1-konrad.dybcio@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/qcom/sm6350.dtsi
index 43324bf291c30..00e43a0d2dd67 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -342,13 +342,12 @@ last_log_region: memory@ffbc0000 {
 		};
 
 		ramoops: ramoops@ffc00000 {
-			compatible = "removed-dma-pool", "ramoops";
-			reg = <0 0xffc00000 0 0x00100000>;
+			compatible = "ramoops";
+			reg = <0 0xffc00000 0 0x100000>;
 			record-size = <0x1000>;
 			console-size = <0x40000>;
-			ftrace-size = <0x0>;
 			msg-size = <0x20000 0x20000>;
-			cc-size = <0x0>;
+			ecc-size = <16>;
 			no-map;
 		};
 
-- 
2.39.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF726673F1
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbjALOBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:01:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234352AbjALOAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:00:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF2B53295
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:00:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E83C60C15
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB44C433EF;
        Thu, 12 Jan 2023 14:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532044;
        bh=WtZAXc5Egf1UunsDb5GUEiXIqTaTsmu1xJmUV254pls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h7znMZUrQXLV54EX8THpGO9RflWgiBnGsRhAfeqOdEdxSGOCRnJA+eiEhbcege6lp
         V3axbcAubhs+Ev0feL1kevHcXXprMhuetu7jNdD2MoSrhJVCxTbDTnGcr+A92x/94S
         d7SYzNZ2BLPx55FDUKdKAszWchFnpgM1qtTmLqGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Stephan Gerhold <stephan.gerhold@kernkonzept.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/783] arm64: dts: qcom: msm8916: Drop MSS fallback compatible
Date:   Thu, 12 Jan 2023 14:45:23 +0100
Message-Id: <20230112135524.520737254@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Stephan Gerhold <stephan.gerhold@kernkonzept.com>

[ Upstream commit ff02ac621634e82c0c34d02a79d402ae700cdfd0 ]

MSM8916 was originally using the "qcom,q6v5-pil" compatible for the
MSS remoteproc. Later it was decided to use SoC-specific compatibles
instead, so "qcom,msm8916-mss-pil" is now the preferred compatible.

Commit 60a05ed059a0 ("arm64: dts: qcom: msm8916: Add MSM8916-specific
compatibles to SCM/MSS") updated the MSM8916 device tree to make use of
the new compatible but still kept the old "qcom,q6v5-pil" as fallback.

This is inconsistent with other SoCs and conflicts with the description
in the binding documentation (which says that only one compatible should
be present). Also, it has no functional advantage since older kernels
could not handle this DT anyway (e.g. "power-domains" in the MSS node is
only supported by kernels that also support "qcom,msm8916-mss-pil").

Make this consistent with other SoCs by using only the
"qcom,msm8916-mss-pil" compatible.

Fixes: 60a05ed059a0 ("arm64: dts: qcom: msm8916: Add MSM8916-specific compatibles to SCM/MSS")
Signed-off-by: Stephan Gerhold <stephan.gerhold@kernkonzept.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220718140344.1831731-2-stephan.gerhold@kernkonzept.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index 291276a38d7c..c32e4a3833f2 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -1249,7 +1249,7 @@ spmi_bus: spmi@200f000 {
 		};
 
 		mpss: remoteproc@4080000 {
-			compatible = "qcom,msm8916-mss-pil", "qcom,q6v5-pil";
+			compatible = "qcom,msm8916-mss-pil";
 			reg = <0x04080000 0x100>,
 			      <0x04020000 0x040>;
 
-- 
2.35.1




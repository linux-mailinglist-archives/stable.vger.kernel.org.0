Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA122E4178
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391745AbgL1OIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:08:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:42886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391735AbgL1OIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:08:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5E8D2063A;
        Mon, 28 Dec 2020 14:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164501;
        bh=VTKFG8x/9ubRDJEHHfb2/5jIan0v6X/2BQC/NjlwyCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D0Vc3WFL0EmkoXnuew9+oqNj2vNqL9CBx3LLoDPth/bp2j2o5uGqbTKjoLXw2QHhz
         J+qrqH36skIqWA7Eqnqnf+BXuzReDxynMXKV/ENjOmkkf3nCfZFdJK5RIEVfmAB27f
         8HuOHBFfl+hN9Yh3rFyCbEruLqlG0D9n/BQzppPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 202/717] arm64: dts: qcom: sdm845: Limit ipa iommu streams
Date:   Mon, 28 Dec 2020 13:43:20 +0100
Message-Id: <20201228125030.656380195@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 95e6f8467c83c4074a6f6b47bad00653549ff90a ]

The Android and Windows firmware does not accept the use of 3 as a mask
to cover the IPA streams. But with 0x721 being related to WiFi and 0x723
being unsed the mapping can be reduced to just cover 0x720 and 0x722,
which is accepted.

Acked-by: Alex Elder <elder@linaro.org>
Tested-by: Alex Elder <elder@linaro.org>
Fixes: e9e89c45bfeb ("arm64: dts: sdm845: add IPA iommus property")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20201123052305.157686-1-bjorn.andersson@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 40e8c11f23ab0..f97f354af86f4 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2141,7 +2141,8 @@
 		ipa: ipa@1e40000 {
 			compatible = "qcom,sdm845-ipa";
 
-			iommus = <&apps_smmu 0x720 0x3>;
+			iommus = <&apps_smmu 0x720 0x0>,
+				 <&apps_smmu 0x722 0x0>;
 			reg = <0 0x1e40000 0 0x7000>,
 			      <0 0x1e47000 0 0x2000>,
 			      <0 0x1e04000 0 0x2c000>;
-- 
2.27.0




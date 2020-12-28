Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8076A2E415D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439490AbgL1PFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:05:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438379AbgL1OLO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:11:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8098F20731;
        Mon, 28 Dec 2020 14:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164634;
        bh=E1bQpI9RN96K7zvpzcbQ7/BxJFNvZGbMLZcbJivgd2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SuHJWSJLMhSupZmNvZ0/jr/jHQK5HXVby9emT73DWFE8vBXiMP2QJ+aICyuVNz0R5
         iUZt2iUswr6WJKoG+tlf+iOKnZ7Od8gL63BGVWw/04WyS46LNb2wkeE7GWbxGrfp2z
         B1rg7WPS+MMiqvuuI3UEGy26yvufiZjow9aIHI3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alex Elder <elder@linaro.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 213/717] arm64: dts: qcom: sc7180: limit IPA iommu streams
Date:   Mon, 28 Dec 2020 13:43:31 +0100
Message-Id: <20201228125031.176824661@linuxfoundation.org>
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

From: Alex Elder <elder@linaro.org>

[ Upstream commit 8f34831d3659d38f480fddccb76d84c6c3e0ac0b ]

Recently we learned that Android and Windows firmware don't seem to
like using 3 as an iommu mask value for IPA.  A simple fix was to
specify exactly the streams needed explicitly, rather than implying
a range with the mask.  Make the same change for the SC7180 platform.

See also:
  https://lore.kernel.org/linux-arm-msm/20201123052305.157686-1-bjorn.andersson@linaro.org/

Fixes: d82fade846aa8 ("arm64: dts: qcom: sc7180: add IPA information")
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Alex Elder <elder@linaro.org>
Link: https://lore.kernel.org/r/20201126015457.6557-2-elder@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index a02776ce77a10..c71f3afc1cc9f 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -1394,7 +1394,8 @@
 		ipa: ipa@1e40000 {
 			compatible = "qcom,sc7180-ipa";
 
-			iommus = <&apps_smmu 0x440 0x3>;
+			iommus = <&apps_smmu 0x440 0x0>,
+				 <&apps_smmu 0x442 0x0>;
 			reg = <0 0x1e40000 0 0x7000>,
 			      <0 0x1e47000 0 0x2000>,
 			      <0 0x1e04000 0 0x2c000>;
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FCA4917C0
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347778AbiARCmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:42:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54034 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240481AbiARCgm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:36:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4664D60A6B;
        Tue, 18 Jan 2022 02:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91190C36AE3;
        Tue, 18 Jan 2022 02:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473400;
        bh=0Q27arFmeWVA9KhKpkcrNms2J3ZrY9IzTiq3hzk3P+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HxWKz/39RtGOyQv9NjnoNgB2SRPPR7gWs4+d2BF9RkX5JebrhrZwHFybLhPRk826F
         NtOQUJ2xW5AsG4ayILqjX26X7sLomUqSuzSGrGXBbTrqauh59TCzIez5vAee0U3aiR
         F6rDBzYyd7CddRXTwX2ZenZBifFYzGGKDJSF8Jkj7gZZWGZRaO9Lsoh4NlNmfkVIFu
         xe4UO3Ksv92VA67gsf6qYHh9WEAfzCktv0LpvRvf7fo1rRvIDOmmPoTZ38qf2SNaul
         1RjY+S4ZBiowduowBKnf5vfN2xPk/4eB6fG9rB6N0EQpxIrv1tOryfalBIk7GEAFx/
         ze7ydi6/nAZqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Elder <elder@linaro.org>, David Heidelberg <david@ixit.cz>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 103/188] ARM: dts: qcom: sdx55: fix IPA interconnect definitions
Date:   Mon, 17 Jan 2022 21:30:27 -0500
Message-Id: <20220118023152.1948105-103-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit c0d6316c238b1bd743108bd4b08eda364f47c7c9 ]

The first two interconnects defined for IPA on the SDX55 SoC are
really two parts of what should be represented as a single path
between IPA and system memory.

Fix this by combining the "memory-a" and "memory-b" interconnects
into a single "memory" interconnect.

Reported-by: David Heidelberg <david@ixit.cz>
Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-sdx55.dtsi | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-sdx55.dtsi b/arch/arm/boot/dts/qcom-sdx55.dtsi
index 1e6ce035f76a9..b5b784c5c65e4 100644
--- a/arch/arm/boot/dts/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom-sdx55.dtsi
@@ -334,12 +334,10 @@ ipa: ipa@1e40000 {
 			clocks = <&rpmhcc RPMH_IPA_CLK>;
 			clock-names = "core";
 
-			interconnects = <&system_noc MASTER_IPA &system_noc SLAVE_SNOC_MEM_NOC_GC>,
-					<&mem_noc MASTER_SNOC_GC_MEM_NOC &mc_virt SLAVE_EBI_CH0>,
+			interconnects = <&system_noc MASTER_IPA &mc_virt SLAVE_EBI_CH0>,
 					<&system_noc MASTER_IPA &system_noc SLAVE_OCIMEM>,
 					<&mem_noc MASTER_AMPSS_M0 &system_noc SLAVE_IPA_CFG>;
-			interconnect-names = "memory-a",
-					     "memory-b",
+			interconnect-names = "memory",
 					     "imem",
 					     "config";
 
-- 
2.34.1


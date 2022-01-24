Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFE64994EC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389563AbiAXUts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:49:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40750 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388131AbiAXUiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:38:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9E19B81253;
        Mon, 24 Jan 2022 20:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA01EC340E8;
        Mon, 24 Jan 2022 20:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056690;
        bh=HIy2u0y7M5fy3vdbc5cARgsiZf/zd6A7vjYEMM4cDAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eakL+C5M+Rpf+fz9zHGdnHLzzibhAR6WDfoGw6HGHGuC4cx5SDQ5MGuO0x7YYh3iC
         6Z7WypI78mZrw79fbIISD1V1bF3ohURleobxu/BYdmMeYhjFyj96FsuK9Xz15PQr7E
         8luXl7D2dCfxiK1y4+OcYJVY8nfSgWn6WUDHHXhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 541/846] ARM: dts: qcom: sdx55: fix IPA interconnect definitions
Date:   Mon, 24 Jan 2022 19:40:58 +0100
Message-Id: <20220124184119.681627935@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -334,12 +334,10 @@
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




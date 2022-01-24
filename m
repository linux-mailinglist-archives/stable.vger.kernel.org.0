Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1589E49A3BA
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2368762AbiAYAAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846509AbiAXXQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:16:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CB9C0617B0;
        Mon, 24 Jan 2022 13:25:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DB47B80FA1;
        Mon, 24 Jan 2022 21:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FF0C340E4;
        Mon, 24 Jan 2022 21:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059510;
        bh=OLkQY0VqpEjqmsadHkfttEzD4OLRruEKHl2jmHWNBVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q6D14CEV7n50vz6/yI0ezWPfM3IhkRr4iFeaWfJUrycsrjqgBJMm4V//Gzs0LCc0w
         oMAbGiwK9eTKc04RICKZAodRhcOnIs84PWO+/KLseAntPzulAI6+6nD0COS4HK2t6/
         sY91pU9KKdf3IPKZbQjajVWq2bWSsOqreejhR+4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0639/1039] ARM: dts: qcom: sdx55: fix IPA interconnect definitions
Date:   Mon, 24 Jan 2022 19:40:28 +0100
Message-Id: <20220124184146.834483881@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 44526ad9d210b..eee2f63b9bbab 100644
--- a/arch/arm/boot/dts/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom-sdx55.dtsi
@@ -333,12 +333,10 @@
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33C86B46CC
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbjCJOqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbjCJOqe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:46:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7482110D300
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:46:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D14C6193B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562C6C433A0;
        Fri, 10 Mar 2023 14:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459578;
        bh=PDgynNgPYSYJb0HSd0akZq7H/XomGcJ67A9zQx4aUbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f81untEF+sPRPUdO5fxrwPHQaqgzaaDV+slNFzSmA68WnvCVhZ2OfRs+btibwU4p9
         moBSHYlIZjNIal8LA83s7vuOjwu4iWY4VV/BtBBoCnbHVWNBYQ3uIqlXVchQttiRpg
         ELkDsy+quUTgxpvGeJaUTy38/hYFAsF7591qzYVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Robert Marko <robimarko@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/529] arm64: dts: qcom: ipq8074: correct PCIe QMP PHY output clock names
Date:   Fri, 10 Mar 2023 14:32:43 +0100
Message-Id: <20230310133805.923765771@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

From: Robert Marko <robimarko@gmail.com>

[ Upstream commit 0e8b90c0256cf9c9589e2cee517dedc987a34355 ]

Current PCIe QMP PHY output name were changed in ("arm64: dts: qcom: Fix
IPQ8074 PCIe PHY nodes") however it did not account for the fact that GCC
driver is relying on the old names to match them as they are being used as
the parent for the gcc_pcie0_pipe_clk and gcc_pcie1_pipe_clk.

This broke parenting as GCC could not find the parent clock, so fix it by
changing to the names that driver is expecting.

Fixes: 942bcd33ed45 ("arm64: dts: qcom: Fix IPQ8074 PCIe PHY nodes")
Signed-off-by: Robert Marko <robimarko@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230113164449.906002-9-robimarko@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index 4ef364c010125..25f78c71e0105 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -192,7 +192,7 @@ pcie_phy0: phy@84200 {
 				#clock-cells = <0>;
 				clocks = <&gcc GCC_PCIE0_PIPE_CLK>;
 				clock-names = "pipe0";
-				clock-output-names = "pcie_0_pipe_clk";
+				clock-output-names = "pcie20_phy0_pipe_clk";
 			};
 		};
 
@@ -220,7 +220,7 @@ pcie_phy1: phy@8e200 {
 				#clock-cells = <0>;
 				clocks = <&gcc GCC_PCIE1_PIPE_CLK>;
 				clock-names = "pipe0";
-				clock-output-names = "pcie_1_pipe_clk";
+				clock-output-names = "pcie20_phy1_pipe_clk";
 			};
 		};
 
-- 
2.39.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371B96ECD08
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbjDXNUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbjDXNTy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:19:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86C74EC9
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:19:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 648FC621D9
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752D3C433EF;
        Mon, 24 Apr 2023 13:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342366;
        bh=6uNGSZLcOj53ZjPsgvxhUUTbUq6Yn3WOkMofCHIjpSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PIrOseiTZrU6y/6OgMVp01UTdqDhwbwQoB9+s0daj7SmcjPEfN6J13on8mz+c72WW
         b44XZMQyuY9Z4IuzV68bOTAFvPBCgmeImXmA47RpLdPKxLPQOdnXl2O7RmT7MaghX3
         fXUlcrVacJSHAUapN3j+3++K0/sz/s6OlGRjQjMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 02/73] arm64: dts: qcom: ipq8074-hk01: enable QMP device, not the PHY node
Date:   Mon, 24 Apr 2023 15:16:16 +0200
Message-Id: <20230424131129.126382277@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 72630ba422b70ea0874fc90d526353cf71c72488 ]

Correct PCIe PHY enablement to refer the QMP device nodes rather than
PHY device nodes. QMP nodes have 'status = "disabled"' property in the
ipq8074.dtsi, while PHY nodes do not correspond to the actual device and
do not have the status property.

Fixes: e8a7fdc505bb ("arm64: dts: ipq8074: qcom: Re-arrange dts nodes based on address")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230324021651.1799969-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074-hk01.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts b/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
index cc08dc4eb56a5..68698cdf56c46 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
+++ b/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
@@ -60,11 +60,11 @@
 	perst-gpio = <&tlmm 58 0x1>;
 };
 
-&pcie_phy0 {
+&pcie_qmp0 {
 	status = "okay";
 };
 
-&pcie_phy1 {
+&pcie_qmp1 {
 	status = "okay";
 };
 
-- 
2.39.2




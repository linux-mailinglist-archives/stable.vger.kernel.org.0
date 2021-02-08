Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD74313BF6
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 18:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235088AbhBHR7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 12:59:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233914AbhBHR6x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 12:58:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32EE864E8A;
        Mon,  8 Feb 2021 17:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807093;
        bh=kFmKTrabg5KPDv675yNUKA0/ZjWb5Rr9aKIU0/5y+ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=okP0NBK5SxCyihXW+Ds6O2/fikcHLkRO09MPBdY0+VSsS96Ei3rCmS7hnDxj4Qm9x
         JDT13gTHMfGSchT7y1eJ7lEbNUIUOHi/3xWqljJkSB/JU7pwTkrCUzHlQAqug23jtz
         xnYvozPBTgEK3h787zWmJILWTG47KYYJ4qCFEYjSGlyzWmqi6RYl8yjsinGNtth41x
         EZ5/LpQzEydKSYxBbV6Nv8OCCMfEjU4d9RFlPDjs/MsGJnaf5XUQek2pRdQcRyMkKc
         AMNDz0i7O6LEwqpqs+USCAuJO44SFeaU3xyyZjPG2l3ioJHK1n6mI/DXfxGMG0BAqQ
         tahbfc4LoFOXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 04/36] arm64: dts: qcom: sdm845: Reserve LPASS clocks in gcc
Date:   Mon,  8 Feb 2021 12:57:34 -0500
Message-Id: <20210208175806.2091668-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175806.2091668-1-sashal@kernel.org>
References: <20210208175806.2091668-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 93f2a11580a9732c1d90f9e01a7e9facc825658f ]

The GCC_LPASS_Q6_AXI_CLK and GCC_LPASS_SWAY_CLK clocks may not be
touched on a typical UEFI based SDM845 device, but when the kernel is
built with CONFIG_SDM_LPASSCC_845 this happens, unless they are marked
as protected-clocks in the DT.

This was done for the MTP and the Pocophone, but not for DB845c and the
Lenovo Yoga C630 - causing these to fail to boot if the LPASS clock
controller is enabled (which it typically isn't).

Tested-by: Vinod Koul <vkoul@kernel.org> #on db845c
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20201222001103.3112306-1-bjorn.andersson@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts           | 4 +++-
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index 7cc236575ee20..c0b93813ea9ac 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -415,7 +415,9 @@ &dsi0_phy {
 &gcc {
 	protected-clocks = <GCC_QSPI_CORE_CLK>,
 			   <GCC_QSPI_CORE_CLK_SRC>,
-			   <GCC_QSPI_CNOC_PERIPH_AHB_CLK>;
+			   <GCC_QSPI_CNOC_PERIPH_AHB_CLK>,
+			   <GCC_LPASS_Q6_AXI_CLK>,
+			   <GCC_LPASS_SWAY_CLK>;
 };
 
 &gpu {
diff --git a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
index 76a8c996d497f..5748a404062bb 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -245,7 +245,9 @@ &cdsp_pas {
 &gcc {
 	protected-clocks = <GCC_QSPI_CORE_CLK>,
 			   <GCC_QSPI_CORE_CLK_SRC>,
-			   <GCC_QSPI_CNOC_PERIPH_AHB_CLK>;
+			   <GCC_QSPI_CNOC_PERIPH_AHB_CLK>,
+			   <GCC_LPASS_Q6_AXI_CLK>,
+			   <GCC_LPASS_SWAY_CLK>;
 };
 
 &gpu {
-- 
2.27.0


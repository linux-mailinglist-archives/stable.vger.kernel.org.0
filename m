Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9746D31BCDF
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhBOPg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:36:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231238AbhBOPe5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:34:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BC1F64EBD;
        Mon, 15 Feb 2021 15:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403077;
        bh=mq1Qo8ZiUNVpDs+RDDKp6kECIl3RoQzYEWYOhFQ+T48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=swdgU4nAoOiD6c5gmjpEEri/DhKKS4rUrG/88OlODRdmsSSBhFLCw8l1e5PUJUZEs
         3bdWpczAs673yPAWZmMhcqAe2X+gdNndo9jVMATK7NZF8c3DJMM2Wx1Jw+WE/5FA92
         NpXrG5X7poAg1VlWMUSJskts3JMtxz8VyVaGLu5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/104] arm64: dts: qcom: sdm845: Reserve LPASS clocks in gcc
Date:   Mon, 15 Feb 2021 16:26:32 +0100
Message-Id: <20210215152720.104266598@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -415,7 +415,9 @@
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
index d70aae77a6e84..888dc23a530e6 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -245,7 +245,9 @@
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56403A0304
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236969AbhFHTLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:11:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237463AbhFHTJm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:09:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D741D6193E;
        Tue,  8 Jun 2021 18:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178091;
        bh=8HFm7bWYWOAEn0HMbL3rn6sn0A0RkwHpBHdj88AOiSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NaZuKFRN1aF8Y2ZV1AFwOL7DE20YX9Dhd0bMKcvy0R4tH9DKzGjU63sh8LnP0//zd
         Yn6LYWmnqhgXUooTzldwgZO60/Dx3PnR/Tt9hrKLeWxqXI7C1WBFfvh91dzEfbHubF
         9F9ZuxmyNNqY3NBt7eseJIRTuM5ks+MDu4THFudk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 073/161] arm64: dts: freescale: sl28: var1: fix RGMII clock and voltage
Date:   Tue,  8 Jun 2021 20:26:43 +0200
Message-Id: <20210608175947.918590624@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 52387bb9a4a75b88887383cb91d3995ae6f4044a ]

During hardware validation it was noticed that the clock isn't
continuously enabled when there is no link. This is because the 125MHz
clock is derived from the internal PLL which seems to go into some kind
of power-down mode every once in a while. The LS1028A expects a contiuous
clock. Thus enable the PLL all the time.

Also, the RGMII pad voltage is wrong, it was configured to 2.5V (that is
the VDDH regulator). The correct voltage is 1.8V, i.e. the VDDIO
regulator.

This fix is for the freescale/fsl-ls1028a-kontron-sl28-var1.dts.

Fixes: 642856097c18 ("arm64: dts: freescale: sl28: add variant 1")
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var1.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var1.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var1.dts
index 6c309b97587d..e8d31279b7a3 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var1.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var1.dts
@@ -46,7 +46,8 @@
 			eee-broken-100tx;
 			qca,clk-out-frequency = <125000000>;
 			qca,clk-out-strength = <AR803X_STRENGTH_FULL>;
-			vddio-supply = <&vddh>;
+			qca,keep-pll-enabled;
+			vddio-supply = <&vddio>;
 
 			vddio: vddio-regulator {
 				regulator-name = "VDDIO";
-- 
2.30.2




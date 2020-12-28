Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E94A2E65A3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393801AbgL1QDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:03:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:57580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390040AbgL1N3G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:29:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2085207FF;
        Mon, 28 Dec 2020 13:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162130;
        bh=FlzTVdfeAIfhwSOELVRFmkpMxcyFM22VR6n3mC0lpj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTRYGYPzb9aEd6Cg8XrQn06pQlqGLr8lSdmQW8RyLbg6QfnSIBVZ0ENmpvMECsjJD
         q3eYp2RqQKQlVKwQpgdEC7hV/n75Vpe0RI+1QEDcQ3Rf2Nwmfo//ph5lgFeb1kvlrc
         gD4FQgOpG0n0wdvTUiEfvGLam47qvQfjKsqH78dM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 198/346] arm64: dts: rockchip: Fix UART pull-ups on rk3328
Date:   Mon, 28 Dec 2020 13:48:37 +0100
Message-Id: <20201228124929.366470428@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 94dad6bed3c86c00050bf7c2b2ad6b630facae31 ]

For UARTs, the local pull-ups should be on the RX pin, not the TX pin.
UARTs transmit active-low, so a disconnected RX pin should be pulled
high instead of left floating to prevent noise being interpreted as
transmissions.

This gets rid of bogus sysrq events when the UART console is not
connected.

Fixes: 52e02d377a72 ("arm64: dts: rockchip: add core dtsi file for RK3328 SoCs")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20201204064805.6480-1-wens@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index 92186edefeb96..6be7c67584ba9 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -1085,8 +1085,8 @@
 
 		uart0 {
 			uart0_xfer: uart0-xfer {
-				rockchip,pins = <1 RK_PB1 1 &pcfg_pull_up>,
-						<1 RK_PB0 1 &pcfg_pull_none>;
+				rockchip,pins = <1 RK_PB1 1 &pcfg_pull_none>,
+						<1 RK_PB0 1 &pcfg_pull_up>;
 			};
 
 			uart0_cts: uart0-cts {
@@ -1104,8 +1104,8 @@
 
 		uart1 {
 			uart1_xfer: uart1-xfer {
-				rockchip,pins = <3 RK_PA4 4 &pcfg_pull_up>,
-						<3 RK_PA6 4 &pcfg_pull_none>;
+				rockchip,pins = <3 RK_PA4 4 &pcfg_pull_none>,
+						<3 RK_PA6 4 &pcfg_pull_up>;
 			};
 
 			uart1_cts: uart1-cts {
@@ -1123,15 +1123,15 @@
 
 		uart2-0 {
 			uart2m0_xfer: uart2m0-xfer {
-				rockchip,pins = <1 RK_PA0 2 &pcfg_pull_up>,
-						<1 RK_PA1 2 &pcfg_pull_none>;
+				rockchip,pins = <1 RK_PA0 2 &pcfg_pull_none>,
+						<1 RK_PA1 2 &pcfg_pull_up>;
 			};
 		};
 
 		uart2-1 {
 			uart2m1_xfer: uart2m1-xfer {
-				rockchip,pins = <2 RK_PA0 1 &pcfg_pull_up>,
-						<2 RK_PA1 1 &pcfg_pull_none>;
+				rockchip,pins = <2 RK_PA0 1 &pcfg_pull_none>,
+						<2 RK_PA1 1 &pcfg_pull_up>;
 			};
 		};
 
-- 
2.27.0




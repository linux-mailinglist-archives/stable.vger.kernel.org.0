Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76292E6715
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732347AbgL1NN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:13:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:42020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732339AbgL1NNz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:13:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4097622B37;
        Mon, 28 Dec 2020 13:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161194;
        bh=Ko5Trk69U5OhAZEh6OBXpcGJOYWf7FYQodG/7bqQcDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BV7SigYjDDkb2l4ve7KoZ5k7t2D0w4GChN/8r1ac3tezvEKpnc8bkwGWIYCT6+x90
         4mROVoP+OEllWC45Ay94UIiKPZicXSDc7w6KPvQmAyNp3D7YecthEtsk+fiF5tC9Es
         mPl0ttMuZ7Xzx8HVNnFTK8pJnXVkwzaJoYWTy7lM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 133/242] arm64: dts: rockchip: Fix UART pull-ups on rk3328
Date:   Mon, 28 Dec 2020 13:48:58 +0100
Message-Id: <20201228124911.250640540@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
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
index c34daae3c37c2..6c3684885fac0 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -1062,8 +1062,8 @@
 
 		uart0 {
 			uart0_xfer: uart0-xfer {
-				rockchip,pins = <1 RK_PB1 1 &pcfg_pull_up>,
-						<1 RK_PB0 1 &pcfg_pull_none>;
+				rockchip,pins = <1 RK_PB1 1 &pcfg_pull_none>,
+						<1 RK_PB0 1 &pcfg_pull_up>;
 			};
 
 			uart0_cts: uart0-cts {
@@ -1081,8 +1081,8 @@
 
 		uart1 {
 			uart1_xfer: uart1-xfer {
-				rockchip,pins = <3 RK_PA4 4 &pcfg_pull_up>,
-						<3 RK_PA6 4 &pcfg_pull_none>;
+				rockchip,pins = <3 RK_PA4 4 &pcfg_pull_none>,
+						<3 RK_PA6 4 &pcfg_pull_up>;
 			};
 
 			uart1_cts: uart1-cts {
@@ -1100,15 +1100,15 @@
 
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




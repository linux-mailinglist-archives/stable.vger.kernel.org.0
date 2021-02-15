Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2567131BCE9
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhBOPhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:37:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:49600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230453AbhBOPfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:35:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E6C764EC2;
        Mon, 15 Feb 2021 15:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403092;
        bh=OacHzyQb5NIOlw9iAIZebiEM6n386KbIu7OjnK5e/VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIhyA9GSuh11jyCFa672fXyQ37RTsPHY6gJ4gjAGu7zhOs51B/lJfzQIhNTRKsg1B
         lesrl/ExTkgYMrI4le9CiD7XdhxIab3rKYmIbfwg5UNZU4vQxDRIT70/5Ww/lYfLIM
         HwUozYswgkn2MxqNVCoUDhTNILGJB/4oB53lSWq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/104] arm64: dts: rockchip: Disable display for NanoPi R2S
Date:   Mon, 15 Feb 2021 16:26:37 +0100
Message-Id: <20210215152720.261108191@linuxfoundation.org>
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

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 74532de460ec664e5a725507d1b59aa9e4d40776 ]

NanoPi R2S is headless, so rightly does not enable any of the display
interface hardware, which currently provokes an obnoxious error in the
boot log from the fake DRM device failing to find anything to bind to.
It probably isn't *too* hard to obviate the fake device shenanigans
entirely with a bit of driver reshuffling, but for now let's just
disable it here to shut up the spurious error.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/c4553dfad1ad6792c4f22454c135ff55de77e2d6.1611186099.git.robin.murphy@arm.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts b/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts
index 2ee07d15a6e37..1eecad724f04c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts
@@ -114,6 +114,10 @@
 	cpu-supply = <&vdd_arm>;
 };
 
+&display_subsystem {
+	status = "disabled";
+};
+
 &gmac2io {
 	assigned-clocks = <&cru SCLK_MAC2IO>, <&cru SCLK_MAC2IO_EXT>;
 	assigned-clock-parents = <&gmac_clk>, <&gmac_clk>;
-- 
2.27.0




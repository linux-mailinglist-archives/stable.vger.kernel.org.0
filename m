Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4007731BCE5
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhBOPhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:37:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230513AbhBOPev (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:34:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F4CA64DA8;
        Mon, 15 Feb 2021 15:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403084;
        bh=XH8RG3/dYrRn0Yt1fi6H7EhblTlojXlcxEQdwJBlnkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8c+q6Pj01IdbmkmrGBo8mJroqJM4lcdR5QsvOTcjPBu/QGSzPs8bBQtlloa9PA2Z
         tRbBbb5mkCHJCDebz4STsPM18qZCNiHZa3xQd+wpy14kvxNHutzHQ33/kzpI9jcz2H
         iM8JLSVq3swa9vUeFjxz5fNi9pl+cjkrfBtSZ9aM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Jonker <jbx6244@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/104] arm64: dts: rockchip: remove interrupt-names property from rk3399 vdec node
Date:   Mon, 15 Feb 2021 16:26:34 +0100
Message-Id: <20210215152720.163829827@linuxfoundation.org>
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

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit 94a5400f8b966c91c49991bae41c2ef911b935ac ]

A test with the command below gives this error:
/arch/arm64/boot/dts/rockchip/rk3399-evb.dt.yaml: video-codec@ff660000:
'interrupt-names' does not match any of the regexes: 'pinctrl-[0-9]+'

The rkvdec driver gets it irq with help of the platform_get_irq()
function, so remove the interrupt-names property from the rk3399
vdec node.

make ARCH=arm64 dtbs_check
DT_SCHEMA_FILES=Documentation/devicetree/bindings/
media/rockchip,vdec.yaml

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/20210117181653.24886-1-jbx6244@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index 5df535ad4bbc3..7e69603fb41c0 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -1278,7 +1278,6 @@
 		compatible = "rockchip,rk3399-vdec";
 		reg = <0x0 0xff660000 0x0 0x400>;
 		interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH 0>;
-		interrupt-names = "vdpu";
 		clocks = <&cru ACLK_VDU>, <&cru HCLK_VDU>,
 			 <&cru SCLK_VDU_CA>, <&cru SCLK_VDU_CORE>;
 		clock-names = "axi", "ahb", "cabac", "core";
-- 
2.27.0




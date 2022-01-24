Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776F94990F7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353390AbiAXUIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:08:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43330 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352152AbiAXT5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:57:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB8B8B81215;
        Mon, 24 Jan 2022 19:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C34C340E5;
        Mon, 24 Jan 2022 19:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054228;
        bh=k/jaFgS3jdXQ+cUcP3Ir26Qm797Ulvmbkt2quYhZPXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EiVRB0/pgehPGxN8zYgj+emrt4ekQJbhQih6mY9VXO3sJsctpDDleFBHyct5t486+
         XCaFHOlMewCUD9y5XKDzwTwTajA7t5/6vm5LWyN+Tea3Esdaz7X8pLpnfmCXQUMExL
         HFRWSG5UCbqe7mbohq2Ni0lrEDU/N7ccGLQm82z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameer Pujar <spujar@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 287/563] arm64: tegra: Fix Tegra194 HDA {clock,reset}-names ordering
Date:   Mon, 24 Jan 2022 19:40:52 +0100
Message-Id: <20220124184034.378586170@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameer Pujar <spujar@nvidia.com>

[ Upstream commit 48f6e195039486bc303118948f49a9873acc888f ]

As per the HDA binding doc reorder {clock,reset}-names entries for
Tegra194. This also serves as a preparation for converting existing
binding doc to json-schema.

Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra194.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
index 9b5007e5f790f..815df654e6387 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -782,13 +782,13 @@
 			reg = <0x3510000 0x10000>;
 			interrupts = <GIC_SPI 161 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_HDA>,
-				 <&bpmp TEGRA194_CLK_HDA2CODEC_2X>,
-				 <&bpmp TEGRA194_CLK_HDA2HDMICODEC>;
-			clock-names = "hda", "hda2codec_2x", "hda2hdmi";
+				 <&bpmp TEGRA194_CLK_HDA2HDMICODEC>,
+				 <&bpmp TEGRA194_CLK_HDA2CODEC_2X>;
+			clock-names = "hda", "hda2hdmi", "hda2codec_2x";
 			resets = <&bpmp TEGRA194_RESET_HDA>,
-				 <&bpmp TEGRA194_RESET_HDA2CODEC_2X>,
-				 <&bpmp TEGRA194_RESET_HDA2HDMICODEC>;
-			reset-names = "hda", "hda2codec_2x", "hda2hdmi";
+				 <&bpmp TEGRA194_RESET_HDA2HDMICODEC>,
+				 <&bpmp TEGRA194_RESET_HDA2CODEC_2X>;
+			reset-names = "hda", "hda2hdmi", "hda2codec_2x";
 			power-domains = <&bpmp TEGRA194_POWER_DOMAIN_DISP>;
 			interconnects = <&mc TEGRA194_MEMORY_CLIENT_HDAR &emc>,
 					<&mc TEGRA194_MEMORY_CLIENT_HDAW &emc>;
-- 
2.34.1




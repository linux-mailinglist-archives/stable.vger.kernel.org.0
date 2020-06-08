Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355181F3080
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 03:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbgFIA7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:59:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbgFHXI3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:08:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 060F5208A9;
        Mon,  8 Jun 2020 23:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657709;
        bh=9bnpDbtIjXuK5hf81+Zi0XxGmFb2an6nsBRCwIBobCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XATXZLj1LjgZbm7pOW+9TTb198t7ZwvcBkubbigsJ/qMyKnmfBMoi8E3p19y2ZQ+e
         jP2fRcnqVPgGavZvXesT917K1BrRvz8B940Gf7PqQ+mN0lnTwdxuzj8MzSHdswYCoa
         /C//Dp+OpdIJ2HeKFKpeM79F7CT3Ua077+nJFApo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jitao Shi <jitao.shi@mediatek.com>, Rob Herring <robh@kernel.org>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 105/274] dt-bindings: display: mediatek: control dpi pins mode to avoid leakage
Date:   Mon,  8 Jun 2020 19:03:18 -0400
Message-Id: <20200608230607.3361041-105-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jitao Shi <jitao.shi@mediatek.com>

[ Upstream commit b0ff9b590733079f7f9453e5976a9dd2630949e3 ]

Add property "pinctrl-names" to swap pin mode between gpio and dpi mode.
Set the dpi pins to gpio mode and output-low to avoid leakage current
when dpi disabled.

Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Jitao Shi <jitao.shi@mediatek.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/display/mediatek/mediatek,dpi.txt   | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/display/mediatek/mediatek,dpi.txt b/Documentation/devicetree/bindings/display/mediatek/mediatek,dpi.txt
index 58914cf681b8..77def4456706 100644
--- a/Documentation/devicetree/bindings/display/mediatek/mediatek,dpi.txt
+++ b/Documentation/devicetree/bindings/display/mediatek/mediatek,dpi.txt
@@ -17,6 +17,9 @@ Required properties:
   Documentation/devicetree/bindings/graph.txt. This port should be connected
   to the input port of an attached HDMI or LVDS encoder chip.
 
+Optional properties:
+- pinctrl-names: Contain "default" and "sleep".
+
 Example:
 
 dpi0: dpi@1401d000 {
@@ -27,6 +30,9 @@ dpi0: dpi@1401d000 {
 		 <&mmsys CLK_MM_DPI_ENGINE>,
 		 <&apmixedsys CLK_APMIXED_TVDPLL>;
 	clock-names = "pixel", "engine", "pll";
+	pinctrl-names = "default", "sleep";
+	pinctrl-0 = <&dpi_pin_func>;
+	pinctrl-1 = <&dpi_pin_idle>;
 
 	port {
 		dpi0_out: endpoint {
-- 
2.25.1


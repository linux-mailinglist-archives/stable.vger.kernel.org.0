Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC9A441867
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbhKAJr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:47:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233957AbhKAJpU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:45:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F60C61100;
        Mon,  1 Nov 2021 09:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758998;
        bh=TyqDyT68/IFEjqBVz9kGc6sjcogYGLHexDIL88CdGcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oyHcdstVMiQuVK7m8Bu5+OI96F1qSYCq/3AiwMemAsTpztpNOGnohYcLFVcQp79ZK
         RY+fBLCFPX+XxTJxIoyLlIbCdPXsyTP6oHT+Df+gLyYOf99ONdqzHQtESUF2SbIoRM
         +nrHg+ILVnbi+0GN5xS2gEMDuzSX8HneLYiAl620=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.14 039/125] arm64: dts: imx8mm-kontron: Fix connection type for VSC8531 RGMII PHY
Date:   Mon,  1 Nov 2021 10:16:52 +0100
Message-Id: <20211101082540.572376676@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

commit 0b28c41e3c951ea3d4f012cfa9da5ebd6512cf6e upstream.

Previously we falsely relied on the PHY driver to unconditionally
enable the internal RX delay. Since the following fix for the PHY
driver this is not the case anymore:

commit 7b005a1742be ("net: phy: mscc: configure both RX and TX internal
delays for RGMII")

In order to enable the delay we need to set the connection type to
"rgmii-rxid". Without the RX delay the ethernet is not functional at
all.

Fixes: 8668d8b2e67f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
@@ -113,7 +113,7 @@
 &fec1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
-	phy-connection-type = "rgmii";
+	phy-connection-type = "rgmii-rxid";
 	phy-handle = <&ethphy>;
 	status = "okay";
 



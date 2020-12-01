Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82F02C9D49
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389289AbgLAJV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:21:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389299AbgLAJIm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:08:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB3BE221EB;
        Tue,  1 Dec 2020 09:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813707;
        bh=Cn32Zuo4z8/oRz45Vg0pjlickZnh85P66xMraAgY90Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0o+BRG23Sdejv81/XOKVIPZgxug3ph7o55JWARav7AUifm143bJN5cH/Twh4Kf4b8
         ww0Ac1FGITrhA1vPnTKrz/UhNqlRTYZ5ixOEQ0qkUwJAdKfILQIOQt7W0MKbZnyG0F
         5j2LkpfPE/ouO3hA9GrtjkfCMTiuXiu6peKlO/Do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.9 031/152] arm64: tegra: Correct the UART for Jetson Xavier NX
Date:   Tue,  1 Dec 2020 09:52:26 +0100
Message-Id: <20201201084715.977764308@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

commit 476e23f4c540949ac5ea4fad4f6f6fa0e2d41f42 upstream.

The Jetson Xavier NX board routes UARTA to the 40-pin header and UARTC
to a 12-pin debug header. The UARTs can be used by either the Tegra
Combined UART (TCU) driver or the Tegra 8250 driver. By default, the
TCU will use UARTC on Jetson Xavier NX. Currently, device-tree for
Xavier NX enables the TCU and the Tegra 8250 node for UARTC. Fix this
by disabling the Tegra 8250 node for UARTC and enabling the Tegra 8250
node for UARTA.

Fixes: 3f9efbbe57bc ("arm64: tegra: Add support for Jetson Xavier NX")
Cc: stable@vger.kernel.org
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/nvidia/tegra194-p3668-0000.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/nvidia/tegra194-p3668-0000.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194-p3668-0000.dtsi
@@ -54,7 +54,7 @@
 			status = "okay";
 		};
 
-		serial@c280000 {
+		serial@3100000 {
 			status = "okay";
 		};
 



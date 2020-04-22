Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4737D1B3FA6
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730325AbgDVKjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:39:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730195AbgDVKVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:21:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A09B620775;
        Wed, 22 Apr 2020 10:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550879;
        bh=WL3PbyBJMFw8o4KxrC8xipxehGC7bO8H7IF894iaawA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0YVG0KyDL6NkGc83XWZVPJ3EKrMf1qhFSzI2wNh8Rz4SaKNCNXB0QQcLyTZrbcvDo
         DlNXS+uBMMo381S7QnA/szUPBRlnn/wH/6OB1JPxYziN8tUCUiHdJmM+MLKBFdyIF/
         PAOEMQYPeELrIvzhoeuVHLX+cD0riSNlvlmBHYsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 012/166] ARM: dts: imx6: Use gpc for FEC interrupt controller to fix wake on LAN.
Date:   Wed, 22 Apr 2020 11:55:39 +0200
Message-Id: <20200422095049.576856427@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Fuzzey <martin.fuzzey@flowbird.group>

commit 4141f1a40fc0789f6fd4330e171e1edf155426aa upstream.

In order to wake from suspend by ethernet magic packets the GPC
must be used as intc does not have wakeup functionality.

But the FEC DT node currently uses interrupt-extended,
specificying intc, thus breaking WoL.

This problem is probably fallout from the stacked domain conversion
as intc used to chain to GPC.

So replace "interrupts-extended" by "interrupts" to use the default
parent which is GPC.

Fixes: b923ff6af0d5 ("ARM: imx6: convert GPC to stacked domains")

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx6qdl.dtsi |    5 ++---
 arch/arm/boot/dts/imx6qp.dtsi  |    1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -1039,9 +1039,8 @@
 				compatible = "fsl,imx6q-fec";
 				reg = <0x02188000 0x4000>;
 				interrupt-names = "int0", "pps";
-				interrupts-extended =
-					<&intc 0 118 IRQ_TYPE_LEVEL_HIGH>,
-					<&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <0 118 IRQ_TYPE_LEVEL_HIGH>,
+					     <0 119 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks IMX6QDL_CLK_ENET>,
 					 <&clks IMX6QDL_CLK_ENET>,
 					 <&clks IMX6QDL_CLK_ENET_REF>;
--- a/arch/arm/boot/dts/imx6qp.dtsi
+++ b/arch/arm/boot/dts/imx6qp.dtsi
@@ -77,7 +77,6 @@
 };
 
 &fec {
-	/delete-property/interrupts-extended;
 	interrupts = <0 118 IRQ_TYPE_LEVEL_HIGH>,
 		     <0 119 IRQ_TYPE_LEVEL_HIGH>;
 };



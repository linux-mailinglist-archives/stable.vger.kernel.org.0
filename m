Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059B82C07E4
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730965AbgKWMpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:45:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:58680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730960AbgKWMpO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:45:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C701620732;
        Mon, 23 Nov 2020 12:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135514;
        bh=UPaGgCww6vH2pt5wQbpdIBAiPafM9ztfYfb7Sz0Tnd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfxC2+06YxVzR9vwF+qrdvm/xgXEBNwQ9SkYntL9UF2LMPqe65EuCLgok6opcI0IB
         nJ2uXosyGrQS9uVvhsEH4ORJJJjcjwr4k2UQq2/v1fvR9IlAHP1PWNrVbS09D4Bm3K
         xler2OQd0CuD4dF3wi//vkzniETcVQH7dSQeLSWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 096/252] arm64: dts: imx8mm-beacon-som: Fix Choppy BT audio
Date:   Mon, 23 Nov 2020 13:20:46 +0100
Message-Id: <20201123121840.223983551@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 587258edd94c305077923ec458e04c032fca83e6 ]

When streaming bluetooth audio, the sound is choppy due to the
fact that the default baud rate of the HCI interface is too slow
to handle 16-bit stereo at 48KHz.

The Bluetooth chip is capable of up to 4M baud on the serial port,
so this patch sets the max-speed to 4000000 in order to properly
stream audio over the Bluetooth.

Fixes: 593816fa2f35 ("arm64: dts: imx: Add Beacon i.MX8m-Mini development kit")
Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
index 94911b1707ef2..09d757b3e3ce6 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
@@ -210,6 +210,7 @@
 		host-wakeup-gpios = <&gpio2 8 GPIO_ACTIVE_HIGH>;
 		device-wakeup-gpios = <&gpio2 7 GPIO_ACTIVE_HIGH>;
 		clocks = <&osc_32k>;
+		max-speed = <4000000>;
 		clock-names = "extclk";
 	};
 };
-- 
2.27.0




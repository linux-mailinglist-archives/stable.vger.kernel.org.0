Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3E2D81D2B
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbfHENVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:21:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730419AbfHENVC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:21:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BE872067D;
        Mon,  5 Aug 2019 13:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011261;
        bh=yi+x7RbmMs095tElme98utNqj5tUu/gIfIx36yBNeSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hUbZQKvl8oEh11xWVX6ykPraa1AbUAR/mjhQL9bIL9AU3hGdR/8lE/kaXLm2SucSg
         TP9AaPHjQu2vo7mMb60Bx/Ez0vafuFK7u4y10ojy4sxeyfzc2uZjbsnHoRslJS7XWH
         cFxbZN3Tzr4YFKAUZQBnXJNu54uA/qDTZP1JSlao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vicente Bergas <vicencb@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 025/131] arm64: dts: rockchip: Fix USB3 Type-C on rk3399-sapphire
Date:   Mon,  5 Aug 2019 15:01:52 +0200
Message-Id: <20190805124953.125844901@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e1d9149e8389f1690cdd4e4056766dd26488a0fe ]

Before this patch, the Type-C port on the Sapphire board is dead.
If setting the 'regulator-always-on' property to 'vcc5v0_typec0'
then the port works for about 4 seconds at start-up. This is a
sample trace with a memory stick plugged in:
1.- The memory stick LED lights on and kernel reports:
[    4.782999] scsi 0:0:0:0: Direct-Access USB DISK PMAP PQ: 0 ANSI: 4
[    5.904580] sd 0:0:0:0: [sdb] 3913344 512-byte logical blocks: (2.00 GB/1.87 GiB)
[    5.906860] sd 0:0:0:0: [sdb] Write Protect is off
[    5.908973] sd 0:0:0:0: [sdb] Mode Sense: 23 00 00 00
[    5.909122] sd 0:0:0:0: [sdb] No Caching mode page found
[    5.911214] sd 0:0:0:0: [sdb] Assuming drive cache: write through
[    5.951585]  sdb: sdb1
[    5.954816] sd 0:0:0:0: [sdb] Attached SCSI removable disk
2.- 4 seconds later the memory stick LED lights off and kernel reports:
[    9.082822] phy phy-ff770000.syscon:usb2-phy@e450.2: charger = USB_DCP_CHARGER
3.- After a minute the kernel reports:
[   71.666761] usb 5-1: USB disconnect, device number 2
It has been checked that, although the LED is off, VBUS is present.

If, instead, the dr_mode is changed to host and the phy-supply changed
accordingly, then it works. It has only been tested in host mode.

Signed-off-by: Vicente Bergas <vicencb@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi
index 04623e52ac5db..1bc1579674e57 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi
@@ -565,12 +565,11 @@
 	status = "okay";
 
 	u2phy0_otg: otg-port {
-		phy-supply = <&vcc5v0_typec0>;
 		status = "okay";
 	};
 
 	u2phy0_host: host-port {
-		phy-supply = <&vcc5v0_host>;
+		phy-supply = <&vcc5v0_typec0>;
 		status = "okay";
 	};
 };
@@ -620,7 +619,7 @@
 
 &usbdrd_dwc3_0 {
 	status = "okay";
-	dr_mode = "otg";
+	dr_mode = "host";
 };
 
 &usbdrd3_1 {
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B051844B68E
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbhKIW2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:28:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344473AbhKIW0s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:26:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5910E619F9;
        Tue,  9 Nov 2021 22:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496389;
        bh=M6aKZ9T5FKtso8ltx5RT1jq4WgxJaF4uumo4QS7copU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHIkN7e3FSx8l/Bq3YuN4vU0d8GchyUF7C7hSF6MJiT33AJxKlc+uejVb9G5XgWdc
         Mxq6QG0V300HIgtTFWN20RRJVgOd2iToIOKHZQn2PNE4lS1W8jVRoKc1XYdMxXK6oO
         sTQAZHBf1nEZAmhMjPOleRRCWBb0bNcgHhrcmpmVaaujTd7L1dHyKihOMoiRq1Udmc
         nDd5NukIP37aDRp986wUI1BDMoYcnBxwMjauG+XjEHiEEIdR7n4D3C0fXMpxQKsQ85
         hTeSwidnIswDDCmVxDmkK6HkZJr/jZm/xC4srAUqzTMViNvdqWohzF7x+sDpuPyLZs
         4PmdnHJQjnEbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 25/75] ARM: BCM53016: Specify switch ports for Meraki MR32
Date:   Tue,  9 Nov 2021 17:18:15 -0500
Message-Id: <20211109221905.1234094-25-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

[ Upstream commit 6abc4ca5a28070945e0d68cb4160b309bfbf4b8b ]

the switch identifies itself as a BCM53012 (rev 5)...
This patch has been tested & verified on OpenWrt's
snapshot with Linux 5.10 (didn't test any older kernels).
The MR32 is able to "talk to the network" as before with
OpenWrt's SWITCHDEV b53 driver.

| b53-srab-switch 18007000.ethernet-switch: found switch: BCM53012, rev 5
| libphy: dsa slave smi: probed
| b53-srab-switch 18007000.ethernet-switch poe (uninitialized):
|	PHY [dsa-0.0:00] driver [Generic PHY] (irq=POLL)
| b53-srab-switch 18007000.ethernet-switch: Using legacy PHYLIB callbacks.
|	Please migrate to PHYLINK!
| DSA: tree 0 setup

Reported-by: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm53016-meraki-mr32.dts | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/boot/dts/bcm53016-meraki-mr32.dts b/arch/arm/boot/dts/bcm53016-meraki-mr32.dts
index 3b978dc8997a4..1dbfa05b65015 100644
--- a/arch/arm/boot/dts/bcm53016-meraki-mr32.dts
+++ b/arch/arm/boot/dts/bcm53016-meraki-mr32.dts
@@ -195,3 +195,25 @@
 		};
 	};
 };
+
+&srab {
+	status = "okay";
+
+	ports {
+		port@0 {
+			reg = <0>;
+			label = "poe";
+		};
+
+		port@5 {
+			reg = <5>;
+			label = "cpu";
+			ethernet = <&gmac0>;
+
+			fixed-link {
+				speed = <1000>;
+				duplex-full;
+			};
+		};
+	};
+};
-- 
2.33.0


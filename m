Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680D545C428
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349436AbhKXNpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:45:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347943AbhKXNo3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:44:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82A15632DD;
        Wed, 24 Nov 2021 12:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758777;
        bh=anNM17j2qQ320cTbZ6Fs1UMAGeraF7RaUY0LOIlNUx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A72teeAEtJo8+t9TqmvUMZdPy9h2n9ZZdShsY09kcEl6UGpC6RRoDivszKeyl5KZB
         knhehg3phAMa2KGz01+j4AnMdwPtzt91Z7g5vsy0pSVuhNfIsuhCetbjE1p+0Yqvdq
         zC0yoN4wulXLmpNuOKuWgM2XISeP5VZ6W7aOzH10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/279] ARM: BCM53016: Specify switch ports for Meraki MR32
Date:   Wed, 24 Nov 2021 12:55:13 +0100
Message-Id: <20211124115719.649959394@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 612d61852bfb9..577a4dc604d93 100644
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




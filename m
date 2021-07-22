Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71793D29E9
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbhGVQHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:07:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhGVQGP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:06:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33F5861DB0;
        Thu, 22 Jul 2021 16:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972409;
        bh=atCHmd2+8/GACVK0I9+O61QtSMnHjd1iFC2leV6oMgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yDo93+d8Wr0GDWiqvaJHY8vhQeu2LD6oGCMi71OxdifpuMtRpBRZanogWBRMjp5CN
         wc2tkY5thdVOTmcuZ1Q7w0QlWN0pSV7Gs/xzhHL89TZ+kKlO4yTH15AT6yHvYkZFPH
         Ny4VHaeJsjMdt7MVGAnlWQLa3/0D8awSX+Ya+d1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 102/156] arm64: dts: marvell: armada-37xx: move firmware node to generic dtsi file
Date:   Thu, 22 Jul 2021 18:31:17 +0200
Message-Id: <20210722155631.672756224@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 3a52a48973b355b3aac5add92ef50650ae37c2bd ]

Move the turris-mox-rwtm firmware node from Turris MOX' device tree into
the generic armada-37xx.dtsi file and use the generic compatible string
'marvell,armada-3700-rwtm-firmware' instead of the current one.

Turris MOX DTS file contains also old compatible string for backward
compatibility.

The Turris MOX rWTM firmware can be used on any Armada 37xx device,
giving them access to the rWTM hardware random number generator, which
is otherwise unavailable.

This change allows Linux to load the turris-mox-rwtm.ko module on these
boards.

Tested on ESPRESSObin v5 with both default Marvell WTMI firmware and
CZ.NIC's firmware. With default WTMI firmware the turris-mox-rwtm fails
to probe, while with CZ.NIC's firmware it registers the HW random number
generator.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts | 6 ++----
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi           | 8 ++++++++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
index 53e817c5f6f3..ce2bcddf396f 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -109,10 +109,8 @@
 	};
 
 	firmware {
-		turris-mox-rwtm {
-			compatible = "cznic,turris-mox-rwtm";
-			mboxes = <&rwtm 0>;
-			status = "okay";
+		armada-3700-rwtm {
+			compatible = "marvell,armada-3700-rwtm-firmware", "cznic,turris-mox-rwtm";
 		};
 	};
 };
diff --git a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
index 6ffbb099fcac..5db81a416cd6 100644
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -504,4 +504,12 @@
 			};
 		};
 	};
+
+	firmware {
+		armada-3700-rwtm {
+			compatible = "marvell,armada-3700-rwtm-firmware";
+			mboxes = <&rwtm 0>;
+			status = "okay";
+		};
+	};
 };
-- 
2.30.2




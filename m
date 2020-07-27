Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A327B22F203
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbgG0ON3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730374AbgG0ON1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:13:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 174262073E;
        Mon, 27 Jul 2020 14:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859206;
        bh=W1kz7H0Zg4K77PouQ4bwaTC+6NDwjaCUYFCrs+r8C1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dV8CWNH/gAkilIAovRiWH8tQTE8xIe7mrzE3VWc7cwaMmXZ2hKjGycVDUrxLKXaTH
         G9r/ae6Sy7fegBPZS3kFh3uvNLA56292DAj9k1DOn1r9rIJfzplYBcxeSQi/bKFjcB
         ydXT2qDCTCq9hF3rWsOS6F2EKWvLU7R27hb3S+/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 020/138] ARM: dts: imx6qdl-gw551x: Do not use simple-audio-card,dai-link
Date:   Mon, 27 Jul 2020 16:03:35 +0200
Message-Id: <20200727134926.330762347@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit e52928e8d5c1c4837a0c6ec2068beea99defde8b ]

According to Documentation/devicetree/bindings/sound/simple-card.txt
the 'simple-audio-card,dai-link' may be omitted when the card has
only one DAI link, which is the case here.

Get rid of 'simple-audio-card,dai-link' in order to fix the following
build warning with W=1:

arch/arm/boot/dts/imx6qdl-gw551x.dtsi:109.32-121.5: Warning (unit_address_vs_reg): /sound-digital/simple-audio-card,dai-link@0: node has a unit name, but no reg property

Cc: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-gw551x.dtsi | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-gw551x.dtsi b/arch/arm/boot/dts/imx6qdl-gw551x.dtsi
index c23ba229fd057..c38e86eedcc01 100644
--- a/arch/arm/boot/dts/imx6qdl-gw551x.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-gw551x.dtsi
@@ -105,19 +105,16 @@
 	sound-digital {
 		compatible = "simple-audio-card";
 		simple-audio-card,name = "tda1997x-audio";
+		simple-audio-card,format = "i2s";
+		simple-audio-card,bitclock-master = <&sound_codec>;
+		simple-audio-card,frame-master = <&sound_codec>;
 
-		simple-audio-card,dai-link@0 {
-			format = "i2s";
-
-			cpu {
-				sound-dai = <&ssi2>;
-			};
+		sound_cpu: simple-audio-card,cpu {
+			sound-dai = <&ssi2>;
+		};
 
-			codec {
-				bitclock-master;
-				frame-master;
-				sound-dai = <&hdmi_receiver>;
-			};
+		sound_codec: simple-audio-card,codec {
+			sound-dai = <&hdmi_receiver>;
 		};
 	};
 };
-- 
2.25.1




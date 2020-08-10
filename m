Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C3A240E88
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729904AbgHJTN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:13:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729893AbgHJTN4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:13:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93FC122B49;
        Mon, 10 Aug 2020 19:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086835;
        bh=ZYzY6ErG/NfSQMyGO+ymxwRPG0Hb5eEKj9Iv+PmCo5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L7atsh4PWRP3j5M0E2fDvXXRP5x8IIfi6Z861pAoxDqOySxEPqKVIillUdwyCJ6Yv
         mcJpz8zcwqGP6ST4p+iJbjVRp2stDexQNNl+4BFBTjgaMmsZKVQNRIaTdl4U7k54UF
         TePh2q44ZO87MXX4lybeEODKPK0yXFqeTLpPA6+0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ricardo=20Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wei Xu <xuwei5@hisilicon.com>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 07/22] arm64: dts: hisilicon: hikey: fixes to comply with adi, adv7533 DT binding
Date:   Mon, 10 Aug 2020 15:13:29 -0400
Message-Id: <20200810191345.3795166-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191345.3795166-1-sashal@kernel.org>
References: <20200810191345.3795166-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Cañuelo <ricardo.canuelo@collabora.com>

[ Upstream commit bbe28fc3cbabbef781bcdf847615d52ce2e26e42 ]

hi3660-hikey960.dts:
  Define a 'ports' node for 'adv7533: adv7533@39' and the
  'adi,dsi-lanes' property to make it compliant with the adi,adv7533 DT
  binding.

  This fills the requirements to meet the binding requirements,
  remote endpoints are not defined.

hi6220-hikey.dts:
  Change property name s/pd-gpio/pd-gpios, gpio properties should be
  plural. This is just a cosmetic change.

Signed-off-by: Ricardo Cañuelo <ricardo.canuelo@collabora.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts | 11 +++++++++++
 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts    |  2 +-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts b/arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts
index e9f87cb61ade7..8587912e1eb00 100644
--- a/arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts
+++ b/arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts
@@ -210,6 +210,17 @@ adv7533: adv7533@39 {
 		status = "ok";
 		compatible = "adi,adv7533";
 		reg = <0x39>;
+		adi,dsi-lanes = <4>;
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			port@0 {
+				reg = <0>;
+			};
+			port@1 {
+				reg = <1>;
+			};
+		};
 	};
 };
 
diff --git a/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts b/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
index 6887cc1a743d4..f78e6468b02fc 100644
--- a/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
+++ b/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
@@ -513,7 +513,7 @@ adv7533: adv7533@39 {
 		reg = <0x39>;
 		interrupt-parent = <&gpio1>;
 		interrupts = <1 2>;
-		pd-gpio = <&gpio0 4 0>;
+		pd-gpios = <&gpio0 4 0>;
 		adi,dsi-lanes = <4>;
 		#sound-dai-cells = <0>;
 
-- 
2.25.1


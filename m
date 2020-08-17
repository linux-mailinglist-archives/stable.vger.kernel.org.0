Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A5F247130
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390908AbgHQSVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388255AbgHQQDl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:03:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 204B4206FA;
        Mon, 17 Aug 2020 16:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680220;
        bh=zHckG6m84Zqzd5VIOruZMFe/2Q7NFzcOkZYzhVCARjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ePs8SNWi5E8vq3w3+F8yI0P08Z6iJ3saecNfdL616WTb2ZveBZobOVtfYVhWrmZkA
         jlMbSjgZ1b+Nn7Qdi3Z41adGDFBBRuF6SZTlaj9GYbJ9M5EEbp59pS7yY6JlS4rJRA
         rU5k7R9CY3MSXN34Vq6wQnZwl87RPfex7W5tGwSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ricardo=20Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wei Xu <xuwei5@hisilicon.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/270] arm64: dts: hisilicon: hikey: fixes to comply with adi, adv7533 DT binding
Date:   Mon, 17 Aug 2020 17:14:20 +0200
Message-Id: <20200817143758.713045200@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e035cf195b19a..8c4bfbaf3a806 100644
--- a/arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts
+++ b/arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts
@@ -530,6 +530,17 @@ adv7533: adv7533@39 {
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
index c14205cd6bf5c..3e47150c05ec2 100644
--- a/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
+++ b/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
@@ -516,7 +516,7 @@ adv7533: adv7533@39 {
 		reg = <0x39>;
 		interrupt-parent = <&gpio1>;
 		interrupts = <1 2>;
-		pd-gpio = <&gpio0 4 0>;
+		pd-gpios = <&gpio0 4 0>;
 		adi,dsi-lanes = <4>;
 		#sound-dai-cells = <0>;
 
-- 
2.25.1




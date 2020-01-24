Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3579D14843D
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390284AbgAXLSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:18:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:55130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390597AbgAXLSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:18:07 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2656B20708;
        Fri, 24 Jan 2020 11:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864686;
        bh=yUGQT0hdXqNofaKXUEwZXH80Ej3LJIWMoag+7cI4x8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p6Tpr8lOemR+XCvZ/9jTEUg09kekUL0npnQZHVnalpooOWAnw6GF9T3aZUb0Qxe0X
         pBPgH6ZGVAerTpBXXr1cvpg1A4pR/JogHgvQgbvm+diu0W+jiPhV1NkL5/2XXRuGTZ
         J5zudKKSHaI8ctYw49YFcnNQ+JCOPx9/THwhX3s4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 337/639] ARM: dts: logicpd-som-lv: Fix MMC1 card detect
Date:   Fri, 24 Jan 2020 10:28:27 +0100
Message-Id: <20200124093129.331241490@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 6a38df676a0a06bfc7ff8607ac62ccd6d95969ad ]

The card detect pin was incorrectly using IRQ_TYPE_LEVEL_LOW
instead of GPIO_ACTIVE_LOW when reading the state of the CD pin.

This was previosly fixed on Torpedo, but missed on the SOM-LV

Fixes: 5cb8b0fa55a9 ("ARM: dts: Move most of logicpd-som-lv-37xx-devkit.dts to logicpd-som-lv-baseboard.dtsi")
Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi b/arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi
index 4990ed90dcea4..3e39b9a1f35d0 100644
--- a/arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi
+++ b/arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi
@@ -153,7 +153,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc1_pins>;
 	wp-gpios = <&gpio4 30 GPIO_ACTIVE_HIGH>;		/* gpio_126 */
-	cd-gpios = <&gpio4 14 IRQ_TYPE_LEVEL_LOW>;		/* gpio_110 */
+	cd-gpios = <&gpio4 14 GPIO_ACTIVE_LOW>;			/* gpio_110 */
 	vmmc-supply = <&vmmc1>;
 	bus-width = <4>;
 	cap-power-off-card;
-- 
2.20.1




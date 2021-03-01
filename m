Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18EEB328E39
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbhCAT0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:26:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:46142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240910AbhCATVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:21:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5582C652C1;
        Mon,  1 Mar 2021 17:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620197;
        bh=B8xcsFFER3jXb57qBy0FUCVsaG1FopeY8Mu47l7l6dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IyuIZuhGs9VF+OwU4JJx6MU2mNqe0y3+2EQx9ivQDonrwF1IGbQ8KS4cmYPuzC+90
         Bm/HXJ/5cFVY/9XJczmzJeVevsrTVaYKZr7Ao00ywF6JbY5j3aCCEQ6B4/4XuCzCRB
         iK1JjLVVF4Lzx0REjRKbBPZsMl49+B32PpGmv+XU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carl Philipp Klemm <philipp@uvos.xyz>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Eduardo Valentin <edubezval@gmail.com>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Pavel Machek <pavel@ucw.cz>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 064/775] ARM: dts: Configure missing thermal interrupt for 4430
Date:   Mon,  1 Mar 2021 17:03:52 +0100
Message-Id: <20210301161204.845189077@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 44f416879a442600b006ef7dec3a6dc98bcf59c6 ]

We have gpio_86 wired internally to the bandgap thermal shutdown
interrupt on 4430 like we have it on 4460 according to the TRM.
This can be found easily by searching for TSHUT.

For some reason the thermal shutdown interrupt was never added
for 4430, let's add it. I believe this is needed for the thermal
shutdown interrupt handler ti_bandgap_tshut_irq_handler() to call
orderly_poweroff().

Fixes: aa9bb4bb8878 ("arm: dts: add omap4430 thermal data")
Cc: Carl Philipp Klemm <philipp@uvos.xyz>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Cc: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap443x.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/omap443x.dtsi b/arch/arm/boot/dts/omap443x.dtsi
index cb309743de5da..dd8ef58cbaed4 100644
--- a/arch/arm/boot/dts/omap443x.dtsi
+++ b/arch/arm/boot/dts/omap443x.dtsi
@@ -33,10 +33,12 @@
 	};
 
 	ocp {
+		/* 4430 has only gpio_86 tshut and no talert interrupt */
 		bandgap: bandgap@4a002260 {
 			reg = <0x4a002260 0x4
 			       0x4a00232C 0x4>;
 			compatible = "ti,omap4430-bandgap";
+			gpios = <&gpio3 22 GPIO_ACTIVE_HIGH>;
 
 			#thermal-sensor-cells = <0>;
 		};
-- 
2.27.0




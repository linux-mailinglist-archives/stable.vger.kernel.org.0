Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 958ED121861
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbfLPR7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:59:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:60938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbfLPR7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:59:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6877D206B7;
        Mon, 16 Dec 2019 17:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519177;
        bh=+KemWMjYWqW5eB6SarUG9NR0qSuKGeP0JUY4NkGsTYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HMHFhTyv/gHFxKH4QiYDR9drRMM1gfLMkve1poOZsGdmYUUXQ4gKF3aVJfsJv1vrK
         HbR7r+100Tfxhp0GQU51xLe5AldxGF2KDt67O0l5QSQV/ILEEEuMkVytSYj/nlJSP8
         Pk8baBFj/oKzheDdELtZ01tr+6Z76di1mL8iQ10g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4.14 225/267] ARM: dts: omap3-tao3530: Fix incorrect MMC card detection GPIO polarity
Date:   Mon, 16 Dec 2019 18:49:11 +0100
Message-Id: <20191216174914.882537948@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@bitmer.com>

commit 287897f9aaa2ad1c923d9875914f57c4dc9159c8 upstream.

The MMC card detection GPIO polarity is active low on TAO3530, like in many
other similar boards. Now the card is not detected and it is unable to
mount rootfs from an SD card.

Fix this by using the correct polarity.

This incorrect polarity was defined already in the commit 30d95c6d7092
("ARM: dts: omap3: Add Technexion TAO3530 SOM omap3-tao3530.dtsi") in v3.18
kernel and later changed to use defined GPIO constants in v4.4 kernel by
the commit 3a637e008e54 ("ARM: dts: Use defined GPIO constants in flags
cell for OMAP2+ boards").

While the latter commit did not introduce the issue I'm marking it with
Fixes tag due the v4.4 kernels still being maintained.

Fixes: 3a637e008e54 ("ARM: dts: Use defined GPIO constants in flags cell for OMAP2+ boards")
Cc: linux-stable <stable@vger.kernel.org> # 4.4+
Signed-off-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/omap3-tao3530.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/omap3-tao3530.dtsi
+++ b/arch/arm/boot/dts/omap3-tao3530.dtsi
@@ -224,7 +224,7 @@
 	pinctrl-0 = <&mmc1_pins>;
 	vmmc-supply = <&vmmc1>;
 	vqmmc-supply = <&vsim>;
-	cd-gpios = <&twl_gpio 0 GPIO_ACTIVE_HIGH>;
+	cd-gpios = <&twl_gpio 0 GPIO_ACTIVE_LOW>;
 	bus-width = <8>;
 };
 



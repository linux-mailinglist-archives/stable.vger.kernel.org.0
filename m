Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCCA9507FB
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730260AbfFXKMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729999AbfFXKFu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:05:50 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 279A3213F2;
        Mon, 24 Jun 2019 10:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370749;
        bh=TTW5Nkeyvf2jF7NMFvKERC/B1WxDwj5qrlsRrLpSqo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gEANnt7DdIU3kIJ0JyJAA7uvVFU2BoXaW4/3dDe8h6ZyxGNLohAuFyOqbNdIZSN5c
         g3o2qwoWbaTM0g0E4b8zqkV+xUGqo2EH4uWP1d0d1HpiuVBkEVyoCM+xMmarMa56o0
         x0Ng3jNoGwsAwgdNZRZfGeWRT7z4ywH7AX/ngVQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Faiz Abbas <faiz_abbas@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4.19 76/90] ARM: dts: am57xx-idk: Remove support for voltage switching for SD card
Date:   Mon, 24 Jun 2019 17:57:06 +0800
Message-Id: <20190624092318.951732384@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

commit 88a748419b84187fd1da05637b8e5928b04a1e06 upstream.

If UHS speed modes are enabled, a compatible SD card switches down to
1.8V during enumeration. If after this a software reboot/crash takes
place and on-chip ROM tries to enumerate the SD card, the difference in
IO voltages (host @ 3.3V and card @ 1.8V) may end up damaging the card.

The fix for this is to have support for power cycling the card in
hardware (with a PORz/soft-reset line causing a power cycle of the
card). Since am571x-, am572x- and am574x-idk don't have this
capability, disable voltage switching for these boards.

The major effect of this is that the maximum supported speed
mode is now high speed(50 MHz) down from SDR104(200 MHz).

Cc: <stable@vger.kernel.org>
Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/am57xx-idk-common.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/am57xx-idk-common.dtsi
+++ b/arch/arm/boot/dts/am57xx-idk-common.dtsi
@@ -410,6 +410,7 @@
 	vqmmc-supply = <&ldo1_reg>;
 	bus-width = <4>;
 	cd-gpios = <&gpio6 27 GPIO_ACTIVE_LOW>; /* gpio 219 */
+	no-1-8-v;
 };
 
 &mmc2 {



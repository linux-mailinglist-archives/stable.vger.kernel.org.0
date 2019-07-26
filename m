Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D648076ADA
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 16:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfGZNjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:39:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbfGZNjj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:39:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19B4722BEF;
        Fri, 26 Jul 2019 13:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148378;
        bh=vNz5ZA4xgYaIQ+rZoEpIu5Ec75bCDhG5YgSO6984J2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zuetk+Oi+8Lv7Mu9molHwZH1pLdeAilalto0jShWvGF5jlKcvCtbsOK7PbWNnuvWD
         90mgnEl25OkeJvLFoHkRxdDMJTpMOJ7HD2LTNxwQ8xwT1paNE7r8Fd1/Eiz5aC9FMa
         zYBQOe98SeqG5ZDM3o+0b+7xLurzQHtxvSk24/jg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 02/85] ARM: dts: rockchip: Make rk3288-veyron-minnie run at hs200
Date:   Fri, 26 Jul 2019 09:38:12 -0400
Message-Id: <20190726133936.11177-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 1c0479023412ab7834f2e98b796eb0d8c627cd62 ]

As some point hs200 was failing on rk3288-veyron-minnie.  See commit
984926781122 ("ARM: dts: rockchip: temporarily remove emmc hs200 speed
from rk3288 minnie").  Although I didn't track down exactly when it
started working, it seems to work OK now, so let's turn it back on.

To test this, I booted from SD card and then used this script to
stress the enumeration process after fixing a memory leak [1]:
  cd /sys/bus/platform/drivers/dwmmc_rockchip
  for i in $(seq 1 3000); do
    echo "========================" $i
    echo ff0f0000.dwmmc > unbind
    sleep .5
    echo ff0f0000.dwmmc > bind
    while true; do
      if [ -e /dev/mmcblk2 ]; then
        break;
      fi
      sleep .1
    done
  done

It worked fine.

[1] https://lkml.kernel.org/r/20190503233526.226272-1-dianders@chromium.org

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3288-veyron-minnie.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/boot/dts/rk3288-veyron-minnie.dts b/arch/arm/boot/dts/rk3288-veyron-minnie.dts
index 468a1818545d..ce57881625ec 100644
--- a/arch/arm/boot/dts/rk3288-veyron-minnie.dts
+++ b/arch/arm/boot/dts/rk3288-veyron-minnie.dts
@@ -90,10 +90,6 @@
 	pwm-off-delay-ms = <200>;
 };
 
-&emmc {
-	/delete-property/mmc-hs200-1_8v;
-};
-
 &gpio_keys {
 	pinctrl-0 = <&pwr_key_l &ap_lid_int_l &volum_down_l &volum_up_l>;
 
-- 
2.20.1


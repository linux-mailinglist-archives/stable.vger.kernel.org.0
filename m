Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECADA7686E
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388371AbfGZNoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:44:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388360AbfGZNog (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:44:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA3C322CEB;
        Fri, 26 Jul 2019 13:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148675;
        bh=AG13s3HdxuZRKVRsb0ywcmrGYozXwPlhLeYJUXH+RFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUsE9MrD88mV+15H341vcJ0SdTtTnXLEb2NGvMAgaSTg7q995K21GQ99433DrBswa
         9n7e6VnPbg2V3Hn/oyj8AgbWK0692zq5miudCU4XT74AeIvGlh38kPQHFdrnv3N7nC
         /RsTBCSdijRolrGYJkefsO8o9/KDtQhzMff7bu+o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 02/30] ARM: dts: rockchip: Make rk3288-veyron-minnie run at hs200
Date:   Fri, 26 Jul 2019 09:44:04 -0400
Message-Id: <20190726134432.12993-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726134432.12993-1-sashal@kernel.org>
References: <20190726134432.12993-1-sashal@kernel.org>
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
index f72d616d1bf8..9647d9b6b299 100644
--- a/arch/arm/boot/dts/rk3288-veyron-minnie.dts
+++ b/arch/arm/boot/dts/rk3288-veyron-minnie.dts
@@ -125,10 +125,6 @@
 	power-supply = <&backlight_regulator>;
 };
 
-&emmc {
-	/delete-property/mmc-hs200-1_8v;
-};
-
 &gpio_keys {
 	pinctrl-0 = <&pwr_key_l &ap_lid_int_l &volum_down_l &volum_up_l>;
 
-- 
2.20.1


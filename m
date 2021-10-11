Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98837428F3C
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237742AbhJKN43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:56:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235476AbhJKNyb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:54:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E0BF60F11;
        Mon, 11 Oct 2021 13:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960336;
        bh=4FxJVdVhKieCEydt0c2Cf/EXCXYWRYaRt97o9ypkH2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UquVYUaOQmHcLnF5KBgzHXBCdMFyJUJ/x/CtfnTlfac7Af/jmS9pdJ9iFIEKNMzSh
         VKfhLUrtRYL9AliEngTQaWTBFOSdPfBepJbykN28eOudKl+hUkY+//s52DiiaqjXU4
         gTiGRp467Q7g4J+LRff8jEXFY4ZfH8IN/5PpmfDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 30/83] ath5k: fix building with LEDS=m
Date:   Mon, 11 Oct 2021 15:45:50 +0200
Message-Id: <20211011134509.408152192@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit fb8c3a3c52400512fc8b3b61150057b888c30b0d ]

Randconfig builds still show a failure for the ath5k driver,
similar to the one that was fixed for ath9k earlier:

WARNING: unmet direct dependencies detected for MAC80211_LEDS
  Depends on [n]: NET [=y] && WIRELESS [=y] && MAC80211 [=y] && (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=MAC80211 [=y])
  Selected by [m]:
  - ATH5K [=m] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_ATH [=y] && (PCI [=y] || ATH25) && MAC80211 [=y]
net/mac80211/led.c: In function 'ieee80211_alloc_led_names':
net/mac80211/led.c:34:22: error: 'struct led_trigger' has no member named 'name'
   34 |         local->rx_led.name = kasprintf(GFP_KERNEL, "%srx",
      |                      ^

Copying the same logic from my ath9k patch makes this one work
as well, stubbing out the calls to the LED subsystem.

Fixes: b64acb28da83 ("ath9k: fix build error with LEDS_CLASS=m")
Fixes: 72cdab808714 ("ath9k: Do not select MAC80211_LEDS by default")
Fixes: 3a078876caee ("ath5k: convert LED code to use mac80211 triggers")
Link: https://lore.kernel.org/all/20210722105501.1000781-1-arnd@kernel.org/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210920122359.353810-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath5k/Kconfig |  4 +---
 drivers/net/wireless/ath/ath5k/led.c   | 10 ++++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/Kconfig b/drivers/net/wireless/ath/ath5k/Kconfig
index f35cd8de228e..6914b37bb0fb 100644
--- a/drivers/net/wireless/ath/ath5k/Kconfig
+++ b/drivers/net/wireless/ath/ath5k/Kconfig
@@ -3,9 +3,7 @@ config ATH5K
 	tristate "Atheros 5xxx wireless cards support"
 	depends on (PCI || ATH25) && MAC80211
 	select ATH_COMMON
-	select MAC80211_LEDS
-	select LEDS_CLASS
-	select NEW_LEDS
+	select MAC80211_LEDS if LEDS_CLASS=y || LEDS_CLASS=MAC80211
 	select ATH5K_AHB if ATH25
 	select ATH5K_PCI if !ATH25
 	help
diff --git a/drivers/net/wireless/ath/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
index 6a2a16856763..33e9928af363 100644
--- a/drivers/net/wireless/ath/ath5k/led.c
+++ b/drivers/net/wireless/ath/ath5k/led.c
@@ -89,7 +89,8 @@ static const struct pci_device_id ath5k_led_devices[] = {
 
 void ath5k_led_enable(struct ath5k_hw *ah)
 {
-	if (test_bit(ATH_STAT_LEDSOFT, ah->status)) {
+	if (IS_ENABLED(CONFIG_MAC80211_LEDS) &&
+	    test_bit(ATH_STAT_LEDSOFT, ah->status)) {
 		ath5k_hw_set_gpio_output(ah, ah->led_pin);
 		ath5k_led_off(ah);
 	}
@@ -104,7 +105,8 @@ static void ath5k_led_on(struct ath5k_hw *ah)
 
 void ath5k_led_off(struct ath5k_hw *ah)
 {
-	if (!test_bit(ATH_STAT_LEDSOFT, ah->status))
+	if (!IS_ENABLED(CONFIG_MAC80211_LEDS) ||
+	    !test_bit(ATH_STAT_LEDSOFT, ah->status))
 		return;
 	ath5k_hw_set_gpio(ah, ah->led_pin, !ah->led_on);
 }
@@ -146,7 +148,7 @@ ath5k_register_led(struct ath5k_hw *ah, struct ath5k_led *led,
 static void
 ath5k_unregister_led(struct ath5k_led *led)
 {
-	if (!led->ah)
+	if (!IS_ENABLED(CONFIG_MAC80211_LEDS) || !led->ah)
 		return;
 	led_classdev_unregister(&led->led_dev);
 	ath5k_led_off(led->ah);
@@ -169,7 +171,7 @@ int ath5k_init_leds(struct ath5k_hw *ah)
 	char name[ATH5K_LED_MAX_NAME_LEN + 1];
 	const struct pci_device_id *match;
 
-	if (!ah->pdev)
+	if (!IS_ENABLED(CONFIG_MAC80211_LEDS) || !ah->pdev)
 		return 0;
 
 #ifdef CONFIG_ATH5K_AHB
-- 
2.33.0




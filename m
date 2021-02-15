Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B05F31BCFB
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhBOPhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:37:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:49636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231253AbhBOPhF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:37:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69E3864EE0;
        Mon, 15 Feb 2021 15:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403160;
        bh=i+j9M7r7dmHplaxzYAZpfgHpxO9jZ4VTKN8GzQOZ0No=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u4HlKl10vNGAIQsHL2YrSrxhMGcAvTIk+o6+4vRQSmw1qsoaCm02vt2no8b+k4gaO
         fcaB+Rqt6mHOxiu8bjUWbW1j4SjNZzn26N4gSOzN2yMqEX0itG25ZUzb8fA94QuM6Y
         qrCwSw5eUNBxuFSJDw5IMyyRG+fechA3LEKCj9FA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/104] ath9k: fix build error with LEDS_CLASS=m
Date:   Mon, 15 Feb 2021 16:27:04 +0100
Message-Id: <20210215152721.121960495@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b64acb28da8394485f0762e657470c9fc33aca4d ]

When CONFIG_ATH9K is built-in but LED support is in a loadable
module, both ath9k drivers fails to link:

x86_64-linux-ld: drivers/net/wireless/ath/ath9k/gpio.o: in function `ath_deinit_leds':
gpio.c:(.text+0x36): undefined reference to `led_classdev_unregister'
x86_64-linux-ld: drivers/net/wireless/ath/ath9k/gpio.o: in function `ath_init_leds':
gpio.c:(.text+0x179): undefined reference to `led_classdev_register_ext'

The problem is that the 'imply' keyword does not enforce any dependency
but is only a weak hint to Kconfig to enable another symbol from a
defconfig file.

Change imply to a 'depends on LEDS_CLASS' that prevents the incorrect
configuration but still allows building the driver without LED support.

The 'select MAC80211_LEDS' is now ensures that the LED support is
actually used if it is present, and the added Kconfig dependency
on MAC80211_LEDS ensures that it cannot be enabled manually when it
has no effect.

Fixes: 197f466e93f5 ("ath9k_htc: Do not select MAC80211_LEDS by default")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210125113654.2408057-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/Kconfig | 8 ++------
 net/mac80211/Kconfig                   | 2 +-
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index a84bb9b6573f8..e150d82eddb6c 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -21,11 +21,9 @@ config ATH9K_BTCOEX_SUPPORT
 config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
 	depends on MAC80211 && HAS_DMA
+	select MAC80211_LEDS if LEDS_CLASS=y || LEDS_CLASS=MAC80211
 	select ATH9K_HW
 	select ATH9K_COMMON
-	imply NEW_LEDS
-	imply LEDS_CLASS
-	imply MAC80211_LEDS
 	help
 	  This module adds support for wireless adapters based on
 	  Atheros IEEE 802.11n AR5008, AR9001 and AR9002 family
@@ -176,11 +174,9 @@ config ATH9K_PCI_NO_EEPROM
 config ATH9K_HTC
 	tristate "Atheros HTC based wireless cards support"
 	depends on USB && MAC80211
+	select MAC80211_LEDS if LEDS_CLASS=y || LEDS_CLASS=MAC80211
 	select ATH9K_HW
 	select ATH9K_COMMON
-	imply NEW_LEDS
-	imply LEDS_CLASS
-	imply MAC80211_LEDS
 	help
 	  Support for Atheros HTC based cards.
 	  Chipsets supported: AR9271
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index cd9a9bd242bab..51ec8256b7fa9 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -69,7 +69,7 @@ config MAC80211_MESH
 config MAC80211_LEDS
 	bool "Enable LED triggers"
 	depends on MAC80211
-	depends on LEDS_CLASS
+	depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
 	select LEDS_TRIGGERS
 	help
 	  This option enables a few LED triggers for different
-- 
2.27.0




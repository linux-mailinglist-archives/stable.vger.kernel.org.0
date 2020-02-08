Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29324156667
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgBHSeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:34:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34256 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727895AbgBHS3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:45 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrL-0003fe-3w; Sat, 08 Feb 2020 18:29:39 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrK-000CTR-0h; Sat, 08 Feb 2020 18:29:38 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johannes Berg" <johannes.berg@intel.com>,
        "Luca Coelho" <luciano.coelho@intel.com>
Date:   Sat, 08 Feb 2020 18:20:49 +0000
Message-ID: <lsq.1581185940.28073388@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 110/148] iwlwifi: check kasprintf() return value
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 5974fbb5e10b018fdbe3c3b81cb4cc54e1105ab9 upstream.

kasprintf() can fail, we should check the return value.

Fixes: 5ed540aecc2a ("iwlwifi: use mac80211 throughput trigger")
Fixes: 8ca151b568b6 ("iwlwifi: add the MVM driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
[bwh: Backported to 3.16: adjust filenames]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/dvm/led.c | 3 +++
 drivers/net/wireless/iwlwifi/mvm/led.c | 3 +++
 2 files changed, 6 insertions(+)

--- a/drivers/net/wireless/iwlwifi/dvm/led.c
+++ b/drivers/net/wireless/iwlwifi/dvm/led.c
@@ -184,6 +184,9 @@ void iwl_leds_init(struct iwl_priv *priv
 
 	priv->led.name = kasprintf(GFP_KERNEL, "%s-led",
 				   wiphy_name(priv->hw->wiphy));
+	if (!priv->led.name)
+		return;
+
 	priv->led.brightness_set = iwl_led_brightness_set;
 	priv->led.blink_set = iwl_led_blink_set;
 	priv->led.max_brightness = 1;
--- a/drivers/net/wireless/iwlwifi/mvm/led.c
+++ b/drivers/net/wireless/iwlwifi/mvm/led.c
@@ -109,6 +109,9 @@ int iwl_mvm_leds_init(struct iwl_mvm *mv
 
 	mvm->led.name = kasprintf(GFP_KERNEL, "%s-led",
 				   wiphy_name(mvm->hw->wiphy));
+	if (!mvm->led.name)
+		return -ENOMEM;
+
 	mvm->led.brightness_set = iwl_led_brightness_set;
 	mvm->led.max_brightness = 1;
 


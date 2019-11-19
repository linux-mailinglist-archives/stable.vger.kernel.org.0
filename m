Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D25D1015CC
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731234AbfKSFr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:47:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730714AbfKSFrZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:47:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BE292071B;
        Tue, 19 Nov 2019 05:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142443;
        bh=RKRTRBPAlk+f+aw3C7A6A3UDnlrwH0Cc8yXEXBYKvkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hAyURS4nP0LAubSYxncjvCGQCmaWa1j7bb1A+mLeqpND+cYt9wGzUPCXuCBeQ4ZU2
         /lbI56blQtu3CwWyLVxp8Rq+sCxytdeSwETI5TLUzBYSvJPulCfvSKvcezTJbPBHjU
         7mCfesy/L5IHtrGdaE6iLdd9c93uqZWboC8X10gU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sven Eckelmann <sven.eckelmann@openmesh.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 043/239] ath10k: limit available channels via DT ieee80211-freq-limit
Date:   Tue, 19 Nov 2019 06:17:23 +0100
Message-Id: <20191119051306.116827965@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven.eckelmann@openmesh.com>

[ Upstream commit 34d5629d2ca89d847b7040762b87964c696c14da ]

Tri-band devices (1x 2.4GHz + 2x 5GHz) often incorporate special filters in
the RX and TX path. These filtered channel can in theory still be used by
the hardware but the signal strength is reduced so much that it makes no
sense.

There is already a DT property to limit the available channels but ath10k
has to manually call this functionality to limit the currrently set wiphy
channels further.

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 58a3c42c4aedb..8c4bb56c262f6 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -17,6 +17,7 @@
 
 #include "mac.h"
 
+#include <net/cfg80211.h>
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <linux/acpi.h>
@@ -8174,6 +8175,7 @@ int ath10k_mac_register(struct ath10k *ar)
 		ar->hw->wiphy->bands[NL80211_BAND_5GHZ] = band;
 	}
 
+	wiphy_read_of_freq_limits(ar->hw->wiphy);
 	ath10k_mac_setup_ht_vht_cap(ar);
 
 	ar->hw->wiphy->interface_modes =
-- 
2.20.1




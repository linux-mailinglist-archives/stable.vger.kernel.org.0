Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F28D395FCE
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbhEaOQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:16:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233476AbhEaONF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:13:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43E276198F;
        Mon, 31 May 2021 13:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468512;
        bh=+VOiRXbyYv3Fjv/OVMeA7XGf5WEvEaeuR3EVG5vmmNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RbRP3BnmGnL8+nytNN8DI7ywfU/QQ5fgBOGLKtQ6nP93Hyr6ZVJ4SIiBgl0LqFVLm
         SEzYXWwgIo5Ghi7QTF4kFrjFVLlMH78HBAR6YA2SAcICmT9Ke3KmNSG6raWD6Ys4by
         vLsaHOz+i7ZJtJehlEzjCWAorpiD8ZdD5rBUf2xU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 018/177] mac80211: drop A-MSDUs on old ciphers
Date:   Mon, 31 May 2021 15:12:55 +0200
Message-Id: <20210531130648.547327071@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 270032a2a9c4535799736142e1e7c413ca7b836e upstream.

With old ciphers (WEP and TKIP) we shouldn't be using A-MSDUs
since A-MSDUs are only supported if we know that they are, and
the only practical way for that is HT support which doesn't
support old ciphers.

However, we would normally accept them anyway. Since we check
the MMIC before deaggregating A-MSDUs, and the A-MSDU bit in
the QoS header is not protected in TKIP (or WEP), this enables
attacks similar to CVE-2020-24588. To prevent that, drop A-MSDUs
completely with old ciphers.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210511200110.076543300172.I548e6e71f1ee9cad4b9a37bf212ae7db723587aa@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/rx.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -6,7 +6,7 @@
  * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2019 Intel Corporation
+ * Copyright (C) 2018-2021 Intel Corporation
  */
 
 #include <linux/jiffies.h>
@@ -2691,6 +2691,23 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx
 	if (is_multicast_ether_addr(hdr->addr1))
 		return RX_DROP_UNUSABLE;
 
+	if (rx->key) {
+		/*
+		 * We should not receive A-MSDUs on pre-HT connections,
+		 * and HT connections cannot use old ciphers. Thus drop
+		 * them, as in those cases we couldn't even have SPP
+		 * A-MSDUs or such.
+		 */
+		switch (rx->key->conf.cipher) {
+		case WLAN_CIPHER_SUITE_WEP40:
+		case WLAN_CIPHER_SUITE_WEP104:
+		case WLAN_CIPHER_SUITE_TKIP:
+			return RX_DROP_UNUSABLE;
+		default:
+			break;
+		}
+	}
+
 	return __ieee80211_rx_h_amsdu(rx, 0);
 }
 



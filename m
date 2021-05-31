Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9954E395C32
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhEaN34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:29:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231801AbhEaN13 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:27:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 733BE611CA;
        Mon, 31 May 2021 13:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467303;
        bh=pWgjaoNU4Rnafi2V1SErLtXXvsQJ3sHRTqZjrDOQ5f0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OkXkcS85PSFZcva5K94cTthdB7GO3D3BK6kgY+gzpwJ5Po+QHJAJWDPX7S9oG7mwt
         9yAyum/d4NXRpPEsP0EM/wdRPewzXGWO7+poZmZYAVI68ohMJBv9JTAT03t5I5+vwi
         J26POOsh+eWbbWuIznqkEEkhUk++bzkj0el8AUec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 015/116] mac80211: drop A-MSDUs on old ciphers
Date:   Mon, 31 May 2021 15:13:11 +0200
Message-Id: <20210531130640.668393496@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
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
@@ -5,7 +5,7 @@
  * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018-2021 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -2614,6 +2614,23 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx
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
 



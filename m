Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2DE817FE6E
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgCJMpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:45:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbgCJMpO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:45:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80EA0246A3;
        Tue, 10 Mar 2020 12:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844313;
        bh=F7gCp+2KCsbU23lR2accZ9m2uIs9HZv3Why4rn5Bmss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JVk8DkM37cbe31Uc36fPNh6Ke70hqW4n9PLyyPvlbhA2jEgjq6uVrS2BnRUniyTuy
         SKzsf2NJ36neNTYAetgvfQ0EI/Oa76kDUGdw3xulytwe91m1Z1gFwp7l5eGYGRD+Pe
         h0HeZ9wfiSmRzSM53H/9c30KUgfqNq4IlUc0XlqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 07/88] mac80211: consider more elements in parsing CRC
Date:   Tue, 10 Mar 2020 13:38:15 +0100
Message-Id: <20200310123608.425356365@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123606.543939933@linuxfoundation.org>
References: <20200310123606.543939933@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a04564c99bb4a92f805a58e56b2d22cc4978f152 ]

We only use the parsing CRC for checking if a beacon changed,
and elements with an ID > 63 cannot be represented in the
filter. Thus, like we did before with WMM and Cisco vendor
elements, just statically add these forgotten items to the
CRC:
 - WLAN_EID_VHT_OPERATION
 - WLAN_EID_OPMODE_NOTIF

I guess that in most cases when VHT/HE operation change, the HT
operation also changed, and so the change was picked up, but we
did notice that pure operating mode notification changes were
ignored.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/20200131111300.891737-22-luca@coelho.fi
[restrict to VHT for the mac80211 branch]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/util.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ca7de02e0a6e9..52f9742c438a4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -943,16 +943,22 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 				elem_parse_failed = true;
 			break;
 		case WLAN_EID_VHT_OPERATION:
-			if (elen >= sizeof(struct ieee80211_vht_operation))
+			if (elen >= sizeof(struct ieee80211_vht_operation)) {
 				elems->vht_operation = (void *)pos;
-			else
-				elem_parse_failed = true;
+				if (calc_crc)
+					crc = crc32_be(crc, pos - 2, elen + 2);
+				break;
+			}
+			elem_parse_failed = true;
 			break;
 		case WLAN_EID_OPMODE_NOTIF:
-			if (elen > 0)
+			if (elen > 0) {
 				elems->opmode_notif = pos;
-			else
-				elem_parse_failed = true;
+				if (calc_crc)
+					crc = crc32_be(crc, pos - 2, elen + 2);
+				break;
+			}
+			elem_parse_failed = true;
 			break;
 		case WLAN_EID_MESH_ID:
 			elems->mesh_id = pos;
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E39F1134BE7
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgAHTr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:47:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43768 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730455AbgAHTqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:04 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-0006oh-VZ; Wed, 08 Jan 2020 19:46:00 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-007dpR-I5; Wed, 08 Jan 2020 19:45:59 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "huangwen" <huangwenabc@gmail.com>,
        "Ganapathi Bhat" <gbhat@marvell.com>,
        "Kalle Valo" <kvalo@codeaurora.org>
Date:   Wed, 08 Jan 2020 19:44:00 +0000
Message-ID: <lsq.1578512578.718890478@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 62/63] mwifiex: fix possible heap overflow in
 mwifiex_process_country_ie()
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ganapathi Bhat <gbhat@marvell.com>

commit 3d94a4a8373bf5f45cf5f939e88b8354dbf2311b upstream.

mwifiex_process_country_ie() function parse elements of bss
descriptor in beacon packet. When processing WLAN_EID_COUNTRY
element, there is no upper limit check for country_ie_len before
calling memcpy. The destination buffer domain_info->triplet is an
array of length MWIFIEX_MAX_TRIPLET_802_11D(83). The remote
attacker can build a fake AP with the same ssid as real AP, and
send malicous beacon packet with long WLAN_EID_COUNTRY elemen
(country_ie_len > 83). Attacker can  force STA connect to fake AP
on a different channel. When the victim STA connects to fake AP,
will trigger the heap buffer overflow. Fix this by checking for
length and if found invalid, don not connect to the AP.

This fix addresses CVE-2019-14895.

Reported-by: huangwen <huangwenabc@gmail.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[bwh: Backported to 3.16:
 - Use wiphy_dbg() instead of mwifiex_dbg()
 - Adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -223,6 +223,14 @@ static int mwifiex_process_country_ie(st
 			  "11D: skip setting domain info in FW\n");
 		return 0;
 	}
+
+	if (country_ie_len >
+	    (IEEE80211_COUNTRY_STRING_LEN + MWIFIEX_MAX_TRIPLET_802_11D)) {
+		wiphy_dbg(priv->wdev->wiphy,
+			  "11D: country_ie_len overflow!, deauth AP\n");
+		return -EINVAL;
+	}
+
 	memcpy(priv->adapter->country_code, &country_ie[2], 2);
 
 	domain_info->country_code[0] = country_ie[2];
@@ -266,8 +274,9 @@ int mwifiex_bss_start(struct mwifiex_pri
 	priv->scan_block = false;
 
 	if (bss) {
-		if (adapter->region_code == 0x00)
-			mwifiex_process_country_ie(priv, bss);
+		if (adapter->region_code == 0x00 &&
+		    mwifiex_process_country_ie(priv, bss))
+			return -EINVAL;
 
 		/* Allocate and fill new bss descriptor */
 		bss_desc = kzalloc(sizeof(struct mwifiex_bssdescriptor),


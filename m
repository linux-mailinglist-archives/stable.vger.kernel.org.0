Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21D8CB92C0
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387868AbfITOfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:35:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36070 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388139AbfITOZE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:04 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqH-00051C-Nv; Fri, 20 Sep 2019 15:25:01 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqH-0007y2-1Z; Fri, 20 Sep 2019 15:25:01 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Amitkumar Karwar" <akarwar@marvell.com>,
        "Karthik D A" <karthida@marvell.com>,
        "Kalle Valo" <kvalo@codeaurora.org>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.455354700@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 110/132] mwifiex: vendor_ie length check for parse
 WMM IEs
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Karthik D A <karthida@marvell.com>

commit 113630b581d6d423998d2113a8e892ed6e6af6f9 upstream.

While copying the vendor_ie obtained from the cfg80211_find_vendor_ie()
to the struct mwifiex_types_wmm_info, length/size was inappropriate.
This patch corrects the required length needed to the
mwifiex_types_wmm_info

Signed-off-by: Karthik D A <karthida@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwifiex/uap_cmd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -364,7 +364,7 @@ mwifiex_set_wmm_params(struct mwifiex_pr
 		       struct cfg80211_ap_settings *params)
 {
 	const u8 *vendor_ie;
-	struct ieee_types_header *wmm_ie;
+	const u8 *wmm_ie;
 	u8 wmm_oui[] = {0x00, 0x50, 0xf2, 0x02};
 
 	vendor_ie = cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
@@ -372,9 +372,9 @@ mwifiex_set_wmm_params(struct mwifiex_pr
 					    params->beacon.tail,
 					    params->beacon.tail_len);
 	if (vendor_ie) {
-		wmm_ie = (struct ieee_types_header *)vendor_ie;
-		memcpy(&bss_cfg->wmm_info, wmm_ie + 1,
-		       sizeof(bss_cfg->wmm_info));
+		wmm_ie = vendor_ie;
+		memcpy(&bss_cfg->wmm_info, wmm_ie +
+		       sizeof(struct ieee_types_header), *(wmm_ie + 1));
 		priv->wmm_enabled = 1;
 	} else {
 		memset(&bss_cfg->wmm_info, 0, sizeof(bss_cfg->wmm_info));


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35520B92BE
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391766AbfITOfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:35:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36062 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388138AbfITOZE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:04 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqH-00051E-PG; Fri, 20 Sep 2019 15:25:01 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqH-0007y8-3J; Fri, 20 Sep 2019 15:25:01 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        "Wen Huang" <huangwenabc@gmail.com>,
        "Ganapathi Bhat" <gbhat@marvell.comg>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.540101899@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 111/132] mwifiex: Fix three heap overflow at parsing
 element in cfg80211_ap_settings
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

From: Wen Huang <huangwenabc@gmail.com>

commit 7caac62ed598a196d6ddf8d9c121e12e082cac3a upstream.

mwifiex_update_vs_ie(),mwifiex_set_uap_rates() and
mwifiex_set_wmm_params() call memcpy() without checking
the destination size.Since the source is given from
user-space, this may trigger a heap buffer overflow.

Fix them by putting the length check before performing memcpy().

This fix addresses CVE-2019-14814,CVE-2019-14815,CVE-2019-14816.

Signed-off-by: Wen Huang <huangwenabc@gmail.com>
Acked-by: Ganapathi Bhat <gbhat@marvell.comg>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[bwh: Backported to 3.16: adjust filenames]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwifiex/ie.c      | 3 +++
 drivers/net/wireless/mwifiex/uap_cmd.c | 9 ++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -240,6 +240,9 @@ static int mwifiex_update_vs_ie(const u8
 		}
 
 		vs_ie = (struct ieee_types_header *)vendor_ie;
+		if (le16_to_cpu(ie->ie_length) + vs_ie->len + 2 >
+			IEEE_MAX_IE_SIZE)
+			return -EINVAL;
 		memcpy(ie->ie_buffer + le16_to_cpu(ie->ie_length),
 		       vs_ie, vs_ie->len + 2);
 		le16_add_cpu(&ie->ie_length, vs_ie->len + 2);
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -247,6 +247,8 @@ mwifiex_set_uap_rates(struct mwifiex_uap
 
 	rate_ie = (void *)cfg80211_find_ie(WLAN_EID_SUPP_RATES, var_pos, len);
 	if (rate_ie) {
+		if (rate_ie->len > MWIFIEX_SUPPORTED_RATES)
+			return;
 		memcpy(bss_cfg->rates, rate_ie + 1, rate_ie->len);
 		rate_len = rate_ie->len;
 	}
@@ -254,8 +256,11 @@ mwifiex_set_uap_rates(struct mwifiex_uap
 	rate_ie = (void *)cfg80211_find_ie(WLAN_EID_EXT_SUPP_RATES,
 					   params->beacon.tail,
 					   params->beacon.tail_len);
-	if (rate_ie)
+	if (rate_ie) {
+		if (rate_ie->len > MWIFIEX_SUPPORTED_RATES - rate_len)
+			return;
 		memcpy(bss_cfg->rates + rate_len, rate_ie + 1, rate_ie->len);
+	}
 
 	return;
 }
@@ -373,6 +378,8 @@ mwifiex_set_wmm_params(struct mwifiex_pr
 					    params->beacon.tail_len);
 	if (vendor_ie) {
 		wmm_ie = vendor_ie;
+		if (*(wmm_ie + 1) > sizeof(struct mwifiex_types_wmm_info))
+			return;
 		memcpy(&bss_cfg->wmm_info, wmm_ie +
 		       sizeof(struct ieee_types_header), *(wmm_ie + 1));
 		priv->wmm_enabled = 1;


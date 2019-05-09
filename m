Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B43418B55
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 16:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfEIONL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 10:13:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46924 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726674AbfEIONK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 10:13:10 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hOjnI-000123-Gi; Thu, 09 May 2019 15:13:08 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hOjnI-0006Lv-9z; Thu, 09 May 2019 15:13:08 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Hante Meuleman" <hante.meuleman@broadcom.com>,
        "Franky Lin" <franky.lin@broadcom.com>,
        "Arend Van Spriel" <arend.vanspriel@broadcom.com>,
        "Pieter-Paul Giesberts" <pieter-paul.giesberts@broadcom.com>,
        "Kalle Valo" <kvalo@codeaurora.org>
Date:   Thu, 09 May 2019 15:08:17 +0100
Message-ID: <lsq.1557410897.750548855@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 02/10] brcmfmac: add length checks in scheduled scan
 result handler
In-Reply-To: <lsq.1557410896.171359878@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.67-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Arend Van Spriel <arend.vanspriel@broadcom.com>

commit 4835f37e3bafc138f8bfa3cbed2920dd56fed283 upstream.

Assure the event data buffer is long enough to hold the array
of netinfo items and that SSID length does not exceed the maximum
of 32 characters as per 802.11 spec.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[bwh: Backported to 3.16:
 - Move the assignment to "data" along with the assignment to "netinfo_start"
   that depends on it
 - Adjust filename, context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3033,6 +3033,7 @@ brcmf_notify_sched_scan_results(struct b
 	struct brcmf_pno_scanresults_le *pfn_result;
 	u32 result_count;
 	u32 status;
+	u32 datalen;
 
 	brcmf_dbg(SCAN, "Enter\n");
 
@@ -3059,6 +3060,14 @@ brcmf_notify_sched_scan_results(struct b
 	if (result_count > 0) {
 		int i;
 
+		data += sizeof(struct brcmf_pno_scanresults_le);
+		netinfo_start = (struct brcmf_pno_net_info_le *)data;
+		datalen = e->datalen - ((void *)netinfo_start - (void *)pfn_result);
+		if (datalen < result_count * sizeof(*netinfo)) {
+			brcmf_err("insufficient event data\n");
+			goto out_err;
+		}
+
 		request = kzalloc(sizeof(*request), GFP_KERNEL);
 		ssid = kcalloc(result_count, sizeof(*ssid), GFP_KERNEL);
 		channel = kcalloc(result_count, sizeof(*channel), GFP_KERNEL);
@@ -3068,9 +3077,6 @@ brcmf_notify_sched_scan_results(struct b
 		}
 
 		request->wiphy = wiphy;
-		data += sizeof(struct brcmf_pno_scanresults_le);
-		netinfo_start = (struct brcmf_pno_net_info_le *)data;
-
 		for (i = 0; i < result_count; i++) {
 			netinfo = &netinfo_start[i];
 			if (!netinfo) {
@@ -3080,6 +3086,8 @@ brcmf_notify_sched_scan_results(struct b
 				goto out_err;
 			}
 
+			if (netinfo->SSID_len > IEEE80211_MAX_SSID_LEN)
+				netinfo->SSID_len = IEEE80211_MAX_SSID_LEN;
 			brcmf_dbg(SCAN, "SSID:%s Channel:%d\n",
 				  netinfo->SSID, netinfo->channel);
 			memcpy(ssid[i].ssid, netinfo->SSID, netinfo->SSID_len);


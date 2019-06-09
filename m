Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28F423A7CF
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731771AbfFIQxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732421AbfFIQxb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:53:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7313C206DF;
        Sun,  9 Jun 2019 16:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099210;
        bh=Qnqvb0bwuWUZl0on7p+Ii6HsgQVKN92+YuGzCQm/g3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMNA3X3rgn3o+MYEKQvLS6hIVrWGCBrEFCcKfOu9r7R1xT3AlnVcaF3imgD19ILcx
         jLPATeWvI9AvEbchTrwjyf6q0e7qbID7+Sfp3nfQIi/dRta3fHKtwvpwFwRqMCyQZd
         ZHKfAK5/TjeAusPQxjPArsOOqjWYLu22J+eTo218=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 49/83] brcmfmac: add length checks in scheduled scan result handler
Date:   Sun,  9 Jun 2019 18:42:19 +0200
Message-Id: <20190609164132.115944698@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
[bwh: Backported to 4.9:
 - Move the assignment to "data" along with the assignment to "netinfo_start"
   that depends on it
 - Adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |   14 +++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3220,6 +3220,7 @@ brcmf_notify_sched_scan_results(struct b
 	struct brcmf_pno_scanresults_le *pfn_result;
 	u32 result_count;
 	u32 status;
+	u32 datalen;
 
 	brcmf_dbg(SCAN, "Enter\n");
 
@@ -3245,6 +3246,14 @@ brcmf_notify_sched_scan_results(struct b
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
@@ -3254,9 +3263,6 @@ brcmf_notify_sched_scan_results(struct b
 		}
 
 		request->wiphy = wiphy;
-		data += sizeof(struct brcmf_pno_scanresults_le);
-		netinfo_start = (struct brcmf_pno_net_info_le *)data;
-
 		for (i = 0; i < result_count; i++) {
 			netinfo = &netinfo_start[i];
 			if (!netinfo) {
@@ -3266,6 +3272,8 @@ brcmf_notify_sched_scan_results(struct b
 				goto out_err;
 			}
 
+			if (netinfo->SSID_len > IEEE80211_MAX_SSID_LEN)
+				netinfo->SSID_len = IEEE80211_MAX_SSID_LEN;
 			brcmf_dbg(SCAN, "SSID:%s Channel:%d\n",
 				  netinfo->SSID, netinfo->channel);
 			memcpy(ssid[i].ssid, netinfo->SSID, netinfo->SSID_len);



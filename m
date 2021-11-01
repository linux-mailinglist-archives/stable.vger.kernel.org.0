Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D85F441715
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbhKAJc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:32:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232942AbhKAJa0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:30:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BEE1610D2;
        Mon,  1 Nov 2021 09:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758639;
        bh=sEOdmsuzoGP6wtd5/Ft4943gT169+eqDJrfi3Jc685g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BV31vpHCU2UbGEmWMS4pxbNVf986fPkLQbM6jYKzc6cgii7ZfcWsi/EWjYrwJbIpf
         UcsjwL0M4C33O5sZXBvqAvqaE+vQpNq2YwOB5rupITrb/WfPY1cAxgQUEDlVufs+ir
         XMfOGogBlix8UKSY/TXNiQ6V4xssZ/xw4TsQgaCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 20/51] cfg80211: scan: fix RCU in cfg80211_add_nontrans_list()
Date:   Mon,  1 Nov 2021 10:17:24 +0100
Message-Id: <20211101082505.200852489@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
References: <20211101082500.203657870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit a2083eeb119fb9307258baea9b7c243ca9a2e0b6 upstream.

The SSID pointer is pointing to RCU protected data, so we
need to have it under rcu_read_lock() for the entire use.
Fix this.

Cc: stable@vger.kernel.org
Fixes: 0b8fb8235be8 ("cfg80211: Parsing of Multiple BSSID information in scanning")
Link: https://lore.kernel.org/r/20210930131120.6ddfc603aa1d.I2137344c4e2426525b1a8e4ce5fca82f8ecbfe7e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/scan.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -379,14 +379,17 @@ cfg80211_add_nontrans_list(struct cfg802
 	}
 	ssid_len = ssid[1];
 	ssid = ssid + 2;
-	rcu_read_unlock();
 
 	/* check if nontrans_bss is in the list */
 	list_for_each_entry(bss, &trans_bss->nontrans_list, nontrans_list) {
-		if (is_bss(bss, nontrans_bss->bssid, ssid, ssid_len))
+		if (is_bss(bss, nontrans_bss->bssid, ssid, ssid_len)) {
+			rcu_read_unlock();
 			return 0;
+		}
 	}
 
+	rcu_read_unlock();
+
 	/* add to the list */
 	list_add_tail(&nontrans_bss->nontrans_list, &trans_bss->nontrans_list);
 	return 0;



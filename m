Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B3044175B
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbhKAJfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:35:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233622AbhKAJdr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:33:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F24061265;
        Mon,  1 Nov 2021 09:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758716;
        bh=pvJr1WrYLJxcxoBfz2R65K5Wa7sWMt1a0oeZCQbtU80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cPOviT/1E+P4LJkdDP5Jh3mxHURZxWMQ+VEVRgP/nMgyJ4Ysl3y1NoUg0t8H5TfMy
         CmyTtSRHX1k9cqjMHM8Xy4R8oHTKKKfRgA2/Q/LmvEsosgclRfZsFVkY4Tskq1J8QM
         gR7KsLP7/bVHpvvpZun3/9USE5nmyXERKN7Ewrtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 28/77] cfg80211: scan: fix RCU in cfg80211_add_nontrans_list()
Date:   Mon,  1 Nov 2021 10:17:16 +0100
Message-Id: <20211101082517.840847610@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
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
@@ -418,14 +418,17 @@ cfg80211_add_nontrans_list(struct cfg802
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



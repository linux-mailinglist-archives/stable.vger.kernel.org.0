Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC47B91B0
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388177AbfITOZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:25:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36048 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388130AbfITOZE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:04 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqH-00050x-Kn; Fri, 20 Sep 2019 15:25:01 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqG-0007xX-SI; Fri, 20 Sep 2019 15:25:00 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Arik Nemtsov" <arik@wizery.com>,
        "Arik Nemtsov" <arikx.nemtsov@intel.com>,
        "Johannes Berg" <johannes.berg@intel.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.140009400@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 107/132] mac80211: add API to request TDLS operation
 from userspace
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

From: Arik Nemtsov <arik@wizery.com>

commit c887f0d3a03283cb6fe2c32aae62229bebd3fa32 upstream.

Write a mac80211 to the cfg80211 API for requesting a userspace TDLS
operation. Define TDLS specific reason codes that can be used here.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/ieee80211.h |  3 +++
 include/net/mac80211.h    | 13 +++++++++++++
 net/mac80211/tdls.c       | 17 +++++++++++++++++
 3 files changed, 33 insertions(+)

--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1621,6 +1621,9 @@ enum ieee80211_reasoncode {
 	WLAN_REASON_INVALID_RSN_IE_CAP = 22,
 	WLAN_REASON_IEEE8021X_FAILED = 23,
 	WLAN_REASON_CIPHER_SUITE_REJECTED = 24,
+	/* TDLS (802.11z) */
+	WLAN_REASON_TDLS_TEARDOWN_UNREACHABLE = 25,
+	WLAN_REASON_TDLS_TEARDOWN_UNSPECIFIED = 26,
 	/* 802.11e */
 	WLAN_REASON_DISASSOC_UNSPECIFIED_QOS = 32,
 	WLAN_REASON_DISASSOC_QAP_NO_BANDWIDTH = 33,
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4815,4 +4815,17 @@ int ieee80211_parse_p2p_noa(const struct
  */
 void ieee80211_update_p2p_noa(struct ieee80211_noa_data *data, u32 tsf);
 
+/**
+ * ieee80211_tdls_oper - request userspace to perform a TDLS operation
+ * @vif: virtual interface
+ * @peer: the peer's destination address
+ * @oper: the requested TDLS operation
+ * @reason_code: reason code for the operation, valid for TDLS teardown
+ * @gfp: allocation flags
+ *
+ * See cfg80211_tdls_oper_request().
+ */
+void ieee80211_tdls_oper_request(struct ieee80211_vif *vif, const u8 *peer,
+				 enum nl80211_tdls_operation oper,
+				 u16 reason_code, gfp_t gfp);
 #endif /* MAC80211_H */
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/ieee80211.h>
+#include <net/cfg80211.h>
 #include "ieee80211_i.h"
 
 static void ieee80211_tdls_add_ext_capab(struct sk_buff *skb)
@@ -323,3 +324,19 @@ int ieee80211_tdls_oper(struct wiphy *wi
 
 	return 0;
 }
+
+void ieee80211_tdls_oper_request(struct ieee80211_vif *vif, const u8 *peer,
+				 enum nl80211_tdls_operation oper,
+				 u16 reason_code, gfp_t gfp)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	if (vif->type != NL80211_IFTYPE_STATION || !vif->bss_conf.assoc) {
+		sdata_err(sdata, "Discarding TDLS oper %d - not STA or disconnected\n",
+			  oper);
+		return;
+	}
+
+	cfg80211_tdls_oper_request(sdata->dev, peer, oper, reason_code, gfp);
+}
+EXPORT_SYMBOL(ieee80211_tdls_oper_request);


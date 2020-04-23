Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1C31B69C5
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgDWX0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:26:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48136 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727065AbgDWXG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:26 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvH-0004ZI-SB; Fri, 24 Apr 2020 00:06:23 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvH-00E6eG-EB; Fri, 24 Apr 2020 00:06:23 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        "Wen Huang" <huangwenabc@gmail.com>,
        "kbuild test robot" <lkp@intel.com>
Date:   Fri, 24 Apr 2020 00:03:49 +0100
Message-ID: <lsq.1587683028.742018254@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 002/245] libertas: Fix two buffer overflows at
 parsing bss descriptor
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wen Huang <huangwenabc@gmail.com>

commit e5e884b42639c74b5b57dc277909915c0aefc8bb upstream.

add_ie_rates() copys rates without checking the length
in bss descriptor from remote AP.when victim connects to
remote attacker, this may trigger buffer overflow.
lbs_ibss_join_existing() copys rates without checking the length
in bss descriptor from remote IBSS node.when victim connects to
remote attacker, this may trigger buffer overflow.
Fix them by putting the length check before performing copy.

This fix addresses CVE-2019-14896 and CVE-2019-14897.
This also fix build warning of mixed declarations and code.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Wen Huang <huangwenabc@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/libertas/cfg.c | 8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -272,6 +272,10 @@ add_ie_rates(u8 *tlv, const u8 *ie, int
 	int hw, ap, ap_max = ie[1];
 	u8 hw_rate;
 
+	if (ap_max > MAX_RATES) {
+		lbs_deb_assoc("invalid rates\n");
+		return tlv;
+	}
 	/* Advance past IE header */
 	ie += 2;
 
@@ -1785,6 +1789,9 @@ static int lbs_ibss_join_existing(struct
 	struct cmd_ds_802_11_ad_hoc_join cmd;
 	u8 preamble = RADIO_PREAMBLE_SHORT;
 	int ret = 0;
+	int hw, i;
+	u8 rates_max;
+	u8 *rates;
 
 	lbs_deb_enter(LBS_DEB_CFG80211);
 
@@ -1845,9 +1852,12 @@ static int lbs_ibss_join_existing(struct
 	if (!rates_eid) {
 		lbs_add_rates(cmd.bss.rates);
 	} else {
-		int hw, i;
-		u8 rates_max = rates_eid[1];
-		u8 *rates = cmd.bss.rates;
+		rates_max = rates_eid[1];
+		if (rates_max > MAX_RATES) {
+			lbs_deb_join("invalid rates");
+			goto out;
+		}
+		rates = cmd.bss.rates;
 		for (hw = 0; hw < ARRAY_SIZE(lbs_rates); hw++) {
 			u8 hw_rate = lbs_rates[hw].bitrate / 5;
 			for (i = 0; i < rates_max; i++) {


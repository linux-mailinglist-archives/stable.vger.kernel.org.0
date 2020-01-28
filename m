Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52C9E14BAC0
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729924AbgA1OOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:14:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:36950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728183AbgA1OOl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:14:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 131F224693;
        Tue, 28 Jan 2020 14:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220880;
        bh=N0+TqitR6x8SaBnWZM8XYV12zZUenDlfzoRwwjLj6Ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hLvFb1dWZ3KEKqdFEexmrL9nIanxNKDHdGOVZi2bImuLT5W32BgqyQpbDXpLZBpLE
         n8nw90ngzBcHwMCELZLooPLplT52VW0+YSghx22GjF0bcljcsQrwEY55FI/1L15Lv5
         3q9JQIh/RBK+xB7yg9kbCsFM/RH2zHp6INeZoybA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Wen Huang <huangwenabc@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.4 183/183] libertas: Fix two buffer overflows at parsing bss descriptor
Date:   Tue, 28 Jan 2020 15:06:42 +0100
Message-Id: <20200128135847.988935436@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/libertas/cfg.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

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
 
@@ -1783,6 +1787,9 @@ static int lbs_ibss_join_existing(struct
 	struct cmd_ds_802_11_ad_hoc_join cmd;
 	u8 preamble = RADIO_PREAMBLE_SHORT;
 	int ret = 0;
+	int hw, i;
+	u8 rates_max;
+	u8 *rates;
 
 	lbs_deb_enter(LBS_DEB_CFG80211);
 
@@ -1843,9 +1850,12 @@ static int lbs_ibss_join_existing(struct
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



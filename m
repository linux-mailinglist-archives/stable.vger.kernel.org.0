Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAB448DA0F
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730287AbfHNROu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:14:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730907AbfHNROu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:14:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D260A2084D;
        Wed, 14 Aug 2019 17:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802889;
        bh=AGQBOIpQCF8aITkhXyPVwPEzllyvkhX+pQqakyPz/uQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHcxlqCOHKkY8ZHZkQtkOygNsR9v+mzKU9JXfUzYF/GBDhwkyXylzq2x2jm+5BYyh
         ig4Z5dVSPzVImCzwO/f/edl0ZF5XBPfs7m3ieDcxLpyKJ0/ilJcD07a7P8IWypiqs4
         odz3p55SFxSO24AdhSC9BfKIBg9/boyxkOWTvvW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.14 65/69] mwifiex: fix 802.11n/WPA detection
Date:   Wed, 14 Aug 2019 19:02:03 +0200
Message-Id: <20190814165750.429515291@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

commit df612421fe2566654047769c6852ffae1a31df16 upstream.

Commit 63d7ef36103d ("mwifiex: Don't abort on small, spec-compliant
vendor IEs") adjusted the ieee_types_vendor_header struct, which
inadvertently messed up the offsets used in
mwifiex_is_wpa_oui_present(). Add that offset back in, mirroring
mwifiex_is_rsn_oui_present().

As it stands, commit 63d7ef36103d breaks compatibility with WPA (not
WPA2) 802.11n networks, since we hit the "info: Disable 11n if AES is
not supported by AP" case in mwifiex_is_network_compatible().

Fixes: 63d7ef36103d ("mwifiex: Don't abort on small, spec-compliant vendor IEs")
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/marvell/mwifiex/main.h |    1 +
 drivers/net/wireless/marvell/mwifiex/scan.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -122,6 +122,7 @@ enum {
 
 #define MWIFIEX_MAX_TOTAL_SCAN_TIME	(MWIFIEX_TIMER_10S - MWIFIEX_TIMER_1S)
 
+#define WPA_GTK_OUI_OFFSET				2
 #define RSN_GTK_OUI_OFFSET				2
 
 #define MWIFIEX_OUI_NOT_PRESENT			0
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -181,7 +181,8 @@ mwifiex_is_wpa_oui_present(struct mwifie
 	u8 ret = MWIFIEX_OUI_NOT_PRESENT;
 
 	if (has_vendor_hdr(bss_desc->bcn_wpa_ie, WLAN_EID_VENDOR_SPECIFIC)) {
-		iebody = (struct ie_body *) bss_desc->bcn_wpa_ie->data;
+		iebody = (struct ie_body *)((u8 *)bss_desc->bcn_wpa_ie->data +
+					    WPA_GTK_OUI_OFFSET);
 		oui = &mwifiex_wpa_oui[cipher][0];
 		ret = mwifiex_search_oui_in_ie(iebody, oui);
 		if (ret)



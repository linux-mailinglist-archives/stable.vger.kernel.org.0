Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B99C5B85E1
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407084AbfISWYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:24:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407077AbfISWX7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:23:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FD0521929;
        Thu, 19 Sep 2019 22:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931838;
        bh=IL7gNa0WwSU3j+XDHGSg+0vrbhkPCEZH8oIstZlTZk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIoiPZ5z0wpKA89Hw8jtO9jnIUAGKUtff0/di/4pmawjVQ7zGGvUgnOgIUBumKlmf
         s/L8I9GEmGGov1Qx4MDl1NCSYfoIIfrtwbzI4NBmlNnd+bxnfja+zyDLiFB7qWmMhx
         8u+drf4hYGBfVutDsb5x6Sr9gSsfHVQiskjRX8Oc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Huang <huangwenabc@gmail.com>,
        Ganapathi Bhat <gbhat@marvell.comg>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.4 34/56] mwifiex: Fix three heap overflow at parsing element in cfg80211_ap_settings
Date:   Fri, 20 Sep 2019 00:04:15 +0200
Message-Id: <20190919214757.729438296@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214742.483643642@linuxfoundation.org>
References: <20190919214742.483643642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/ie.c      |    3 +++
 drivers/net/wireless/mwifiex/uap_cmd.c |    9 ++++++++-
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
@@ -286,6 +286,8 @@ mwifiex_set_uap_rates(struct mwifiex_uap
 
 	rate_ie = (void *)cfg80211_find_ie(WLAN_EID_SUPP_RATES, var_pos, len);
 	if (rate_ie) {
+		if (rate_ie->len > MWIFIEX_SUPPORTED_RATES)
+			return;
 		memcpy(bss_cfg->rates, rate_ie + 1, rate_ie->len);
 		rate_len = rate_ie->len;
 	}
@@ -293,8 +295,11 @@ mwifiex_set_uap_rates(struct mwifiex_uap
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
@@ -412,6 +417,8 @@ mwifiex_set_wmm_params(struct mwifiex_pr
 					    params->beacon.tail_len);
 	if (vendor_ie) {
 		wmm_ie = (struct ieee_types_header *)vendor_ie;
+		if (*(vendor_ie + 1) > sizeof(struct mwifiex_types_wmm_info))
+			return;
 		memcpy(&bss_cfg->wmm_info, wmm_ie + 1,
 		       sizeof(bss_cfg->wmm_info));
 		priv->wmm_enabled = 1;



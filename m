Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB46FB8763
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393120AbfISWHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393117AbfISWHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:07:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1952821907;
        Thu, 19 Sep 2019 22:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930819;
        bh=hFYo/74gVn52eg42PNmX0qBZBecS71x9smF8rN55b5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w6zT5l6VLhTz9AzQfWSgRQOnJoN9FywNRHruMIZfQ3/74s+D1zxoDLMA6mPlTMwJw
         TbxfSyLut8r5cjD5tjqUkzXDJW39+9XhN4/9xa1ku77D1LGdCKuPaRMNHWHTevmaOH
         fA/xhnoB7wYpDpntOYQ6ZPcgsur/BbP4RuBDkRpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Huang <huangwenabc@gmail.com>,
        Ganapathi Bhat <gbhat@marvell.comg>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.2 025/124] mwifiex: Fix three heap overflow at parsing element in cfg80211_ap_settings
Date:   Fri, 20 Sep 2019 00:01:53 +0200
Message-Id: <20190919214819.972597811@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
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
 drivers/net/wireless/marvell/mwifiex/ie.c      |    3 +++
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c |    9 ++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/marvell/mwifiex/ie.c
+++ b/drivers/net/wireless/marvell/mwifiex/ie.c
@@ -241,6 +241,9 @@ static int mwifiex_update_vs_ie(const u8
 		}
 
 		vs_ie = (struct ieee_types_header *)vendor_ie;
+		if (le16_to_cpu(ie->ie_length) + vs_ie->len + 2 >
+			IEEE_MAX_IE_SIZE)
+			return -EINVAL;
 		memcpy(ie->ie_buffer + le16_to_cpu(ie->ie_length),
 		       vs_ie, vs_ie->len + 2);
 		le16_unaligned_add_cpu(&ie->ie_length, vs_ie->len + 2);
--- a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
@@ -265,6 +265,8 @@ mwifiex_set_uap_rates(struct mwifiex_uap
 
 	rate_ie = (void *)cfg80211_find_ie(WLAN_EID_SUPP_RATES, var_pos, len);
 	if (rate_ie) {
+		if (rate_ie->len > MWIFIEX_SUPPORTED_RATES)
+			return;
 		memcpy(bss_cfg->rates, rate_ie + 1, rate_ie->len);
 		rate_len = rate_ie->len;
 	}
@@ -272,8 +274,11 @@ mwifiex_set_uap_rates(struct mwifiex_uap
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
@@ -391,6 +396,8 @@ mwifiex_set_wmm_params(struct mwifiex_pr
 					    params->beacon.tail_len);
 	if (vendor_ie) {
 		wmm_ie = vendor_ie;
+		if (*(wmm_ie + 1) > sizeof(struct mwifiex_types_wmm_info))
+			return;
 		memcpy(&bss_cfg->wmm_info, wmm_ie +
 		       sizeof(struct ieee_types_header), *(wmm_ie + 1));
 		priv->wmm_enabled = 1;



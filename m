Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36827113458
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbfLDSDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:03:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729968AbfLDSDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:03:01 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFAF3206DF;
        Wed,  4 Dec 2019 18:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482581;
        bh=as36yyMTcOQBSa+zdeo2KYFdGCCRtc4a2mshTBBRIh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uh1+L/R2/nlUj8Zk81MaHRJRrfHY655wVmFRlUlkYZDNQrpNgJ/fYZaW2WFNkGNkO
         dEiU3KZOwRhuyZoQqq1JOac4AwXRtkO0SxQuV/teUhXBDant7gLTlr93/3hpTlkcJY
         UiGlACYI19/12+ORu4EvTtfVWOAv1Ip+PlJvTUyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 046/209] mwifiex: fix potential NULL dereference and use after free
Date:   Wed,  4 Dec 2019 18:54:18 +0100
Message-Id: <20191204175324.567625200@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 1dcd9429212b98bea87fc6ec92fb50bf5953eb47 ]

There are two defects: (1) passing a NULL bss to
mwifiex_save_hidden_ssid_channels will result in NULL dereference,
(2) using bss after dropping the reference to it via cfg80211_put_bss.
To fix them, the patch moves the buggy code to the branch that bss is
not NULL and puts it before cfg80211_put_bss.

Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 67c3342210777..c013c94fbf15f 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1901,15 +1901,17 @@ mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
 					    ETH_ALEN))
 					mwifiex_update_curr_bss_params(priv,
 								       bss);
-				cfg80211_put_bss(priv->wdev.wiphy, bss);
-			}
 
-			if ((chan->flags & IEEE80211_CHAN_RADAR) ||
-			    (chan->flags & IEEE80211_CHAN_NO_IR)) {
-				mwifiex_dbg(adapter, INFO,
-					    "radar or passive channel %d\n",
-					    channel);
-				mwifiex_save_hidden_ssid_channels(priv, bss);
+				if ((chan->flags & IEEE80211_CHAN_RADAR) ||
+				    (chan->flags & IEEE80211_CHAN_NO_IR)) {
+					mwifiex_dbg(adapter, INFO,
+						    "radar or passive channel %d\n",
+						    channel);
+					mwifiex_save_hidden_ssid_channels(priv,
+									  bss);
+				}
+
+				cfg80211_put_bss(priv->wdev.wiphy, bss);
 			}
 		}
 	} else {
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9724191E5
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 11:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbhI0KAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 06:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233703AbhI0KAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 06:00:21 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8605AC061575;
        Mon, 27 Sep 2021 02:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=/lx1hyTvCxGj53rEQ9WPNWOBGzLKtKut8eOy9Qi9d3k=; t=1632736723; x=1633946323; 
        b=phN9WPCrQvmQ2P+MIIh3Q39uC3X2GLPjff5CF0x00qoc4yJoqER9N8cXV6gZnHaXpITCnNi/VXg
        VynmMvY+3LcD+o99GTLtxSyA4BS3Qvd6xE6gPjfOw6IjDObvgvNSngBwGcJrPgpQ4cCiQ702XAZ/L
        HBppL3DOZmrG/nKT7NFNjNwS0J+m5UOpkaSMFH6I552tes7ue/+1yJzkAyqC5xRZuiWpNFOleeWWU
        VW51/zHq/vdw2RoweInOeR71tq5Exeyl85lwfDc7K+L6tAc6Z7H7HcknBSOwsjHSE+4sW9FgAxk+I
        qRhQDeG/v7ypfDRpfZffl5URSaPHXUiSXeyg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95-RC2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mUnPF-00CN3q-FX;
        Mon, 27 Sep 2021 11:58:41 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org
Subject: [PATCH] mac80211: fix use-after-free in CCMP/GCMP RX
Date:   Mon, 27 Sep 2021 11:58:39 +0200
Message-Id: <20210927115838.12b9ac6bb233.I1d066acd5408a662c3b6e828122cd314fcb28cdb@changeid>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

When PN checking is done in mac80211, for fragmentation we need
to copy the PN to the RX struct so we can later use it to do a
comparison, since commit bf30ca922a0c ("mac80211: check defrag
PN against current frame").

Unfortunately, in that commit I used the 'hdr' variable without
it being necessarily valid, so use-after-free could occur if it
was necessary to reallocate (parts of) the frame.

Fix this by reloading the variable after the code that results
in the reallocations, if any.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=214401.

Cc: stable@vger.kernel.org
Fixes: bf30ca922a0c ("mac80211: check defrag PN against current frame")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/wpa.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index bca47fad5a16..4eed23e27610 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -520,6 +520,9 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx,
 			return RX_DROP_UNUSABLE;
 	}
 
+	/* reload hdr - skb might have been reallocated */
+	hdr = (void *)rx->skb->data;
+
 	data_len = skb->len - hdrlen - IEEE80211_CCMP_HDR_LEN - mic_len;
 	if (!rx->sta || data_len < 0)
 		return RX_DROP_UNUSABLE;
@@ -749,6 +752,9 @@ ieee80211_crypto_gcmp_decrypt(struct ieee80211_rx_data *rx)
 			return RX_DROP_UNUSABLE;
 	}
 
+	/* reload hdr - skb might have been reallocated */
+	hdr = (void *)rx->skb->data;
+
 	data_len = skb->len - hdrlen - IEEE80211_GCMP_HDR_LEN - mic_len;
 	if (!rx->sta || data_len < 0)
 		return RX_DROP_UNUSABLE;
-- 
2.31.1


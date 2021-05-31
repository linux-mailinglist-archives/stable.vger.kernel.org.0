Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1D9395BE3
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhEaNZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:25:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232019AbhEaNXn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:23:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 649A06135D;
        Mon, 31 May 2021 13:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467204;
        bh=T0uyLt3w9LbOp+KZeE25iK1OAQJNXyiNPw5Gs/3sDHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uV52WvL9Plge4fQcVUrjuNRtdzpZ01iSz/I6McHxOWw67DCgGMCjeGJCD60FVrYmA
         P9NeXonZ1y4f1yWQ1HvjoUIADMOVnOlFbopQDpt1JaUeMQY/d4aUqDesSEA0cdt6Rd
         6FjBCQZOjkNa4ij3yIadPwBt6/fP54HhpihL3+MM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.9 09/66] mac80211: assure all fragments are encrypted
Date:   Mon, 31 May 2021 15:13:42 +0200
Message-Id: <20210531130636.562556549@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.254683895@linuxfoundation.org>
References: <20210531130636.254683895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>

commit 965a7d72e798eb7af0aa67210e37cf7ecd1c9cad upstream.

Do not mix plaintext and encrypted fragments in protected Wi-Fi
networks. This fixes CVE-2020-26147.

Previously, an attacker was able to first forward a legitimate encrypted
fragment towards a victim, followed by a plaintext fragment. The
encrypted and plaintext fragment would then be reassembled. For further
details see Section 6.3 and Appendix D in the paper "Fragment and Forge:
Breaking Wi-Fi Through Frame Aggregation and Fragmentation".

Because of this change there are now two equivalent conditions in the
code to determine if a received fragment requires sequential PNs, so we
also move this test to a separate function to make the code easier to
maintain.

Cc: stable@vger.kernel.org
Signed-off-by: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
Link: https://lore.kernel.org/r/20210511200110.30c4394bb835.I5acfdb552cc1d20c339c262315950b3eac491397@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/rx.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1942,6 +1942,16 @@ ieee80211_reassemble_find(struct ieee802
 	return NULL;
 }
 
+static bool requires_sequential_pn(struct ieee80211_rx_data *rx, __le16 fc)
+{
+	return rx->key &&
+		(rx->key->conf.cipher == WLAN_CIPHER_SUITE_CCMP ||
+		 rx->key->conf.cipher == WLAN_CIPHER_SUITE_CCMP_256 ||
+		 rx->key->conf.cipher == WLAN_CIPHER_SUITE_GCMP ||
+		 rx->key->conf.cipher == WLAN_CIPHER_SUITE_GCMP_256) &&
+		ieee80211_has_protected(fc);
+}
+
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 {
@@ -1987,12 +1997,7 @@ ieee80211_rx_h_defragment(struct ieee802
 		/* This is the first fragment of a new frame. */
 		entry = ieee80211_reassemble_add(rx->sdata, frag, seq,
 						 rx->seqno_idx, &(rx->skb));
-		if (rx->key &&
-		    (rx->key->conf.cipher == WLAN_CIPHER_SUITE_CCMP ||
-		     rx->key->conf.cipher == WLAN_CIPHER_SUITE_CCMP_256 ||
-		     rx->key->conf.cipher == WLAN_CIPHER_SUITE_GCMP ||
-		     rx->key->conf.cipher == WLAN_CIPHER_SUITE_GCMP_256) &&
-		    ieee80211_has_protected(fc)) {
+		if (requires_sequential_pn(rx, fc)) {
 			int queue = rx->security_idx;
 
 			/* Store CCMP/GCMP PN so that we can verify that the
@@ -2034,11 +2039,7 @@ ieee80211_rx_h_defragment(struct ieee802
 		u8 pn[IEEE80211_CCMP_PN_LEN], *rpn;
 		int queue;
 
-		if (!rx->key ||
-		    (rx->key->conf.cipher != WLAN_CIPHER_SUITE_CCMP &&
-		     rx->key->conf.cipher != WLAN_CIPHER_SUITE_CCMP_256 &&
-		     rx->key->conf.cipher != WLAN_CIPHER_SUITE_GCMP &&
-		     rx->key->conf.cipher != WLAN_CIPHER_SUITE_GCMP_256))
+		if (!requires_sequential_pn(rx, fc))
 			return RX_DROP_UNUSABLE;
 		memcpy(pn, entry->last_pn, IEEE80211_CCMP_PN_LEN);
 		for (i = IEEE80211_CCMP_PN_LEN - 1; i >= 0; i--) {



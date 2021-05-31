Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B205395C39
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhEaNaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:30:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231397AbhEaN1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:27:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C709613CB;
        Mon, 31 May 2021 13:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467318;
        bh=QqGeEXf6GZB/7XfQGcN/jwXIRiJkbfoc+B93n3Y1/vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kYCcd6oVcgiDaXdVno+rCMNK0O+T/a28QLrfYi01rntt76EKP1ja7RTffZJzYIgt2
         DLBjpLtZLKGocF1mVmACMje/ArSVA+3WqVjU2/v73MfxoGaqQdPcb8oT+rlOW2+H09
         pbbfhSRIL7fbUUpqXSGXVQAXmnlFsYnRTF5AYSZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gong <wgong@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 020/116] mac80211: extend protection against mixed key and fragment cache attacks
Date:   Mon, 31 May 2021 15:13:16 +0200
Message-Id: <20210531130640.838919766@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Gong <wgong@codeaurora.org>

commit 3edc6b0d6c061a70d8ca3c3c72eb1f58ce29bfb1 upstream.

For some chips/drivers, e.g., QCA6174 with ath10k, the decryption is
done by the hardware, and the Protected bit in the Frame Control field
is cleared in the lower level driver before the frame is passed to
mac80211. In such cases, the condition for ieee80211_has_protected() is
not met in ieee80211_rx_h_defragment() of mac80211 and the new security
validation steps are not executed.

Extend mac80211 to cover the case where the Protected bit has been
cleared, but the frame is indicated as having been decrypted by the
hardware. This extends protection against mixed key and fragment cache
attack for additional drivers/chips. This fixes CVE-2020-24586 and
CVE-2020-24587 for such cases.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00110-QCARMSWP-1

Cc: stable@vger.kernel.org
Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Link: https://lore.kernel.org/r/20210511200110.037aa5ca0390.I7bb888e2965a0db02a67075fcb5deb50eb7408aa@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/rx.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2113,6 +2113,7 @@ ieee80211_rx_h_defragment(struct ieee802
 	unsigned int frag, seq;
 	struct ieee80211_fragment_entry *entry;
 	struct sk_buff *skb;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 
 	hdr = (struct ieee80211_hdr *)rx->skb->data;
 	fc = hdr->frame_control;
@@ -2171,7 +2172,9 @@ ieee80211_rx_h_defragment(struct ieee802
 				     sizeof(rx->key->u.gcmp.rx_pn[queue]));
 			BUILD_BUG_ON(IEEE80211_CCMP_PN_LEN !=
 				     IEEE80211_GCMP_PN_LEN);
-		} else if (rx->key && ieee80211_has_protected(fc)) {
+		} else if (rx->key &&
+			   (ieee80211_has_protected(fc) ||
+			    (status->flag & RX_FLAG_DECRYPTED))) {
 			entry->is_protected = true;
 			entry->key_color = rx->key->color;
 		}
@@ -2216,13 +2219,19 @@ ieee80211_rx_h_defragment(struct ieee802
 			return RX_DROP_UNUSABLE;
 		memcpy(entry->last_pn, pn, IEEE80211_CCMP_PN_LEN);
 	} else if (entry->is_protected &&
-		   (!rx->key || !ieee80211_has_protected(fc) ||
+		   (!rx->key ||
+		    (!ieee80211_has_protected(fc) &&
+		     !(status->flag & RX_FLAG_DECRYPTED)) ||
 		    rx->key->color != entry->key_color)) {
 		/* Drop this as a mixed key or fragment cache attack, even
 		 * if for TKIP Michael MIC should protect us, and WEP is a
 		 * lost cause anyway.
 		 */
 		return RX_DROP_UNUSABLE;
+	} else if (entry->is_protected && rx->key &&
+		   entry->key_color != rx->key->color &&
+		   (status->flag & RX_FLAG_DECRYPTED)) {
+		return RX_DROP_UNUSABLE;
 	}
 
 	skb_pull(rx->skb, ieee80211_hdrlen(fc));



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2173420F3C
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237718AbhJDNca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:32:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237562AbhJDNae (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:30:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E89061B96;
        Mon,  4 Oct 2021 13:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353231;
        bh=9DB9ESAOJ1QB5v+g5UT2LVVrpoNPdfYcg2nLYbholQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ythVLsRqwDIs8FPiTAH2QGdGMManVBLA+5SoXCvaI2PHkifTtqz/4K52Q7jueNMpd
         6FYAB/nCEA9RCgw+/SBkPPpNjFxsWhvnKnJBZgw/f/IgB9UcjF8/S5zz5H/cC7lneo
         DkJKrGmOzyYokdYcmMeXfkJJ646cH7hbRsFdwU88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.14 046/172] mac80211: fix use-after-free in CCMP/GCMP RX
Date:   Mon,  4 Oct 2021 14:51:36 +0200
Message-Id: <20211004125046.478858397@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 94513069eb549737bcfc3d988d6ed4da948a2de8 upstream.

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
Link: https://lore.kernel.org/r/20210927115838.12b9ac6bb233.I1d066acd5408a662c3b6e828122cd314fcb28cdb@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/wpa.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -520,6 +520,9 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 			return RX_DROP_UNUSABLE;
 	}
 
+	/* reload hdr - skb might have been reallocated */
+	hdr = (void *)rx->skb->data;
+
 	data_len = skb->len - hdrlen - IEEE80211_CCMP_HDR_LEN - mic_len;
 	if (!rx->sta || data_len < 0)
 		return RX_DROP_UNUSABLE;
@@ -749,6 +752,9 @@ ieee80211_crypto_gcmp_decrypt(struct iee
 			return RX_DROP_UNUSABLE;
 	}
 
+	/* reload hdr - skb might have been reallocated */
+	hdr = (void *)rx->skb->data;
+
 	data_len = skb->len - hdrlen - IEEE80211_GCMP_HDR_LEN - mic_len;
 	if (!rx->sta || data_len < 0)
 		return RX_DROP_UNUSABLE;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9114D19AFC0
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733049AbgDAQUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:20:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732279AbgDAQUo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:20:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1D1F214DB;
        Wed,  1 Apr 2020 16:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758043;
        bh=ETc9gsiahZ4Pty8Vw11tG9m3QQorzMwTAanEJJvVprM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QvOsHKBmfHZNnpRxMxA9UF1tFXU50YFb1n6B5kQQyB19a9/mieLKZLDeBDQCcy9Hf
         HvP9xJJ9upbY0D4ACBvIAlaNqcv/M5kVEZ5x1sjJ51NMlR04yLUkEd451u3oHC56+x
         biwnyahK57kKvyeCYvrzmon8Bfp7xwJPr3fEPZWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Woody Suwalski <terraluna977@gmail.com>
Subject: [PATCH 5.5 03/30] mac80211: fix authentication with iwlwifi/mvm
Date:   Wed,  1 Apr 2020 18:17:07 +0200
Message-Id: <20200401161417.037219061@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161414.345528747@linuxfoundation.org>
References: <20200401161414.345528747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit be8c827f50a0bcd56361b31ada11dc0a3c2fd240 upstream.

The original patch didn't copy the ieee80211_is_data() condition
because on most drivers the management frames don't go through
this path. However, they do on iwlwifi/mvm, so we do need to keep
the condition here.

Cc: stable@vger.kernel.org
Fixes: ce2e1ca70307 ("mac80211: Check port authorization in the ieee80211_tx_dequeue() case")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Woody Suwalski <terraluna977@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/tx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3610,7 +3610,8 @@ begin:
 		 * Drop unicast frames to unauthorised stations unless they are
 		 * EAPOL frames from the local station.
 		 */
-		if (unlikely(!ieee80211_vif_is_mesh(&tx.sdata->vif) &&
+		if (unlikely(ieee80211_is_data(hdr->frame_control) &&
+			     !ieee80211_vif_is_mesh(&tx.sdata->vif) &&
 			     tx.sdata->vif.type != NL80211_IFTYPE_OCB &&
 			     !is_multicast_ether_addr(hdr->addr1) &&
 			     !test_sta_flag(tx.sta, WLAN_STA_AUTHORIZED) &&



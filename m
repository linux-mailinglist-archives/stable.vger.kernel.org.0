Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7075047AEFC
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237266AbhLTPHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241457AbhLTPF1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:05:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEC8C09B129;
        Mon, 20 Dec 2021 06:52:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 347E7B80EF8;
        Mon, 20 Dec 2021 14:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793E8C36AE7;
        Mon, 20 Dec 2021 14:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011972;
        bh=tCY0QyjfFF6hrUjOA4Xx1Qc+ggrY7c9SBUBVLR/xPEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0u4cmPjVlPMkWLz47nrwWGjPP9U5PpF1rIIykPyi81TKbfqiTav+GFex3NGsX3B5j
         ButmyUaWAfsHArFd4LxZev1CLWWlTEUAEwzJ61u9FdSsma9kPdaDWWqMD+r1mc50GO
         iAG04NmQEShx/yLD/migvkY3U2c00O0FHR6VCqOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Robert W <rwbugreport@lost-in-the-void.net>,
        Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 007/177] mac80211: fix rate control for retransmitted frames
Date:   Mon, 20 Dec 2021 15:32:37 +0100
Message-Id: <20211220143040.322809076@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

commit 18688c80ad8a8dd50523dc9276e929932cac86d4 upstream.

Since retransmission clears info->control, rate control needs to be called
again, otherwise the driver might crash due to invalid rates.

Cc: stable@vger.kernel.org # 5.14+
Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reported-by: Robert W <rwbugreport@lost-in-the-void.net>
Fixes: 03c3911d2d67 ("mac80211: call ieee80211_tx_h_rate_ctrl() when dequeue")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Link: https://lore.kernel.org/r/20211122204323.9787-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/tx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1821,15 +1821,15 @@ static int invoke_tx_handlers_late(struc
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	ieee80211_tx_result res = TX_CONTINUE;
 
+	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
+		CALL_TXH(ieee80211_tx_h_rate_ctrl);
+
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_RETRANSMISSION)) {
 		__skb_queue_tail(&tx->skbs, tx->skb);
 		tx->skb = NULL;
 		goto txh_done;
 	}
 
-	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
-		CALL_TXH(ieee80211_tx_h_rate_ctrl);
-
 	CALL_TXH(ieee80211_tx_h_michael_mic_add);
 	CALL_TXH(ieee80211_tx_h_sequence);
 	CALL_TXH(ieee80211_tx_h_fragment);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C962F35BFC4
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238055AbhDLJGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239959AbhDLJEO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:04:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6C546125F;
        Mon, 12 Apr 2021 09:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218109;
        bh=pvq29ehwiw1el+BH46uOAN2FjF35TIZooBak9YNdEj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8LyWw4h7Q2rTFZDBydXTBC9Yf2WjNhdQE9n6Hrt8+5H/6GZd3KcM7msZXpRtmVb/
         A7NOSbabFRVTJe439Vyx5WY5I5UR2QtfKs2ZPWg4G9s/Vf8WA8DLNkSKZ5583hZzVs
         ZncngmIoZCzNdQLFIXcGyDn6DvSH9bvFtPpjdr1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.11 074/210] mac80211: fix TXQ AC confusion
Date:   Mon, 12 Apr 2021 10:39:39 +0200
Message-Id: <20210412084018.489822201@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 1153a74768a9212daadbb50767aa400bc6a0c9b0 upstream.

Normally, TXQs have

  txq->tid = tid;
  txq->ac = ieee80211_ac_from_tid(tid);

However, the special management TXQ actually has

  txq->tid = IEEE80211_NUM_TIDS; // 16
  txq->ac = IEEE80211_AC_VO;

This makes sense, but ieee80211_ac_from_tid(16) is the same
as ieee80211_ac_from_tid(0) which is just IEEE80211_AC_BE.

Now, normally this is fine. However, if the netdev queues
were stopped, then the code in ieee80211_tx_dequeue() will
propagate the stop from the interface (vif->txqs_stopped[])
if the AC 2 (ieee80211_ac_from_tid(txq->tid)) is marked as
stopped. On wake, however, __ieee80211_wake_txqs() will wake
the TXQ if AC 0 (txq->ac) is woken up.

If a driver stops all queues with ieee80211_stop_tx_queues()
and then wakes them again with ieee80211_wake_tx_queues(),
the ieee80211_wake_txqs() tasklet will run to resync queue
and TXQ state. If all queues were woken, then what'll happen
is that _ieee80211_wake_txqs() will run in order of HW queues
0-3, typically (and certainly for iwlwifi) corresponding to
ACs 0-3, so it'll call __ieee80211_wake_txqs() for each AC in
order 0-3.

When __ieee80211_wake_txqs() is called for AC 0 (VO) that'll
wake up the management TXQ (remember its tid is 16), and the
driver's wake_tx_queue() will be called. That tries to get a
frame, which will immediately *stop* the TXQ again, because
now we check against AC 2, and AC 2 hasn't yet been marked as
woken up again in sdata->vif.txqs_stopped[] since we're only
in the __ieee80211_wake_txqs() call for AC 0.

Thus, the management TXQ will never be started again.

Fix this by checking txq->ac directly instead of calculating
the AC as ieee80211_ac_from_tid(txq->tid).

Fixes: adf8ed01e4fd ("mac80211: add an optional TXQ for other PS-buffered frames")
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20210323210500.bf4d50afea4a.I136ffde910486301f8818f5442e3c9bf8670a9c4@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3578,7 +3578,7 @@ begin:
 	    test_bit(IEEE80211_TXQ_STOP_NETIF_TX, &txqi->flags))
 		goto out;
 
-	if (vif->txqs_stopped[ieee80211_ac_from_tid(txq->tid)]) {
+	if (vif->txqs_stopped[txq->ac]) {
 		set_bit(IEEE80211_TXQ_STOP_NETIF_TX, &txqi->flags);
 		goto out;
 	}



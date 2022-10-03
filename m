Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76AE55F2914
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiJCHNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiJCHMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:12:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33A83ED51;
        Mon,  3 Oct 2022 00:12:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD0DDB80E65;
        Mon,  3 Oct 2022 07:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C2AC433D6;
        Mon,  3 Oct 2022 07:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781150;
        bh=bAsZibJ+SV/6sKdKx+eVm7gzU6Hj6eFDQbdIssBdeA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJKXsziGOQOt2UfnzokKEuQMkSe+/h8uyj98Ix6iTzi5wyohiWEq2Y7ehByLiOAN3
         pk4pMN4Pqnfy3frwIj8KK7y7hahJ5V8W7BtCLu6lbUywB65+IHrsSAdxczU+37g5cn
         pQy+rfMpoU7R24Iv9fpD8tIECB17ZsCv8vOsxYsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>,
        Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.19 016/101] wifi: mac80211: ensure vif queues are operational after start
Date:   Mon,  3 Oct 2022 09:10:12 +0200
Message-Id: <20221003070724.905319582@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Wetzel <alexander@wetzel-home.de>

commit 527008e5e87600a389feb8a57042c928ecca195d upstream.

Make sure local->queue_stop_reasons and vif.txqs_stopped stay in sync.

When a new vif is created the queues may end up in an inconsistent state
and be inoperable:
Communication not using iTXQ will work, allowing to e.g. complete the
association. But the 4-way handshake will time out. The sta will not
send out any skbs queued in iTXQs.

All normal attempts to start the queues will fail when reaching this
state.
local->queue_stop_reasons will have marked all queues as operational but
vif.txqs_stopped will still be set, creating an inconsistent internal
state.

In reality this seems to be race between the mac80211 function
ieee80211_do_open() setting SDATA_STATE_RUNNING and the wake_txqs_tasklet:
Depending on the driver and the timing the queues may end up to be
operational or not.

Cc: stable@vger.kernel.org
Fixes: f856373e2f31 ("wifi: mac80211: do not wake queues on a vif that is being stopped")
Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
Acked-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20220915130946.302803-1-alexander@wetzel-home.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 53826c663723..efcefb2dd882 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -301,14 +301,14 @@ static void __ieee80211_wake_txqs(struct ieee80211_sub_if_data *sdata, int ac)
 	local_bh_disable();
 	spin_lock(&fq->lock);
 
+	sdata->vif.txqs_stopped[ac] = false;
+
 	if (!test_bit(SDATA_STATE_RUNNING, &sdata->state))
 		goto out;
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP)
 		ps = &sdata->bss->ps;
 
-	sdata->vif.txqs_stopped[ac] = false;
-
 	list_for_each_entry_rcu(sta, &local->sta_list, list) {
 		if (sdata != sta->sdata)
 			continue;
-- 
2.37.3




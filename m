Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790B85B9BAB
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 15:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiIONR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 09:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiIONR3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 09:17:29 -0400
X-Greylist: delayed 369 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 15 Sep 2022 06:17:27 PDT
Received: from ns2.wdyn.eu (ns2.wdyn.eu [5.252.227.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BAB5354C82
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 06:17:27 -0700 (PDT)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1663247476;
        bh=48tDIj0A9GvYAtg3Z0lO5EOHGEAhb+Ky2FLtbtQEnyw=;
        h=From:To:Cc:Subject:Date;
        b=gzABjwsw0zaNDSDnEI2d+B+BN4kfzn+AiuNUlR9g32bmjGoh3uhohxO64Ioddd7EV
         nnuuVMIUEnfzRr/JRiYPYtsn7lPmzZpRzJLUOIrrzFngyQLFua6O0Crdc0ISUsN3Ii
         wTCrCLOrsRwwX00k+Ysw8JyqyGKrTaWs4+4RWMjg=
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Felix Fietkau <nbd@nbd.name>,
        Alexander Wetzel <alexander@wetzel-home.de>,
        stable@vger.kernel.org
Subject: [PATCH] mac80211: Ensure vif queues are operational after start
Date:   Thu, 15 Sep 2022 15:09:46 +0200
Message-Id: <20220915130946.302803-1-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 net/mac80211/util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 0ea5d50091dc..bf7461c41bef 100644
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


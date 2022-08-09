Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A6658DB8A
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 18:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237321AbiHIQCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 12:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239710AbiHIQCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 12:02:51 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847D1101C0
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 09:02:50 -0700 (PDT)
Received: from lvc-arm12.ispras.local (unknown [83.149.199.125])
        by mail.ispras.ru (Postfix) with ESMTPS id D7FAB40755CB;
        Tue,  9 Aug 2022 16:02:48 +0000 (UTC)
From:   Viacheslav Sablin <sablin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Viacheslav Sablin <sablin@ispras.ru>,
        Ahmed Zaki <anzaki@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org
Subject: [PATCH 5.10 1/1] mac80211: fix a memory leak where sta_info is not freed
Date:   Tue,  9 Aug 2022 19:02:45 +0300
Message-Id: <20220809160245.29232-2-sablin@ispras.ru>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220809160245.29232-1-sablin@ispras.ru>
References: <20220809160245.29232-1-sablin@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmed Zaki <anzaki@gmail.com>

commit 8f9dcc29566626f683843ccac6113a12208315ca upstream.

The following is from a system that went OOM due to a memory leak:

wlan0: Allocated STA 74:83:c2:64:0b:87
wlan0: Allocated STA 74:83:c2:64:0b:87
wlan0: IBSS finish 74:83:c2:64:0b:87 (---from ieee80211_ibss_add_sta)
wlan0: Adding new IBSS station 74:83:c2:64:0b:87
wlan0: moving STA 74:83:c2:64:0b:87 to state 2
wlan0: moving STA 74:83:c2:64:0b:87 to state 3
wlan0: Inserted STA 74:83:c2:64:0b:87
wlan0: IBSS finish 74:83:c2:64:0b:87 (---from ieee80211_ibss_work)
wlan0: Adding new IBSS station 74:83:c2:64:0b:87
wlan0: moving STA 74:83:c2:64:0b:87 to state 2
wlan0: moving STA 74:83:c2:64:0b:87 to state 3
.
.
wlan0: expiring inactive not authorized STA 74:83:c2:64:0b:87
wlan0: moving STA 74:83:c2:64:0b:87 to state 2
wlan0: moving STA 74:83:c2:64:0b:87 to state 1
wlan0: Removed STA 74:83:c2:64:0b:87
wlan0: Destroyed STA 74:83:c2:64:0b:87

The ieee80211_ibss_finish_sta() is called twice on the same STA from 2
different locations. On the second attempt, the allocated STA is not
destroyed creating a kernel memory leak.

This is happening because sta_info_insert_finish() does not call
sta_info_free() the second time when the STA already exists (returns
-EEXIST). Note that the caller sta_info_insert_rcu() assumes STA is
destroyed upon errors.

Same fix is applied to -ENOMEM.

Signed-off-by: Ahmed Zaki <anzaki@gmail.com>
Link: https://lore.kernel.org/r/20211002145329.3125293-1-anzaki@gmail.com
[change the error path label to use the existing code]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Viacheslav Sablin <sablin@ispras.ru>
---
 net/mac80211/sta_info.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index e18c3855f616..461c03737da8 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -645,13 +645,13 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 	/* check if STA exists already */
 	if (sta_info_get_bss(sdata, sta->sta.addr)) {
 		err = -EEXIST;
-		goto out_err;
+		goto out_cleanup;
 	}
 
 	sinfo = kzalloc(sizeof(struct station_info), GFP_KERNEL);
 	if (!sinfo) {
 		err = -ENOMEM;
-		goto out_err;
+		goto out_cleanup;
 	}
 
 	local->num_sta++;
@@ -707,8 +707,8 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
  out_drop_sta:
 	local->num_sta--;
 	synchronize_net();
+ out_cleanup:
 	cleanup_single_sta(sta);
- out_err:
 	mutex_unlock(&local->sta_mtx);
 	kfree(sinfo);
 	rcu_read_lock();
-- 
2.30.2


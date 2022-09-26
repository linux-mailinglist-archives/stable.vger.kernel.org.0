Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D25B5E9FBC
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235463AbiIZK3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235640AbiIZK2n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:28:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BF44E61E;
        Mon, 26 Sep 2022 03:19:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAFF4B80915;
        Mon, 26 Sep 2022 10:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49862C433C1;
        Mon, 26 Sep 2022 10:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187488;
        bh=Gws39Zod51pQ7ojLk/9ZwRkZ9aRl9dDPPARiAQhVGa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d08FGmpmPjgSIjd5QwvSnCOKriSKGa0aLl0CSjCqEuTgAhDNtxV7+2c4K0WzXJk9d
         /nLmfCye7TeiwYqbhZykBZg3stmXYgg8rdf6GZI9EoDfIkoceC8BOjjDjpK8SCZIlt
         /PvlJnGWkBIFZqyZNiOxi1eKgQb1RGDzYbfgAHwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f9acff9bf08a845f225d@syzkaller.appspotmail.com,
        Johannes Berg <johannes@sipsolutions.net>,
        Siddh Raman Pant <code@siddh.me>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 24/58] wifi: mac80211: Fix UAF in ieee80211_scan_rx()
Date:   Mon, 26 Sep 2022 12:11:43 +0200
Message-Id: <20220926100742.330172253@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Siddh Raman Pant <code@siddh.me>

[ Upstream commit 60deb9f10eec5c6a20252ed36238b55d8b614a2c ]

ieee80211_scan_rx() tries to access scan_req->flags after a
null check, but a UAF is observed when the scan is completed
and __ieee80211_scan_completed() executes, which then calls
cfg80211_scan_done() leading to the freeing of scan_req.

Since scan_req is rcu_dereference()'d, prevent the racing in
__ieee80211_scan_completed() by ensuring that from mac80211's
POV it is no longer accessed from an RCU read critical section
before we call cfg80211_scan_done().

Cc: stable@vger.kernel.org
Link: https://syzkaller.appspot.com/bug?extid=f9acff9bf08a845f225d
Reported-by: syzbot+f9acff9bf08a845f225d@syzkaller.appspotmail.com
Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Siddh Raman Pant <code@siddh.me>
Link: https://lore.kernel.org/r/20220819200340.34826-1-code@siddh.me
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/scan.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index de42bcfeda9c..e3d8be4feea5 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -412,10 +412,6 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	scan_req = rcu_dereference_protected(local->scan_req,
 					     lockdep_is_held(&local->mtx));
 
-	if (scan_req != local->int_scan_req) {
-		local->scan_info.aborted = aborted;
-		cfg80211_scan_done(scan_req, &local->scan_info);
-	}
 	RCU_INIT_POINTER(local->scan_req, NULL);
 
 	scan_sdata = rcu_dereference_protected(local->scan_sdata,
@@ -425,6 +421,13 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	local->scanning = 0;
 	local->scan_chandef.chan = NULL;
 
+	synchronize_rcu();
+
+	if (scan_req != local->int_scan_req) {
+		local->scan_info.aborted = aborted;
+		cfg80211_scan_done(scan_req, &local->scan_info);
+	}
+
 	/* Set power back to normal operating levels. */
 	ieee80211_hw_config(local, 0);
 
-- 
2.35.1




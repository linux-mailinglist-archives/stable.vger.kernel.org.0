Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B569C63DF12
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbiK3Sni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbiK3Sn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:43:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D7E532FD
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:43:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4CC3DCE1ADB
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BA2C433D6;
        Wed, 30 Nov 2022 18:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833802;
        bh=q/BJ+//GJyKpfHhVMqvr+v+pGDKuEWPiV8o1bGKTibg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s9dslespamM758xZQjFZWmdmyl5SUFbr0i5MaZcoBdcIhK3wvgwjTBDoPJBHGu3EO
         iK23DeXA3lsnbByRWjIXBVoJv4NXsd8U5cFccHSC73hSJY2Rqp63fC3EBbVyw6OX4Z
         ZEukUIVdX09m9YfSXVjM4WrGbBYK0GvZxP8xczgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, taozhang <taozhang@bestechnic.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 004/289] wifi: mac80211: fix memory free error when registering wiphy fail
Date:   Wed, 30 Nov 2022 19:19:49 +0100
Message-Id: <20221130180544.214601340@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: taozhang <taozhang@bestechnic.com>

[ Upstream commit 50b2e8711462409cd368c41067405aa446dfa2af ]

ieee80211_register_hw free the allocated cipher suites when
registering wiphy fail, and ieee80211_free_hw will re-free it.

set wiphy_ciphers_allocated to false after freeing allocated
cipher suites.

Signed-off-by: taozhang <taozhang@bestechnic.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 5b1c47ed0cc0..87e24bba4c67 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1437,8 +1437,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	ieee80211_led_exit(local);
 	destroy_workqueue(local->workqueue);
  fail_workqueue:
-	if (local->wiphy_ciphers_allocated)
+	if (local->wiphy_ciphers_allocated) {
 		kfree(local->hw.wiphy->cipher_suites);
+		local->wiphy_ciphers_allocated = false;
+	}
 	kfree(local->int_scan_req);
 	return result;
 }
@@ -1506,8 +1508,10 @@ void ieee80211_free_hw(struct ieee80211_hw *hw)
 	mutex_destroy(&local->iflist_mtx);
 	mutex_destroy(&local->mtx);
 
-	if (local->wiphy_ciphers_allocated)
+	if (local->wiphy_ciphers_allocated) {
 		kfree(local->hw.wiphy->cipher_suites);
+		local->wiphy_ciphers_allocated = false;
+	}
 
 	idr_for_each(&local->ack_status_frames,
 		     ieee80211_free_ack_frame, NULL);
-- 
2.35.1




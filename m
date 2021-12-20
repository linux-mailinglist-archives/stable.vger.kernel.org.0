Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A57747A5BA
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 09:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhLTIJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 03:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237821AbhLTIJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 03:09:27 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EB7C061574;
        Mon, 20 Dec 2021 00:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=/Ok/WJNg439fF5t91FF+Oe9kJwWx1DC1dX/ps27Wrws=; t=1639987767; x=1641197367; 
        b=VQgr2cGpMLFRDyCYHXRGXisqj3xFZY/fpnR7b2IxMqP2dJP2fwNqpjp5AZRbTEKPqWbXMv6rMcg
        Z4CEWo6dJanDZ58Qnd0+s3fq1AcKdG3VAq4fdsVdHDSgtFExUzqsl44o0yeZD1g682n4AvoJsDfYy
        FbX2O70etpiOAW1pbr3hd8BwvRNFEGFJTWZjSDCPWibpuZRCtWEx2qsg41+2ztXndgmW88UZsT7JV
        JA7qA37SceynZpursbKdvY1RX8fHXgIxHzjCCgneAmvzrBvCnzh2VBueWVmBjhC425axbgQ5ZTAFJ
        ZOVX7Pys82gOXGmgZB108apA3pMH/xdxvMIA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mzDjX-00E1CY-Bl;
        Mon, 20 Dec 2021 09:09:23 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org,
        syzbot+11c342e5e30e9539cabd@syzkaller.appspotmail.com
Subject: [PATCH] mac80211: fix locking in ieee80211_start_ap error path
Date:   Mon, 20 Dec 2021 09:08:40 +0100
Message-Id: <20211220090836.cee3d59a1915.I36bba9b79dc2ff4d57c3c7aa30dff9a003fe8c5c@changeid>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

We need to hold the local->mtx to release the channel context,
as even encoded by the lockdep_assert_held() there. Fix it.

Cc: stable@vger.kernel.org
Fixes: 295b02c4be74 ("mac80211: Add FILS discovery support")
Reported-by: syzbot+11c342e5e30e9539cabd@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git master
---
 net/mac80211/cfg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bd3d3195097f..2d0dd69f9753 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1264,7 +1264,10 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 
 error:
+	mutex_lock(&local->mtx);
 	ieee80211_vif_release_channel(sdata);
+	mutex_unlock(&local->mtx);
+
 	return err;
 }
 
-- 
2.33.1


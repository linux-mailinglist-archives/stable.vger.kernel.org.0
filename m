Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2D6194204
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 15:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgCZOvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 10:51:50 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:48760 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728203AbgCZOvt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 10:51:49 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jHTrH-00BYfo-RB; Thu, 26 Mar 2020 15:51:47 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] mac80211: mark station unauthorized before key removal
Date:   Thu, 26 Mar 2020 15:51:35 +0100
Message-Id: <20200326155133.ccb4fb0bb356.If48f0f0504efdcf16b8921f48c6d3bb2cb763c99@changeid>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200326155133.ced84317ea29.I34d4c47cd8cc8a4042b38a76f16a601fbcbfd9b3@changeid>
References: <20200326155133.ced84317ea29.I34d4c47cd8cc8a4042b38a76f16a601fbcbfd9b3@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

If a station is still marked as authorized, mark it as no longer
so before removing its keys. This allows frames transmitted to it
to be rejected, providing additional protection against leaking
plain text data during the disconnection flow.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 0f5f40678885..e3572be307d6 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -4,7 +4,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright (C) 2015 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2019 Intel Corporation
+ * Copyright (C) 2018-2020 Intel Corporation
  */
 
 #include <linux/module.h>
@@ -1049,6 +1049,11 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 	might_sleep();
 	lockdep_assert_held(&local->sta_mtx);
 
+	while (sta->sta_state == IEEE80211_STA_AUTHORIZED) {
+		ret = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
+		WARN_ON_ONCE(ret);
+	}
+
 	/* now keys can no longer be reached */
 	ieee80211_free_sta_keys(local, sta);
 
-- 
2.25.1


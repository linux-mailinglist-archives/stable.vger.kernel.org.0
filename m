Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D08A2FF001
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 17:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387489AbhAUQRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 11:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731794AbhAUQRP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 11:17:15 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B08C0613D6;
        Thu, 21 Jan 2021 08:16:32 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l2cdK-009bHu-3m; Thu, 21 Jan 2021 17:16:30 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org,
        syzbot+444248c79e117bc99f46@syzkaller.appspotmail.com,
        syzbot+8b2a88a09653d4084179@syzkaller.appspotmail.com
Subject: [PATCH] wext: fix NULL-ptr-dereference with cfg80211's lack of commit()
Date:   Thu, 21 Jan 2021 17:16:22 +0100
Message-Id: <20210121171621.2076e4a37d5a.I5d9c72220fe7bb133fb718751da0180a57ecba4e@changeid>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Since cfg80211 doesn't implement commit, we never really cared about
that code there (and it's configured out w/o CONFIG_WIRELESS_EXT).
After all, since it has no commit, it shouldn't return -EIWCOMMIT to
indicate commit is needed.

However, EIWCOMMIT is actually an alias for EINPROGRESS, which _can_
happen if e.g. we try to change the frequency but we're already in
the process of connecting to some network, and drivers could return
that value (or even cfg80211 itself might).

This then causes us to crash because dev->wireless_handlers is NULL
but we try to check dev->wireless_handlers->standard[0].

Fix this by also checking dev->wireless_handlers. Also simplify the
code a little bit.

Cc: stable@vger.kernel.org
Reported-by: syzbot+444248c79e117bc99f46@syzkaller.appspotmail.com
Reported-by: syzbot+8b2a88a09653d4084179@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/wext-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index 69102fda9ebd..76a80a41615b 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -896,8 +896,9 @@ static int ioctl_standard_iw_point(struct iw_point *iwp, unsigned int cmd,
 int call_commit_handler(struct net_device *dev)
 {
 #ifdef CONFIG_WIRELESS_EXT
-	if ((netif_running(dev)) &&
-	   (dev->wireless_handlers->standard[0] != NULL))
+	if (netif_running(dev) &&
+	    dev->wireless_handlers &&
+	    dev->wireless_handlers->standard[0])
 		/* Call the commit handler on the driver */
 		return dev->wireless_handlers->standard[0](dev, NULL,
 							   NULL, NULL);
-- 
2.26.2


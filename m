Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D459C918E
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbfJBTJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:09:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35990 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729346AbfJBTIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:18 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyx-00036H-Rj; Wed, 02 Oct 2019 20:08:16 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyp-0003el-6W; Wed, 02 Oct 2019 20:08:07 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        syzbot+7fddca22578bc67c3fe4@syzkaller.appspotmail.com,
        "Johannes Berg" <johannes.berg@intel.com>,
        "Eric Biggers" <ebiggers@google.com>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.166355228@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 61/87] cfg80211: fix memory leak of wiphy device name
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

commit 4f488fbca2a86cc7714a128952eead92cac279ab upstream.

In wiphy_new_nm(), if an error occurs after dev_set_name() and
device_initialize() have already been called, it's necessary to call
put_device() (via wiphy_free()) to avoid a memory leak.

Reported-by: syzbot+7fddca22578bc67c3fe4@syzkaller.appspotmail.com
Fixes: 1f87f7d3a3b4 ("cfg80211: add rfkill support")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/wireless/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -386,7 +386,7 @@ struct wiphy *wiphy_new(const struct cfg
 				   &rdev->rfkill_ops, rdev);
 
 	if (!rdev->rfkill) {
-		kfree(rdev);
+		wiphy_free(&rdev->wiphy);
 		return NULL;
 	}
 


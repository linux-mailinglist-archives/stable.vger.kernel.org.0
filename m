Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50C7B106F70
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbfKVKvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:51:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729281AbfKVKvr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:51:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 542A32073B;
        Fri, 22 Nov 2019 10:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419906;
        bh=JzuVXnbANtHScJdB3rqEe/ae8c7To3o2P+Dk19lLAnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JLgz0QhqwwKBUew4u+TTYNEKbmzpfN/uGQ6JtA7eR3y9O1906HgYEZU4StCXyr8Od
         9RydVAzbrPk3HlBwarcuUpw9vaPiT2qew5sLOsf7E21qS2IArIac+KeGJWWIoYOpTH
         Ik7ouLOLU5Js42VkOfw1ue9+T3vI9pQCQ8lgmKps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        NeilBrown <neilb@suse.com>, Shaohua Li <shli@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 049/122] md: allow metadata updates while suspending an array - fix
Date:   Fri, 22 Nov 2019 11:28:22 +0100
Message-Id: <20191122100757.092527726@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.com>

[ Upstream commit 059421e041eb461fb2b3e81c9adaec18ef03ca3c ]

Commit 35bfc52187f6 ("md: allow metadata update while suspending.")
added support for allowing md_check_recovery() to still perform
metadata updates while the array is entering the 'suspended' state.
This is needed to allow the processes of entering the state to
complete.

Unfortunately, the patch doesn't really work.  The test for
"mddev->suspended" at the start of md_check_recovery() means that the
function doesn't try to do anything at all while entering suspend.

This patch moves the code of updating the metadata while suspending to
*before* the test on mddev->suspended.

Reported-by: Jeff Mahoney <jeffm@suse.com>
Fixes: 35bfc52187f6 ("md: allow metadata update while suspending.")
Signed-off-by: NeilBrown <neilb@suse.com>
Signed-off-by: Shaohua Li <shli@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e529cef5483a8..b942c74f1ce83 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8736,6 +8736,18 @@ static void md_start_sync(struct work_struct *ws)
  */
 void md_check_recovery(struct mddev *mddev)
 {
+	if (test_bit(MD_ALLOW_SB_UPDATE, &mddev->flags) && mddev->sb_flags) {
+		/* Write superblock - thread that called mddev_suspend()
+		 * holds reconfig_mutex for us.
+		 */
+		set_bit(MD_UPDATING_SB, &mddev->flags);
+		smp_mb__after_atomic();
+		if (test_bit(MD_ALLOW_SB_UPDATE, &mddev->flags))
+			md_update_sb(mddev, 0);
+		clear_bit_unlock(MD_UPDATING_SB, &mddev->flags);
+		wake_up(&mddev->sb_wait);
+	}
+
 	if (mddev->suspended)
 		return;
 
@@ -8896,16 +8908,6 @@ void md_check_recovery(struct mddev *mddev)
 	unlock:
 		wake_up(&mddev->sb_wait);
 		mddev_unlock(mddev);
-	} else if (test_bit(MD_ALLOW_SB_UPDATE, &mddev->flags) && mddev->sb_flags) {
-		/* Write superblock - thread that called mddev_suspend()
-		 * holds reconfig_mutex for us.
-		 */
-		set_bit(MD_UPDATING_SB, &mddev->flags);
-		smp_mb__after_atomic();
-		if (test_bit(MD_ALLOW_SB_UPDATE, &mddev->flags))
-			md_update_sb(mddev, 0);
-		clear_bit_unlock(MD_UPDATING_SB, &mddev->flags);
-		wake_up(&mddev->sb_wait);
 	}
 }
 EXPORT_SYMBOL(md_check_recovery);
-- 
2.20.1




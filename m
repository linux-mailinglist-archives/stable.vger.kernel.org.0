Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 103226168B
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbfGGTkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:40:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58066 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727674AbfGGTiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:17 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCzG-0006jD-7s; Sun, 07 Jul 2019 20:38:14 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz8-0005fh-SD; Sun, 07 Jul 2019 20:38:06 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Guoqing Jiang" <gqjiang@suse.com>,
        "Song Liu" <songliubraving@fb.com>,
        "Aditya Pakki" <pakki001@umn.edu>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.248076757@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 115/129] md: Fix failed allocation of md_register_thread
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Pakki <pakki001@umn.edu>

commit e406f12dde1a8375d77ea02d91f313fb1a9c6aec upstream.

mddev->sync_thread can be set to NULL on kzalloc failure downstream.
The patch checks for such a scenario and frees allocated resources.

Committer node:

Added similar fix to raid5.c, as suggested by Guoqing.

Acked-by: Guoqing Jiang <gqjiang@suse.com>
Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/raid10.c | 2 ++
 drivers/md/raid5.c  | 2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3820,6 +3820,8 @@ static int run(struct mddev *mddev)
 		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 		mddev->sync_thread = md_register_thread(md_do_sync, mddev,
 							"reshape");
+		if (!mddev->sync_thread)
+			goto out_free_conf;
 	}
 
 	return 0;
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6180,6 +6180,8 @@ static int run(struct mddev *mddev)
 		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 		mddev->sync_thread = md_register_thread(md_do_sync, mddev,
 							"reshape");
+		if (!mddev->sync_thread)
+			goto abort;
 	}
 
 


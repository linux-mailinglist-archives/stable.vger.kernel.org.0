Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07B3366C03
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242565AbhDUNKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:10:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237669AbhDUNIA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 09:08:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39FA56146E;
        Wed, 21 Apr 2021 13:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619010432;
        bh=fb6wv+k+r34nPifQMNdj1TtHQ0hQzZhGqSH+F//8p2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v/pyeA/6kg2bO7tsQazHl9Jl8RHLFBYn0v4w9/m3u6ULFPzN32OPK5Bs3fd8PfTj1
         /01poYcpOrpU1+M+pF+98G9QBTdw0fDw/xmmLZjYUCFYLKO4PDQ2fbL/NruIvQDNl/
         uzoUvbmzz1YG5bcNsnz1jsamuS94Xm1aQxparCfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>,
        Aditya Pakki <pakki001@umn.edu>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 134/190] Revert "md: Fix failed allocation of md_register_thread"
Date:   Wed, 21 Apr 2021 15:00:09 +0200
Message-Id: <20210421130105.1226686-135-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit e406f12dde1a8375d77ea02d91f313fb1a9c6aec.

Commits from @umn.edu addresses have been found to be submitted in "bad
faith" to try to test the kernel community's ability to review "known
malicious" changes.  The result of these submissions can be found in a
paper published at the 42nd IEEE Symposium on Security and Privacy
entitled, "Open Source Insecurity: Stealthily Introducing
Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University
of Minnesota) and Kangjie Lu (University of Minnesota).

Because of this, all submissions from this group must be reverted from
the kernel tree and will need to be re-reviewed again to determine if
they actually are a valid fix.  Until that work is complete, remove this
change to ensure that no problems are being introduced into the
codebase.

Cc: stable@vger.kernel.org # v3.16+
Cc: Guoqing Jiang <gqjiang@suse.com>
Cc: Aditya Pakki <pakki001@umn.edu>
Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid10.c | 2 --
 drivers/md/raid5.c  | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a9ae7d113492..4fec1cdd4207 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3896,8 +3896,6 @@ static int raid10_run(struct mddev *mddev)
 		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 		mddev->sync_thread = md_register_thread(md_do_sync, mddev,
 							"reshape");
-		if (!mddev->sync_thread)
-			goto out_free_conf;
 	}
 
 	return 0;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5d57a5bd171f..9b2bd50beee7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7677,8 +7677,6 @@ static int raid5_run(struct mddev *mddev)
 		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 		mddev->sync_thread = md_register_thread(md_do_sync, mddev,
 							"reshape");
-		if (!mddev->sync_thread)
-			goto abort;
 	}
 
 	/* Ok, everything is just fine now */
-- 
2.31.1


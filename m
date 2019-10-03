Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 848EACA4F3
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390954AbfJCQ3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:29:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391603AbfJCQ3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:29:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FE0720700;
        Thu,  3 Oct 2019 16:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120173;
        bh=cJprQ2OblI9iEzh9eo9uHXgZQJr/iyLO55MZ5AYFf+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HhW2yi3xMOBZOJEBA5FXPJ2e893eAzxWepBkSthN1Csq3OLd3hf3Nnoi9rJWxuezN
         +Q/PU+5vNJYARcpll4FLQTYhVyGePwJOHCJrjyDwFYVT/jVaPsnPDZceG8w2fTgqpg
         StS51LWUfg//AD1Ccxt+PJ2y8hu/v85N+IMKxbBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 076/313] md: dont set In_sync if array is frozen
Date:   Thu,  3 Oct 2019 17:50:54 +0200
Message-Id: <20191003154540.334477448@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoqing Jiang <jgq516@gmail.com>

[ Upstream commit 062f5b2ae12a153644c765e7ba3b0f825427be1d ]

When a disk is added to array, the following path is called in mdadm.

Manage_subdevs -> sysfs_freeze_array
               -> Manage_add
               -> sysfs_set_str(&info, NULL, "sync_action","idle")

Then from kernel side, Manage_add invokes the path (add_new_disk ->
validate_super = super_1_validate) to set In_sync flag.

Since In_sync means "device is in_sync with rest of array", and the new
added disk need to resync thread to help the synchronization of data.
And md_reap_sync_thread would call spare_active to set In_sync for the
new added disk finally. So don't set In_sync if array is in frozen.

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5e885b6c4240d..b3bfac5f2bdb6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1754,8 +1754,15 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 				if (!(le32_to_cpu(sb->feature_map) &
 				      MD_FEATURE_RECOVERY_BITMAP))
 					rdev->saved_raid_disk = -1;
-			} else
-				set_bit(In_sync, &rdev->flags);
+			} else {
+				/*
+				 * If the array is FROZEN, then the device can't
+				 * be in_sync with rest of array.
+				 */
+				if (!test_bit(MD_RECOVERY_FROZEN,
+					      &mddev->recovery))
+					set_bit(In_sync, &rdev->flags);
+			}
 			rdev->raid_disk = role;
 			break;
 		}
-- 
2.20.1




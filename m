Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33E437D2A6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353224AbhELSLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:11:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240953AbhELSEz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:04:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9DD361447;
        Wed, 12 May 2021 18:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842626;
        bh=o2jXKpuhkJIfer2K8SU3B+OWR3J5Y6ya9LXAL2VJYtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cxy4fbSeRT3/HPUW8W8QbhbmE5gcct6WgcPsC5q2C9OAtSIVHitwiz+QxSNdOEJl2
         eFbkr+mBxu4tMic+jYSJCACKunnSug6C5x2DtNSjCn6BE2cNPpV0tFCLSD5OjJjxrb
         V2uK69TVOD6o5sC04VEjtTFdE7ibYGsqN5HzI0fMEtWopTVKz6saulhDk6JDr6xHcF
         fkTwGSrXY+44on7pUswnSA8KfysfVf9EeBNPcQPutoc77cEI58LsgnGHRQePe3iQC5
         ld+wakiSHFgNlJRnZOqldzFlcttuDwbUpwVgiRy1LrSbs2YnYbKpXN3KPYxjOwKDbz
         UvG6WeZ9R4dqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 23/34] scsi: target: tcmu: Return from tcmu_handle_completions() if cmd_id not found
Date:   Wed, 12 May 2021 14:02:54 -0400
Message-Id: <20210512180306.664925-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180306.664925-1-sashal@kernel.org>
References: <20210512180306.664925-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bodo Stroesser <bostroesser@gmail.com>

[ Upstream commit 9814b55cde0588b6d9bc496cee43f87316cbc6f1 ]

If tcmu_handle_completions() finds an invalid cmd_id while looping over cmd
responses from userspace it sets TCMU_DEV_BIT_BROKEN and breaks the
loop. This means that it does further handling for the tcmu device.

Skip that handling by replacing 'break' with 'return'.

Additionally change tcmu_handle_completions() from unsigned int to bool,
since the value used in return already is bool.

Link: https://lore.kernel.org/r/20210423150123.24468-1-bostroesser@gmail.com
Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 7d5814a95e1e..c6950f157b99 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1391,7 +1391,7 @@ static int tcmu_run_tmr_queue(struct tcmu_dev *udev)
 	return 1;
 }
 
-static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
+static bool tcmu_handle_completions(struct tcmu_dev *udev)
 {
 	struct tcmu_mailbox *mb;
 	struct tcmu_cmd *cmd;
@@ -1434,7 +1434,7 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 			pr_err("cmd_id %u not found, ring is broken\n",
 			       entry->hdr.cmd_id);
 			set_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
-			break;
+			return false;
 		}
 
 		tcmu_handle_completion(cmd, entry);
-- 
2.30.2


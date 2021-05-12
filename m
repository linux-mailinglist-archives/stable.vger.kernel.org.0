Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D69C37D2D1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241165AbhELSOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353162AbhELSHH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:07:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F1FB61624;
        Wed, 12 May 2021 18:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842676;
        bh=cBDFQ6T9nKMjY6cs3VgPOYNoVcPxNaiHvrAWiXC657Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4sfUXOLy6BunrBbITJt4vpymS5fYp9tB9NFN37K4SYF0d3vqJ4dmO6fu0qkYO3ST
         ns6bySyg7xm2Rb6BssHEHf4m+hYKdvymyaM72Qsl56K35E5moYyiBVMoPsssLy2Z+l
         +TVjZsUSyKvxtjA3AbZFKomnwnRwA8aq79vgKb6RiGz3WJVTl1Fq0YU8QEKzeHouxA
         EKQpGSTOZf+0P5rhr3eC6xtQANGIo61PtHOydWovM6/gInpigrsYaK6pZN+7rvtf4t
         v9Cw+uUy7Y9n/kX/QvMO1IUBgONeSSim+I8b+o6ShIAVPdFlGyIeUH5CnaGbewImsD
         Mk0G2W3DtA38g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 16/23] scsi: target: tcmu: Return from tcmu_handle_completions() if cmd_id not found
Date:   Wed, 12 May 2021 14:04:00 -0400
Message-Id: <20210512180408.665338-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180408.665338-1-sashal@kernel.org>
References: <20210512180408.665338-1-sashal@kernel.org>
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
index d6634baebb47..71144e33272a 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1205,7 +1205,7 @@ static void tcmu_set_next_deadline(struct list_head *queue,
 		del_timer(timer);
 }
 
-static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
+static bool tcmu_handle_completions(struct tcmu_dev *udev)
 {
 	struct tcmu_mailbox *mb;
 	struct tcmu_cmd *cmd;
@@ -1245,7 +1245,7 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 			pr_err("cmd_id %u not found, ring is broken\n",
 			       entry->hdr.cmd_id);
 			set_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
-			break;
+			return false;
 		}
 
 		tcmu_handle_completion(cmd, entry);
-- 
2.30.2


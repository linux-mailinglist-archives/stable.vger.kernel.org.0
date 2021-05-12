Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6007637D29E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353187AbhELSKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:10:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352237AbhELSCv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:02:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A7BF610F7;
        Wed, 12 May 2021 18:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842503;
        bh=H43xm+WMtNrfk1LdR8lVNuVsxTgEYIhPWq3vTxV73Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNoLwXSNF8Vfay2dNT6Y3+cATDMwTOCN7TSBOudtRZEYw3Pf51updA07DGiqAjVVg
         yZTI6h16EairRGIBjZfdxgeET9+BJF5eI0jrhYp1i5gwZ059iXBoMwKNuqi/Td08eZ
         ZHgxdyR2BvPEsWN+ZhWB3TW1K2TOFH519W3aMz08ai/2X2QxcwAZRHG3cGFc/aJRkr
         EseTqonQtA159cXnkGxEQsQHP0hDT0DkSyYoNS/veW6Luw81h2vMAGXNXT9srTXsAD
         aXPhJSh5uSW0TUEifKjUm5lWGC3RiS2SA6M7LJqM5yrlWZQrC4nITpqaUWCIj6EIoj
         GlNK+eUSkZKTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 26/37] scsi: target: tcmu: Return from tcmu_handle_completions() if cmd_id not found
Date:   Wed, 12 May 2021 14:00:53 -0400
Message-Id: <20210512180104.664121-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180104.664121-1-sashal@kernel.org>
References: <20210512180104.664121-1-sashal@kernel.org>
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
index bf73cd5f4b04..6809c970be03 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1377,7 +1377,7 @@ static int tcmu_run_tmr_queue(struct tcmu_dev *udev)
 	return 1;
 }
 
-static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
+static bool tcmu_handle_completions(struct tcmu_dev *udev)
 {
 	struct tcmu_mailbox *mb;
 	struct tcmu_cmd *cmd;
@@ -1420,7 +1420,7 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 			pr_err("cmd_id %u not found, ring is broken\n",
 			       entry->hdr.cmd_id);
 			set_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
-			break;
+			return false;
 		}
 
 		tcmu_handle_completion(cmd, entry);
-- 
2.30.2


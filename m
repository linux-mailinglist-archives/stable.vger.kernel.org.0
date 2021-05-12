Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3340F37D27E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350049AbhELSKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:10:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352661AbhELSDz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:03:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F1A16143C;
        Wed, 12 May 2021 18:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842566;
        bh=stKEiz1pJEGAUkugfYllcGw7HzoeVRAPD8RvjUxFabg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VWE7VdbUxV52xWLypzAwE9hzFEPoY8DdAEv4Gjn52BRyvVIvNIabaqPLq8tHZeUXd
         +py7LkC4Xf3B5bSh7UzcxhVzJvgHhvE1wd9Rk366bq7MUClDWEES1ftFlJUjRuSxOS
         AC8yyIeW/F9AHxPgutkq6FHU33JLPFqxCMY+pG/zohm9Oo6e2iMQ/Br2AqtDIW0ngz
         vXmEBa4OrKUmJYpuV+3H1YazWB0mv8clV9GpNQFpcuZDkgJfOpWM5AOZTsN22QzXTR
         sUJ2T4b76weppBM5IDrqwVetUgzX76vtzIqpqrj6p7pwwohNAz9i++ioett1+OiN74
         F1JaeUbs4pMuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 24/35] scsi: target: tcmu: Return from tcmu_handle_completions() if cmd_id not found
Date:   Wed, 12 May 2021 14:01:54 -0400
Message-Id: <20210512180206.664536-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180206.664536-1-sashal@kernel.org>
References: <20210512180206.664536-1-sashal@kernel.org>
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
index a5991df23581..430d30960966 100644
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


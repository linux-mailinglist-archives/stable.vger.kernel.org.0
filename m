Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63EBF37D338
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242385AbhELSPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:15:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241918AbhELSJS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:09:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4662E616EA;
        Wed, 12 May 2021 18:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842713;
        bh=aSQKIBYutKB3cmHT41pmeTCqDhF70hCYvJxhGPDoI00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f89gBTArzL34ZZ5DrU+HZ/+yqdPAtQ9Gptc34bLwqLpVsdNF/gWGnUfs6FGSZy2UE
         3Fogqxo6BgbSZBYdsTfdgV3nFoRCEQvEiYZrcgj79qw4N5wlPex78PBH4BEt9i7LQz
         0QWbLWVHJmdnVqxbrzSmJkVZUGCPoJdRGhhMzQIlV/8dnwsy2Sereo4Zvm5gU04/+/
         G/qKXAhg4JVNEYdfKSwkWCNVaQ4YbAJNnH/wxzFLNcNM87TBfuy+cQh1vrBiVF51g+
         wCj74f0UK0dbGHA/sLQnnHv7kCK2mKy+RARF7yTK0KZkVlB4lXEKj+4pSAYwBt3987
         cKQGg7SPazvXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/18] scsi: target: tcmu: Return from tcmu_handle_completions() if cmd_id not found
Date:   Wed, 12 May 2021 14:04:44 -0400
Message-Id: <20210512180450.665586-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180450.665586-1-sashal@kernel.org>
References: <20210512180450.665586-1-sashal@kernel.org>
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
index 0219b5a865be..dd7307375504 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1216,7 +1216,7 @@ static void tcmu_set_next_deadline(struct list_head *queue,
 		del_timer(timer);
 }
 
-static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
+static bool tcmu_handle_completions(struct tcmu_dev *udev)
 {
 	struct tcmu_mailbox *mb;
 	struct tcmu_cmd *cmd;
@@ -1256,7 +1256,7 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 			pr_err("cmd_id %u not found, ring is broken\n",
 			       entry->hdr.cmd_id);
 			set_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
-			break;
+			return false;
 		}
 
 		tcmu_handle_completion(cmd, entry);
-- 
2.30.2


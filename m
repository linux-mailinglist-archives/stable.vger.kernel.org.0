Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F4C1FE403
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgFRCO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:14:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730332AbgFRBUl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:20:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0738720776;
        Thu, 18 Jun 2020 01:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443241;
        bh=jgjHGsVhsJSxDyGA5Ork60r7TWAvi3KNCTPoeYEILdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I6TMmsQlwvykcti/s8QMx1bkCetcMEhYB0W0gNap1elxP8QJbf4DeVZmO+OxtOC9v
         krn4CuDK1MbEQoRtQvBjqrUq9ZAL51YU+BNjC8WPswgkvFs2LxqlNu9zu+wPqPkr1t
         Ch0b+IQ/CaiB8vj8rcqRtV6ISmPd6IfOT7LSB6o0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Mike Christie <mchristi@redhat.com>,
        David Disseldorp <ddiss@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 192/266] scsi: target: tcmu: Fix a use after free in tcmu_check_expired_queue_cmd()
Date:   Wed, 17 Jun 2020 21:15:17 -0400
Message-Id: <20200618011631.604574-192-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 9d7464b18892332e35ff37f0b024429a1a9835e6 ]

The pr_debug() dereferences "cmd" after we already freed it by calling
tcmu_free_cmd(cmd).  The debug printk needs to be done earlier.

Link: https://lore.kernel.org/r/20200523101129.GB98132@mwanda
Fixes: 61fb24822166 ("scsi: target: tcmu: Userspace must not complete queued commands")
Reviewed-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 70c64e69a1d2..a497e7c1f4fc 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1292,13 +1292,13 @@ static void tcmu_check_expired_queue_cmd(struct tcmu_cmd *cmd)
 	if (!time_after(jiffies, cmd->deadline))
 		return;
 
+	pr_debug("Timing out queued cmd %p on dev %s.\n",
+		  cmd, cmd->tcmu_dev->name);
+
 	list_del_init(&cmd->queue_entry);
 	se_cmd = cmd->se_cmd;
 	tcmu_free_cmd(cmd);
 
-	pr_debug("Timing out queued cmd %p on dev %s.\n",
-		  cmd, cmd->tcmu_dev->name);
-
 	target_complete_cmd(se_cmd, SAM_STAT_TASK_SET_FULL);
 }
 
-- 
2.25.1


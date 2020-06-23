Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6BB206403
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391164AbgFWVOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390934AbgFWU3A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:29:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 372CB2064B;
        Tue, 23 Jun 2020 20:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944140;
        bh=7SiCr40mxqN8cAYDHS6gADa/pXDurxsfBtLVqOY735w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M0klOyi4g++JrZr5qPg7TqogcxMbcEGGUWNYEhpGpcTmnQl6dMxWXsKgsqtcHx9gH
         x/0KycVXkArdpf0LxOx4+ejjEFScd0cUEY9IKSgJ/c/qtooll9r8dEiZKPT+T5RQE+
         GwpZzapMwROYppjvrmDoyEoszqikNYsXNc0LZZGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Christie <mchristi@redhat.com>,
        David Disseldorp <ddiss@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 188/314] scsi: target: tcmu: Fix a use after free in tcmu_check_expired_queue_cmd()
Date:   Tue, 23 Jun 2020 21:56:23 +0200
Message-Id: <20200623195347.880864073@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 70c64e69a1d29..a497e7c1f4fcc 100644
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




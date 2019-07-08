Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD49623FF
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389484AbfGHPjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:39:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389469AbfGHP30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:29:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1534A21537;
        Mon,  8 Jul 2019 15:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599765;
        bh=qZLBh1sHjxWGHiD87H4Vw/gWJ+gUf8HfaEv+Mc9nFsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZlDD6VpVrvM44LD8Aij9s2QR7yUYeuCUBDBAk8xW8n0hyerUt8Nf/pG0fWr7xAwU
         dqmvumuybbQv+GXqjknq4ggVREomCMcEpJcPUmqeKYL++SqBuoxQQE1vrXA9aLPCGr
         xeb/x1Re+RnUj41D4kIzBvr6YNKQDKnynMQW++40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mike Christie <mchristi@redhat.com>,
        Xiubo Li <xiubli@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 70/90] scsi: tcmu: fix use after free
Date:   Mon,  8 Jul 2019 17:13:37 +0200
Message-Id: <20190708150525.874122459@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 40d883b091758472c79b81fa1c0e0347e24a9cff ]

Fixes: a94a2572b977 ("scsi: tcmu: avoid cmd/qfull timers updated whenever a new cmd comes")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mike Christie <mchristi@redhat.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Mike Christie <mchristi@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index ac7620120491..c46efa47d68a 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1317,12 +1317,13 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
 		 * target_complete_cmd will translate this to LUN COMM FAILURE
 		 */
 		scsi_status = SAM_STAT_CHECK_CONDITION;
+		list_del_init(&cmd->queue_entry);
 	} else {
+		list_del_init(&cmd->queue_entry);
 		idr_remove(&udev->commands, id);
 		tcmu_free_cmd(cmd);
 		scsi_status = SAM_STAT_TASK_SET_FULL;
 	}
-	list_del_init(&cmd->queue_entry);
 
 	pr_debug("Timing out cmd %u on dev %s that is %s.\n",
 		 id, udev->name, is_running ? "inflight" : "queued");
-- 
2.20.1




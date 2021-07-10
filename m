Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE353C2DDD
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhGJCZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233007AbhGJCZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:25:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1700C613EC;
        Sat, 10 Jul 2021 02:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883752;
        bh=tZLjfOhzYoqZb1o44QvJtfXr2zfgQOLr7OJ0cpy4/JU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R/4AZz6LL/qiLo6OJrSVLpxg27SqLYODKvbz2FBIVBvtdZ9W5RolwkDf9fWcOosUR
         LSAHn4haps9fHDLxJYqnrmCmI4EH99FVHHoZDuUt3KWE8TrFr9AZpn0DWV0uBT4wMt
         cWo/RyMKQCexWMSuacu2m5nMEryk/ULwdMnBO4N/MgkosakbK2N0q8bolVszJEJg69
         L7F10+ZtPW8gC/J1wEoaXFiwvWymUdPc+9nLLjDIbknt9ZNS82EjyqqhahwmKdPhQy
         28VL8YF2ClfGCJQK4NIeTqE/Vkk3tbB9gtbQaYLzDlYG8M8Q5vo+fYFhfxRAjtVJRw
         oVwQ9ahr4pljw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 028/104] scsi: lpfc: Fix crash when lpfc_sli4_hba_setup() fails to initialize the SGLs
Date:   Fri,  9 Jul 2021 22:20:40 -0400
Message-Id: <20210710022156.3168825-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 5aa615d195f1e142c662cb2253f057c9baec7531 ]

The driver is encountering a crash in lpfc_free_iocb_list() while
performing initial attachment.

Code review found this to be an errant failure path that was taken, jumping
to a tag that then referenced structures that were uninitialized.

Fix the failure path.

Link: https://lore.kernel.org/r/20210514195559.119853-9-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index f8a5a4eb5bce..5b43396815fa 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7962,7 +7962,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 				"0393 Error %d during rpi post operation\n",
 				rc);
 		rc = -ENODEV;
-		goto out_destroy_queue;
+		goto out_free_iocblist;
 	}
 	lpfc_sli4_node_prep(phba);
 
@@ -8128,8 +8128,9 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 out_unset_queue:
 	/* Unset all the queues set up in this routine when error out */
 	lpfc_sli4_queue_unset(phba);
-out_destroy_queue:
+out_free_iocblist:
 	lpfc_free_iocb_list(phba);
+out_destroy_queue:
 	lpfc_sli4_queue_destroy(phba);
 out_stop_timers:
 	lpfc_stop_hba_timers(phba);
-- 
2.30.2


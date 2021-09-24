Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8580417465
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345782AbhIXNFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344740AbhIXNDe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:03:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D7E461354;
        Fri, 24 Sep 2021 12:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488105;
        bh=kwa2jfCqOoKbuuYs9rnYeJBV4EoiYzPzJ+ohGP7H+BQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TcPHUdGRZD+6vCuOvhJB4ZOF3GbZV+MywsbGLFZQ/GSJMJEu1fuJO/4FVlXObumh6
         xQz2MlE66aTjPJpuYVhObOsipvnlZp6XgifW84/X7oypY9NI4wKPrrLsoyb/AmcsZA
         5NFlxm5CHucR0nJC7dmlk2J5M0Ir5bmPBhal61Y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        farah kassabri <fkassabri@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 087/100] habanalabs: cannot sleep while holding spinlock
Date:   Fri, 24 Sep 2021 14:44:36 +0200
Message-Id: <20210924124344.383259129@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: farah kassabri <fkassabri@habana.ai>

[ Upstream commit 607b1468c2263e082d74c1a3e71399a9026b41ce ]

Fix 2 areas in the code where it's possible the code will
go to sleep while holding a spinlock.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: farah kassabri <fkassabri@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/command_buffer.c | 2 --
 drivers/misc/habanalabs/common/memory.c         | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/misc/habanalabs/common/command_buffer.c b/drivers/misc/habanalabs/common/command_buffer.c
index 719168c980a4..402ac2395fc8 100644
--- a/drivers/misc/habanalabs/common/command_buffer.c
+++ b/drivers/misc/habanalabs/common/command_buffer.c
@@ -314,8 +314,6 @@ int hl_cb_create(struct hl_device *hdev, struct hl_cb_mgr *mgr,
 
 	spin_lock(&mgr->cb_lock);
 	rc = idr_alloc(&mgr->cb_handles, cb, 1, 0, GFP_ATOMIC);
-	if (rc < 0)
-		rc = idr_alloc(&mgr->cb_handles, cb, 1, 0, GFP_KERNEL);
 	spin_unlock(&mgr->cb_lock);
 
 	if (rc < 0) {
diff --git a/drivers/misc/habanalabs/common/memory.c b/drivers/misc/habanalabs/common/memory.c
index af339ce1ab4f..fcadde594a58 100644
--- a/drivers/misc/habanalabs/common/memory.c
+++ b/drivers/misc/habanalabs/common/memory.c
@@ -124,7 +124,7 @@ static int alloc_device_memory(struct hl_ctx *ctx, struct hl_mem_in *args,
 
 	spin_lock(&vm->idr_lock);
 	handle = idr_alloc(&vm->phys_pg_pack_handles, phys_pg_pack, 1, 0,
-				GFP_KERNEL);
+				GFP_ATOMIC);
 	spin_unlock(&vm->idr_lock);
 
 	if (handle < 0) {
-- 
2.33.0




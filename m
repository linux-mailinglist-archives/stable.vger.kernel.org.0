Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E3F40EF66
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242912AbhIQCfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243018AbhIQCfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:35:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AD4461108;
        Fri, 17 Sep 2021 02:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846060;
        bh=V1Vu6A/ucOLrAiNwJP25hHE9Fkw5udXm9z2r2DIVsRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uw8BioXLW5dqRCg1NVVfqRi4IcPZgRrhnAUO74W6a+gRYjBLPzkmhO6mCIQqkiGEm
         LIPHi0qOaMswToOOxlEfZV5YoDeHM56Xu7webvroZBG6PJmafjCYjwAEMfyCJwopf+
         JVTo5pzvXGmcKQV8XiV9NwwLFxAPD8+drDPp7S54f1pZCb0GPk77GJv7YZY9VbJmtJ
         mgRQ4bg4vep6keeC4xdkmzOAPfGCRO7+kx+fx0812HUjV0zOU5MOZZYC9295Y0pKDg
         MwcdFWmwmsPD8+iEFY/cIAhFIMLbS96pn0afDnzho3PT3dpRFLbdBPKvWx3/xEo/ub
         tTN6HsJ74dr+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     farah kassabri <fkassabri@habana.ai>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Arnd@vger.kernel.org,
        gregkh@linuxfoundation.org, ttayar@habana.ai, obitton@habana.ai,
        amizrahi@habana.ai, hdanton@sina.com, zyehudai@habana.ai,
        daniel.vetter@ffwll.ch, ynudelman@habana.ai, oshpigelman@habana.ai,
        mhaimovski@habana.ai, bjauhari@habana.ai
Subject: [PATCH AUTOSEL 5.14 10/21] habanalabs: cannot sleep while holding spinlock
Date:   Thu, 16 Sep 2021 22:33:04 -0400
Message-Id: <20210917023315.816225-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917023315.816225-1-sashal@kernel.org>
References: <20210917023315.816225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
2.30.2


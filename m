Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA2C26A74F
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 16:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgIOOjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 10:39:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727224AbgIOOic (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:38:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32F44206B7;
        Tue, 15 Sep 2020 14:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180140;
        bh=sK7ILSZVozEYvJaWTYMPr5b05a5jAp2muVMYn6xpy3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fjRAYw1t78R0nd0X0Lc0rN1nWRzUpNr1emcihMJO6IlgneMjuc6taTygRA37rlOV2
         O0jNnnPnDU16VpNXp4TqhVOBsmDcHE7flwiKr/uQzbgncwq84Vk1TBzZbEe4PohXs2
         6GulpU0OCvt5z5F+77ViY06n8EFL+ocUZaZnzh2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 085/177] nvme: have nvme_wait_freeze_timeout return if it timed out
Date:   Tue, 15 Sep 2020 16:12:36 +0200
Message-Id: <20200915140657.715189410@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 7cf0d7c0f3c3b0203aaf81c1bc884924d8fdb9bd ]

Users can detect if the wait has completed or not and take appropriate
actions based on this information (e.g. weather to continue
initialization or rather fail and schedule another initialization
attempt).

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 3 ++-
 drivers/nvme/host/nvme.h | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index fa0039dcacc66..da82ba1896d8d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4287,7 +4287,7 @@ void nvme_unfreeze(struct nvme_ctrl *ctrl)
 }
 EXPORT_SYMBOL_GPL(nvme_unfreeze);
 
-void nvme_wait_freeze_timeout(struct nvme_ctrl *ctrl, long timeout)
+int nvme_wait_freeze_timeout(struct nvme_ctrl *ctrl, long timeout)
 {
 	struct nvme_ns *ns;
 
@@ -4298,6 +4298,7 @@ void nvme_wait_freeze_timeout(struct nvme_ctrl *ctrl, long timeout)
 			break;
 	}
 	up_read(&ctrl->namespaces_rwsem);
+	return timeout;
 }
 EXPORT_SYMBOL_GPL(nvme_wait_freeze_timeout);
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index e268f1d7e1a0f..c053aedbc55db 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -538,7 +538,7 @@ void nvme_kill_queues(struct nvme_ctrl *ctrl);
 void nvme_sync_queues(struct nvme_ctrl *ctrl);
 void nvme_unfreeze(struct nvme_ctrl *ctrl);
 void nvme_wait_freeze(struct nvme_ctrl *ctrl);
-void nvme_wait_freeze_timeout(struct nvme_ctrl *ctrl, long timeout);
+int nvme_wait_freeze_timeout(struct nvme_ctrl *ctrl, long timeout);
 void nvme_start_freeze(struct nvme_ctrl *ctrl);
 
 #define NVME_QID_ANY -1
-- 
2.25.1




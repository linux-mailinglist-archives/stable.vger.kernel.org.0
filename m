Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37332600A5
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 18:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730988AbgIGQwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 12:52:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730566AbgIGQeo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 12:34:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F19321D79;
        Mon,  7 Sep 2020 16:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496484;
        bh=4taMP0KtAQ3FpoKjx8CsPOo7xUU2+5CQiZzdAwWs+Lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=llK5ZJAwsY9e82uJLrJd/CPOmAsfkx64tG2DTN7K/6QrOpaaPexY2rI8wFOBlW37+
         AKwJVdWa+CpfLwpnI3px5NUZitG169dphjDt5xSlWaE8ylOvReIrjR2v1KPELezU1t
         yIbHL1hLSvX6RvHLU67iLU4dRPAcw41DAmm+sk0c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 14/26] nvme: have nvme_wait_freeze_timeout return if it timed out
Date:   Mon,  7 Sep 2020 12:34:14 -0400
Message-Id: <20200907163426.1281284-14-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163426.1281284-1-sashal@kernel.org>
References: <20200907163426.1281284-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 0d60f2f8f3eec..1b0133564f0ca 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3726,7 +3726,7 @@ void nvme_unfreeze(struct nvme_ctrl *ctrl)
 }
 EXPORT_SYMBOL_GPL(nvme_unfreeze);
 
-void nvme_wait_freeze_timeout(struct nvme_ctrl *ctrl, long timeout)
+int nvme_wait_freeze_timeout(struct nvme_ctrl *ctrl, long timeout)
 {
 	struct nvme_ns *ns;
 
@@ -3737,6 +3737,7 @@ void nvme_wait_freeze_timeout(struct nvme_ctrl *ctrl, long timeout)
 			break;
 	}
 	up_read(&ctrl->namespaces_rwsem);
+	return timeout;
 }
 EXPORT_SYMBOL_GPL(nvme_wait_freeze_timeout);
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index cc4273f119894..9bada68b4bd0c 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -438,7 +438,7 @@ void nvme_start_queues(struct nvme_ctrl *ctrl);
 void nvme_kill_queues(struct nvme_ctrl *ctrl);
 void nvme_unfreeze(struct nvme_ctrl *ctrl);
 void nvme_wait_freeze(struct nvme_ctrl *ctrl);
-void nvme_wait_freeze_timeout(struct nvme_ctrl *ctrl, long timeout);
+int nvme_wait_freeze_timeout(struct nvme_ctrl *ctrl, long timeout);
 void nvme_start_freeze(struct nvme_ctrl *ctrl);
 
 #define NVME_QID_ANY -1
-- 
2.25.1


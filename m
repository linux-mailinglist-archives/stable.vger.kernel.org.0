Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12801E5C96
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfJZNbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfJZNTQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:19:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF401222C9;
        Sat, 26 Oct 2019 13:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095955;
        bh=J02sUj+m/UPBOLsmviY3nnf45uUHrYc2ULlOdHBWVlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dEplbGKybTebsDeLiGalxBAkO0CoSkzyGEDbm8jJrpb1zl4wirZW+tpV/lEl08LgB
         3EjY3lOqKl784dpdzEWW9801ZZXs56pOsp0CpSC7O+WKQb/J7AZ24IiiL4kR5+aqvt
         KoqzhX4pemOM27niBlr7mj7UIubDrOezoIzryAuk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Judy Brock <judy.brock@samsung.com>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 04/59] nvme: fix possible deadlock when nvme_update_formats fails
Date:   Sat, 26 Oct 2019 09:18:15 -0400
Message-Id: <20191026131910.3435-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131910.3435-1-sashal@kernel.org>
References: <20191026131910.3435-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 6abff1b9f7b8884a46b7bd80b49e7af0b5625aeb ]

nvme_update_formats may fail to revalidate the namespace and
attempt to remove the namespace. This may lead to a deadlock
as nvme_ns_remove will attempt to acquire the subsystem lock
which is already acquired by the passthru command with effects.

Move the invalid namepsace removal to after the passthru command
releases the subsystem lock.

Reported-by: Judy Brock <judy.brock@samsung.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ae0b01059fc6d..ddd5c72a565ad 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1201,8 +1201,6 @@ static void nvme_update_formats(struct nvme_ctrl *ctrl)
 		if (ns->disk && nvme_revalidate_disk(ns->disk))
 			nvme_set_queue_dying(ns);
 	up_read(&ctrl->namespaces_rwsem);
-
-	nvme_remove_invalid_namespaces(ctrl, NVME_NSID_ALL);
 }
 
 static void nvme_passthru_end(struct nvme_ctrl *ctrl, u32 effects)
@@ -1218,6 +1216,7 @@ static void nvme_passthru_end(struct nvme_ctrl *ctrl, u32 effects)
 		nvme_unfreeze(ctrl);
 		nvme_mpath_unfreeze(ctrl->subsys);
 		mutex_unlock(&ctrl->subsys->lock);
+		nvme_remove_invalid_namespaces(ctrl, NVME_NSID_ALL);
 		mutex_unlock(&ctrl->scan_lock);
 	}
 	if (effects & NVME_CMD_EFFECTS_CCC)
-- 
2.20.1


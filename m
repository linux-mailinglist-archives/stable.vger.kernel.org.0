Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4C5CA2533
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbfH2S3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:29:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729055AbfH2SPG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:15:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27D2E23404;
        Thu, 29 Aug 2019 18:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102506;
        bh=kCo6rtnN3uj+HRkVKB54selVGg42JXeQR2KTGbXdhjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=am750hGKWqVrVOhuAO9brEHIGWEjdqh2tg+xQMeAoMKjGjSdRHU/uBYB6eOcKFtg5
         pPmYC85rNYYwM1pdym3jHrAmeceM7rFHwG7d1+7g1gaFUns9hlTKOuaQG2Rj9nqEco
         5YKq6uxFzX+oM6hg/mSECmIY8uxaog/XysxmAyco=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anton Eidelman <anton@lightbitslabs.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.2 56/76] nvme-multipath: fix possible I/O hang when paths are updated
Date:   Thu, 29 Aug 2019 14:12:51 -0400
Message-Id: <20190829181311.7562-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anton Eidelman <anton@lightbitslabs.com>

[ Upstream commit 504db087aaccdb32af61539916409f7dca31ceb5 ]

nvme_state_set_live() making a path available triggers requeue_work
in order to resubmit requests that ended up on requeue_list when no
paths were available.

This requeue_work may race with concurrent nvme_ns_head_make_request()
that do not observe the live path yet.
Such concurrent requests may by made by either:
- New IO submission.
- Requeue_work triggered by nvme_failover_req() or another ana_work.

A race may cause requeue_work capture the state of requeue_list before
more requests get onto the list. These requests will stay on the list
forever unless requeue_work is triggered again.

In order to prevent such race, nvme_state_set_live() should
synchronize_srcu(&head->srcu) before triggering the requeue_work and
prevent nvme_ns_head_make_request referencing an old snapshot of the
path list.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anton Eidelman <anton@lightbitslabs.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index e942b3e840687..4f599366bc5ae 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -356,6 +356,7 @@ static void nvme_mpath_set_live(struct nvme_ns *ns)
 		srcu_read_unlock(&head->srcu, srcu_idx);
 	}
 
+	synchronize_srcu(&ns->head->srcu);
 	kblockd_schedule_work(&ns->head->requeue_work);
 }
 
-- 
2.20.1


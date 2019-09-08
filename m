Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2339CACE2D
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfIHMyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:54:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732891AbfIHMwG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:52:06 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FC4420693;
        Sun,  8 Sep 2019 12:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947126;
        bh=AhQPHzaq5nt+1yIqizAqPSmHJXm4UO0QbpW66fd8Kfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m0/tXrMc/7tEmMFj9MEPDje0+kz3MpavLg8QVSzDObhpatARN/KBXlxK4BaDH6gtO
         1gToAbJiF4qyDXgNDwsN8Ng1qg5vz71z72wtiFJI/RzAeA670CLXKh3ZxCQYY8FAwa
         FE3t6B/W9HSyzv3UYFHbgMKcs1WrA+IEvcHjlxwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Anton Eidelman <anton@lightbitslabs.com>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 71/94] nvme-multipath: fix possible I/O hang when paths are updated
Date:   Sun,  8 Sep 2019 13:42:07 +0100
Message-Id: <20190908121152.466141598@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 747c0d4f9ff5b..304aa8a65f2f8 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -420,6 +420,7 @@ static void nvme_mpath_set_live(struct nvme_ns *ns)
 		srcu_read_unlock(&head->srcu, srcu_idx);
 	}
 
+	synchronize_srcu(&ns->head->srcu);
 	kblockd_schedule_work(&ns->head->requeue_work);
 }
 
-- 
2.20.1




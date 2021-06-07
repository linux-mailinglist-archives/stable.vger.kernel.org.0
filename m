Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D866B39E364
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbhFGQXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233034AbhFGQVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:21:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A659E6187E;
        Mon,  7 Jun 2021 16:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082508;
        bh=tAdZA2+lzyNrpX6STAGFeXg7NBSwvYRhtKnJEukb594=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVYQvvjtB5FIu/NZdqy3pZDHsRIp7P9OmhlaZELSbPjqfXGumNbtyAkf2/IrUqrg5
         e/HmY0UNztJ110RH3O0O7FMSAMQSv8dL7vTosZpq0dNR9u3HGVx4l3e1KA2oVwvfV8
         NvzPH1ipytxWlAzYbaimU0qPbfWjfRFQB3z1HFDFDR3ENZxS/vAHyxOL/fPfI0MGta
         jprYxKcJRz5OMgmhlD7hUvVtCGR7GOF/h04WvwurjC7fcjzwMFJ8CwkRP0HR3p/V22
         2BLF64PdNBODnIaiT9I8mQs+/SiN806HLQIxQ24QmmRadbSCTqCuKnpfn+YFreAcWb
         W+Fg5ybZg1GcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 15/21] nvme-loop: clear NVME_LOOP_Q_LIVE when nvme_loop_configure_admin_queue() fails
Date:   Mon,  7 Jun 2021 12:14:42 -0400
Message-Id: <20210607161448.3584332-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161448.3584332-1-sashal@kernel.org>
References: <20210607161448.3584332-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 1c5f8e882a05de5c011e8c3fbeceb0d1c590eb53 ]

When the call to nvme_enable_ctrl() in nvme_loop_configure_admin_queue()
fails the NVME_LOOP_Q_LIVE flag is not cleared.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/loop.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index 7b6e44ed299a..dba0b0145f48 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -418,6 +418,7 @@ static int nvme_loop_configure_admin_queue(struct nvme_loop_ctrl *ctrl)
 	return 0;
 
 out_cleanup_queue:
+	clear_bit(NVME_LOOP_Q_LIVE, &ctrl->queues[0].flags);
 	blk_cleanup_queue(ctrl->ctrl.admin_q);
 out_free_tagset:
 	blk_mq_free_tag_set(&ctrl->admin_tag_set);
-- 
2.30.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A09902F140
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfE3ELZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:11:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730824AbfE3DQt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:49 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 165C02463B;
        Thu, 30 May 2019 03:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186209;
        bh=2UazqRjuzoOXDHyZZIdyQrYIVDecx+AtbXkWHmBiQsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4JoyhJmbjBt3HJKGeN4SgTYHpIrDmqZaLU5V1T2zPHkDX4h4tjpcE0aGW3TVM4T+
         Dk5wXVSSHad0dOQaPkKK+t8R7fBVJri2RZANfw42oODGNWGAfXp921l3Ya1rIaCwQB
         6DM/0qgg+uizOn0gDvchabsgALbVu9bBI6kt2fAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@intel.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/276] nvme: set 0 capacity if namespace block size exceeds PAGE_SIZE
Date:   Wed, 29 May 2019 20:04:17 -0700
Message-Id: <20190530030532.308764459@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 01fa017484ad98fccdeaab32db0077c574b6bd6f ]

If our target exposed a namespace with a block size that is greater
than PAGE_SIZE, set 0 capacity on the namespace as we do not support it.

This issue encountered when the nvmet namespace was backed by a tempfile.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 2cdb3032ca0fc..abfb46378cc13 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1480,6 +1480,10 @@ static void nvme_update_disk_info(struct gendisk *disk,
 	sector_t capacity = le64_to_cpup(&id->nsze) << (ns->lba_shift - 9);
 	unsigned short bs = 1 << ns->lba_shift;
 
+	if (ns->lba_shift > PAGE_SHIFT) {
+		/* unsupported block size, set capacity to 0 later */
+		bs = (1 << 9);
+	}
 	blk_mq_freeze_queue(disk->queue);
 	blk_integrity_unregister(disk);
 
@@ -1490,7 +1494,8 @@ static void nvme_update_disk_info(struct gendisk *disk,
 	if (ns->ms && !ns->ext &&
 	    (ns->ctrl->ops->flags & NVME_F_METADATA_SUPPORTED))
 		nvme_init_integrity(disk, ns->ms, ns->pi_type);
-	if (ns->ms && !nvme_ns_has_pi(ns) && !blk_get_integrity(disk))
+	if ((ns->ms && !nvme_ns_has_pi(ns) && !blk_get_integrity(disk)) ||
+	    ns->lba_shift > PAGE_SHIFT)
 		capacity = 0;
 
 	set_capacity(disk, capacity);
-- 
2.20.1




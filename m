Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62A1A10BCA7
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730560AbfK0VWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:22:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:59332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727459AbfK0VFd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:05:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E19B2080F;
        Wed, 27 Nov 2019 21:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888732;
        bh=PV75VkIsQLSgJfMJKGoDxgGY1yV4axR33hw/nS5ls3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gi5RZJsAhPF4iz/AVgy3HeWZZRmedDCvY1UFGbZpRYu/l2oyDlDwc5qTOzgsgTpSQ
         k0N9LgXmqoy7wXqjJCZXIi6QopEQ4VcwwjOASWmBCwZUpcH+cp7Odx6m6CNzz6SsWc
         RUvlD2kcc5nsG4Gzu2Eq7kty2L34BkJwwNqVHcoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Konopko <igor.j.konopko@intel.com>,
        Keith Busch <keith.busch@intel.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 249/306] nvme-pci: fix surprise removal
Date:   Wed, 27 Nov 2019 21:31:39 +0100
Message-Id: <20191127203133.104515360@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Konopko <igor.j.konopko@intel.com>

[ Upstream commit 751a0cc0cd3a0d51e6aaf6fd3b8bd31f4ecfaf3e ]

When a PCIe NVMe device is not present, nvme_dev_remove_admin() calls
blk_cleanup_queue() on the admin queue, which frees the hctx for that
queue.  Moments later, on the same path nvme_kill_queues() calls
blk_mq_unquiesce_queue() on admin queue and tries to access hctx of it,
which leads to following OOPS:

Oops: 0000 [#1] SMP PTI
RIP: 0010:sbitmap_any_bit_set+0xb/0x40
Call Trace:
 blk_mq_run_hw_queue+0xd5/0x150
 blk_mq_run_hw_queues+0x3a/0x50
 nvme_kill_queues+0x26/0x50
 nvme_remove_namespaces+0xb2/0xc0
 nvme_remove+0x60/0x140
 pci_device_remove+0x3b/0xb0

Fixes: cb4bfda62afa2 ("nvme-pci: fix hot removal during error handling")
Signed-off-by: Igor Konopko <igor.j.konopko@intel.com>
Reviewed-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 5d0f99bcc987f..44da9fe5b27b8 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3647,7 +3647,7 @@ void nvme_kill_queues(struct nvme_ctrl *ctrl)
 	down_read(&ctrl->namespaces_rwsem);
 
 	/* Forcibly unquiesce queues to avoid blocking dispatch */
-	if (ctrl->admin_q)
+	if (ctrl->admin_q && !blk_queue_dying(ctrl->admin_q))
 		blk_mq_unquiesce_queue(ctrl->admin_q);
 
 	list_for_each_entry(ns, &ctrl->namespaces, list)
-- 
2.20.1




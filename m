Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84C63AA019
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235494AbhFPPoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:44:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235285AbhFPPme (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:42:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3ADC5613E9;
        Wed, 16 Jun 2021 15:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857896;
        bh=P5ycT09ZcXhZUQODqUPfMBH6y1mKQAUoeOI2dT/yBF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RcYQqCT8KkcutG0a4s6PhJXP3ZnVkJJmquKicbqJyzbes+GHuzuPPbcFucfpqqc4n
         nX00FF1zpaV3hUtO2fO8Lr1nVFXQ+NVYDoFAylKOZTZPrl1XXZCsNVufReY+HXnhRZ
         +KfbLrrNd+F3xBrXcWv5AmVbU5LRYzo90w8WflrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 37/48] nvme-loop: check for NVME_LOOP_Q_LIVE in nvme_loop_destroy_admin_queue()
Date:   Wed, 16 Jun 2021 17:33:47 +0200
Message-Id: <20210616152837.821140040@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
References: <20210616152836.655643420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 4237de2f73a669e4f89ac0aa2b44fb1a1d9ec583 ]

We need to check the NVME_LOOP_Q_LIVE flag in
nvme_loop_destroy_admin_queue() to protect against duplicate
invocations eg during concurrent reset and remove calls.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/loop.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index c34f785e699d..fe14609d2254 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -261,7 +261,8 @@ static const struct blk_mq_ops nvme_loop_admin_mq_ops = {
 
 static void nvme_loop_destroy_admin_queue(struct nvme_loop_ctrl *ctrl)
 {
-	clear_bit(NVME_LOOP_Q_LIVE, &ctrl->queues[0].flags);
+	if (!test_and_clear_bit(NVME_LOOP_Q_LIVE, &ctrl->queues[0].flags))
+		return;
 	nvmet_sq_destroy(&ctrl->queues[0].nvme_sq);
 	blk_cleanup_queue(ctrl->ctrl.admin_q);
 	blk_cleanup_queue(ctrl->ctrl.fabrics_q);
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1DF39E29F
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbhFGQS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:18:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232378AbhFGQQ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:16:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA89C61444;
        Mon,  7 Jun 2021 16:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082434;
        bh=I4m+XpZrW2wzPqovMymNFsz6ypXp0Om+sOgn8BKa0kU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgufDorAZ/swjsH2cit4sZiFGHffD/gX9qUimVf9SS/XIw8rAfwBeGVYq4XbrKfzo
         AgbouscYVwv93c8X2Xdfn5wMbGHwjrPqJ9waq40E1E9pD1eqrnzsCKrhv9GwjdZvPW
         EB9hxeEMZ1wcrgOa+3ekziYjpD6z+ffcRJYDC4ReLdx6f01HO4qAc8qsPO4ohiu8ei
         FEWmnmGBFNmkKppvoigWYprhHDaeE9W2hp0jhfI1SGcjhoz2RKjU2txjnnz5KBa5RX
         RPC70epsIQ+8ws3Ndb9IZu+OH4HB/iz2ic/4xqLnwmqoOnZcu5YetP+Zs+EnkegHws
         7ri0aiAgl1LNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 28/39] nvme-loop: check for NVME_LOOP_Q_LIVE in nvme_loop_destroy_admin_queue()
Date:   Mon,  7 Jun 2021 12:13:07 -0400
Message-Id: <20210607161318.3583636-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161318.3583636-1-sashal@kernel.org>
References: <20210607161318.3583636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index c07b4a14d477..df0e5288ae6e 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -251,7 +251,8 @@ static const struct blk_mq_ops nvme_loop_admin_mq_ops = {
 
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


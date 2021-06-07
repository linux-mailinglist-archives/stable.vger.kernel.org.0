Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780BE39E297
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhFGQSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:18:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232304AbhFGQQN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:16:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F0D261468;
        Mon,  7 Jun 2021 16:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082433;
        bh=eiAg7Qqdly+8Se81U+BBNFOQ5+F8mKga4+SfAWWhJmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWPOta50lnJDDoH5/Hcuq1s7rQ4VkqdP+On26DfOYdzZ2WQoTpbmg/ctG1zSWC7ck
         DDDlx5x7ODxAgpKnyNcHphYcuJOPOej8fTwbsgbKW8hMp0zUoykw9wYYxVim0ZxdKA
         i+iWWXTN3gUCgh6MOFsv0YGU/Ea5H0DJWsgxSuXy8ajYmM7iqcgpoqYMWy40OtAC2o
         xEKOrnM6ElgSnFMHFMi0DJjDokSWKzFb+L/bSYt00Yi89Iwp4ZG8Zs1RRZEr44LNL9
         cTEgAeU+SG5P2O1WIM/Q7PDmvzyJCpJnyKH9vd5C9FpvpMwZmgvFhOScBVg1z1bLdp
         OasMJRgSadNTg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 27/39] nvme-loop: clear NVME_LOOP_Q_LIVE when nvme_loop_configure_admin_queue() fails
Date:   Mon,  7 Jun 2021 12:13:06 -0400
Message-Id: <20210607161318.3583636-27-sashal@kernel.org>
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
index 1d3185c82596..c07b4a14d477 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -394,6 +394,7 @@ static int nvme_loop_configure_admin_queue(struct nvme_loop_ctrl *ctrl)
 	return 0;
 
 out_cleanup_queue:
+	clear_bit(NVME_LOOP_Q_LIVE, &ctrl->queues[0].flags);
 	blk_cleanup_queue(ctrl->ctrl.admin_q);
 out_cleanup_fabrics_q:
 	blk_cleanup_queue(ctrl->ctrl.fabrics_q);
-- 
2.30.2


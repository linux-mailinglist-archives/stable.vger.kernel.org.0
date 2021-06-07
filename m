Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F9F39E397
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbhFGQ1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:27:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233471AbhFGQXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:23:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1C7D6192E;
        Mon,  7 Jun 2021 16:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082534;
        bh=+AUXDUczjuSawvCTHOIWXEs386Lj8FbWpVxfUswMffo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YKwlZryFkmnOKRRTJkMnysvXLs1vwsIP8FR05HoGvUGINg7T6VUvgLvTuJ7Ec/Uup
         WPy6kTRyuD1KRx9W8gwJMp2G0IFMJJYo7PUJYpJ3CkLaLQ7twcB2OnPA4UYVxeuPko
         reOmR4U9zHvD1C8iv70cWTo+74frbHoJWIm9vPWy+7RgFfrptjdPBCfzM7eBivcjI3
         4aSu22/B89WFgasNSPJcnWlmg9sq2JiEXdr/Zc+Hb2KmY2H9Fsx6bFoIvSC1q5lYuW
         T9Hs7j4oPD15jsUV8+VhX5r/071I1nPYG1ZxyVtAGq2W7DYr2JGEDqbzdAfW4+PgoN
         w1N6uvVTv9t2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 12/18] nvme-loop: clear NVME_LOOP_Q_LIVE when nvme_loop_configure_admin_queue() fails
Date:   Mon,  7 Jun 2021 12:15:10 -0400
Message-Id: <20210607161517.3584577-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161517.3584577-1-sashal@kernel.org>
References: <20210607161517.3584577-1-sashal@kernel.org>
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
index 5f33c3a9469b..963d8de932d1 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -430,6 +430,7 @@ static int nvme_loop_configure_admin_queue(struct nvme_loop_ctrl *ctrl)
 	return 0;
 
 out_cleanup_queue:
+	clear_bit(NVME_LOOP_Q_LIVE, &ctrl->queues[0].flags);
 	blk_cleanup_queue(ctrl->ctrl.admin_q);
 out_free_tagset:
 	blk_mq_free_tag_set(&ctrl->admin_tag_set);
-- 
2.30.2


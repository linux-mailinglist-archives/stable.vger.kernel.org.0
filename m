Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB4239E320
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbhFGQVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232363AbhFGQTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:19:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CC606162A;
        Mon,  7 Jun 2021 16:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082477;
        bh=ypz9PQ9qe0SVB/8adFFM25pP4e02WlCyeIliOP7utIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehDiBAsT6M7dx6e6QRxHvfWj3I6xsBWv3XeR4B0CazgulY5iwhhwAgDgqpLNE6KT6
         G63WYkpNEG5+hSFFoyUod/m+fzkgLfzClUd/CunyJczm7InvMAJt/4RqRg7sIrKLye
         usaDQwO1T5rY63Tr6UfGuwqe8mI8udsj85rsznbI4eO7/DlN6TZQbGO4l0vc4Ad4Gd
         ZxHN6nsEJA8geHGf7F2DxxPys+h0dX7L3LOumYjdSX9TUPpmoG5I5j4thMrmUS3Cuk
         LAr/wRCCt15H0PE2klo+Jm1/loWbz0OKP+tz2s19HV3VTzfqSQgiSOqq6nBzYugIGP
         HAx6Ru3Gs1nLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 21/29] nvme-loop: clear NVME_LOOP_Q_LIVE when nvme_loop_configure_admin_queue() fails
Date:   Mon,  7 Jun 2021 12:14:02 -0400
Message-Id: <20210607161410.3584036-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161410.3584036-1-sashal@kernel.org>
References: <20210607161410.3584036-1-sashal@kernel.org>
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
index b4f5503ae570..f752e9432676 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -395,6 +395,7 @@ static int nvme_loop_configure_admin_queue(struct nvme_loop_ctrl *ctrl)
 	return 0;
 
 out_cleanup_queue:
+	clear_bit(NVME_LOOP_Q_LIVE, &ctrl->queues[0].flags);
 	blk_cleanup_queue(ctrl->ctrl.admin_q);
 out_cleanup_fabrics_q:
 	blk_cleanup_queue(ctrl->ctrl.fabrics_q);
-- 
2.30.2


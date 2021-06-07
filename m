Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5EE39E230
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbhFGQPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:15:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231805AbhFGQOz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 348AA6142C;
        Mon,  7 Jun 2021 16:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082383;
        bh=na31MgO79blGNGq2tw8e/gm26XvdqvGPIV3mHVLaqiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGmLHxnqijAI834FSFwcU+wgH2jMs8wDGa7wih4Jgk/0GgVXEDxofeVne2pV3/eP9
         hX0gGfDLEAxcCRImoDvQRL3Cb/VKni4gh37S8SXulTBJh84dasi8Oh0q8b3L5K2zK1
         37AeantOmFj+Le7Jr3ibaSiAGsJIRiErm3GLHARZEStmV6SAeU1Bvnwh5tnWedNLVN
         O4l/0cdvO4jAwbYVfCtKP7mt3a+o8unXy3qhZ8UFHAfHBl3YffAWS3N43fQ54ITNDs
         8hADSktI2y9BizIbugWVnI8nYElJMl0xPysmY71StUBhv4CblYmGBakIbc0yJmN9XH
         cWMMwpJngkHiA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 39/49] nvme-loop: do not warn for deleted controllers during reset
Date:   Mon,  7 Jun 2021 12:12:05 -0400
Message-Id: <20210607161215.3583176-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 6622f9acd29cd4f6272720e827e6406f5a970cb0 ]

During concurrent reset and delete calls the reset workqueue is
flushed, causing nvme_loop_reset_ctrl_work() to be executed when
the controller is in state DELETING or DELETING_NOIO.
But this is expected, so we shouldn't issue a WARN_ON here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/loop.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index fe14609d2254..0f22f333ff24 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -463,8 +463,10 @@ static void nvme_loop_reset_ctrl_work(struct work_struct *work)
 	nvme_loop_shutdown_ctrl(ctrl);
 
 	if (!nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_CONNECTING)) {
-		/* state change failure should never happen */
-		WARN_ON_ONCE(1);
+		if (ctrl->ctrl.state != NVME_CTRL_DELETING &&
+		    ctrl->ctrl.state != NVME_CTRL_DELETING_NOIO)
+			/* state change failure for non-deleted ctrl? */
+			WARN_ON_ONCE(1);
 		return;
 	}
 
-- 
2.30.2


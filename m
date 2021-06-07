Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099CF39E2A1
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbhFGQS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:18:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232122AbhFGQQa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:16:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1948761462;
        Mon,  7 Jun 2021 16:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082435;
        bh=JLiPSW/F3RteIc4jb/cRphFsajUUSG+Yu0jZClB4Iw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mP2eOg3+Wn0ZMTlCbHlHlbePuNplAQ4bdxhgFP4VSDs0kpC093sUe1PW93SAfTawt
         EvOjTO5tevPH2L185ok3PvracnM40WpGrwPVi3V+4cNbHdqJ+fDTldMypiIz5cIaTb
         pqJzfRtloFC8TarGrqvf5fSC93/KOY/MxLPKCI/UyeCR6iHILuOhqhM+Zn/bnmSm5h
         duOoRDlwLiETkaTcau6rC7dYRFXAFM1FxEANd2pdaA+L9LwWO6IIZjjEL/dfxs2Xtu
         BnmM34zvx+nTHSwJ+bWONiwZIiLvTMLDyPojRZZF8hTKpBgFfnxOel0v07nkKg6mGp
         ekLgVfWMhjAkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 29/39] nvme-loop: do not warn for deleted controllers during reset
Date:   Mon,  7 Jun 2021 12:13:08 -0400
Message-Id: <20210607161318.3583636-29-sashal@kernel.org>
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
index df0e5288ae6e..16d71cc5a50e 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -453,8 +453,10 @@ static void nvme_loop_reset_ctrl_work(struct work_struct *work)
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


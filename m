Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8877E3A9F92
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbhFPPjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:39:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234675AbhFPPiD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:38:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4776061351;
        Wed, 16 Jun 2021 15:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857756;
        bh=JLiPSW/F3RteIc4jb/cRphFsajUUSG+Yu0jZClB4Iw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YHHBWVR+krkw1leJz7kgVZFbr1qX6rN+RlFVmE4mjz4/SE6UDOOMpONbBW7dRPi2c
         HTyAr1VzIUQzqRA/Ik6cP4T6GhW0K/fe60SgXnu+EhMQ08j2U56T6MbjGjF1QZuyPT
         0fz2vyC5soIMT0kKy/SvNnIXUdLdrjiOmfsTaerk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 28/38] nvme-loop: do not warn for deleted controllers during reset
Date:   Wed, 16 Jun 2021 17:33:37 +0200
Message-Id: <20210616152836.286484102@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152835.407925718@linuxfoundation.org>
References: <20210616152835.407925718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




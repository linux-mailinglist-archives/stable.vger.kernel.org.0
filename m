Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A018226B44D
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbgIOXVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727215AbgIOOiW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:38:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86E3223C90;
        Tue, 15 Sep 2020 14:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180117;
        bh=szHbSRCe9pRJ6fYgItgZsuGEJdXiWSdwE4DfDKvwjd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ksGbeGxOlZ1ogxlLUn3XkZd/9y9IklGwyXAn+VX1Dv0JeJRMOlTiuO+87xnUJ91ZH
         TSThIPUq7uOABCdBOgJyNL9F0oySRX2xwcpwOvwXuA5zEa+iHiOca8p34+PjEo1uWA
         vaYf6iOaa1ed4CofQMJ2UJOkdyyMWvbW8AETdc44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 088/177] nvme-tcp: fix reset hang if controller died in the middle of a reset
Date:   Tue, 15 Sep 2020 16:12:39 +0200
Message-Id: <20200915140657.860619665@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit e5c01f4f7f623e768e868bcc08d8e7ceb03b75d0 ]

If the controller becomes unresponsive in the middle of a reset, we will
hang because we are waiting for the freeze to complete, but that cannot
happen since we have commands that are inflight holding the
q_usage_counter, and we can't blindly fail requests that times out.

So give a timeout and if we cannot wait for queue freeze before
unfreezing, fail and have the error handling take care how to proceed
(either schedule a reconnect of remove the controller).

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 65a3bad778104..f1f66bf96cbb9 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1753,7 +1753,15 @@ static int nvme_tcp_configure_io_queues(struct nvme_ctrl *ctrl, bool new)
 
 	if (!new) {
 		nvme_start_queues(ctrl);
-		nvme_wait_freeze(ctrl);
+		if (!nvme_wait_freeze_timeout(ctrl, NVME_IO_TIMEOUT)) {
+			/*
+			 * If we timed out waiting for freeze we are likely to
+			 * be stuck.  Fail the controller initialization just
+			 * to be safe.
+			 */
+			ret = -ENODEV;
+			goto out_wait_freeze_timed_out;
+		}
 		blk_mq_update_nr_hw_queues(ctrl->tagset,
 			ctrl->queue_count - 1);
 		nvme_unfreeze(ctrl);
@@ -1761,6 +1769,9 @@ static int nvme_tcp_configure_io_queues(struct nvme_ctrl *ctrl, bool new)
 
 	return 0;
 
+out_wait_freeze_timed_out:
+	nvme_stop_queues(ctrl);
+	nvme_tcp_stop_io_queues(ctrl);
 out_cleanup_connect_q:
 	if (new)
 		blk_cleanup_queue(ctrl->connect_q);
-- 
2.25.1




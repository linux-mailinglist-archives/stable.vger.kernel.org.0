Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F8E69CEBE
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbjBTOCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbjBTOCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:02:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAF91F5D1
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 06:01:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8F5D60EB7
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 14:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F5AC433EF;
        Mon, 20 Feb 2023 14:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901676;
        bh=cbOjMZmyVbRTZ3QQUl5lkKQ+MYwMIWfGu3PIuK6tN1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2kBrprxJLKsPGoKzByK3LZ2TrJRFfn6vMzWf0BNTXd99Z8E+YYSUsSeorVb5z3PH
         aq7L2uWjmR6LQ8lyTClgJZKsesg1X1FJcFOZJQnugzwf786mJZkxVMJ0RflGV89yQf
         Yhm3a13EgH+L6gQG2LLCOc5lsCQiNiP3/rMe7HUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 109/118] nvme-tcp: stop auth work after tearing down queues in error recovery
Date:   Mon, 20 Feb 2023 14:37:05 +0100
Message-Id: <20230220133604.760554807@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 1f1a4f89562d3b33b6ca4fc8a4f3bd4cd35ab4ea ]

when starting error recovery there might be a authentication work
running, and it involves I/O commands. Given the controller is tearing
down there is no chance for the I/O to complete other than timing out
which may unnecessarily take a full io timeout.

So first tear down the queues, fail/cancel all inflight I/O (including
potentially authentication) and only then stop authentication. This
ensures that failover is not stalled due to blocked authentication I/O.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 4c052c261517e..1dc7c733c7e39 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2128,7 +2128,6 @@ static void nvme_tcp_error_recovery_work(struct work_struct *work)
 				struct nvme_tcp_ctrl, err_work);
 	struct nvme_ctrl *ctrl = &tcp_ctrl->ctrl;
 
-	nvme_auth_stop(ctrl);
 	nvme_stop_keep_alive(ctrl);
 	flush_work(&ctrl->async_event_work);
 	nvme_tcp_teardown_io_queues(ctrl, false);
@@ -2136,6 +2135,7 @@ static void nvme_tcp_error_recovery_work(struct work_struct *work)
 	nvme_start_queues(ctrl);
 	nvme_tcp_teardown_admin_queue(ctrl, false);
 	nvme_start_admin_queue(ctrl);
+	nvme_auth_stop(ctrl);
 
 	if (!nvme_change_ctrl_state(ctrl, NVME_CTRL_CONNECTING)) {
 		/* state change failure is ok if we started ctrl delete */
-- 
2.39.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063C94AFBBC
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238728AbiBIStE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240775AbiBISs0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:48:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8127DC1DC5E1;
        Wed,  9 Feb 2022 10:44:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B54B612D5;
        Wed,  9 Feb 2022 18:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C010AC340E7;
        Wed,  9 Feb 2022 18:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432293;
        bh=oyFYobVkluLYsmiNyANfzF/cCwasyGX2hI+4PT+cfbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HDdHgAAAetlIR9B0WGsDdY/NzC4ANSSMJlEyZsburhwdUpqzocqcGWOKoD8+u5DKj
         /zZrgO5bExNIaEGkEpIuG26scIlfB0l8R8GbWwZorj4dUGEuxyCt2WQFVQc0qIufyo
         YmrUW1CQBHuizPIimE+xhEb1ZfCkkN/jqXT/DdsBcuk/RUzreHKH8A6uSkwbneRPkP
         6Fe00hyfVydD8VMrGoMaH2mtPkmj2OFeAWLgQsjWKD900I++Ci2QHLFj57OIgdLLTo
         xTmELlySf2a87pwWMcn6ZOymniupNWtfvdaCq0BaXfIB5ihht3OVvDiXhSiSJwHnk4
         h3o+MnsYa2u/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Sasha Levin <sashal@kernel.org>,
        kbusch@kernel.org, axboe@fb.com, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 09/10] nvme-rdma: fix possible use-after-free in transport error_recovery work
Date:   Wed,  9 Feb 2022 13:44:08 -0500
Message-Id: <20220209184410.48223-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209184410.48223-1-sashal@kernel.org>
References: <20220209184410.48223-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit b6bb1722f34bbdbabed27acdceaf585d300c5fd2 ]

While nvme_rdma_submit_async_event_work is checking the ctrl and queue
state before preparing the AER command and scheduling io_work, in order
to fully prevent a race where this check is not reliable the error
recovery work must flush async_event_work before continuing to destroy
the admin queue after setting the ctrl state to RESETTING such that
there is no race .submit_async_event and the error recovery handler
itself changing the ctrl state.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 1f41cf80f827c..55f4999525037 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1050,6 +1050,7 @@ static void nvme_rdma_error_recovery_work(struct work_struct *work)
 			struct nvme_rdma_ctrl, err_work);
 
 	nvme_stop_keep_alive(&ctrl->ctrl);
+	flush_work(&ctrl->ctrl.async_event_work);
 	nvme_rdma_teardown_io_queues(ctrl, false);
 	nvme_start_queues(&ctrl->ctrl);
 	nvme_rdma_teardown_admin_queue(ctrl, false);
-- 
2.34.1


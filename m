Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2084AFBB9
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240671AbiBISss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240945AbiBISsN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:48:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D72C1DC5C5;
        Wed,  9 Feb 2022 10:44:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 501D0612CC;
        Wed,  9 Feb 2022 18:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0578C340E7;
        Wed,  9 Feb 2022 18:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432291;
        bh=IbxYndShaUN1LdttA6NiRREW3GWMiaYelf0xxIh24h0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPBxjhT8X5M2HLhLw8ztfnXZmm1it9w0HBHDROIug6nvCWqdUeCc0JTcnkitZAAT8
         UbKYCsCMB3IJUSO/h0zizlRSox8E427Lge8YrFGxSaVDI/PZEwiOIpBSRelvePEz6m
         0HYtv2T5rmfgomBuuByEj7BHKqIdSFg3RRGbNRbXfbTgiFZLBlJGH0C0DNKHECiM1c
         DoHmPRRk2qjfHaPGujiyto5djWJFkyMZoxnTR91wiPg+aMdm3NrX8PocNXlJDsdoil
         2FP4zXA6K56EKFtv080ToCCOeiMW2zWecGrWF2q4m6sPtHZ4E9xvnS5n14FC7JqkiQ
         A+woWHOSgSm3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Sasha Levin <sashal@kernel.org>,
        kbusch@kernel.org, axboe@fb.com, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 08/10] nvme: fix a possible use-after-free in controller reset during load
Date:   Wed,  9 Feb 2022 13:44:07 -0500
Message-Id: <20220209184410.48223-8-sashal@kernel.org>
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

[ Upstream commit 0fa0f99fc84e41057cbdd2efbfe91c6b2f47dd9d ]

Unlike .queue_rq, in .submit_async_event drivers may not check the ctrl
readiness for AER submission. This may lead to a use-after-free
condition that was observed with nvme-tcp.

The race condition may happen in the following scenario:
1. driver executes its reset_ctrl_work
2. -> nvme_stop_ctrl - flushes ctrl async_event_work
3. ctrl sends AEN which is received by the host, which in turn
   schedules AEN handling
4. teardown admin queue (which releases the queue socket)
5. AEN processed, submits another AER, calling the driver to submit
6. driver attempts to send the cmd
==> use-after-free

In order to fix that, add ctrl state check to validate the ctrl
is actually able to accept the AER submission.

This addresses the above race in controller resets because the driver
during teardown should:
1. change ctrl state to RESETTING
2. flush async_event_work (as well as other async work elements)

So after 1,2, any other AER command will find the
ctrl state to be RESETTING and bail out without submitting the AER.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e64310f2296f8..a0a805a5ab6b2 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3463,7 +3463,14 @@ static void nvme_async_event_work(struct work_struct *work)
 		container_of(work, struct nvme_ctrl, async_event_work);
 
 	nvme_aen_uevent(ctrl);
-	ctrl->ops->submit_async_event(ctrl);
+
+	/*
+	 * The transport drivers must guarantee AER submission here is safe by
+	 * flushing ctrl async_event_work after changing the controller state
+	 * from LIVE and before freeing the admin queue.
+	*/
+	if (ctrl->state == NVME_CTRL_LIVE)
+		ctrl->ops->submit_async_event(ctrl);
 }
 
 static bool nvme_ctrl_pp_status(struct nvme_ctrl *ctrl)
-- 
2.34.1


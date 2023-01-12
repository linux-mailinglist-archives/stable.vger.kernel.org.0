Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCB8667719
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbjALOj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239336AbjALOjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:39:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C895D68F
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:29:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 829746202D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E796C433F0;
        Thu, 12 Jan 2023 14:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533745;
        bh=MDoSzXVtTwsEULaVygo8hfDjSSlpwneZQiauIwiF8+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aarS7JVFajPUReETvhDZGLScqwfnOVWNUGzAwj7pKAjv+Xo4eteiTcj15TrXO3wFX
         Zehg13y1WkC0tH6GHpV7qzpfuXy/3eA58gF15PJbUf1mDuvGvpWzpYdR9C7OzhSEUL
         QOcb/IHWgzp+G5CHO5h7vyqEZkI9DAsQoQwdkWFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 579/783] nvmet: dont defer passthrough commands with trivial effects to the workqueue
Date:   Thu, 12 Jan 2023 14:54:55 +0100
Message-Id: <20230112135551.089622789@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 2a459f6933e1c459bffb7cc73fd6c900edc714bd ]

Mask out the "Command Supported" and "Logical Block Content Change" bits
and only defer execution of commands that have non-trivial effects to
the workqueue for synchronous execution.  This allows to execute admin
commands asynchronously on controllers that provide a Command Supported
and Effects log page, and will keep allowing to execute Write commands
asynchronously once command effects on I/O commands are taken into
account.

Fixes: c1fef73f793b ("nvmet: add passthru code to process commands")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/passthru.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/target/passthru.c b/drivers/nvme/target/passthru.c
index d24251ece502..f76d01028df0 100644
--- a/drivers/nvme/target/passthru.c
+++ b/drivers/nvme/target/passthru.c
@@ -259,14 +259,13 @@ static void nvmet_passthru_execute_cmd(struct nvmet_req *req)
 	}
 
 	/*
-	 * If there are effects for the command we are about to execute, or
-	 * an end_req function we need to use nvme_execute_passthru_rq()
-	 * synchronously in a work item seeing the end_req function and
-	 * nvme_passthru_end() can't be called in the request done callback
-	 * which is typically in interrupt context.
+	 * If a command needs post-execution fixups, or there are any
+	 * non-trivial effects, make sure to execute the command synchronously
+	 * in a workqueue so that nvme_passthru_end gets called.
 	 */
 	effects = nvme_command_effects(ctrl, ns, req->cmd->common.opcode);
-	if (req->p.use_workqueue || effects) {
+	if (req->p.use_workqueue ||
+	    (effects & ~(NVME_CMD_EFFECTS_CSUPP | NVME_CMD_EFFECTS_LBCC))) {
 		INIT_WORK(&req->p.work, nvmet_passthru_execute_cmd_work);
 		req->p.rq = rq;
 		schedule_work(&req->p.work);
-- 
2.35.1




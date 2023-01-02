Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59CA065B0DE
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbjABL24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236067AbjABL2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:28:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F547BA8
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:27:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2C64B80D1C
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DF9C433EF;
        Mon,  2 Jan 2023 11:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658849;
        bh=YrpSDw0Ddgqbf3Hl4Hp6WdGzmN+sxNK/GPf1rq6mXe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=huwgBq6WK6mj9ZTPmGEmWFo9WCk3PVq6v+06fXM4pqmuP1RAhqkKWy6brIWcdI8Q7
         zCum2rPHdLunxS3uO1hLPEBRaTZKcrY/VZlsplfyXf/70uNOBntwanlnIu2+x2ddE4
         XuqnByoTrLw2PcRsCjSC+nMVisaLXncgFr3hII/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 22/74] nvmet: dont defer passthrough commands with trivial effects to the workqueue
Date:   Mon,  2 Jan 2023 12:21:55 +0100
Message-Id: <20230102110553.013957377@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
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
index 94d3153bae54..09537000d817 100644
--- a/drivers/nvme/target/passthru.c
+++ b/drivers/nvme/target/passthru.c
@@ -333,14 +333,13 @@ static void nvmet_passthru_execute_cmd(struct nvmet_req *req)
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
 		queue_work(nvmet_wq, &req->p.work);
-- 
2.35.1




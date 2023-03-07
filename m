Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C443E6AE8CE
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjCGRS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjCGRSV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:18:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9E842BF5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:14:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0878EB819A9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E7AC433EF;
        Tue,  7 Mar 2023 17:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209241;
        bh=Dt9QAMKPw+Z1C0SFGdnrRflwdCKsaO31FmicX3CvGnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eR3LXbMIAQDA4JGrdpCb1bq3wx4qzDMrZqFvBm0v/+nIicSXZAxKZjK/RzmKqRi9V
         GxsXAM9/r/gX4RWId9dBEwc1+D2/Xn1TwN2SDTWXxvrYzkK0wqOTMrudUE8ZM80NuI
         PyoaHcJHNmBu5AJEXgeWCSWw7q1cY9ff30s4hrbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liu Xiaodong <xiaodong.liu@intel.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0125/1001] block: ublk: check IO buffer based on flag need_get_data
Date:   Tue,  7 Mar 2023 17:48:17 +0100
Message-Id: <20230307170027.503954010@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Xiaodong <xiaodong.liu@intel.com>

[ Upstream commit 2f1e07dda1e1310873647abc40bbc49eaf3b10e3 ]

Currently, uring_cmd with UBLK_IO_FETCH_REQ or
UBLK_IO_COMMIT_AND_FETCH_REQ is always checked whether
userspace server has provided IO buffer even flag
UBLK_F_NEED_GET_DATA is configured.

This is a excessive check. If UBLK_F_NEED_GET_DATA is
configured, FETCH_RQ doesn't need to provide IO buffer;
COMMIT_AND_FETCH_REQ also doesn't need to do that if
the IO type is not READ.

Check ub_cmd->addr together with ublk_need_get_data()
and IO type in ublk_ch_uring_cmd().

With this fix, userspace server doesn't need to preserve
buffers for every ublk_io when flag UBLK_F_NEED_GET_DATA
is configured, in order to save memory.

Signed-off-by: Liu Xiaodong <xiaodong.liu@intel.com>
Fixes: c86019ff75c1 ("ublk_drv: add support for UBLK_IO_NEED_GET_DATA")
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230210141356.112321-1-xiaodong.liu@intel.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 450bd54fd0061..4aec9be0ab77e 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1206,6 +1206,7 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	u32 cmd_op = cmd->cmd_op;
 	unsigned tag = ub_cmd->tag;
 	int ret = -EINVAL;
+	struct request *req;
 
 	pr_devel("%s: received: cmd op %d queue %d tag %d result %d\n",
 			__func__, cmd->cmd_op, ub_cmd->q_id, tag,
@@ -1256,8 +1257,8 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		 */
 		if (io->flags & UBLK_IO_FLAG_OWNED_BY_SRV)
 			goto out;
-		/* FETCH_RQ has to provide IO buffer */
-		if (!ub_cmd->addr)
+		/* FETCH_RQ has to provide IO buffer if NEED GET DATA is not enabled */
+		if (!ub_cmd->addr && !ublk_need_get_data(ubq))
 			goto out;
 		io->cmd = cmd;
 		io->flags |= UBLK_IO_FLAG_ACTIVE;
@@ -1266,8 +1267,12 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		ublk_mark_io_ready(ub, ubq);
 		break;
 	case UBLK_IO_COMMIT_AND_FETCH_REQ:
-		/* FETCH_RQ has to provide IO buffer */
-		if (!ub_cmd->addr)
+		req = blk_mq_tag_to_rq(ub->tag_set.tags[ub_cmd->q_id], tag);
+		/*
+		 * COMMIT_AND_FETCH_REQ has to provide IO buffer if NEED GET DATA is
+		 * not enabled or it is Read IO.
+		 */
+		if (!ub_cmd->addr && (!ublk_need_get_data(ubq) || req_op(req) == REQ_OP_READ))
 			goto out;
 		if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
 			goto out;
-- 
2.39.2




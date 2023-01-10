Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B2766498B
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239187AbjAJSW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239224AbjAJSWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:22:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07948F29F
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:19:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EC1461864
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523B4C433EF;
        Tue, 10 Jan 2023 18:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374774;
        bh=U0IgMbheWfPsgM7fBPstUM3K0hXuWEkzuDByQym12CE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u5ckhKcL0vlwc0IPaDuTRT709qravn51QmEed4V62jfWieQnYI5SdHngFs1p6zEyD
         f9OtZTcug+vjU7x3Zp/8bKVjAmUkqYjisrEoKZ9LelhJ8nLqMEphIoCuDePzlkE0fx
         f6yC18jDRTWfVvLn3wJoelQSv/ceITWtjAbBkKC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Ming Lei <ming.lei@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/159] ublk: honor IO_URING_F_NONBLOCK for handling control command
Date:   Tue, 10 Jan 2023 19:04:10 +0100
Message-Id: <20230110180021.529737547@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit fa8e442e832a3647cdd90f3e606c473a51bc1b26 ]

Most of control command handlers may sleep, so return -EAGAIN in case
of IO_URING_F_NONBLOCK to defer the handling into io wq context.

Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230104133235.836536-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index e9de9d846b73..17b677b5d3b2 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1992,6 +1992,9 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
 	int ret = -EINVAL;
 
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
 	ublk_ctrl_cmd_dump(cmd);
 
 	if (!(issue_flags & IO_URING_F_SQE128))
-- 
2.35.1




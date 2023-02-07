Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7918468D7AC
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjBGNC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbjBGNBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:01:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149183C13
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:01:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78DFF61411
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBBFC433EF;
        Tue,  7 Feb 2023 13:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774886;
        bh=ymx/lZ4UsqGIpVe3M21VYx1OQXiLM1kyDP0yZqoaghc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KzVg5TRWb0VBWExnjxAbq3WJ8qSIMXC6sVmFQurYMwT+clZxBs4BWTqiSQq5aO6Oe
         jfEzOgr8mxdX/hbE2Qw2rxWYScnMxQT6XACBxXIWICIcvDmmBNhy2ObCEwrXO9kT5/
         gtQd+INMNmGrh4q3KVExEQp6m82IFOktvrG9ngrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liu Xiaodong <xiaodong.liu@intel.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/208] block: ublk: extending queue_size to fix overflow
Date:   Tue,  7 Feb 2023 13:55:21 +0100
Message-Id: <20230207125637.356001431@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

From: Liu Xiaodong <xiaodong.liu@intel.com>

[ Upstream commit 29baef789c838bd5c02f50c88adbbc6b955aaf61 ]

When validating drafted SPDK ublk target, in a case that
assigning large queue depth to multiqueue ublk device,
ublk target would run into a weird incorrect state. During
rounds of review and debug, An overflow bug was found
in ublk driver.

In ublk_cmd.h, UBLK_MAX_QUEUE_DEPTH is 4096 which means
each ublk queue depth can be set as large as 4096. But
when setting qd for a ublk device,
sizeof(struct ublk_queue) + depth * sizeof(struct ublk_io)
will be larger than 65535 if qd is larger than 2728.
Then queue_size is overflowed, and ublk_get_queue()
references a wrong pointer position. The wrong content of
ublk_queue elements will lead to out-of-bounds memory
access.

Extend queue_size in ublk_device as "unsigned int".

Signed-off-by: Liu Xiaodong <xiaodong.liu@intel.com>
Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230131070552.115067-1-xiaodong.liu@intel.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index e54693204630..6368b56eacf1 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -137,7 +137,7 @@ struct ublk_device {
 
 	char	*__queues;
 
-	unsigned short  queue_size;
+	unsigned int	queue_size;
 	struct ublksrv_ctrl_dev_info	dev_info;
 
 	struct blk_mq_tag_set	tag_set;
-- 
2.39.0




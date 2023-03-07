Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7928C6AE88B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjCGRQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:16:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjCGRQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:16:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB2D97FC8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:12:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F4F061508
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E14AC433EF;
        Tue,  7 Mar 2023 17:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209135;
        bh=xcGvdYIi3xBUtI7d3Mwlb1YERsxmBuvYnxyI5IQxoOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IILp2qihx2zlMBtJ7WrwYCXD28DmqAjiaoYdRNAjNi+FLtRhwqVFZIQz68/fAyyG/
         i7ssK00gprY0YTaBWAjUbPkKe1NFApYyncn6LMwxlxNDVdEbRqFosAm4wCGwrjq217
         D0Gyi7A5hQqR8VM7fvcIGin2v0ctqNT/Nuu11VIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0092/1001] ublk_drv: remove nr_aborted_queues from ublk_device
Date:   Tue,  7 Mar 2023 17:47:44 +0100
Message-Id: <20230307170026.165085967@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit ed878d1c1c641c4a6bd366658fc8e6bc842b80d1 ]

No one uses 'nr_aborted_queues' any more, so remove it.

Reviewed-by: ZiyangZhang <ZiyangZhang@linux.alibaba.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230106041711.914434-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 73a166d97492 ("ublk_drv: don't probe partitions if the ubq daemon isn't trusted")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 6368b56eacf11..f44b9467720c9 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -159,7 +159,6 @@ struct ublk_device {
 
 	struct completion	completion;
 	unsigned int		nr_queues_ready;
-	atomic_t		nr_aborted_queues;
 
 	/*
 	 * Our ubq->daemon may be killed without any notification, so
-- 
2.39.2




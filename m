Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA92F59DC50
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347711AbiHWLRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357542AbiHWLQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:16:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA029BB938;
        Tue, 23 Aug 2022 02:19:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9744861298;
        Tue, 23 Aug 2022 09:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96586C433C1;
        Tue, 23 Aug 2022 09:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246379;
        bh=VpSDeaQJ9EoiRQpU/oG0/HC97bBbTXYhd/rde+chD1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pk9WUtEcYBEtFkMEzNa9412VR9B4bnTStR4rPxePmJs4USpK0jfh1IOA+na5dJ9xo
         olUHFe/d0eJNRS7YJ2sjpDe9P1FPVDoQgtHi1T1HV4EI6OZSkAv73jKN237hPQv7nO
         XIT+ToiXut82iJHNmRmG4pPexDI+bN2OwO2xJbCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Zhang <yi.zhang@redhat.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/389] blk-mq: dont create hctx debugfs dir until q->debugfs_dir is created
Date:   Tue, 23 Aug 2022 10:22:48 +0200
Message-Id: <20220823080119.377590916@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit f3ec5d11554778c24ac8915e847223ed71d104fc ]

blk_mq_debugfs_register_hctx() can be called by blk_mq_update_nr_hw_queues
when gendisk isn't added yet, such as nvme tcp.

Fixes the warning of 'debugfs: Directory 'hctx0' with parent '/' already present!'
which can be observed reliably when running blktests nvme/005.

Fixes: 6cfc0081b046 ("blk-mq: no need to check return value of debugfs_create functions")
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220711090808.259682-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 121f4c1e0697..772a6c6b1634 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -883,6 +883,9 @@ void blk_mq_debugfs_register_hctx(struct request_queue *q,
 	char name[20];
 	int i;
 
+	if (!q->debugfs_dir)
+		return;
+
 	snprintf(name, sizeof(name), "hctx%u", hctx->queue_num);
 	hctx->debugfs_dir = debugfs_create_dir(name, q->debugfs_dir);
 
-- 
2.35.1




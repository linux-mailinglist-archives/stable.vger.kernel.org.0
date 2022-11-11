Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57040625058
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbiKKCev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbiKKCeR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:34:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB669663CA;
        Thu, 10 Nov 2022 18:34:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7967BB822ED;
        Fri, 11 Nov 2022 02:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87455C433D6;
        Fri, 11 Nov 2022 02:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134041;
        bh=/rp34yeGFKsFhtHhn2MEDPm5v0CJcRrSiHHjvvOT3j0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDOZJjleH+mGHD79za0KdkPsoeFfFetqkhrJXh0sO/wW8hEsy4geiI4KnetMwv/eW
         q+d0RoG+vpHpjJlNUYmGpS83Kwr41xOWz1lorQ67VWOnTVjZtq7DvELm5HrSM6JCNy
         U0udeNEQ1eI8959DlF2Y2aEvkIB6HF1ycRyxuuZNwEHUaKfqOD/fGlwxN4IAJb8l2j
         7A8/h8O4o9w9MvG6ZEw0H1tKCRk3KZ7iRbkllLXsXaZUB+2mH0TYohcgxZXBd8nm0v
         89DAATQEgXwWmzUaIOsJEvbIPMMkT4Ql0yhp0NrgiX+di781CN+eXq+RYHhrqr0I1q
         iCcOLNcz0ouig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 11/30] block: blk_add_rq_to_plug(): clear stale 'last' after flush
Date:   Thu, 10 Nov 2022 21:33:19 -0500
Message-Id: <20221111023340.227279-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023340.227279-1-sashal@kernel.org>
References: <20221111023340.227279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 878eb6e48f240d02ed1c9298020a0b6370695f24 ]

blk_mq_flush_plug_list() empties ->mq_list and request we'd peeked there
before that call is gone; in any case, we are not dealing with a mix
of requests for different queues now - there's no requests left in the
plug.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index fe840536e6ac..d1326d48b45e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1183,6 +1183,7 @@ static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
 		   (!blk_queue_nomerges(rq->q) &&
 		    blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
 		blk_mq_flush_plug_list(plug, false);
+		last = NULL;
 		trace_block_plug(rq->q);
 	}
 
-- 
2.35.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32ADB6357A8
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238227AbiKWJqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238142AbiKWJpx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:45:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D6311092E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:43:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E0AAB81E54
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F18C433D6;
        Wed, 23 Nov 2022 09:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196582;
        bh=YlFeKfM+KvupLe3tKXn3zh1HFAZfcLoLsKdVQmOOpXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TEkX/7lJfzmGl8tsg52U5m1tX18Z0UTKAX5LWpwnF1DLSiSBvvIDqIEWStgT17QFo
         hvht399XneTuXuHUezCsdyBzyL3dPVKBenp/lRfYGStEbw2w/L9t7C8Y+H8L1LUVjy
         ugA5EA8EP1xYSNr2Hk2tv7NB39xzB5f51Uj/uwns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 042/314] block: blk_add_rq_to_plug(): clear stale last after flush
Date:   Wed, 23 Nov 2022 09:48:07 +0100
Message-Id: <20221123084627.425427623@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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
index edf41959a705..4402e4ecb8b1 100644
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




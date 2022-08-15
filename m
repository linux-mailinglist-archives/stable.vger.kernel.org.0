Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5069C5940B9
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243647AbiHOU4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346668AbiHOUzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:55:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7F83B964;
        Mon, 15 Aug 2022 12:11:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07E2EB810C6;
        Mon, 15 Aug 2022 19:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56386C433D6;
        Mon, 15 Aug 2022 19:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590675;
        bh=KCCnZy4VwddJyPRUyy8fpAUc4A0puR9fu+CDJ3uYcRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLcEz57tHSTZyZnV4rlAO3tz1BANASbdkPYFU59XMrjRzGlRcoqJn3qTKJY0lDGcG
         20XG2vin9r2QGub1iZvqRrUqI6nAtUKZgUtHxz/+fNDmQFoj5zf2WgiQ2T0SMxUSzg
         tA1A1w/EGvAG8bxNYUXYv5o/q1TSrsIG4pdhp2Bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0294/1095] io_uring: Dont require reinitable percpu_ref
Date:   Mon, 15 Aug 2022 19:54:53 +0200
Message-Id: <20220815180441.942422287@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Michal Koutný <mkoutny@suse.com>

[ Upstream commit 48904229928d941ce1db181b991948387ab463cd ]

The commit 8bb649ee1da3 ("io_uring: remove ring quiesce for
io_uring_register") removed the worklow relying on reinit/resurrection
of the percpu_ref, hence, initialization with that requested is a relic.

This is based on code review, this causes no real bug (and theoretically
can't). Technically it's a revert of commit 214828962dea ("io_uring:
initialize percpu refcounters using PERCU_REF_ALLOW_REINIT") but since
the flag omission is now justified, I'm not making this a revert.

Fixes: 8bb649ee1da3 ("io_uring: remove ring quiesce for io_uring_register")
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b25e59da129f..2dd6731c1022 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1576,7 +1576,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		INIT_LIST_HEAD(&ctx->io_buffers[i]);
 
 	if (percpu_ref_init(&ctx->refs, io_ring_ctx_ref_free,
-			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
+			    0, GFP_KERNEL))
 		goto err;
 
 	ctx->flags = p->flags;
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF4E540BD7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbiFGScE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351528AbiFGS3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:29:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94ACE179955;
        Tue,  7 Jun 2022 10:55:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BC3161825;
        Tue,  7 Jun 2022 17:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76368C34119;
        Tue,  7 Jun 2022 17:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624520;
        bh=5gp+eWBQzQzxOlVDyPcIvuFGDZEuXQfPgvDwlxkfPjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TRE0aEBPffsPkHflOv6WCjlWlA+0qR/LGLfvRsjKwYM0wWrS+zP7I/7GjzMUvzHcp
         uL56aIR8pMMBQYw9q1u6SYSlIqfG9RmnIWYUNM9naocHthEut0mdoR6AkAlQCLWmbm
         qbOBjaJJDVQrAnbZwNtG6v/rDPI9adBmQKZP5Z/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 358/667] bfq: Allow current waker to defend against a tentative one
Date:   Tue,  7 Jun 2022 19:00:23 +0200
Message-Id: <20220607164945.492612985@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit c5ac56bb6110e42e79d3106866658376b2e48ab9 ]

The code in bfq_check_waker() ignores wake up events from the current
waker. This makes it more likely we select a new tentative waker
although the current one is generating more wake up events. Treat
current waker the same way as any other process and allow it to reset
the waker detection logic.

Fixes: 71217df39dc6 ("block, bfq: make waker-queue detection more robust")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220519105235.31397-2-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index a2aefb4a1e2e..343ca559ab8a 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2022,8 +2022,7 @@ static void bfq_check_waker(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	if (!bfqd->last_completed_rq_bfqq ||
 	    bfqd->last_completed_rq_bfqq == bfqq ||
 	    bfq_bfqq_has_short_ttime(bfqq) ||
-	    now_ns - bfqd->last_completion >= 4 * NSEC_PER_MSEC ||
-	    bfqd->last_completed_rq_bfqq == bfqq->waker_bfqq)
+	    now_ns - bfqd->last_completion >= 4 * NSEC_PER_MSEC)
 		return;
 
 	if (bfqd->last_completed_rq_bfqq !=
-- 
2.35.1




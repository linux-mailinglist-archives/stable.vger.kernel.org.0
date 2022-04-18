Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3365F5050CD
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238801AbiDRM3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239066AbiDRM1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:27:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E4C1EAF7;
        Mon, 18 Apr 2022 05:21:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59E0060FBC;
        Mon, 18 Apr 2022 12:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0B5C385A7;
        Mon, 18 Apr 2022 12:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284475;
        bh=fqp40Y9UjZn+SQBAxw+bQ8zFxntrr6A8v5QsewFp2MY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DHHW67GyJc0n4hZ6a5SwZsNN8CAhFhIIlOrOf7DutWfNBVxAg2ycx4WbZZDbRM21k
         S5tTGCHMMG9EbpazOOhjQ26CKJ501Dg9UmpKPD1p6wiv1cyYyTFEu4kqYI81jJMfpp
         VQUpC5Jelt6Ub1UtyXYVI6w7F4XLp4C/42l4hUt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 127/219] block: null_blk: end timed out poll request
Date:   Mon, 18 Apr 2022 14:11:36 +0200
Message-Id: <20220418121210.451529719@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 3e3876d322aef82416ecc496a4d4a587e0fdf7a3 ]

When poll request is timed out, it is removed from the poll list,
but not completed, so the request is leaked, and never get chance
to complete.

Fix the issue by ending it in timeout handler.

Fixes: 0a593fbbc245 ("null_blk: poll queue support")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20220413084836.1571995-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 13004beb48ca..233577b14141 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1606,7 +1606,7 @@ static enum blk_eh_timer_return null_timeout_rq(struct request *rq, bool res)
 	 * Only fake timeouts need to execute blk_mq_complete_request() here.
 	 */
 	cmd->error = BLK_STS_TIMEOUT;
-	if (cmd->fake_timeout)
+	if (cmd->fake_timeout || hctx->type == HCTX_TYPE_POLL)
 		blk_mq_complete_request(rq);
 	return BLK_EH_DONE;
 }
-- 
2.35.1




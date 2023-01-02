Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB79365B0AC
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbjABL1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235804AbjABL0t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:26:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE256423
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:25:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99667B80CA9
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CE9C433EF;
        Mon,  2 Jan 2023 11:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658724;
        bh=Wsc5TiXFv+6K2LLujXTsw0TuH3R2sxsc0KweF37smBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=195Hf+AUeEa3dtdjgSc2BT4JP9NFTxP4RC1NqgOEZwmrnAzBhtyl+XGCSSYt6jsiW
         wwljyJ+vxZ3r1ptVaCJwScij7NNUi/dqeyug9BVHmgvJHp1QwAeGp/h4s4xf7M3/zk
         3nue2nd0jhXS5MEfdJ6Jn9e3FbLGTyV5df6Bh/GY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yi Zhang <yi.zhang@redhat.com>,
        Yu Kuai <yukuai3@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 11/71] block, bfq: fix uaf for bfqq in bfq_exit_icq_bfqq
Date:   Mon,  2 Jan 2023 12:21:36 +0100
Message-Id: <20230102110551.940852386@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 246cf66e300b76099b5dbd3fdd39e9a5dbc53f02 ]

Commit 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'")
will access 'bic->bfqq' in bic_set_bfqq(), however, bfq_exit_icq_bfqq()
can free bfqq first, and then call bic_set_bfqq(), which will cause uaf.

Fix the problem by moving bfq_exit_bfqq() behind bic_set_bfqq().

Fixes: 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'")
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20221226030605.1437081-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 3e3bd1a46646..7b894df32e32 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5383,8 +5383,8 @@ static void bfq_exit_icq_bfqq(struct bfq_io_cq *bic, bool is_sync)
 		unsigned long flags;
 
 		spin_lock_irqsave(&bfqd->lock, flags);
-		bfq_exit_bfqq(bfqd, bfqq);
 		bic_set_bfqq(bic, NULL, is_sync);
+		bfq_exit_bfqq(bfqd, bfqq);
 		spin_unlock_irqrestore(&bfqd->lock, flags);
 	}
 }
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD856BB114
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbjCOMYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbjCOMYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:24:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37FC74A5D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:23:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D92FB81E08
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCF9C433D2;
        Wed, 15 Mar 2023 12:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882948;
        bh=4PQPPlT5tXd+qzAnGnFVVyBNzxdAoH2Tpguhmr4Eo/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gt2YJ7e8c1vG7YgQytlJIDF0XTlDYkh5IxKYd7u83pgWNn2O1JznWt6Wony7RdryM
         xs/cBPmcvJGaSECsw3xdVWByNSrH09B57VC7KkAxapKJeEuvLUqNoGcB3YlAHDm8iC
         7TUJbMr8uubDDo4hVqlA0sCbSl/e86LyO/bNihCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yi Zhang <yi.zhang@redhat.com>,
        Yu Kuai <yukuai3@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>,
        Khazhismel Kumykov <khazhy@google.com>
Subject: [PATCH 5.10 062/104] block, bfq: fix uaf for bfqq in bfq_exit_icq_bfqq
Date:   Wed, 15 Mar 2023 13:12:33 +0100
Message-Id: <20230315115734.552502207@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
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
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index afaededb3c49c..0a53b653a7e2e 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -4983,8 +4983,8 @@ static void bfq_exit_icq_bfqq(struct bfq_io_cq *bic, bool is_sync)
 		unsigned long flags;
 
 		spin_lock_irqsave(&bfqd->lock, flags);
-		bfq_exit_bfqq(bfqd, bfqq);
 		bic_set_bfqq(bic, NULL, is_sync);
+		bfq_exit_bfqq(bfqd, bfqq);
 		spin_unlock_irqrestore(&bfqd->lock, flags);
 	}
 }
-- 
2.39.2




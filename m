Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3855653ED5C
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiFFR5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 13:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiFFR5H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 13:57:07 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126CF3151ED;
        Mon,  6 Jun 2022 10:57:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id F260921B82;
        Mon,  6 Jun 2022 17:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654538220; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9dNUC5ElJIbZzeLi0chUE2OFIgsfH7PTiQ5PX1L/rm0=;
        b=mzb9pmVRJklNcSzjV2KezE9JC99jN6Rji69LmfS+hTA6skaXZvxK1M5j20BRbFV9zCarb+
        QMrr4U1DxZmIU0PjSJKKh7GSoVIZqPu3c2U5Oja27ibnQmrdoG4Hd0xhiLGVssaTfNfTiq
        wrUKpc/5+sVCXKl5UZXbR+yHHzUT4HQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654538220;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9dNUC5ElJIbZzeLi0chUE2OFIgsfH7PTiQ5PX1L/rm0=;
        b=v0RYa4Ep4J36sU2XL157c5DEDqSnQOMpRR1RpGbRW0BcAtEFP+RMqBfNgKSKijD5TuUMky
        TgaIYTF9//E9smCg==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id DEDB52C143;
        Mon,  6 Jun 2022 17:57:00 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 15C2BA0635; Mon,  6 Jun 2022 19:56:55 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     stable@vger.kernel.org
Cc:     <linux-block@vger.kernel.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        "yukuai (C)" <yukuai3@huawei.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] bfq: Drop pointless unlock-lock pair
Date:   Mon,  6 Jun 2022 19:56:37 +0200
Message-Id: <20220606175655.8993-2-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220606174118.10992-1-jack@suse.cz>
References: <20220606174118.10992-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1164; h=from:subject; bh=fazGyHZ8AizFT9D2tpzVsapOpu4GnWYR/+Eh7rri6nA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBinj/VYdWTQHDswBgNchjRCke1hpPpM9cmGOwxdQoo 9VHvj96JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYp4/1QAKCRCcnaoHP2RA2T0iCA CFRN0ozJFeULDoqCgXP9vq9WxFZz5f4zsDfbI8lNlAqgcXsE8ZU9KMTu10ZNqPbVcurP4hGI0VLU5P l+Q0a7HItNkcAvEo6THMM28yV+pVn29Dn3eGZkmup7ovpHXS+myS44+I8ObKXynhQRFqHZ4SJu4+Da R8mxUpDoxKWWRjfo6eUvoR1xJFT6xdENWI0BHx3CJdge0n9GO/3Y5Es0Ln7OFUMCTy4qgTy1Vova77 chH3VAiNvm/zft4R190AxVCkKQoOYHXy+J0R8Txh2vBSwsA5RrRn9iDK+hGBAXowMx7WP0E3tebgPC thnVsh3nL/VJNCm68Byvw8vzHV8bfR
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit fc84e1f941b91221092da5b3102ec82da24c5673 upstream.

In bfq_insert_request() we unlock bfqd->lock only to call
trace_block_rq_insert() and then lock bfqd->lock again. This is really
pointless since tracing is disabled if we really care about performance
and even if the tracepoint is enabled, it is a quick call.

CC: stable@vger.kernel.org
Tested-by: "yukuai (C)" <yukuai3@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220401102752.8599-5-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/bfq-iosched.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index e14f421282dd..bad088103279 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5537,11 +5537,8 @@ static void bfq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 		return;
 	}
 
-	spin_unlock_irq(&bfqd->lock);
-
 	blk_mq_sched_request_inserted(rq);
 
-	spin_lock_irq(&bfqd->lock);
 	bfqq = bfq_init_rq(rq);
 	if (!bfqq || at_head || blk_rq_is_passthrough(rq)) {
 		if (at_head)
-- 
2.35.3


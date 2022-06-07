Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987BD53F931
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239071AbiFGJPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238824AbiFGJPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:15:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB322A76CE;
        Tue,  7 Jun 2022 02:15:30 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 77B0D21B3B;
        Tue,  7 Jun 2022 09:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654593329; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aQ6DHrhNfnWMqAX40DTZmsd8AmWzistjpn0em+WHbF4=;
        b=WcuMQ+i4O2Gh3VjZHVaKuKZWvTGm2qQVDjjvyL4o+fQXxLBfIaeSl3fz25Hl9DGQ9Zmix8
        SzRVaFVnyJkPLZiD3lREX4NpSY6HDftGroV7nzGVVk6eBCInCUn2afTZ5sGlDyNzqhjKic
        h5CB/rWdF9xGUKImvLF+v9aWdTuxBzw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654593329;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aQ6DHrhNfnWMqAX40DTZmsd8AmWzistjpn0em+WHbF4=;
        b=do3oeOtRnOdWwTYbf+R5sWVOxJIioXIwM3XyULOf4zy4cTDURHdrKb8/C2fQl9OJvy7UMU
        kRmySdXaLd5JjeCA==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 6A6782C145;
        Tue,  7 Jun 2022 09:15:29 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 820DCA0635; Tue,  7 Jun 2022 11:15:28 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        <linux-block@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        "yukuai (C)" <yukuai3@huawei.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] bfq: Drop pointless unlock-lock pair
Date:   Tue,  7 Jun 2022 11:15:10 +0200
Message-Id: <20220607091528.11906-2-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220607091209.24033-1-jack@suse.cz>
References: <20220607091209.24033-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1164; h=from:subject; bh=yEPZSoF0vAo/Rn9LPqlXHYF8g51iNM6EYawHR/5TsB4=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBinxcdDLRv8ahNrlQQdvI9IybRw39NHlPKAAOnLh/l /usNk+eJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYp8XHQAKCRCcnaoHP2RA2TqMB/ 9cZBsag2W1EWLVU3R5SU4laRc8Hruwmy5axAIfwsvAhPxg7zUIxSBUTWwAeZFYbZYQm0d23m6vMKjw FV+CsmJDMMCGiydzvcR9/ObdgW1EmuDt4oyPiJs4USyQqNP2yub+2ZBqZBhcl3CXwC8bh4t+ih9pN1 nZHDuDiaU++RQbhXKW//pX8Bdls1pWU9u9IpywZCoyZWWqCrRMaJKNxHdYSRXcfteO7Mr8TyURWuHe YEFIKGz3H8bZROJIzSTjF6iWB7ccky1Glft6Bs5ATfztn3dnLb6c1woEKRHuV1li8iE1tickM4UMir u9oXPdjn2mXvvMLEFTHGCC/kq19H/i
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
index 29c15079c4d5..ed25bcd1e820 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5529,11 +5529,8 @@ static void bfq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
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


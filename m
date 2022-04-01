Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7724EEB43
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 12:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245713AbiDAK3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 06:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245615AbiDAK3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 06:29:47 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2167526E570;
        Fri,  1 Apr 2022 03:27:56 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A77A81FD04;
        Fri,  1 Apr 2022 10:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648808874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qOuiYb1lKXflzrbNlr4ffbWrXf/9yvnmykox32bxZwU=;
        b=ep7ydXvlBedTPae2aigPOIZ7tu2Ft92V7kSszeE6Kxtl+yWuLZSVcdDszCkTAvMu5JlWCa
        Wj8NlKMS2h879TYNNkKnocd8Lse+pWD5ZLNgO8Gbos44ihumvwoILbW512U8C07eVuBXSV
        iOqdujo0kQhDgY1q5iIJWhQYgfkvJqE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648808874;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qOuiYb1lKXflzrbNlr4ffbWrXf/9yvnmykox32bxZwU=;
        b=UEZuT2o0A5mvF2zOFujCYL+I5oC+cH9jRcbxP5+q1yYIFElLVzcglFU5KMQ1lwu4DWilIU
        BzOr99OONa3PkaDA==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 82246A3B92;
        Fri,  1 Apr 2022 10:27:54 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 8D79BA061B; Fri,  1 Apr 2022 12:27:52 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Paolo Valente <paolo.valente@linaro.org>
Cc:     <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 5/9] bfq: Drop pointless unlock-lock pair
Date:   Fri,  1 Apr 2022 12:27:46 +0200
Message-Id: <20220401102752.8599-5-jack@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401102325.17617-1-jack@suse.cz>
References: <20220401102325.17617-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=908; h=from:subject; bh=f6a//ztGhPlB2z2XpIrLMQ0/PyT+BqDb2fM6yWfWv9E=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBiRtOiyQ3U5Y+mlC8NHplioNGOhgYJ9xWmqnglRyDH +MzguKeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYkbTogAKCRCcnaoHP2RA2UdHCA CEUQLtCsQKDFr2Em7i2k2huuA1KKXygTe7pFnzk6qUmZy3lu0H5aQptIyMq3a5c4x8xSZexhnnT2Iw E+zDpozVXoi4z2YXee+zborRL9MCRRxx8wOnUI40Fhl+BJRKT6eURHiqc34h0MGnQ4NCVUUVo/4K7t Jmdq0VGTwqYM/9HkqYSNkZ4Jki3HXxj1mQt834quxDMdRKthlk6U4htltt1nm+b6tZ7hZPc0mRF7Ja sfTd20Hp21QKZny5HF4LXpG6+b9YWfvRlxaMRflyV8lmoD8l23pNX/jwR/i/FzfzTl3k+YY/XUjMMy oBG0VS9y5y4OEhDIaRFb0GwiKggNDb
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

In bfq_insert_request() we unlock bfqd->lock only to call
trace_block_rq_insert() and then lock bfqd->lock again. This is really
pointless since tracing is disabled if we really care about performance
and even if the tracepoint is enabled, it is a quick call.

CC: stable@vger.kernel.org
Tested-by: "yukuai (C)" <yukuai3@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/bfq-iosched.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 1fc4d4628fba..19082e14f3c1 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6150,11 +6150,8 @@ static void bfq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 		return;
 	}
 
-	spin_unlock_irq(&bfqd->lock);
-
 	trace_block_rq_insert(rq);
 
-	spin_lock_irq(&bfqd->lock);
 	bfqq = bfq_init_rq(rq);
 	if (!bfqq || at_head) {
 		if (at_head)
-- 
2.34.1


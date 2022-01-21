Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D667495E08
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 11:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380043AbiAUK60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 05:58:26 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:52624 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380042AbiAUK6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 05:58:18 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id AC93121910;
        Fri, 21 Jan 2022 10:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1642762696; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pS/tDT0OL3AJ1Hj7o6QL2j+6i7j/yu+TDoB+Spendow=;
        b=UK1RjAZYk+wKGSGTVZZ9hStjxZN/fPf6oIRA5BXT0xnLXQfxjRM3xJSoXYW2/N6vdNU0qk
        u8yypDWH89PtSCs+0t8108yBirIjo4h0mBVJ6XKYy6oKqS6HnAzrZ8EaFCEIE+xXqoPLHk
        7Tu9Ig3BVf6e5z23lGXH0uC/RMG4urM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1642762696;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pS/tDT0OL3AJ1Hj7o6QL2j+6i7j/yu+TDoB+Spendow=;
        b=dk448OV/xMtAveIva2yjwt6xdFKZpZe+MAz54ymYgqncaQ0LDauo/1xwfhGkd4VJnc/GGe
        tFlnRpruyhVehDAA==
Received: from quack3.suse.cz (unknown [10.100.200.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9DBE3A3B95;
        Fri, 21 Jan 2022 10:58:16 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 2CD70A05D0; Fri, 21 Jan 2022 11:58:16 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-block@vger.kernel.org>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 1/4] bfq: Avoid false marking of bic as stably merged
Date:   Fri, 21 Jan 2022 11:56:42 +0100
Message-Id: <20220121105816.27320-1-jack@suse.cz>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220121105503.14069-1-jack@suse.cz>
References: <20220121105503.14069-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1119; h=from:subject; bh=5U8ovRbTkvkFai3dDsau8hR63c7msoBSWRjO0JL3zkc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBh6pFpD9DXHDYFgwsklw51KXLtvtKGVx/PMj1feWCk x+0rFemJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYeqRaQAKCRCcnaoHP2RA2ZgLB/ 9mKgJ8jDv34aqnHab6wK4GsPb7xfVHabWWXjG22Wwwe6h35J98pR00B6t5p5dZT4Ul56tXk36ikF+5 oqXbV2y5KA8MC8dEG30F2joMFeKD+aWyz0t57OrwDCU/dmSNGIol6ruCfAQ7TqsIglLBpqIPmFWXDW j75tdwn3UDPGwLUg9Dc8VsueuYVz1AeNdeIqqVSjpo9m5NW2lISbZeQH3Fh/p1Sp409x4HTSXgTbHT fd2XE+3g4qOF4SDeRS5gqsbVMklUWnLqnlKtgWoWusG1yIoOTx9nOHJE24p0C0TR/r08WmXkIIMNjv oqNzfn+LqI+pmavyAh8Fr3ijm7PlnO
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

bfq_setup_cooperator() can mark bic as stably merged even though it
decides to not merge its bfqqs (when bfq_setup_merge() returns NULL).
Make sure to mark bic as stably merged only if we are really going to
merge bfqqs.

CC: stable@vger.kernel.org
Fixes: 430a67f9d616 ("block, bfq: merge bursts of newly-created queues")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/bfq-iosched.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index fec18118dc30..056399185c2f 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2762,9 +2762,12 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 				struct bfq_queue *new_bfqq =
 					bfq_setup_merge(bfqq, stable_merge_bfqq);
 
-				bic->stably_merged = true;
-				if (new_bfqq && new_bfqq->bic)
-					new_bfqq->bic->stably_merged = true;
+				if (new_bfqq) {
+					bic->stably_merged = true;
+					if (new_bfqq->bic)
+						new_bfqq->bic->stably_merged =
+									true;
+				}
 				return new_bfqq;
 			} else
 				return NULL;
-- 
2.31.1


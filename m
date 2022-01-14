Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFC848EEEA
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 18:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243672AbiANRC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 12:02:29 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:57152 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243690AbiANRC2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 12:02:28 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A08381F45E;
        Fri, 14 Jan 2022 17:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1642179747; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pS/tDT0OL3AJ1Hj7o6QL2j+6i7j/yu+TDoB+Spendow=;
        b=wfkLH8ER9uCSCLXefMTeakM3Dv2DjtVEQ2Ypj5jkz9MA+FPDKEKtqy1uoeC2FZPuwMHZ/m
        srF55g3lLvSbtfbDufudmRnZEFYo62KbySDmrVAMCyKOO524hnO20UnGQj3+jsqzjPCF2K
        2Jy86rsxvw2I3V4o8BX55w1XCb7pJBg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1642179747;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pS/tDT0OL3AJ1Hj7o6QL2j+6i7j/yu+TDoB+Spendow=;
        b=FvAxc+t89T6DXWuhj1w5Vi2wQlR8aj5EUOCaLTo/U8IqxNvzLT66v+sq7ffBmdMWSS+ppA
        K+SNql0oXfkLmXBA==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id B0E8DA3B89;
        Fri, 14 Jan 2022 17:02:26 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 58DCEA05B3; Fri, 14 Jan 2022 18:02:09 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-block@vger.kernel.org>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 1/4] bfq: Avoid false marking of bic as stably merged
Date:   Fri, 14 Jan 2022 18:01:53 +0100
Message-Id: <20220114170209.8606-1-jack@suse.cz>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220114164215.28972-1-jack@suse.cz>
References: <20220114164215.28972-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1119; h=from:subject; bh=5U8ovRbTkvkFai3dDsau8hR63c7msoBSWRjO0JL3zkc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBh4ayBD9DXHDYFgwsklw51KXLtvtKGVx/PMj1feWCk x+0rFemJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYeGsgQAKCRCcnaoHP2RA2f4QCA C05A512uxEqhtUjkzoG8YyhczL3rS079/gjQf587squagH/d/nYZXXm41Mb8O0vd2ESOBe/GE63vih Q+Q21oCDfPQi+4+v9cL5Mz9GxiMIgYFU2rjduIJMbcoEgRf4P/tU0WwQOCum1zkTMItCvHoF2WpbyG QiFh07CJCGfKZDRWVseNXWwkZXb+BPRu1yiv1QLu7qTR32tSEmOxVpdJs6QOFUD8Gj8dOEUUpoHXGY 04fiw4D1PhQHM5Ve76rGKP7CKKQTCQmjC2X3qdYTRKTT9C1ciYitYFd6+ao3GfOSd/55JWhgujrg8w w/bo6iuorneP7MMoMPxPer0/VrOQk8
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


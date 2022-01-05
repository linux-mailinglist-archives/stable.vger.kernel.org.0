Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879884866E6
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 16:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240619AbiAFPpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 10:45:46 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:50266 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240583AbiAFPpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 10:45:46 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4757E210EC;
        Thu,  6 Jan 2022 15:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1641483945; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6qjJiNK0cWTOqoFS+WWMjdK5b55EjHrufpsxkVrl5B4=;
        b=VyZBEExWWmXVlghNv1UqlKzJwbjd9Z3vOoe5FCX8Pd1wXS2XcmDTjyPCzW4rKJLkSjklT/
        19jZpwcuOauRMXTHv70bq4BOKMathz0GKml5JC6bz6i9Hkax/JCvQQWqYM0eB5Ze4QKRmM
        +kJHu3qXbwVgb9NWgRXcm6bg8oO3OX4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1641483945;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6qjJiNK0cWTOqoFS+WWMjdK5b55EjHrufpsxkVrl5B4=;
        b=DLLigEj3YRqwf1RZ13Xvh3cJBFgzuJHp1cPsG6H9K3TeDoGwtRlMBZAPspujbi9SMnlIzs
        saMaFWtThFLTbHAQ==
Received: from quack3.suse.cz (unknown [10.163.43.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 2A64AA3B85;
        Thu,  6 Jan 2022 15:45:44 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id D0A60A083C; Wed,  5 Jan 2022 15:36:39 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-block@vger.kernel.org>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 3/5] bfq: Simplify bfq_put_cooperator()
Date:   Wed,  5 Jan 2022 15:36:34 +0100
Message-Id: <20220105143639.31266-3-jack@suse.cz>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220105143037.20542-1-jack@suse.cz>
References: <20220105143037.20542-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1653; h=from:subject; bh=6QtknRLV0Xa9cvkfRyUEwR+73nSDXeh5oZVQ4gxDteg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBh1azyH+eh3DREjrGH+y2vmzAI/9yAj+JGWvNZoVum F8L48fmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYdWs8gAKCRCcnaoHP2RA2TrjCA CYs+fmxlJqHNeBgiojpbv9dTIi6JFthdRl1W4lTIWes4bEiphRBSK+DgrEmfcDgLuYvGUM+2RbVp90 wsrNekQCGREEbgzu4ZjgfKuGrywEyO1VsBaVkiEXEiGlL29CrbzKWzz7WNHUDjL9QTjp44MsraThrY yDHjnpVdEog5N9twJofXRCl+fBA21i8YgAsFpzsvm2kzMOFVVUggOX3RU3axy3rVraJ0fa1UMYwY/N peVPp+gdBhdWLfeaOurfziKO/Q3Zu35nfcbRXLJf+p/+FbruFieLBprVRNV9sk66u5rS5sNKb3N31d PZgk7hX0RtfydLvh+l/+CoGBAcc9Xw
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

All calls to bfq_setup_merge() are followed by bfq_merge_bfqqs() so
there should be no chance for chaining several queue merges. And if
chained queue merges were possible, then bfq_put_cooperator() would drop
cooperator references without clearing corresponding bfqq->new_bfqq
pointers causing possible use-after-free issues. Fix these problems by
making bfq_put_cooperator() drop only the immediate bfqq->new_bfqq
reference.

CC: stable@vger.kernel.org
Fixes: 36eca8948323 ("block, bfq: add Early Queue Merge (EQM)")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/bfq-iosched.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 0da47f2ca781..654191c6face 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5184,22 +5184,16 @@ static void bfq_put_stable_ref(struct bfq_queue *bfqq)
 	bfq_put_queue(bfqq);
 }
 
+
+/*
+ * If this queue was scheduled to merge with another queue, be
+ * sure to drop the reference taken on that queue.
+ */
 static void bfq_put_cooperator(struct bfq_queue *bfqq)
 {
-	struct bfq_queue *__bfqq, *next;
-
-	/*
-	 * If this queue was scheduled to merge with another queue, be
-	 * sure to drop the reference taken on that queue (and others in
-	 * the merge chain). See bfq_setup_merge and bfq_merge_bfqqs.
-	 */
-	__bfqq = bfqq->new_bfqq;
-	while (__bfqq) {
-		if (__bfqq == bfqq)
-			break;
-		next = __bfqq->new_bfqq;
-		bfq_put_queue(__bfqq);
-		__bfqq = next;
+	if (bfqq->new_bfqq) {
+		bfq_put_queue(bfqq->new_bfqq);
+		bfqq->new_bfqq = NULL;
 	}
 }
 
-- 
2.31.1


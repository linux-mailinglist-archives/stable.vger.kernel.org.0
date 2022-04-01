Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F92A4EEB39
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 12:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245702AbiDAK3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 06:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245580AbiDAK3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 06:29:45 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB7126E55E;
        Fri,  1 Apr 2022 03:27:55 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id CA5851FD01;
        Fri,  1 Apr 2022 10:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648808873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ve5MoBnU6j7qsA5vAC+9zKpXDeMocKoMXKYujoxLpg4=;
        b=v360xNS40sg9jA3maj5tikmtk3xjtfuP0oYU3VuaYFEhfEe2tiJG+QHF4vul4mqY2Vcqix
        4pi/Vf0fyY4PIgmQjoUjM+i6jgsYSCrZvYauFCsORmTr2lGltSzVTzpAEig7+KcV50+5px
        f0CrexRRJnZk5sDJw7BrzUwYPhosopc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648808873;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ve5MoBnU6j7qsA5vAC+9zKpXDeMocKoMXKYujoxLpg4=;
        b=OFru2bu2h5h2L9rBD8NBRaoEEorH5IEUWdu1zy6aCZG7jl6h4s8W48lTxIrRuAqGaOTlg5
        YDGEcNZfDBG2yUBg==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A73A1A3B8A;
        Fri,  1 Apr 2022 10:27:53 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 7552FA059B; Fri,  1 Apr 2022 12:27:52 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Paolo Valente <paolo.valente@linaro.org>
Cc:     <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 1/9] bfq: Avoid false marking of bic as stably merged
Date:   Fri,  1 Apr 2022 12:27:42 +0200
Message-Id: <20220401102752.8599-1-jack@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401102325.17617-1-jack@suse.cz>
References: <20220401102325.17617-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1165; h=from:subject; bh=frZzv2m+qEXWPCVllSYQTbrZO5Wf1OHveC5lfcQSEjY=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBiRtOe5tyP+Xu0lpBrb9Mxi9IKj7ipa0vOExN+jB1O XjGHoumJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYkbTngAKCRCcnaoHP2RA2UQJB/ 4hR6H8kAvK2hWfiweJi69jhHS60vlDa8BWTkn7apkjz2bv0jVSUrQu20U7pJ5pYN3nSgajZkYIko4M S0m2apQca4tynHOS1Kl2Bdh+vY5JrdBRVvIoGIB35R+ZvDxpdDhZ0IDNbtFDW43fkinE24Qgga+5cQ o6SBLn1My3JZ8D2gy1oPHbb0CYvDOfiHhlW1X4n7WmXSShHAYw94V6Qkyg/3GEnDjmqky/e4qfSQ7h 0WXVsIdmZRKg/LKhpILBCqOZpz3ZU1As/gKIQ8sG/4Zk1NFepf8p84NVHfeRC9ORO5Xm8ZJnHu/cIp 0T8p3bQ41L+MEr9xzi62ji4aWcP3TT
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

bfq_setup_cooperator() can mark bic as stably merged even though it
decides to not merge its bfqqs (when bfq_setup_merge() returns NULL).
Make sure to mark bic as stably merged only if we are really going to
merge bfqqs.

CC: stable@vger.kernel.org
Tested-by: "yukuai (C)" <yukuai3@huawei.com>
Fixes: 430a67f9d616 ("block, bfq: merge bursts of newly-created queues")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/bfq-iosched.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 2e0dd68a3cbe..6d122c28086e 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2895,9 +2895,12 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
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
2.34.1


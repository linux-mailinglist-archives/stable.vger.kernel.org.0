Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E644866FF
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 16:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240723AbiAFPqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 10:46:04 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:50290 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240596AbiAFPpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 10:45:46 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A70272113A;
        Thu,  6 Jan 2022 15:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1641483945; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pS/tDT0OL3AJ1Hj7o6QL2j+6i7j/yu+TDoB+Spendow=;
        b=ai6Mk7JwRL7ho88WGbBwr1HsZJ/48+CvQUy8fwM/6G3hwzzKGjV67/UErAES8OpQyZmj+o
        aISzg6eP+cdoNgvonsImGM9c37WvsKZ3GTzFj1q1FhCbt7+1CdlREOxFZRIZIkQyfeKX7z
        63qUIGYyMDLJcnnVXCvqkm8J/uv21pU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1641483945;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pS/tDT0OL3AJ1Hj7o6QL2j+6i7j/yu+TDoB+Spendow=;
        b=304cqqKhQAjXqqqqsVSqLgTUJL0MYtGjAe9z5EPAAXWJ8+vNrdwzq2r04ayNUqach9Lm4d
        QkGqLBWJG/vTdlAg==
Received: from quack3.suse.cz (unknown [10.163.43.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 93D05A3B87;
        Thu,  6 Jan 2022 15:45:45 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id C6E80A07E1; Wed,  5 Jan 2022 15:36:39 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-block@vger.kernel.org>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 1/5] bfq: Avoid false marking of bic as stably merged
Date:   Wed,  5 Jan 2022 15:36:32 +0100
Message-Id: <20220105143639.31266-1-jack@suse.cz>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220105143037.20542-1-jack@suse.cz>
References: <20220105143037.20542-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1119; h=from:subject; bh=5U8ovRbTkvkFai3dDsau8hR63c7msoBSWRjO0JL3zkc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBh1azwD9DXHDYFgwsklw51KXLtvtKGVx/PMj1feWCk x+0rFemJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYdWs8AAKCRCcnaoHP2RA2VKTB/ 94dBTvwc+jnpzmyTh6pPFiOWodsqz0zcdocFPrZAvwjefVjK4nJEvP1tvHIoMfndNKEXvloXeXc493 6Nh24lxZzeQVHecyLHoOvY0gE2cWsWcHCIAulLtFL0Qy07x5bhdi8xQi13aRdHMSMhanO8SpEuRpus NyzdcxTxzwP43s+57SyYOP4jfjZUoewz8rb5SQODPQN2DXelGnk8bMDWvllJqY+vAbLVpcXyyNKFxb qY+10BRLmgh3H0a7sGmiGCzWCLovlfSc4gts67mLRTiH5jGef12VN5hTQpbklw5KIp5FxhAbEdPS+d Pa1DO4QTlZNtTM4xe4IndlUUjce7fH
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


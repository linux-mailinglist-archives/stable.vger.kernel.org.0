Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044A247E713
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 18:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236622AbhLWRcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 12:32:41 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:54106 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244497AbhLWRcM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 12:32:12 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 621D4212C9;
        Thu, 23 Dec 2021 17:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1640280730; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QikYsI6tpiNvzhNII6O3hXNc22etDJ2ItyVUZR1gNys=;
        b=VT2ad/UjT099XlZF7zdYcybzukePJyF82QKcc2G292wOf+R8GkLm4htdTE6sRL0upXCBCm
        z64v4apnvlva9MRKU2Mv4eF0yQRb2ewfYn/6uvdNQvmeBS4VzHvRHhrOWT8GwdtDBnq3x8
        I9OtatcBLWPpXzQn7if3G1lS1xt5JSw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1640280730;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QikYsI6tpiNvzhNII6O3hXNc22etDJ2ItyVUZR1gNys=;
        b=P5Sdi6RAEvl7zB9dQ6P6rQnPW3dtULdbTKLRqXcYsAA8gQYfDfaUfYEAkKCO3o77EOr/Fx
        it9cKo3fvTr1mLAg==
Received: from quack2.suse.cz (unknown [10.163.28.18])
        by relay2.suse.de (Postfix) with ESMTP id 518F5A3B8A;
        Thu, 23 Dec 2021 17:32:10 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 1D0071E0BCE; Thu, 23 Dec 2021 18:32:07 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-block@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 1/3] bfq: Avoid false marking of bic as stably merged
Date:   Thu, 23 Dec 2021 18:31:57 +0100
Message-Id: <20211223173207.15388-1-jack@suse.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211223171425.3551-1-jack@suse.cz>
References: <20211223171425.3551-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1119; h=from:subject; bh=s24YJhUV9PaVoF9XPonZ2DcL0PhzkDxy7int8Fo9bZ4=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBhxLKMrd3RDSYuLwevckUk1a2v9JbPj8JDz8xuizgR myDeYaeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYcSyjAAKCRCcnaoHP2RA2Q45CA CnCKu3QEkRrX4zqwVBpVO7DE+XOqRv8ux5g3cLi2FRf5Heb6XRxdXjQpe0D1NQdgqCsb70rLiFJrgT HW38RIcUAo5A6qQJooZQbA7EconXhpCCXyYg+c+4UCp+7LlyRn739HHvkY0iP5gP5F2UIBd9B9s2tl L1GPEgz0ALzcP6rsW6Na4kVt4nqkDIFkmji2ZzWnYgnx3XSRRY/71N+KU/VA838Rl1CFcDBLvzkEUr Bb0b+0+j+TyF34e99qmnt/wTHs2xtaoI6jEDC+uWmhc5sfExmDvMtspVmGhjzsVbS0LXQXqO6TcyUg 23FwtDPWVl1b/F+gamoN2lcfPyZm11
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
2.26.2


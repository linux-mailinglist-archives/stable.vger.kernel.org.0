Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA2916B84C7
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 23:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjCMWaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 18:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjCMWaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 18:30:01 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9016A2D1
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 15:30:00 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so3126566pjt.2
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 15:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678746599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XPLn+orVfSK+z4tupCE3vvaGTo6pOxRCWsTN9XiJPXw=;
        b=jwVQFnAZvTbL1m3KsEL+nj7y4CkOYqkthOJJZum4ez+s9ehzdY/jhGB0JirvrTvSCM
         7SR9W1NWfEuWwA6QbUBpgU0GPxwrjZmm2fE5jYhi23JHRYR5Q3ZCDyPrpG03hgw3sark
         ZA4S2l4uR/NYjZU1VXsKl+FSisRWndkN9o27U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678746599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XPLn+orVfSK+z4tupCE3vvaGTo6pOxRCWsTN9XiJPXw=;
        b=pYtEDYYtaf4xe8PXLNrALRZ9mTiYiC2N8aaMma1muepOor5pSBKI0LmE1HVKJvz9uD
         DIHgKBY3AJczulKk2SuUrHR6DrLt3AEiDmr6giwEcrua4R9XxxOmytTiDcTHHH0iJX/e
         OL1zLc/eg4xhjo8ldb5JhtrXBq94jhk3g0F0Z1uAsyIY8scxWs8vDfF2gnr0FB74UPt6
         67MvEQLqm7W5BmVJiYg6wjVMg0I3dOlUBZKnjXFs9kI9u+0tURAyD1kb0L/d8HVNsglK
         eOLfkYH5Tdj12TWcbCUo/FFG6ORD3b21Cla4oIhjDNvliBycDc46RKuFqk6gsR6uCBk/
         qy/g==
X-Gm-Message-State: AO0yUKVdrMhvf1RUdfEZ/fc5dhuodCgbhVS33XNMtSN/ybtRHbvUvkOa
        0y9CYWH2SDuyxA8NejRF04cq0kGJnWDqOMSYZ5SvlQ==
X-Google-Smtp-Source: AK7set+bwCXPeXXJYiHoIs21LWog9BcgfWy0JQjslrBQOlmossB4jqnklmjuEP81ZHtlr8WCPOmtjQ==
X-Received: by 2002:a17:903:446:b0:1a0:48ff:53a0 with SMTP id iw6-20020a170903044600b001a048ff53a0mr3867362plb.35.1678746599155;
        Mon, 13 Mar 2023 15:29:59 -0700 (PDT)
Received: from khazhy-linux.svl.corp.google.com ([2620:15c:2d4:203:157:b07d:930a:fb24])
        by smtp.gmail.com with ESMTPSA id km8-20020a17090327c800b0019aa8149cb9sm352440plb.79.2023.03.13.15.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 15:29:58 -0700 (PDT)
From:   Khazhismel Kumykov <khazhy@chromium.org>
X-Google-Original-From: Khazhismel Kumykov <khazhy@google.com>
To:     stable@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>,
        Khazhismel Kumykov <khazhy@google.com>
Subject: [PATCH v5.10 5/5] block, bfq: fix uaf for bfqq in bic_set_bfqq()
Date:   Mon, 13 Mar 2023 15:27:57 -0700
Message-Id: <20230313222757.1103179-6-khazhy@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230313222757.1103179-1-khazhy@google.com>
References: <20230313222757.1103179-1-khazhy@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit b600de2d7d3a16f9007fad1bdae82a3951a26af2 ]

After commit 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'"),
bic->bfqq will be accessed in bic_set_bfqq(), however, in some context
bic->bfqq will be freed, and bic_set_bfqq() is called with the freed
bic->bfqq.

Fix the problem by always freeing bfqq after bic_set_bfqq().

Fixes: 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'")
Reported-and-tested-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230130014136.591038-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
---
 block/bfq-cgroup.c  | 2 +-
 block/bfq-iosched.c | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 2f440b79183d..1f9ccc661d57 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -748,8 +748,8 @@ static void *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
 				 * request from the old cgroup.
 				 */
 				bfq_put_cooperator(sync_bfqq);
-				bfq_release_process_ref(bfqd, sync_bfqq);
 				bic_set_bfqq(bic, NULL, true);
+				bfq_release_process_ref(bfqd, sync_bfqq);
 			}
 		}
 	}
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 016d7f32af9f..6687b805bab3 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5070,9 +5070,11 @@ static void bfq_check_ioprio_change(struct bfq_io_cq *bic, struct bio *bio)
 
 	bfqq = bic_to_bfqq(bic, false);
 	if (bfqq) {
-		bfq_release_process_ref(bfqd, bfqq);
+		struct bfq_queue *old_bfqq = bfqq;
+
 		bfqq = bfq_get_queue(bfqd, bio, false, bic);
 		bic_set_bfqq(bic, bfqq, false);
+		bfq_release_process_ref(bfqd, old_bfqq);
 	}
 
 	bfqq = bic_to_bfqq(bic, true);
-- 
2.40.0.rc1.284.g88254d51c5-goog


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B34C6B84C4
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 23:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjCMWaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 18:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjCMWaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 18:30:00 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FA069238
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 15:29:58 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id cn6so909023pjb.2
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 15:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678746598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FXqMwWwZuspLZLvoXRZdl9+91DL98FHBt3BrpUMzrfc=;
        b=KnNT2FCspPV/5hiSse0cmreKXdTEhVxglNy0zyCJL8zolYeTFHlnZSoR3lwlSdUaHp
         S980fGvhkM/Xk7Ifiu+tfpbC8ynqXoOkEgS3kscUz1NPY6V5hOC2cOXM7Zyq3dAMwl2G
         IVgJYY4MbvSKvXR8NNhMQ/WmbNM67wpOi8oF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678746598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FXqMwWwZuspLZLvoXRZdl9+91DL98FHBt3BrpUMzrfc=;
        b=r8IfUccZqu/luM6+1yCtCBF0i4pomLuf3rCrbGVZ9/KXoyIEkJFg9/kbAjGbdagDfZ
         qM6RTcGcgTbTJQu/1PXKnftlrhB6C1oCd9THaXPlljOxPcLWhNn4AoZSkHGen+My+tTI
         5BLptauYYw65ooxYZD2SHvJU0BQNGlFdvl2xiXRACK+zvgjRjQOuhZmiCFQdCp1BZGdP
         m4jGB/UW/UjGzArwuSVjnREiA/BkAbul90mhqLnhRY6NoxbpR/9OCD75Gs2zAR+vVBcu
         J17ncz/FX14zJT0U0HZ+Rkayb2viN9AujSge2KRNQexKpUuIZNr9k7O6KOoUgokw9vxR
         +kIQ==
X-Gm-Message-State: AO0yUKUe34vCIIULR0tu7xwEr4N465Zq+y4H6wLmg0Dr4o7TiSpoRx6e
        OmcZS4qTOJOY4DrAK+zaCzBBfX8BYD+Xf0iP+gA=
X-Google-Smtp-Source: AK7set/znSADW30jufifevptgSTUlyVkYs+FwxwM/lLCmRtZrch2HNLXkgzES3kQLOqupqdTpAjLmA==
X-Received: by 2002:a17:902:eccd:b0:19c:f232:21ca with SMTP id a13-20020a170902eccd00b0019cf23221camr45821624plh.3.1678746597972;
        Mon, 13 Mar 2023 15:29:57 -0700 (PDT)
Received: from khazhy-linux.svl.corp.google.com ([2620:15c:2d4:203:157:b07d:930a:fb24])
        by smtp.gmail.com with ESMTPSA id km8-20020a17090327c800b0019aa8149cb9sm352440plb.79.2023.03.13.15.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 15:29:57 -0700 (PDT)
From:   Khazhismel Kumykov <khazhy@chromium.org>
X-Google-Original-From: Khazhismel Kumykov <khazhy@google.com>
To:     stable@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>,
        Khazhismel Kumykov <khazhy@google.com>
Subject: [PATCH v5.10 4/5] block, bfq: replace 0/1 with false/true in bic apis
Date:   Mon, 13 Mar 2023 15:27:56 -0700
Message-Id: <20230313222757.1103179-5-khazhy@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230313222757.1103179-1-khazhy@google.com>
References: <20230313222757.1103179-1-khazhy@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 337366e02b370d2800110fbc99940f6ddddcbdfa ]

Just to make the code a litter cleaner, there are no functional changes.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221214033155.3455754-3-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: b600de2d7d3a ("block, bfq: fix uaf for bfqq in bic_set_bfqq()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
---
 block/bfq-cgroup.c  | 8 ++++----
 block/bfq-iosched.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index badb90352bf3..2f440b79183d 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -705,15 +705,15 @@ static void *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
 				     struct bfq_io_cq *bic,
 				     struct bfq_group *bfqg)
 {
-	struct bfq_queue *async_bfqq = bic_to_bfqq(bic, 0);
-	struct bfq_queue *sync_bfqq = bic_to_bfqq(bic, 1);
+	struct bfq_queue *async_bfqq = bic_to_bfqq(bic, false);
+	struct bfq_queue *sync_bfqq = bic_to_bfqq(bic, true);
 	struct bfq_entity *entity;
 
 	if (async_bfqq) {
 		entity = &async_bfqq->entity;
 
 		if (entity->sched_data != &bfqg->sched_data) {
-			bic_set_bfqq(bic, NULL, 0);
+			bic_set_bfqq(bic, NULL, false);
 			bfq_release_process_ref(bfqd, async_bfqq);
 		}
 	}
@@ -749,7 +749,7 @@ static void *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
 				 */
 				bfq_put_cooperator(sync_bfqq);
 				bfq_release_process_ref(bfqd, sync_bfqq);
-				bic_set_bfqq(bic, NULL, 1);
+				bic_set_bfqq(bic, NULL, true);
 			}
 		}
 	}
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 35b240cba092..016d7f32af9f 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2816,7 +2816,7 @@ bfq_merge_bfqqs(struct bfq_data *bfqd, struct bfq_io_cq *bic,
 	/*
 	 * Merge queues (that is, let bic redirect its requests to new_bfqq)
 	 */
-	bic_set_bfqq(bic, new_bfqq, 1);
+	bic_set_bfqq(bic, new_bfqq, true);
 	bfq_mark_bfqq_coop(new_bfqq);
 	/*
 	 * new_bfqq now belongs to at least two bics (it is a shared queue):
@@ -6014,7 +6014,7 @@ bfq_split_bfqq(struct bfq_io_cq *bic, struct bfq_queue *bfqq)
 		return bfqq;
 	}
 
-	bic_set_bfqq(bic, NULL, 1);
+	bic_set_bfqq(bic, NULL, true);
 
 	bfq_put_cooperator(bfqq);
 
-- 
2.40.0.rc1.284.g88254d51c5-goog


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8AC96B84C0
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 23:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjCMW37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 18:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjCMW36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 18:29:58 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAF46BDF7
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 15:29:55 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso30345pjc.1
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 15:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678746595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=46km6/xQDE/lr25tFcuq2eYU9Y42SqtxUbI2RZS41Fg=;
        b=T8Ne8ugWDZF9tpmQV+0C+EFGYNh2NwYqrv6iybU5bymFLC7HrIkw5Jf5Mxm32WhPFz
         GY+ZIOvtkJdE2smmo80YiChjxTyJVvDTynNFrPjHlmCf3QUj6JccoX73tuPVORzHcu9l
         4gTVTSxI3Fyq6zQEr6i5RWl/WCC91KDf1Np3c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678746595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=46km6/xQDE/lr25tFcuq2eYU9Y42SqtxUbI2RZS41Fg=;
        b=hKYCH8cYpbR1tKoGW+0mLj1p2P6PQir/Oz2MkCxWPqzX9BwNyxxXCtXIJ1QItm8oDZ
         EG98Ec27NN+vhpWntZ/o5in/ISRp5OmFe8uAN2/UB007AalzFl7YQn0TQhOni/CZA9iG
         aOzdTlahdil8gN5fB5xcSFcA16G3P0XPBuiF5bQn9URGCAciz4VoZzJZ8YnEvPhcyxfo
         9n4K0g7T2pdJq9DS1KVkGh9SdgUY9K/rftF3du3UPKtuPS+imPrS/RCzd+0DKiowCz/b
         YgOCnuzRn5xr9TbiWOLGBzwBr6DuWT0iH/A+3hRqR7Nn7GAyFxOHsSm1aW3NTAsUaKJ4
         qidA==
X-Gm-Message-State: AO0yUKURBz6INTEgUciMKzQeCYQbW4h7xs547HCtibfvqJwjmSRxq0rm
        Nq5VP7lh+qVWBCygGKuuwOSMzprWn25eSKFrP80=
X-Google-Smtp-Source: AK7set+JOvgWc7s+kU5s9wzz2uKUB9/K1uceOE3LlxdRZ0kl63wBGGkDy3C9BjcjxjcoX0RBAm7isg==
X-Received: by 2002:a17:90a:c7c3:b0:23b:4bf6:bbee with SMTP id gf3-20020a17090ac7c300b0023b4bf6bbeemr8127165pjb.21.1678746595006;
        Mon, 13 Mar 2023 15:29:55 -0700 (PDT)
Received: from khazhy-linux.svl.corp.google.com ([2620:15c:2d4:203:157:b07d:930a:fb24])
        by smtp.gmail.com with ESMTPSA id km8-20020a17090327c800b0019aa8149cb9sm352440plb.79.2023.03.13.15.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 15:29:54 -0700 (PDT)
From:   Khazhismel Kumykov <khazhy@chromium.org>
X-Google-Original-From: Khazhismel Kumykov <khazhy@google.com>
To:     stable@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Yi Zhang <yi.zhang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>,
        Khazhismel Kumykov <khazhy@google.com>
Subject: [PATCH v5.10 2/5] block, bfq: fix uaf for bfqq in bfq_exit_icq_bfqq
Date:   Mon, 13 Mar 2023 15:27:54 -0700
Message-Id: <20230313222757.1103179-3-khazhy@google.com>
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

[ Upstream commit 246cf66e300b76099b5dbd3fdd39e9a5dbc53f02 ]

Commit 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'")
will access 'bic->bfqq' in bic_set_bfqq(), however, bfq_exit_icq_bfqq()
can free bfqq first, and then call bic_set_bfqq(), which will cause uaf.

Fix the problem by moving bfq_exit_bfqq() behind bic_set_bfqq().

Fixes: 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'")
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20221226030605.1437081-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
---
 block/bfq-iosched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index afaededb3c49..0a53b653a7e2 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -4983,8 +4983,8 @@ static void bfq_exit_icq_bfqq(struct bfq_io_cq *bic, bool is_sync)
 		unsigned long flags;
 
 		spin_lock_irqsave(&bfqd->lock, flags);
-		bfq_exit_bfqq(bfqd, bfqq);
 		bic_set_bfqq(bic, NULL, is_sync);
+		bfq_exit_bfqq(bfqd, bfqq);
 		spin_unlock_irqrestore(&bfqd->lock, flags);
 	}
 }
-- 
2.40.0.rc1.284.g88254d51c5-goog


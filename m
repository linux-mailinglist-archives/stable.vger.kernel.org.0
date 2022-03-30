Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A607D4EC59E
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 15:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346031AbiC3Naa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 09:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbiC3Na2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 09:30:28 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17991E03C
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 06:28:43 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id n63-20020a1c2742000000b0038d0c31db6eso3478662wmn.1
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 06:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GHIn8jF7kijlzKUsCmJnklrA/35duIdzd25rQBgUIto=;
        b=zBqmE+tssvyXMWSaWWFA5b3hgsuLoHxgjptPS2wa21s3JnYpnAeHsoAsVAuQAQg8la
         DRihke0OX1KqyUvS9rLerwqWQdyfhd2+7aQtjdLWlzEb1vqAdlzn27Uz0odDEEosdYW7
         IYPx/7buHNgAzeenxQWnzVlKuxmT9dOhJ5+MGSOhkJKAM12fUMESm6wLMCGTDWBWfWBy
         23WQCUE2GVRt2ElfINOnDQGJhYrqsn07XBfrsRrVHwaj2Te2TTzRGZZudO+QyMSRAyG0
         Ja0wzwoBAqDadaNAN7siUsG1dFIdEtSnkHLTWVYBRjeDgOk67AGniwagepJ8//8f12ej
         UZZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GHIn8jF7kijlzKUsCmJnklrA/35duIdzd25rQBgUIto=;
        b=5BhdJ9n51TwgUaXp4ee5bNT0OgfQev/n48WMcVWuzZc7274idz4I5maDy6J2jLBIF+
         o7zaN1d8f4glFh1NwkbI960LXD2+sUti3eX4cV0n+ZYMcKY7/CVZ7XKyHmaajCI1V6xw
         lh7iFM8DnC6WQKk3xaLSAAmCsfs/F0U/v3imR9pkqqoc7wHdQG7m+RFD0vzIOsk3s2cu
         6p5l6Pn8cS6+tChhOpGPZRdTj1eRE3QyZZWRzI1mEfj3LMvyy/60IvrWJumylrwMXPQC
         uCAhdr27GhMvBG63w+mGCQ1QClh0aSDP9JLVKRsjUpx5tfRYKaqySb5px46Ed1sSaSg6
         bWrQ==
X-Gm-Message-State: AOAM530WSP7QXO4cd7d1H1C9TzXetNaL5iAvr71GmxVf9tYZJ3Aka/LF
        Q1T+NzL1DlrdrZOZdvBy6UDRCQ==
X-Google-Smtp-Source: ABdhPJw9IvJl63SBstCduN2OP7OJcuD3hKsPyvIR6lBEQN9W0ZQd+Js37bwtDptS5ptr9smNiHupwA==
X-Received: by 2002:a05:600c:5024:b0:38c:a426:8ea6 with SMTP id n36-20020a05600c502400b0038ca4268ea6mr4427138wmr.193.1648646921590;
        Wed, 30 Mar 2022 06:28:41 -0700 (PDT)
Received: from joneslee-l.cable.virginm.net (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id n10-20020a5d588a000000b002052e4aaf89sm17682274wrf.80.2022.03.30.06.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 06:28:41 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 4.19 1/2] block: Add a helper to validate the block size
Date:   Wed, 30 Mar 2022 14:28:36 +0100
Message-Id: <20220330132837.1002748-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit 570b1cac477643cbf01a45fa5d018430a1fddbce ]

There are some duplicated codes to validate the block
size in block drivers. This limitation actually comes
from block layer, so this patch tries to add a new block
layer helper for that.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Link: https://lore.kernel.org/r/20211026144015.188-2-xieyongji@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/blkdev.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 209ba8e7bd317..56fe682d9beb4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -56,6 +56,14 @@ struct blk_stat_callback;
  */
 #define BLKCG_MAX_POLS		5
 
+static inline int blk_validate_block_size(unsigned int bsize)
+{
+	if (bsize < 512 || bsize > PAGE_SIZE || !is_power_of_2(bsize))
+		return -EINVAL;
+
+	return 0;
+}
+
 typedef void (rq_end_io_fn)(struct request *, blk_status_t);
 
 #define BLK_RL_SYNCFULL		(1U << 0)
-- 
2.35.1.1021.g381101b075-goog


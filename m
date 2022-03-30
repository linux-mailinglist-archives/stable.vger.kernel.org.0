Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB26D4EBF6E
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245705AbiC3LDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245713AbiC3LDC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:03:02 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCCFDF70
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 04:01:16 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id v64-20020a1cac43000000b0038cfd1b3a6dso968425wme.5
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 04:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ooOYm/lxfXHFr95vspk2EkrmG+u1vi1Ig36ixjr1fH4=;
        b=w/vNSRhjNZX0jVpYDSS9h1Isv5ypDR2LR9ypZGowe/u94ihCHOi7oSbLe+Ji7sqFqg
         S8q1bBZWXHxkGUgKeskjvC9k2nlZo1OZLcNpWWVSotjbNHWB5Ew+mSTStLeaFDTN03f2
         66Ub5RgVN1UynwaPWrv5YLKDQLUXHhMeLf+y1NCBe6+//M0cXBQeqY7uj2FF9gRDKUgY
         i1s5Uo9kMqgzcO0t3zY5n6a/9RdNGzXPEBM/3CfRIfZ+igen8GHFIOwfSUoy5gdyLL/9
         /VioS1cWqNylUIm3OccnEV6mDS3O2eULRtiFnENau5uUxeo4abc4CVtfAw6X4C35wGvR
         oLCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ooOYm/lxfXHFr95vspk2EkrmG+u1vi1Ig36ixjr1fH4=;
        b=ZqAz3HG9Q/mwsbvZ9AQt+igzA/LHPKv4POTw44kKFPkqL5Skqg6KTFxCAK9DNHF2A7
         q9SsA2Z4es4WX2gT66RDuaX6qjEdY24ynzUGmilw0s+kjpSLGSs5GMCVGdK5l2QhSg98
         +BvZwkeg+02tyxy5gY18nLrgdK1BHI9ky5tTm0fCYsXdQwCvDFAh6m4NqKSuob60k20Q
         2UoCAcX4EBQDpjvZAH4JzEEXyQ95VJHlH4HvFsRvO6o5P6Kfw3uVd4WQlj2r5Jq7oKTj
         xqkRrvmGUGF3vqbR/oJ4OLE9LktOis4AhtzVHR/GozQyzjFqN5aUYk1cegme7NlVTJh2
         PSZw==
X-Gm-Message-State: AOAM532ZYNZ9aIyyhTHoRBkWwWEQlPtjs6EvVWzFHatx8Lo4jFiHRfyb
        a1NLDJhCz4qclh7W9rGlJqgEkg==
X-Google-Smtp-Source: ABdhPJxFSEmr7/qL6fwKYsyhKnGkoqZO82YOeTfyZ+NSjHAX19hbnp4k39KLq9wajE0TJ0FFExMwtA==
X-Received: by 2002:a05:600c:4ed2:b0:38c:93ad:4825 with SMTP id g18-20020a05600c4ed200b0038c93ad4825mr3817231wmq.181.1648638075494;
        Wed, 30 Mar 2022 04:01:15 -0700 (PDT)
Received: from joneslee-l.cable.virginm.net (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id c5-20020a5d63c5000000b002040822b680sm24739765wrw.81.2022.03.30.04.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 04:01:15 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] block: Add a helper to validate the block size
Date:   Wed, 30 Mar 2022 12:01:06 +0100
Message-Id: <20220330110107.465728-1-lee.jones@linaro.org>
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
index d5338b9ee5502..8cc766743270f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -59,6 +59,14 @@ struct blk_stat_callback;
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
 
 /*
-- 
2.35.1.1021.g381101b075-goog


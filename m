Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEAD4EC659
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 16:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346583AbiC3OVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 10:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241080AbiC3OVg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 10:21:36 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094C18FE44
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 07:19:51 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id w21so24963177wra.2
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 07:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uVvGxdvMBPSTq/WyJlIGu/36n1UoWKFxo4FrQyNtSrA=;
        b=DP+2MVi56j8SmXve2lqxhIJVbLUkwfmmEs4RseCvCCpdXDTO0vYDWvkxYL0yKxXJLQ
         z5yTVX8EpTR+C6l6UjVDNrHpMs5eKJWfojpr06NKRDnSsAdX0Wm0rWSeW28hqCv0K4+2
         rvH5/1pKpPFGLbBFhKKqsdpfP64Cxk33G5USHWo4t84Qh8y/Mw+m12hQZ/5vFraE/uZG
         BKuO2apCLWkavWUHIxvfuwqGXyIGsiXKz1zqq0PRIwGk1RvhCfniJlDHw/n4XGfzZd/Q
         guW5u0ml1Xt+Cl0KYlkFrkbdCSygu6V6QJjCUDVeKX1k1UwcSe1Y/EUcxBKFMLoDSz+9
         8zkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uVvGxdvMBPSTq/WyJlIGu/36n1UoWKFxo4FrQyNtSrA=;
        b=4RMFox96dyVaIVL4nz8XfqzeFFE2DVRjJjWvuYVGfqYg06lx6vHPQvL0c0LCXS88hE
         b4+/D50O9My05cNzsnn29b5JKnVroFklidOuhkG36jwPFMglqTl3UmjclW5LmyJ31cCL
         7el2tmDqc7QAfSVsgcXs+YmsNpCcQ7GS40HPlU4Ixrq2JNR5GdMEmSPxfsGzUSIR+RWU
         Y8GOc8TENkwy5y7UyOovcDtgph35uDS1kyaAORIMIQZLZnJcqmKmpAoQfYIE/vqxCYqY
         gpuUVvvFGtAseRPU08ZVIBzvU8YbIxvfAOKh5wzAwxtDH/JUtZ2crI2HpusI8uwxe2LY
         jBzA==
X-Gm-Message-State: AOAM531Xvw1XV4JS0R67ZqPqc2y2OmuTx3xHRTf+kxDnQWBAkDeRXBQv
        nThY3D05dRYoejtWXjEuL/JLhg==
X-Google-Smtp-Source: ABdhPJyzZwBy7/qQtIZiFw4ZXGFuzSGgeWiz3tm62idqW5SJ3vnx5z6gW1VyN6Geee9ewe6elO7BCw==
X-Received: by 2002:a05:6000:1a85:b0:205:a234:d0a5 with SMTP id f5-20020a0560001a8500b00205a234d0a5mr31820784wry.126.1648649989595;
        Wed, 30 Mar 2022 07:19:49 -0700 (PDT)
Received: from joneslee-l.cable.virginm.net (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id y13-20020adffa4d000000b00203e3ca2701sm24027645wrr.45.2022.03.30.07.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 07:19:49 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 4.14 1/2] block: Add a helper to validate the block size
Date:   Wed, 30 Mar 2022 15:19:43 +0100
Message-Id: <20220330141944.1172191-1-lee.jones@linaro.org>
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
index 1c3d774d3c839..afbe2fcc476ac 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -56,6 +56,14 @@ struct blk_stat_callback;
  */
 #define BLKCG_MAX_POLS		3
 
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


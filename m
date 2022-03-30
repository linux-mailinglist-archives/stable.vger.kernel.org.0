Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C084EC543
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 15:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241260AbiC3NLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 09:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345744AbiC3NLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 09:11:34 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68E9205BEC
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 06:09:47 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id r7so12205803wmq.2
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 06:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ooOYm/lxfXHFr95vspk2EkrmG+u1vi1Ig36ixjr1fH4=;
        b=OrqJj1SgjHhKkYGq5PfQmncYG7Wxlto4NJm3OKVFBPC+sggEoYjdDHGtYsmCewq8Qz
         h08tDPrJ+MRSspL8psMtnfoCk7ZXVusgRilCkktTzcH83bhtqQ01zq6mgm/0xipMt3k0
         SIOP+0imT5lJQeCc6ZKWiwK60Ywv3jK/5K/kzT9WNcgq8G/4FQPyw3Y0HI8ePZ+Wk+pJ
         /u1P0ZvupwjvUc0j6QnJ5VHqOg/DWxrAR8+NVT+gsAYKcJrnYilIIu+qQq5lwz0+v//j
         7kl1kanWZRtaEDmaGTPod5TYx+70VLj/zsNylPpTAY0LLH810qfZZAUpYQuOMQiQOaW6
         +Rnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ooOYm/lxfXHFr95vspk2EkrmG+u1vi1Ig36ixjr1fH4=;
        b=WwI5liGW1ca8hlcKsagGK+KmdwfPynzd/UOfltHORh8V2El8p922W5Kn83v+8/k1G4
         2HasJUPjncijL7K0dWpNsxZxheojEprqcG7RL7Wuc2nqAxZZZX9Bi4A6W+ucdKMdKZrX
         4LgO13cHF9vOz4v7GR2UXWOXQyU9W6boZ7AAbbgLz6qBrLuVkwwnExteHjgmQ1NHloso
         xOz9UYKNQCvBalfkGF/aELGYV7MpPaDVwxGPUZv29zaQS/zS3qzH25k/n5rhu2Q2PJ5p
         7wkV2wsXihZJ8HkI+mf2N+pn9nmjE/YsbUaFuxYMKuYyxZLz1JiA7GvF5SZXyH1suyI2
         QzDA==
X-Gm-Message-State: AOAM531vtP43BQkCEO1tVgah07eV49M7U0b3FyOO/Heur/qRFQRs+o5b
        PKVXDYs/yau7gOLj6QM8EyIuGA==
X-Google-Smtp-Source: ABdhPJzUt8kjnwF97l16U79idvkd6nuQ86rEYiOYZzlcmlMr3BY8+UnKn9HbsHktBmByt8yPbvWEsA==
X-Received: by 2002:a05:600c:1990:b0:38c:c0a2:c0ab with SMTP id t16-20020a05600c199000b0038cc0a2c0abmr4368565wmq.72.1648645786215;
        Wed, 30 Mar 2022 06:09:46 -0700 (PDT)
Received: from joneslee-l.cable.virginm.net (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id c8-20020a056000184800b002040e925afasm20857932wri.59.2022.03.30.06.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 06:09:45 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 5.4 1/2] block: Add a helper to validate the block size
Date:   Wed, 30 Mar 2022 14:09:41 +0100
Message-Id: <20220330130942.882258-1-lee.jones@linaro.org>
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


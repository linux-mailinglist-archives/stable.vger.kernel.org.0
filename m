Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029504EC69E
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 16:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346893AbiC3OgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 10:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244899AbiC3Of7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 10:35:59 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7947323157
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 07:34:14 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id w21so25025968wra.2
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 07:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fb2vi6D4kpmYKFUN9SMEazEUR+f60ljTCG4PBRbH3hw=;
        b=t0SU+2jZ7TvbD1V/6dq8som+LmtT/cCcxlC1l+gmSMW2Zg/9V14hDaOl1297TpZ975
         AfC28N4ZWarIJlc1m+u/gjew3X7Xdf1lA2WM2pH9CaWLTUDiL/Zg5LyQ7hshavtF+WGp
         WdukYi3D/B7SZMbB2XVBXEO4UySXoSmIQrN2tpuRIydq3suJpXWME19cwwCl4Tv98+DV
         GBiXAbeYrXXkMKa0kCXp4iYiIxX8kMwLy2dpEmHDPjLKUK3kg0HwC5Jlor7HPKzcW+P0
         yamb07Wv6Q6gJeGaMc0ODE0CmFAirOdOrESR1lvXgXfr/mq6uPcnDPzQpGueA+a36YTz
         9pig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fb2vi6D4kpmYKFUN9SMEazEUR+f60ljTCG4PBRbH3hw=;
        b=ojjdg20W11FiH/KOupt9GkJ7XC7uxqnH2PPQJCKCrh/ljS3oqrr5zKBqMIUoPG7I1c
         o+apk1g3dwho0o6QP6K0DFjQcORpUL5FmNTmyedgogQuZVgEMw3FCK13e1i2ZiMKYq7y
         lrXp4b/UT9LyscGFCWIUC9gvIHGdt9jaDsNUEhVk62/hPWg6WLDJAHVI2zLV9K5McgoD
         btxG0EBQT+N3MSnbP/S4zYFzV982h3aLmbVQP5kNc/+Xv9SItK1tOENMumlQltepCDjE
         yh2pq/9hSoni/Kpb+esUGKOAChOMnnTTB3C8TH3Fdbnk8Xxfgs2LJDuZXEZfUsNToxzE
         nQ/g==
X-Gm-Message-State: AOAM530v6Kw+aMSLz7RYlJ07WOcnBczriKzSUWacOVx1ce+gKBhAwIVs
        m600Dw6b4PKmVTuBu0n5swnJfNcGa1fFwg==
X-Google-Smtp-Source: ABdhPJx5/0emA/PDScEDFfdj8Ni1GuC7/XI7ohEIE7e3uWtJp+71NxOBv/O57vTB9wZcH+CWXtIUNw==
X-Received: by 2002:a5d:5987:0:b0:204:1f21:6a29 with SMTP id n7-20020a5d5987000000b002041f216a29mr36854151wri.716.1648650852989;
        Wed, 30 Mar 2022 07:34:12 -0700 (PDT)
Received: from joneslee-l.cable.virginm.net (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id a11-20020a5d456b000000b0020406ce0e06sm17176511wrc.94.2022.03.30.07.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 07:34:12 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.9 1/2] block: Add a helper to validate the block size
Date:   Wed, 30 Mar 2022 15:34:08 +0100
Message-Id: <20220330143409.1230642-1-lee.jones@linaro.org>
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
index 848aab6c69823..8050724065524 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -49,6 +49,14 @@ struct pr_ops;
 
 typedef void (rq_end_io_fn)(struct request *, int);
 
+static inline int blk_validate_block_size(unsigned int bsize)
+{
+	if (bsize < 512 || bsize > PAGE_SIZE || !is_power_of_2(bsize))
+		return -EINVAL;
+
+	return 0;
+}
+
 #define BLK_RL_SYNCFULL		(1U << 0)
 #define BLK_RL_ASYNCFULL	(1U << 1)
 
-- 
2.35.1.1021.g381101b075-goog


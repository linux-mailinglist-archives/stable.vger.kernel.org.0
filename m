Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA786B9A99
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 17:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjCNQEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 12:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjCNQEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 12:04:39 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4D853290;
        Tue, 14 Mar 2023 09:04:29 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id p13-20020a9d744d000000b0069438f0db7eso8678579otk.3;
        Tue, 14 Mar 2023 09:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678809868;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0V1xObPOu1sKOo+zU+U91XCBQL6wMo8D/re2Ep+Sd8c=;
        b=Nd1h0JZpPla3jCeVZ1zmfgs/A5lsBso9dx3o9uaMBnU7ovfuVL4Btpd4Jjb9KTw5yJ
         aiyrdBxue+cetazW9tJbrvTYC1pCiPbT1wnAfD9bagmSmWtwXCEFiIUEJ97LkjQ6HUA8
         U3Z9z8cRe7Dh48GsbaEDxvFmJh9RtsbLLjl0bRxi5jgC6I0nlU4ArWhzEmPNpJc5AUb4
         g0g4OvOY63wcQRomcoYP/ttsMIEREcU3jQCqu4mjIwuCF9CQp8+Wt/Fu+91KrV717RkQ
         h/hmzJ7hinywYxt1QICr9++nEECZ/N19KxG18Hsu7/q1E1zZodX5OWMAv3fO+BPOQ+oL
         FInw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678809868;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0V1xObPOu1sKOo+zU+U91XCBQL6wMo8D/re2Ep+Sd8c=;
        b=NtvMVuTnJk84kUL0ByRs2rFJuBqQIwaWcBZtzPPljs859pFxwTyU8zRCMwDigLfBE1
         gJnFCM21ts+/jltPxK8L5HpEy9cwBBJVxw4kRzU287P+/GtWc5RQKaRhsyD6oPqxqkFp
         8AZqQFcGFzNSedD25YB6o3eWd9lQ5NPjTJopRW3jiOY8BGoCd8+05TxaS+gTVNjoRj5u
         fS32s2GKPBFiM0VWMKJsl/LpM635xiHFFwVeYq76qB8/0kI8q0KQUqjPFWGnQcpeRaNR
         F95bnH/1Y78j9DxbpvLrQJZ9bqCJByS+XN59NwAtGO8A+ZwerPFtjB4v9BgscbYU4Vbp
         /UhA==
X-Gm-Message-State: AO0yUKVtWQGcTQrAO5v3gjRpCwObJdzZxwMv9EMwyWNEWeTN+K4oeMl5
        1cVWcPwApiS8QPotUATDTu4=
X-Google-Smtp-Source: AK7set94TsrHo854JTD8IoFkuuoEcNBJlUmrlBDp9qrrNBZXdGOkUyGEG1VV/8LCaCCYvf1OIp+mIA==
X-Received: by 2002:a05:6830:6504:b0:699:221e:b07d with SMTP id cm4-20020a056830650400b00699221eb07dmr347642otb.11.1678809868351;
        Tue, 14 Mar 2023 09:04:28 -0700 (PDT)
Received: from chcpu13.cse.ust.hk (191host119.mobilenet.cse.ust.hk. [143.89.191.119])
        by smtp.gmail.com with ESMTPSA id q5-20020a4a3005000000b0051a6cb524b6sm1194392oof.2.2023.03.14.09.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:04:28 -0700 (PDT)
From:   Wei Chen <harperchen1110@gmail.com>
To:     andi.shyti@kernel.org
Cc:     linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Wei Chen <harperchen1110@gmail.com>
Subject: [PATCH v3] i2c: xgene-slimpro: Fix out-of-bounds bug in xgene_slimpro_i2c_xfer()
Date:   Tue, 14 Mar 2023 16:04:16 +0000
Message-Id: <20230314160416.2813398-1-harperchen1110@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The data->block[0] variable comes from user and is a number between
0-255. Without proper check, the variable may be very large to cause
an out-of-bounds when performing memcpy in slimpro_i2c_blkwr.

Fix this bug by checking the value of writelen.

Fixes: f6505fbabc42 ("i2c: add SLIMpro I2C device driver on APM X-Gene platform")
Signed-off-by: Wei Chen <harperchen1110@gmail.com>
---
Changes in v2:
 - Put length check inside slimpro_i2c_blkwr
Changes in v3:
 - Correct the format of patch

 drivers/i2c/busses/i2c-xgene-slimpro.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/busses/i2c-xgene-slimpro.c b/drivers/i2c/busses/i2c-xgene-slimpro.c
index bc9a3e7e0c96..0f7263e2276a 100644
--- a/drivers/i2c/busses/i2c-xgene-slimpro.c
+++ b/drivers/i2c/busses/i2c-xgene-slimpro.c
@@ -308,6 +308,9 @@ static int slimpro_i2c_blkwr(struct slimpro_i2c_dev *ctx, u32 chip,
 	u32 msg[3];
 	int rc;
 
+	if (writelen > I2C_SMBUS_BLOCK_MAX)
+		return -EINVAL;
+
 	memcpy(ctx->dma_buffer, data, writelen);
 	paddr = dma_map_single(ctx->dev, ctx->dma_buffer, writelen,
 			       DMA_TO_DEVICE);
-- 
2.25.1


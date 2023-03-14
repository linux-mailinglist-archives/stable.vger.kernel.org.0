Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3607E6B9C45
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 17:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjCNQyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 12:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCNQya (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 12:54:30 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8720665C7D;
        Tue, 14 Mar 2023 09:54:28 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id a4-20020a056830008400b0069432af1380so8732614oto.13;
        Tue, 14 Mar 2023 09:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678812868;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EonhBFpRiqDdLBEHZpZFnmSI1fVQAggjhLPOkfzboxU=;
        b=GuoqaT0ezIyiRlJ3FdQWwOTI1X530tBwzC970F6RfB+Bfx8PoriAp7ZVm+6yaPInDj
         3TzgvnQTVasY62fklUd3uMQdNDD0qwgQkOPXdHBRo70mtdQebaz/NTqOsWDkj4JEASPL
         7nmVkNlzpZhwU+6pijbaFFpyp73sxO3jX+MDechRyakZeXAG3Z7M2hXzAGjgoBvqxiNh
         lEzhnrTXc3PM4pMZ1bdSH0gJtd+oNQaDlYSyxoc9VzKcxo5YVYI0jwoM9WrvVUF4Pgij
         pYblBZ1TjYSh9IwkAVzQG5LJlLihUD1uxMLgQ2O6NcWsT47d3t97dmKKrMPBfG6gsTMU
         y2Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678812868;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EonhBFpRiqDdLBEHZpZFnmSI1fVQAggjhLPOkfzboxU=;
        b=cWPhZ1p4ogLAwZ5l7fMTinJxU/XyCZaqIedcLTCXdhkMqUCYCCntYdaMdWfa4vFnBL
         0bf2mVsw8HFJQB0GB4Hn/IjAl6DBYs/B5dMGVf45p9Pr1z7CCV56Ba/3a1mOehs+Fnxd
         tOqqt2mN5To2ruqpWY56qdSgOy6ovYZb0DO/3N+Tg+dYxahZfzdhoGEjJJdrngkNnT4o
         0U2Ezudaues2NdPIDKfZe/s3ofVpkc5FL1e1q3K/XM6r+pPKgoXPhRjnYYQkJ/43w3bS
         8hImT0bDuw+JLXc5mmJDGoaESuv0UVoFHdIeSz4fwEpPy4x86oKEXRJVCKbiOjZPIuxr
         Y1Uw==
X-Gm-Message-State: AO0yUKVKljdZk0mwHqNBrcPtYVBU3HTRmH7fj0K7TIVEbmvdzd1c+1iC
        wVNIlOSa5tbnMZSYR0QYpVc=
X-Google-Smtp-Source: AK7set+agmiBPmN2KvGz5ZmQoo9mQgcUQ1XTE074qe/FTMBBkL62pXyAk0rETJSA4Gm0vgNKpyILxw==
X-Received: by 2002:a9d:4c4:0:b0:68d:4eb7:49d9 with SMTP id 62-20020a9d04c4000000b0068d4eb749d9mr21722524otm.37.1678812867863;
        Tue, 14 Mar 2023 09:54:27 -0700 (PDT)
Received: from chcpu13.cse.ust.hk (191host119.mobilenet.cse.ust.hk. [143.89.191.119])
        by smtp.gmail.com with ESMTPSA id z30-20020a9d71de000000b0069463b0207asm1332874otj.30.2023.03.14.09.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:54:27 -0700 (PDT)
From:   Wei Chen <harperchen1110@gmail.com>
To:     andi.shyti@kernel.org
Cc:     linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Wei Chen <harperchen1110@gmail.com>
Subject: [PATCH v4] i2c: xgene-slimpro: Fix out-of-bounds bug in xgene_slimpro_i2c_xfer()
Date:   Tue, 14 Mar 2023 16:54:21 +0000
Message-Id: <20230314165421.2823691-1-harperchen1110@gmail.com>
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
Cc: stable@vger.kernel.org
---
Changes in v2:
 - Put length check inside slimpro_i2c_blkwr
Changes in v3:
 - Correct the format of patch
Changes in v4:
 - CC stable email address

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


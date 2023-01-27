Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6555667E1E4
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 11:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbjA0Kki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 05:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbjA0Kkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 05:40:37 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4591E61B3
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 02:40:24 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id l8so3127778wms.3
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 02:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nTkajujz2PbWOlDLokzlXiyxOl9BSGAFgie62+J1Eyo=;
        b=s+W5+n62jwib/xTTJBkNb7ee9T+KKMqFWtG3GXq+NtAnt+YYBi917eRTRIFwvM3vf9
         44UgBD5tabXE6aj7lFEyAXedD4cqV8i+KDJtIS+9Uf3gv0YZlDYl5csLnGY7AwTHH+9q
         /4WvmwO3fzuXfqBr6Bp+l3/fqVMOniQE/s3YrBF23q/2bvYhvQDv7+5LSaFn7SPZDkeu
         otekpHHl6F92kyeyL6K38rrBuscggPJfZQi72MQG83ncBRVUBz1gmUx5Dr7fx3mtyEZR
         rozoRfzgFu1lzLf7ZAJsVE8ANaexRJM4jvJwLbK3ixI15dpUYL2FdmhE6icmZUf3FFTU
         6FsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nTkajujz2PbWOlDLokzlXiyxOl9BSGAFgie62+J1Eyo=;
        b=8LjFhBjfDt4dF/c8aQidJ3bnxX1MEvB72ppCPgFvI2+qTa2g1/kFDc7iIxoN/HGloS
         RFOQMoaVGEwPiskAo7BsmdnPbxxLz7x3GBn7gJ0G/35rkaVEMk0XucgCMyk7ZMV09dvh
         s3ILZ3G9477FgfA0yT+F1HwxmjDYUel+S1BCcBLdwEJT2gqM6SXvF3dVn++cw8gbxTXV
         X98ws1O7S+gy+XTJ3DhLQsGyJ7Pa5jZIekbLZejyoJAQhSF0mmoiRGf/UJRAhS1UIOFn
         NfFsnM+l0yF/oBFbkPgaziVbLLXO5Wp0uDaRI9CKj7OtYx3vbTt3zEfiphyHCFw8A3Iv
         U1jg==
X-Gm-Message-State: AFqh2kpVfkVG/QJSCNXCvCMSsFXDJu3qEimY2dU2PxHWR6OLozOGWAYU
        xHnD9IACau+kwTiCY9sF0PnBng==
X-Google-Smtp-Source: AMrXdXv2uX+g92Qeopbr15XptCvYgcTmav6tLAuhuLtOiXhi9z2GXTk8Wy0JmTm/815r6cJctVUNTQ==
X-Received: by 2002:a05:600c:3d14:b0:3da:f793:fff6 with SMTP id bh20-20020a05600c3d1400b003daf793fff6mr38791890wmb.16.1674816022840;
        Fri, 27 Jan 2023 02:40:22 -0800 (PST)
Received: from localhost.localdomain ([5.133.47.210])
        by smtp.gmail.com with ESMTPSA id q9-20020a1ce909000000b003dc34edacf8sm1619787wmc.31.2023.01.27.02.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 02:40:22 -0800 (PST)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>, stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 01/10] nvmem: brcm_nvram: Add check for kzalloc
Date:   Fri, 27 Jan 2023 10:40:06 +0000
Message-Id: <20230127104015.23839-2-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127104015.23839-1-srinivas.kandagatla@linaro.org>
References: <20230127104015.23839-1-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

Add the check for the return value of kzalloc in order to avoid
NULL pointer dereference.

Cc: stable@vger.kernel.org
Fixes: 6e977eaa8280 ("nvmem: brcm_nvram: parse NVRAM content into NVMEM cells")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/nvmem/brcm_nvram.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvmem/brcm_nvram.c b/drivers/nvmem/brcm_nvram.c
index 34130449f2d2..39aa27942f28 100644
--- a/drivers/nvmem/brcm_nvram.c
+++ b/drivers/nvmem/brcm_nvram.c
@@ -98,6 +98,9 @@ static int brcm_nvram_parse(struct brcm_nvram *priv)
 	len = le32_to_cpu(header.len);
 
 	data = kzalloc(len, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
 	memcpy_fromio(data, priv->base, len);
 	data[len - 1] = '\0';
 
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B394BCF4A
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 16:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236044AbiBTPPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 10:15:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237306AbiBTPPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 10:15:00 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8FC34B9A
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 07:14:39 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id m126-20020a1ca384000000b0037bb8e379feso11946590wme.5
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 07:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xVb0fT1MGhcBbhhTafWv2pABvtbVRcxp+NDQSOBSHBI=;
        b=vrUhGbzWYj9b0IvENuCjMtgDybie2NNldRu/4ngPcWe+XGiXsvwrMpfRvcEvVaP3Ps
         UJCnKFn+dmvzzjzM9JLBxemtS6FsgvCHYfZREBuBx/aqs/U3r5TPjSNoTAKTbxtQiz0P
         rIqhmznel+D2xTurkav2gDEPUIjJD0xed1eMPjEWnQIAZKgUMcyViX3CnyU0sxGV1osN
         r7/KYIk39sxKnmLKQwUvUcGs7WAmYh3m3M+tVqfhecNSCZXoiOM93tTofC/Ot/xWh5k1
         d1xruKTiXtp7GXbKUN/vn6p1xgYvC70uJ0zCsrWLsh4iLxMybafTJBLgxOZdU+XDmrY1
         rGkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xVb0fT1MGhcBbhhTafWv2pABvtbVRcxp+NDQSOBSHBI=;
        b=pgkCxl8X33m+YZigLFzqx9acSla3cQwmXyXeIKvW34PyxF/+378ERQc4cn7I8g70Vi
         xu6UccQ2gLSRQfY+8uxzK45hmvCQciyuXLviDGASVemfElAlw/kNYZXgRGV17ifi13mm
         yK2AN/Y0g9Wp7MQOrkYjhEYRRAfbRVxZsZUFSBrLaZfWISqAMMYdTcwM4Vw5rxBReEIr
         l9cA977uCGwFzxvSQE3va7f1xJ52JrayY/Je+HG7V3HaEHPhAb3/TE21MZOcUJLLJN3M
         IR93pTManTkrRi4IvmrWawv9YzZK2Y58LkLbJPt+1agr5OKkYA6tb0lKKscwayaYVmpj
         XfWw==
X-Gm-Message-State: AOAM530DlcRhIIRz6ywT7jYC8nturkrQr9fJSK06XmyV3gZAGbAC1Htp
        xcTraN6bZgfhyq3kfMd47Hv8NQ==
X-Google-Smtp-Source: ABdhPJx0+otiYCAHPq6CQ9cJdD6jVkuoNt9NaRuoXNvS+K1VEh/IhESSbQ3rerpybwtaOmEeML66jw==
X-Received: by 2002:a7b:c74e:0:b0:37b:9785:fbe5 with SMTP id w14-20020a7bc74e000000b0037b9785fbe5mr14373492wmk.54.1645370078205;
        Sun, 20 Feb 2022 07:14:38 -0800 (PST)
Received: from srini-hackbox.lan (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.gmail.com with ESMTPSA id d6sm46703322wrs.85.2022.02.20.07.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 07:14:37 -0800 (PST)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org,
        Christophe Kerello <christophe.kerello@foss.st.com>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 2/2] mtd: core: Fix a conflict between MTD and NVMEM on wp-gpios property
Date:   Sun, 20 Feb 2022 15:14:32 +0000
Message-Id: <20220220151432.16605-3-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220220151432.16605-1-srinivas.kandagatla@linaro.org>
References: <20220220151432.16605-1-srinivas.kandagatla@linaro.org>
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

From: Christophe Kerello <christophe.kerello@foss.st.com>

Wp-gpios property can be used on NVMEM nodes and the same property can
be also used on MTD NAND nodes. In case of the wp-gpios property is
defined at NAND level node, the GPIO management is done at NAND driver
level. Write protect is disabled when the driver is probed or resumed
and is enabled when the driver is released or suspended.

When no partitions are defined in the NAND DT node, then the NAND DT node
will be passed to NVMEM framework. If wp-gpios property is defined in
this node, the GPIO resource is taken twice and the NAND controller
driver fails to probe.

A new Boolean flag named ignore_wp has been added in nvmem_config.
In case ignore_wp is set, it means that the GPIO is handled by the
provider. Lets set this flag in MTD layer to avoid the conflict on
wp_gpios property.

Fixes: 2a127da461a9 ("nvmem: add support for the write-protect pin")
Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
Cc: stable@vger.kernel.org
Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mtd/mtdcore.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 70f492dce158..eef87b28d6c8 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -546,6 +546,7 @@ static int mtd_nvmem_add(struct mtd_info *mtd)
 	config.stride = 1;
 	config.read_only = true;
 	config.root_only = true;
+	config.ignore_wp = true;
 	config.no_of_node = !of_device_is_compatible(node, "nvmem-cells");
 	config.priv = mtd;
 
@@ -833,6 +834,7 @@ static struct nvmem_device *mtd_otp_nvmem_register(struct mtd_info *mtd,
 	config.owner = THIS_MODULE;
 	config.type = NVMEM_TYPE_OTP;
 	config.root_only = true;
+	config.ignore_wp = true;
 	config.reg_read = reg_read;
 	config.size = size;
 	config.of_node = np;
-- 
2.21.0


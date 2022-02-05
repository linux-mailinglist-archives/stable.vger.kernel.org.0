Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A857D4AA93C
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 14:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbiBEN5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 08:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380069AbiBEN5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 08:57:44 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BD5C061348
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 05:57:44 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id v4so2512669pjh.2
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 05:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0+gDcwKFt260uCvDNcXKUjFFsl38YOMRKAZVrvcRdwE=;
        b=XlJ5yMs426ODFx+xgWqfUcLqFmH4PL2v8lpt6L59iacJBmvu9Ngw0SiwPOBMqMsTDL
         xt/lgG6904HeSdebFAtVTpHP03tBQnY/oRTg/+qp8vwAPOaj4oqSmt4+/3M8qD6mbujh
         Z87DCD256gmoB8zo64VldVSX9tyhiuyAcHY6HP/8+yXPWWirDzQmUS29ZOGerFwgBcdq
         qKUhDOZhBLnl0U9FHyc0QD1LsQi2UIZwjRQu1lREbQSAdhizuXqvJZJC9Ysvde+X6TJo
         n/iWyXXcIN7+Mm8dqttMLJw233iQb6ium4e3/68UJHvHoieuPkYEtD9JvXZZ5jPfOEho
         dWtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0+gDcwKFt260uCvDNcXKUjFFsl38YOMRKAZVrvcRdwE=;
        b=O4oBEQJo17Ld6jrVmv+8gBsWvgSydPRf4AOMC6/kZG5JSNZKHkC88Tyej4cMoM5ITU
         fldSsRefQX2PI4Z6c1wpeU9VM2azG0pO6shuOraT1vrFZJ5gJvwyEebgmS/8ocB1jqWg
         rIiIepLtxdW4py1pDwxKKFKRTN0jTNihY7gudbRR656PK2XO6/qUKc0BL/5TlCGnXvw0
         HIj+hpdhENIC2X+qkbCUzW/M/0OmGt5u/hq6OUXdFrVLsJ5mgEgniwc39uBNmAqzxl94
         18t2KCFVC7oVxAU/rwD1upuv7x+YTZK5OUQfe2Y0jZZLeyar+syJ8h5P+LKq6M9BX+s0
         UUMQ==
X-Gm-Message-State: AOAM53027+l6OMKtS6srKa4T3sJKmN1u+PCR78Rzb7vG+VVThZwQoIWC
        J0S0oUsRO1bM7spsir76kpMk
X-Google-Smtp-Source: ABdhPJwFGqmH4T3wyyAlgOBztWunQqSqTZ7RAMNcABX8QqwkGCpTVL0Ji9MYBQtqWT5fGGbf5WptxA==
X-Received: by 2002:a17:902:e0cd:: with SMTP id e13mr1591531pla.15.1644069463788;
        Sat, 05 Feb 2022 05:57:43 -0800 (PST)
Received: from localhost.localdomain ([220.158.158.32])
        by smtp.gmail.com with ESMTPSA id z13sm6355533pfe.20.2022.02.05.05.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 05:57:43 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     mhi@lists.linux.dev, hemantk@codeaurora.org, bbhatt@codeaurora.org,
        Slark Xiao <slark_xiao@163.com>, stable@vger.kernel.org,
        Manivannan Sadhasivam <mani@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 2/2] bus: mhi: pci_generic: Add mru_default for Cinterion MV31-W
Date:   Sat,  5 Feb 2022 19:27:31 +0530
Message-Id: <20220205135731.157871-3-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220205135731.157871-1-manivannan.sadhasivam@linaro.org>
References: <20220205135731.157871-1-manivannan.sadhasivam@linaro.org>
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

From: Slark Xiao <slark_xiao@163.com>

For default mechanism, product would use default MRU 3500 if
they didn't define it. But for Cinterion MV31-W, there is a known
issue which MRU 3500 would lead to data connection lost.
So we align it with Qualcomm default MRU settings.

Cc: stable@vger.kernel.org # v5.14 +
Fixes: 87693e092bd0 ("bus: mhi: pci_generic: Add Cinterion MV31-W PCIe to MHI")
Signed-off-by: Slark Xiao <slark_xiao@163.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://lore.kernel.org/r/20220119102519.5342-1-slark_xiao@163.com
[mani: Modified the commit message to reflect Cinterion MV31-W and CCed stable]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/pci_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index 74e8fc342cfd..b79895810c52 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -402,6 +402,7 @@ static const struct mhi_pci_dev_info mhi_mv31_info = {
 	.config = &modem_mv31_config,
 	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
 	.dma_data_width = 32,
+	.mru_default = 32768,
 };
 
 static const struct mhi_channel_config mhi_sierra_em919x_channels[] = {
-- 
2.25.1


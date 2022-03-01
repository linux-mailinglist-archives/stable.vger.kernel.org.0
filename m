Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6374C8FA1
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 17:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbiCAQEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 11:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235968AbiCAQEI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 11:04:08 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C5D4D9D1
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 08:03:27 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id z2so13794171plg.8
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 08:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v1g2hYf97RcajpTup4MPHjgGvJjlulQZjdgR68xQMns=;
        b=hepV1AjZLA0WjhWVmPnDKy4Ig58wsvt7UUn7IcDnRnL8NVM/Cf/a6x7x0BfS7PPa28
         kpAO/hxd+lBzZs8iELLydoj7WCPgVBAbR3r/Qsk9/wR4GofXAJbOS0NalaoiUO3fZ1Ft
         +jwQWW02MCVCPSrXQ00hmnhUl/e+wjpTzuCbmX0FSdUyTxG56uUizoWxPt+Mo0afymgT
         keJ6a1c9Legnc0Lfn1ci4wPHKBikRDLMV4SDLALOqEaV6cmtl0YOmBJGso10Ij5MpdUs
         XXNR0yUy5buQsT8K1UL0x8c3rkiBASUSu+cuBjrLqD0eqoOn7upR/TCBx8AeRSeS1OI9
         HDHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v1g2hYf97RcajpTup4MPHjgGvJjlulQZjdgR68xQMns=;
        b=xAhMzEcVD6Z1fTb8ZN2OgXfqHi1rsap/4nsW4CcgpawDf8Y5iQwPD7Aqw4Tm5cCgut
         xY7R65sgUzOB9L2Cktu6loL2BkvaqIMp4NNVGt/AjrKTdStx7EAPdMaoeJYz99S15ow7
         bz9ndArmCg/zfOgIROyu33Op4lZSJErORNjmim3Uip9GMssenJ+FtgjtMvfbX+np1ZIB
         a4DfcKJQiVIEoO7ZXFk+OWG2Zebs01HdRRu1lKg3Euu4lK1XurjuQzOkNSq3qK3d5Udq
         4kg5mfo23UoKTzENVlB9SK6XoR6EMRXKla5/Wd44Uz5U55u6eAZ5nEMayzDvAfq7IXMI
         NsAg==
X-Gm-Message-State: AOAM533za8QojQVLA4ckxrdxxQ+pwXDPkpxXGYBJHPKMwvLbRravMVP6
        g/4dcx6RHi07wGuk4iZNojEc
X-Google-Smtp-Source: ABdhPJyREiVd2eDrhZP23iEPA/klSgkX0IjDBvULPNNBz7EbnxeJXEtY77qXeeqN1goRinuTcFstlQ==
X-Received: by 2002:a17:903:40ce:b0:151:7343:9981 with SMTP id t14-20020a17090340ce00b0015173439981mr7150385pld.102.1646150607288;
        Tue, 01 Mar 2022 08:03:27 -0800 (PST)
Received: from localhost.localdomain ([117.207.25.80])
        by smtp.gmail.com with ESMTPSA id m17-20020a17090a859100b001bc20ddcc67sm2489530pjn.34.2022.03.01.08.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 08:03:26 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     mhi@lists.linux.dev, quic_hemantk@quicinc.com,
        quic_bbhatt@quicinc.com, elder@linaro.org,
        paul.davey@alliedtelesis.co.nz,
        Yonglin Tan <yonglin.tan@outlook.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 01/10] bus: mhi: pci_generic: Add mru_default for Quectel EM1xx series
Date:   Tue,  1 Mar 2022 21:32:59 +0530
Message-Id: <20220301160308.107452-2-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301160308.107452-1-manivannan.sadhasivam@linaro.org>
References: <20220301160308.107452-1-manivannan.sadhasivam@linaro.org>
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

From: Yonglin Tan <yonglin.tan@outlook.com>

For default mechanism, the driver uses default MRU 3500 if mru_default
is not initialized. The Qualcomm configured the MRU size to 32768 in the
WWAN device FW. So, we align the driver setting with Qualcomm FW setting.

Fixes: ac4bf60bbaa0 ("bus: mhi: pci_generic: Introduce quectel EM1XXGR-L support")
Signed-off-by: Yonglin Tan <yonglin.tan@outlook.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/MEYP282MB2374EE345DADDB591AFDA6AFFD2E9@MEYP282MB2374.AUSP282.PROD.OUTLOOK.COM
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/pci_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index b79895810c52..9527b7d63840 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -327,6 +327,7 @@ static const struct mhi_pci_dev_info mhi_quectel_em1xx_info = {
 	.config = &modem_quectel_em1xx_config,
 	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
 	.dma_data_width = 32,
+	.mru_default = 32768,
 	.sideband_wake = true,
 };
 
-- 
2.25.1


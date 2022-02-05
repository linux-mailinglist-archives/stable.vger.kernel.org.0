Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5CF34AA93B
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 14:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbiBEN5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 08:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbiBEN5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 08:57:41 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1F9C061346
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 05:57:40 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id v74so7638953pfc.1
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 05:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XGvSdM7vC1pTecZPrsZrqX912rXQTMoXwV75tbAyEZ0=;
        b=z8Gb0j54BsIY+IbBcLL06Zb2L6yrH6HiE6WuMg/jebrTdWkB8+bJYMzCJqtnn75LI9
         0hmRY8iXkX1bgtmKX66TrWY7JejlzVwK+xolTU4C/T17kzW96AbClpxfBr7+ZU9GvK1l
         6LSDGIjAcqlMj2/URngQGqWE5jZ6fQjUv08/hJhlUvv11Q9OEbioMUmXMFbwvG9aOXYi
         aghWeHOHZAZs6JlNlQh2TV5NKZQjFRui06bc+o/CRtmF7LvtAs9s9kaIrnRk8PCBVA4w
         5A6oz588HH8ano1YQ3J6G/CmpgWOIHFG94XtjaUEXuSFrkj1pBoT1ktM4HgTE9fuUH/Q
         58OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XGvSdM7vC1pTecZPrsZrqX912rXQTMoXwV75tbAyEZ0=;
        b=pj6Co4VZLUHMFDy9DWjxBBypAgABrz0LDuvwkymzWSlGpVO+H8I+k6hYqgQeILmAdg
         BfwiiElAsdoBE3n89tj01JMhJg3qbnp0lpDz10L8+JWXHlGzPxR7hO2k47BFyFc3tsNv
         qn6osIqsy5ZmRu30JBypUOny0to1Nb5ruEfQalKI2cNvphmzXzAF9xyCUv+zpr9pdzWw
         MqNf4lsloQd1ajfUKyVCkmjQkEYrJQ1Mds9ZUtQpt3sShKYA0QdCBme0w8R2hQ7rapE9
         i6qE3n8VTuJmUTnNRsD7EjgiPMtOZdymMorD4M7H6V/kKThf04bOHQvZAKW4R9jWjqh2
         7T6Q==
X-Gm-Message-State: AOAM53263rULa576rA5BtyzWwlURXrjNEa6CUKu1Mwnxf+AMqqyTV6nB
        iNjq620htqxXzBNZ5cH19NZZ
X-Google-Smtp-Source: ABdhPJzFtN4U47gHOs5fpHk30zlLd9QNQ9cqJ1cbTXhtuIUhOWlawmAhSkx04/uY0vd6OiIoi8rHlA==
X-Received: by 2002:a63:6bc4:: with SMTP id g187mr2962271pgc.151.1644069460224;
        Sat, 05 Feb 2022 05:57:40 -0800 (PST)
Received: from localhost.localdomain ([220.158.158.32])
        by smtp.gmail.com with ESMTPSA id z13sm6355533pfe.20.2022.02.05.05.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 05:57:39 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     mhi@lists.linux.dev, hemantk@codeaurora.org, bbhatt@codeaurora.org,
        Slark Xiao <slark_xiao@163.com>, stable@vger.kernel.org,
        Manivannan Sadhasivam <mani@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 1/2] bus: mhi: pci_generic: Add mru_default for Foxconn SDX55
Date:   Sat,  5 Feb 2022 19:27:30 +0530
Message-Id: <20220205135731.157871-2-manivannan.sadhasivam@linaro.org>
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
they didn't define it. But for Foxconn SDX55, there is a known
issue which MRU 3500 would lead to data connection lost.
So we align it with Qualcomm default MRU settings.

Cc: stable@vger.kernel.org # v5.12+
Fixes: aac426562f56 ("bus: mhi: pci_generic: Introduce Foxconn T99W175 support")
Signed-off-by: Slark Xiao <slark_xiao@163.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://lore.kernel.org/r/20220119101213.5008-1-slark_xiao@163.com
[mani: Added pci_generic prefix to subject and CCed stable]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/pci_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index 3a258a677df8..74e8fc342cfd 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -366,6 +366,7 @@ static const struct mhi_pci_dev_info mhi_foxconn_sdx55_info = {
 	.config = &modem_foxconn_sdx55_config,
 	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
 	.dma_data_width = 32,
+	.mru_default = 32768,
 	.sideband_wake = false,
 };
 
-- 
2.25.1


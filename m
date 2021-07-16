Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F733CB395
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 09:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236908AbhGPHyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 03:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236450AbhGPHyc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 03:54:32 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EABC06175F
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 00:51:37 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id u126so513476pfb.8
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 00:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A5YTg0MnmWJbRIWQkegAwKJdKUa9X9i6zjHdjizNY+o=;
        b=Jc3SqWk2rhU0EU8oc/KfB7YReeHkXS37Fzs+U9Pc5NXU3sEp+5NMNpROi/+0AP/wLZ
         M61GrRqFVq+A7BxmNH6XY8bZY0Fk7f9zwQZJ2S9ADp3ilmyM23I9UO9oDESd/OBREOhp
         ofraqRypc3xRe2gGaVijrhFZiwDPUanL/u+zFBzmuKZ6WMvRA85t6+YCOIuM/G++3UWK
         Wd84197KT81ZT608yNFy2VCJ5Yp6JnlLpeNLhfzDh3T9QIuYA2OYV+QH8E6xEt77EgPg
         W8QQ1b3+etohCmXNzUm8VduavoTdYaYNciKBm36EzC5TlJ3k/t4zY2OkGeSn9nodPGEQ
         CIoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A5YTg0MnmWJbRIWQkegAwKJdKUa9X9i6zjHdjizNY+o=;
        b=NU88qczLX0gZr/jYdSi6BnDDlg2ckhr9uw9jkXQnzK3XZ1aiOqaUpCX+Y3tdDSilLh
         lBsr0Ao8lY+DL5875vn8EMY7wb7DHDfDFZIUFxpKzdqxrpSnkspZh7OaEOe/Vk8bDjtj
         uVDezsGYxdnp8cXWntus0TEgRNaB/mD19OzAfHJrLPYH3Ip6KRYjc2WP5a/11BfMlPfN
         pvh1X28GbOVFprQL6BHDO01bqA8zlIr2WLqlRiqhkYdnnuBQ6CENU1fDLPByJABLZxBj
         COPeyQwGPFYeYS+SY/s0IG4KjdtBsRKvJU4J2Pfk8Dsczdzbe9CxCqCLKY+ot3Gm+Dtp
         bGsA==
X-Gm-Message-State: AOAM531yHm4ffG0wMOkFPsL6jfhH/1DmHOFnaSDVVtxYNvcRzySrX9zy
        Dj5pBtwxhHPtNtMQ7Ix8af9a
X-Google-Smtp-Source: ABdhPJzHARcoweCD8ijUdwN0f19ItbZzuXlPE2Inss7Ib478RGmUELS0cJZbwmv27jUZ86oGv3tuPA==
X-Received: by 2002:aa7:95a4:0:b029:332:f4e1:1dac with SMTP id a4-20020aa795a40000b0290332f4e11dacmr8210346pfk.34.1626421897372;
        Fri, 16 Jul 2021 00:51:37 -0700 (PDT)
Received: from localhost.localdomain ([120.138.12.214])
        by smtp.gmail.com with ESMTPSA id 21sm9253357pfp.211.2021.07.16.00.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jul 2021 00:51:36 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     hemantk@codeaurora.org, bbhatt@codeaurora.org,
        linux-arm-msm@vger.kernel.org, jhugo@codeaurora.org,
        linux-kernel@vger.kernel.org, loic.poulain@linaro.org,
        stable@vger.kernel.org, Manivannan Sadhasivam <mani@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 3/3] bus: mhi: pci_generic: Fix inbound IPCR channel
Date:   Fri, 16 Jul 2021 13:21:06 +0530
Message-Id: <20210716075106.49938-4-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210716075106.49938-1-manivannan.sadhasivam@linaro.org>
References: <20210716075106.49938-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

The qrtr-mhi client driver assumes that inbound buffers are
automatically allocated and queued by the MHI core, but this
doesn't happen for mhi pci devices since IPCR inbound channel is
not flagged with auto_queue, causing unusable IPCR (qrtr)
feature. Fix that.

Cc: stable@vger.kernel.org #5.10
Fixes: 855a70c12021 ("bus: mhi: Add MHI PCI support for WWAN modems")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Hemant kumar <hemantk@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://lore.kernel.org/r/1625736749-24947-1-git-send-email-loic.poulain@linaro.org
[mani: fixed a spelling mistake in commit description]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/pci_generic.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index 3396cb30ebec..4dd1077354af 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -75,6 +75,22 @@ struct mhi_pci_dev_info {
 		.doorbell_mode_switch = false,		\
 	}
 
+#define MHI_CHANNEL_CONFIG_DL_AUTOQUEUE(ch_num, ch_name, el_count, ev_ring) \
+	{						\
+		.num = ch_num,				\
+		.name = ch_name,			\
+		.num_elements = el_count,		\
+		.event_ring = ev_ring,			\
+		.dir = DMA_FROM_DEVICE,			\
+		.ee_mask = BIT(MHI_EE_AMSS),		\
+		.pollcfg = 0,				\
+		.doorbell = MHI_DB_BRST_DISABLE,	\
+		.lpm_notify = false,			\
+		.offload_channel = false,		\
+		.doorbell_mode_switch = false,		\
+		.auto_queue = true,			\
+	}
+
 #define MHI_EVENT_CONFIG_CTRL(ev_ring, el_count) \
 	{					\
 		.num_elements = el_count,	\
@@ -213,7 +229,7 @@ static const struct mhi_channel_config modem_qcom_v1_mhi_channels[] = {
 	MHI_CHANNEL_CONFIG_UL(14, "QMI", 4, 0),
 	MHI_CHANNEL_CONFIG_DL(15, "QMI", 4, 0),
 	MHI_CHANNEL_CONFIG_UL(20, "IPCR", 8, 0),
-	MHI_CHANNEL_CONFIG_DL(21, "IPCR", 8, 0),
+	MHI_CHANNEL_CONFIG_DL_AUTOQUEUE(21, "IPCR", 8, 0),
 	MHI_CHANNEL_CONFIG_UL_FP(34, "FIREHOSE", 32, 0),
 	MHI_CHANNEL_CONFIG_DL_FP(35, "FIREHOSE", 32, 0),
 	MHI_CHANNEL_CONFIG_HW_UL(100, "IP_HW0", 128, 2),
-- 
2.25.1


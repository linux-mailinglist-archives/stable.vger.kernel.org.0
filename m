Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60593BF782
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 11:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhGHJY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 05:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbhGHJY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 05:24:56 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D334C06175F
        for <stable@vger.kernel.org>; Thu,  8 Jul 2021 02:22:13 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id l7so5691200wrv.7
        for <stable@vger.kernel.org>; Thu, 08 Jul 2021 02:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=D0GVRma+WjAiBuDgc+UXLQN2rv//eYbHQ7Ejo+oBtUc=;
        b=WQeQMQAv9C2Za3ek0oZdqELqlKM3rUF1pGwDKWu23OB+eykGNP+YaB+YLHWLZ1N4dX
         Na4JUQI+tXLOm/DUlXW198CU41H0U1SCkqj2vswhp688qhEba7np0405BdAfZW+ti5LM
         fQRfEDwx+RhyO0lZwKkQuNaaMBWt/0+7voEtVAv4HtBcI9K6xF0QbmdM+ilmFEFL8ik/
         aXBff4eHw2PCeoVXSrVHfC6eNQWNTFLA45o1lq1+nEaQ0tW2tZVF+MUV3Rhc9AUffQws
         3WwxRFcqKELJY572f4OtaCRUROVf4DYTzyVaNwiB2/+LjLCKefBLoltBSLSQCRmrsLzO
         8LhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=D0GVRma+WjAiBuDgc+UXLQN2rv//eYbHQ7Ejo+oBtUc=;
        b=ZYDiXaB4PfkRFrJ9zJ39jLLTaSXawQrIqZkEh667v7OwrDOWDHgzcwQXriraZyqXfw
         3RkMvjial6uUUtlhWdtBsAg5hPTTaln9lOUR7heIAIaO9u+HPSkNlB2CIkx4SV7QPBgp
         FSbc+lShXv5xyaS++lzADwbRaaKVTBd8OPGQOOKTd87XE2Eq7Uqdj6txk9m6YNdXNTB0
         nYsq/bus0UVAz2bGK0C66oaLcn5tzYXhi+kKD2Uk/DHKhi7rClc+DaCYTGAClQ718Re8
         Qwi/4InyycPwN8SLdygjkGG0NSWK95dDdwIwYT59wWl7prMkWb8vOkOm9FOAgtLVodaU
         NCIg==
X-Gm-Message-State: AOAM532tePvUhl+NQI8/G1xNJhx1ZFHslfTIm7XiRoToD7luE5XC2JD3
        fqH/i38hUBHKXTwByeOBfcXrXQ==
X-Google-Smtp-Source: ABdhPJwFe4M1R5WELQh7kNtotD3NOLVrJ8iLDSxlJ0NowpmKiG1AHiEpZJQrm/PvzxBD3bT1U3qaAw==
X-Received: by 2002:adf:e10c:: with SMTP id t12mr33021799wrz.36.1625736132066;
        Thu, 08 Jul 2021 02:22:12 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:7064:9879:f4d7:9ccc])
        by smtp.gmail.com with ESMTPSA id p5sm1675590wrd.25.2021.07.08.02.22.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Jul 2021 02:22:11 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     mani@kernel.org, hemantk@codeaurora.org
Cc:     linux-arm-msm@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>, stable@vger.kernel.org
Subject: [PATCH] mhi: pci_generic: Fix inbound IPCR channel
Date:   Thu,  8 Jul 2021 11:32:29 +0200
Message-Id: <1625736749-24947-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The qrtr-mhi client driver assumes that inbound buffers are
automatically allocated and queued by the MHI core, but this
no happens for mhi pci devices since IPCR inbound channel is
not flagged with auto_queue, causing unusable IPCR (qrtr)
feature. Fix that.

Cc: stable@vger.kernel.org
Fixes: 855a70c12021 ("bus: mhi: Add MHI PCI support for WWAN modems")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/bus/mhi/pci_generic.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index 8bc6149..6d2ddec 100644
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
2.7.4


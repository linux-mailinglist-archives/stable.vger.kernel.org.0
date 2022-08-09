Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A1358D587
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 10:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238886AbiHIIle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 04:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240900AbiHIIla (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 04:41:30 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AA1220CA
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 01:41:29 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id i14so20988569ejg.6
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 01:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citymesh-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=Om59joR1M6pWAO+wEsEo7W0q2krbcksNOjJDMPtWolo=;
        b=hq6Tj7nvgE8df+Qr/wG64TjBCXr54y92zjUqwCn4HLNh9wDImMrUQfURIgOLM4M1y/
         a2/IJi29CzljycUauErG6jYLiosY0Jhf65fLyPvBuhFSNkT/voXKwvbB7YGPmm7Y34EG
         pCS0gxxRWcb39cQuoTYpI4rledWXZLVDzCwCd+qNd8UQ3YgqT7RmTnjQRc4T06vBkqdA
         B7xKp9MjObYVgZwEXFDiPrIkf1ePdxr3rclHV0ERV2FKkIGP++KYzREaWmmLePQ1xU8b
         XFczOzd2JeRXeQzq/skoKftSOilQ3f1PZjAyaPuHOM0itWNJGGucybL+y1rocEhxf6kw
         9yDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=Om59joR1M6pWAO+wEsEo7W0q2krbcksNOjJDMPtWolo=;
        b=nqyXQORXh0tTD4aQU6+QmZLCBfaUuMA8gF6/3c3AMJZEgKL3FPcuIKqHyzhCUZHOSo
         hhY+cbcDtmIC0YCF0U6X6fEuDmVCeZbP/F0785tlwCocHzpH7ip1tPFEAr1X4D8g9ZJU
         uIqKa1qVUfJntDJ9ueirQ6+WAcgK86kv7FcmNavrnPXJ/q1YA1fBw33jI98Nb+RKZYtW
         qd0nnHDG5t/amgF+s6Y3+8McZRzDEzFKbqs1E6LeRP7xdwUWYDD51n/alye1d/vGaRRC
         hGY2lvZOtkQiiGwqTEQiaRmgjWfVz/X8LYjggxcDFiCxbcZqP44yRreGWaFl+nzmDUlh
         shrQ==
X-Gm-Message-State: ACgBeo0Knkp9rql/tCW955vNBvl/1LZ/OXkf0naWbBrgu/jkGWiW50uI
        2eO8DU6OWnQE8lbAxpRXo1l93pRYo0UgxQ==
X-Google-Smtp-Source: AA6agR48B50bLZWIxPoqyExcqiZKT3tK+31PUCI+uMamwC54CdWHdz3T0XkIfah43aznuZz1tO9hGA==
X-Received: by 2002:a17:907:ea8:b0:731:67eb:b60a with SMTP id ho40-20020a1709070ea800b0073167ebb60amr4832727ejc.497.1660034487707;
        Tue, 09 Aug 2022 01:41:27 -0700 (PDT)
Received: from localhost.localdomain ([31.31.140.89])
        by smtp.gmail.com with ESMTPSA id v25-20020a170906b01900b007315e57ba0asm848983ejy.114.2022.08.09.01.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 01:41:27 -0700 (PDT)
From:   Koen Vandeputte <koen.vandeputte@citymesh.com>
X-Google-Original-From: Koen Vandeputte <koen.vandeputte@ncentric.com>
To:     stable@vger.kernel.org
Cc:     Thomas Perrot <thomas.perrot@bootlin.com>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] bus: mhi: pci_generic: Introduce Sierra EM919X support
Date:   Tue,  9 Aug 2022 10:40:58 +0200
Message-Id: <20220809084058.323170-1-koen.vandeputte@ncentric.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Perrot <thomas.perrot@bootlin.com>

Add support for EM919X modems, this modem series is based on SDX55
qcom chip.

It is mandatory to use the same ring for control+data and diag events.

Link: https://lore.kernel.org/r/20211123081541.648426-1-thomas.perrot@bootlin.com
Tested-by: Aleksander Morgado <aleksander@aleksander.es>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Thomas Perrot <thomas.perrot@bootlin.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20211216081227.237749-11-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Backported/refreshed version for 5.15 LTS based on 5.15.59
This LTS contains all required bits and other modems have been backported already.


 drivers/bus/mhi/pci_generic.c | 43 +++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index b780990faf80..336dba72e552 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -406,6 +406,46 @@ static const struct mhi_pci_dev_info mhi_mv31_info = {
 	.mru_default = 32768,
 };
 
+static const struct mhi_channel_config mhi_sierra_em919x_channels[] = {
+	MHI_CHANNEL_CONFIG_UL_SBL(2, "SAHARA", 32, 0),
+	MHI_CHANNEL_CONFIG_DL_SBL(3, "SAHARA", 256, 0),
+	MHI_CHANNEL_CONFIG_UL(4, "DIAG", 32, 0),
+	MHI_CHANNEL_CONFIG_DL(5, "DIAG", 32, 0),
+	MHI_CHANNEL_CONFIG_UL(12, "MBIM", 128, 0),
+	MHI_CHANNEL_CONFIG_DL(13, "MBIM", 128, 0),
+	MHI_CHANNEL_CONFIG_UL(14, "QMI", 32, 0),
+	MHI_CHANNEL_CONFIG_DL(15, "QMI", 32, 0),
+	MHI_CHANNEL_CONFIG_UL(32, "DUN", 32, 0),
+	MHI_CHANNEL_CONFIG_DL(33, "DUN", 32, 0),
+	MHI_CHANNEL_CONFIG_HW_UL(100, "IP_HW0", 512, 1),
+	MHI_CHANNEL_CONFIG_HW_DL(101, "IP_HW0", 512, 2),
+};
+
+static struct mhi_event_config modem_sierra_em919x_mhi_events[] = {
+	/* first ring is control+data and DIAG ring */
+	MHI_EVENT_CONFIG_CTRL(0, 2048),
+	/* Hardware channels request dedicated hardware event rings */
+	MHI_EVENT_CONFIG_HW_DATA(1, 2048, 100),
+	MHI_EVENT_CONFIG_HW_DATA(2, 2048, 101)
+};
+
+static const struct mhi_controller_config modem_sierra_em919x_config = {
+	.max_channels = 128,
+	.timeout_ms = 24000,
+	.num_channels = ARRAY_SIZE(mhi_sierra_em919x_channels),
+	.ch_cfg = mhi_sierra_em919x_channels,
+	.num_events = ARRAY_SIZE(modem_sierra_em919x_mhi_events),
+	.event_cfg = modem_sierra_em919x_mhi_events,
+};
+
+static const struct mhi_pci_dev_info mhi_sierra_em919x_info = {
+	.name = "sierra-em919x",
+	.config = &modem_sierra_em919x_config,
+	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
+	.dma_data_width = 32,
+	.sideband_wake = false,
+};
+
 static const struct mhi_channel_config mhi_telit_fn980_hw_v1_channels[] = {
 	MHI_CHANNEL_CONFIG_UL(14, "QMI", 32, 0),
 	MHI_CHANNEL_CONFIG_DL(15, "QMI", 32, 0),
@@ -480,6 +520,9 @@ static const struct mhi_pci_dev_info mhi_telit_fn990_info = {
 };
 
 static const struct pci_device_id mhi_pci_id_table[] = {
+	/* EM919x (sdx55), use the same vid:pid as qcom-sdx55m */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0306, 0x18d7, 0x0200),
+		.driver_data = (kernel_ulong_t) &mhi_sierra_em919x_info },
 	/* Telit FN980 hardware revision v1 */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0306, 0x1C5D, 0x2000),
 		.driver_data = (kernel_ulong_t) &mhi_telit_fn980_hw_v1_info },
-- 
2.25.1


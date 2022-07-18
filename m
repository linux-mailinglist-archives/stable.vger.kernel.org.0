Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07C85783AF
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 15:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiGRN2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 09:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiGRN2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 09:28:16 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1545298
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 06:28:15 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id fy29so20083128ejc.12
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 06:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9rCnF3Il/qiqc/cpX5LXo41bRTWUnO9IpL7J4RKDd9c=;
        b=FGvYH/IvYSlbvN+wWGZCdFxL8QlwksqJX/xrwRqlvp3WuBSp+/8qJ7jQANYy+QP7Y/
         zOLkIqb6FQmsfQkFf//5UWKK7Oa5+C9g1PW1GaVeSN1sepbDdRbjk+JsGJQ1uT1+nIUk
         IPpomIFG6rWmQz/F/bJbPi2TLQllBAh+xl+wA4DKlWlR5c7jPiQMd4DOoVFK5VYmwkiY
         bUSriF4ha03gqZshdcM1z0tnmPq65rokH1PyTH22AkQdn4Gz9wTZm2j87XfQVx0P/hE0
         tz+OS3KvmDMw6AUI7y99W/aoP+K4vAfSOrMihebnUHKuGW0eDzGJst9nr/R4qfj8WrpO
         OZww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9rCnF3Il/qiqc/cpX5LXo41bRTWUnO9IpL7J4RKDd9c=;
        b=K/NSRVQYtRjRv6n0f+49mCXNRfjq7wmXwWloS35atrw0MSBeau3tJ93mXBgnV6/Wng
         smMkDS2EeeGLaR9lkfib633HRlSk0X56/l2Stcu4cO5+S4CVURIlshwsCnyBcSILxQKI
         ddoUxsRJ0B5VwElRBOvIap5m3ezcbietZ6wGka4WrwqdlRatb5s6wKOk6j6/Pmpx19mg
         wHkZXj+uUKOaJzGfvU2+Qy/Qqmd1uXmn/11FJ3YZ9hStRSrqt11VXglTPnWUGWRN2yVv
         e52SgK3XVTunQbkcpOjw/I9J0HqBo9t6+MxJ6e7BEBoNeD+YIzJu/lnHdNvP82XlIAjW
         mMSA==
X-Gm-Message-State: AJIora8urV2aYlGYVgxfk42TWb+1rVrm+yvmm/3qYaj6dKosMmUJJODo
        HXdNr2ccLqsGBycrGIOZTgicds2eP0E=
X-Google-Smtp-Source: AGRyM1ucNIMPfIxP8LdQn9Az4N4NtkO2L4IwMxckLrIBMLLTlbKsf3vS8X9tNESsAxUbxT2jJwpsOw==
X-Received: by 2002:a17:907:60d1:b0:72f:42a0:f3f9 with SMTP id hv17-20020a17090760d100b0072f42a0f3f9mr1992182ejc.727.1658150894224;
        Mon, 18 Jul 2022 06:28:14 -0700 (PDT)
Received: from labdl-itc-sw06.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id s5-20020a1709066c8500b0071c6dc728b2sm5490219ejr.86.2022.07.18.06.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 06:28:13 -0700 (PDT)
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
To:     stable@vger.kernel.org
Cc:     Fabio Porcedda <fabio.porcedda@gmail.com>,
        Daniele Palmas <dnlplm@gmail.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v2 5.18 1/2] bus: mhi: host: pci_generic: add Telit FN980 v1 hardware revision
Date:   Mon, 18 Jul 2022 15:27:10 +0200
Message-Id: <20220718132711.393957-2-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220718132711.393957-1-fabio.porcedda@gmail.com>
References: <20220718132711.393957-1-fabio.porcedda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a96ef8b504efb2ad445dfb6d54f9488c3ddf23d2 upstream.

Add Telit FN980 v1 hardware revision:

01:00.0 Unassigned class [ff00]: Qualcomm Device [17cb:0306]
        Subsystem: Device [1c5d:2000]

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://lore.kernel.org/r/20220427072648.17635-1-dnlplm@gmail.com
[mani: Added "host" to the subject]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
---
 drivers/bus/mhi/host/pci_generic.c | 38 ++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
index 541ced27d941..6b27295f566f 100644
--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -446,10 +446,48 @@ static const struct mhi_pci_dev_info mhi_sierra_em919x_info = {
 	.sideband_wake = false,
 };
 
+static const struct mhi_channel_config mhi_telit_fn980_hw_v1_channels[] = {
+	MHI_CHANNEL_CONFIG_UL(14, "QMI", 32, 0),
+	MHI_CHANNEL_CONFIG_DL(15, "QMI", 32, 0),
+	MHI_CHANNEL_CONFIG_UL(20, "IPCR", 16, 0),
+	MHI_CHANNEL_CONFIG_DL_AUTOQUEUE(21, "IPCR", 16, 0),
+	MHI_CHANNEL_CONFIG_HW_UL(100, "IP_HW0", 128, 1),
+	MHI_CHANNEL_CONFIG_HW_DL(101, "IP_HW0", 128, 2),
+};
+
+static struct mhi_event_config mhi_telit_fn980_hw_v1_events[] = {
+	MHI_EVENT_CONFIG_CTRL(0, 128),
+	MHI_EVENT_CONFIG_HW_DATA(1, 1024, 100),
+	MHI_EVENT_CONFIG_HW_DATA(2, 2048, 101)
+};
+
+static struct mhi_controller_config modem_telit_fn980_hw_v1_config = {
+	.max_channels = 128,
+	.timeout_ms = 20000,
+	.num_channels = ARRAY_SIZE(mhi_telit_fn980_hw_v1_channels),
+	.ch_cfg = mhi_telit_fn980_hw_v1_channels,
+	.num_events = ARRAY_SIZE(mhi_telit_fn980_hw_v1_events),
+	.event_cfg = mhi_telit_fn980_hw_v1_events,
+};
+
+static const struct mhi_pci_dev_info mhi_telit_fn980_hw_v1_info = {
+	.name = "telit-fn980-hwv1",
+	.fw = "qcom/sdx55m/sbl1.mbn",
+	.edl = "qcom/sdx55m/edl.mbn",
+	.config = &modem_telit_fn980_hw_v1_config,
+	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
+	.dma_data_width = 32,
+	.mru_default = 32768,
+	.sideband_wake = false,
+};
+
 static const struct pci_device_id mhi_pci_id_table[] = {
 	/* EM919x (sdx55), use the same vid:pid as qcom-sdx55m */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0306, 0x18d7, 0x0200),
 		.driver_data = (kernel_ulong_t) &mhi_sierra_em919x_info },
+	/* Telit FN980 hardware revision v1 */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0306, 0x1C5D, 0x2000),
+		.driver_data = (kernel_ulong_t) &mhi_telit_fn980_hw_v1_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0306),
 		.driver_data = (kernel_ulong_t) &mhi_qcom_sdx55_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0304),
-- 
2.37.1


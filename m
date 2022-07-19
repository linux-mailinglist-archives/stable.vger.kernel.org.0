Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC0E57951E
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 10:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbiGSISg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 04:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236795AbiGSISf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 04:18:35 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1F324970
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 01:18:34 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id e15so18558045edj.2
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 01:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JK9DuNUn5xxUaIm5zeiot/4MTm9draBeWT/9N7PpVX4=;
        b=T0NqEz3ICO+8MqOtmR0MobTs/lebF8JaUQ5rbWeaDPwXuPkSZPMQX7U7JpKQe0fs0+
         4JjdDrnHWK0S1FYghPTSjMj4dW1+xC8xF5XqqOggJQoZs6dJaMjlW7sK/g5fnGSP+z6R
         HgEmacSZNk697cJlCFrEXJWQ2fhpAOG8BimkxdqNWDxLy8mXnBceDj3iha4TzRqNbBkV
         KXKX5I+FlEvvNYHBt/0Faf/iiiwGJ4iAhbVrG/bcIM66j8IJOyXb8VNc2Mt5F0Sy9I4h
         xbXY3nBNLGIdlzBzMi0nRkvcSNGAdIpSi2diDb2GO+FV8oJoP54bGOG4ySVmpXXeLBUT
         ug2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JK9DuNUn5xxUaIm5zeiot/4MTm9draBeWT/9N7PpVX4=;
        b=Yt6w3hjMvgMzgE3hOj6ReMuxKXtvYcLEBJx5Ez20LnRccTMMVTUEGj/qy4bPtkbxTU
         heCIGKtr3UGumh4cJB/s64x06yYo/FXV2TxbpOjowgrv0AJCuU/3WsCNyiN7lxwY5QgU
         O6P5A3hTViI3JNEV6ds9wJZm3r3QPZG/JdzLZBQr/kSdXv20zAQJJfeJA573Y+4jNhGs
         v6/pT8eaqkXLdZjAYBRNl8E54/qIDI1uVhAOFn/9qwo17q2SJ0dFjiporkMKSYmjwoEu
         fGruXhXXVKNPI8x6JfwrzDW8Fk0ZgayCuFWXXQ6MwT16TsvsILWJX09lo6RDMHMcUvxx
         wRsw==
X-Gm-Message-State: AJIora/Rwmm7T4Unzo6syoERiF6QpOuGhBJvnYMAz13SrZrOiXjgIzwj
        sLLB+YkoGanCsZzEBTWWnv1Z8RDBfLY=
X-Google-Smtp-Source: AGRyM1taZOISsvf45+CKrsWgc+qQiv2xQSy3W5QK8rFtp1jIZkLkR7v+4fDSm7C3+cfYnVRdJS5S9A==
X-Received: by 2002:a05:6402:50d0:b0:43a:df6d:6f4d with SMTP id h16-20020a05640250d000b0043adf6d6f4dmr42262776edb.72.1658218712762;
        Tue, 19 Jul 2022 01:18:32 -0700 (PDT)
Received: from labdl-itc-sw06.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id w13-20020aa7cb4d000000b0043a5004e714sm10008075edt.64.2022.07.19.01.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 01:18:32 -0700 (PDT)
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
To:     stable@vger.kernel.org
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: [PATCH 5.15 1/2] bus: mhi: host: pci_generic: add Telit FN980 v1 hardware revision
Date:   Tue, 19 Jul 2022 10:18:14 +0200
Message-Id: <20220719081815.466080-2-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719081815.466080-1-fabio.porcedda@gmail.com>
References: <20220719081815.466080-1-fabio.porcedda@gmail.com>
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

From: Daniele Palmas <dnlplm@gmail.com>

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
 drivers/bus/mhi/pci_generic.c | 38 +++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index 0982642a7907..1621e4ac94b2 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -406,7 +406,45 @@ static const struct mhi_pci_dev_info mhi_mv31_info = {
 	.mru_default = 32768,
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
+	/* Telit FN980 hardware revision v1 */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0306, 0x1C5D, 0x2000),
+		.driver_data = (kernel_ulong_t) &mhi_telit_fn980_hw_v1_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0306),
 		.driver_data = (kernel_ulong_t) &mhi_qcom_sdx55_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0304),
-- 
2.37.1


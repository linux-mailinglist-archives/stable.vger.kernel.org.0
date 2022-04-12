Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199194FD851
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355521AbiDLIKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 04:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357315AbiDLHj6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CD223BD7;
        Tue, 12 Apr 2022 00:14:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3E626176E;
        Tue, 12 Apr 2022 07:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46E1C385A6;
        Tue, 12 Apr 2022 07:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747697;
        bh=pTCguM5hKfS5YojLbcfsg4liUJK9KCMGfsJzuRRUdt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iK1kTBV1asbdAzKe4tlQe92rhwRyDYza7E2Ji+uj2yxvy7u/vqWNusZCxsdEPmXsV
         mSRTLo3zfFj556Ew1AJDyOlB3VeLErp7jcm06YeuFLS2lZ30jw9sSZaP+ah6mL9ILD
         2FRoni85NSka/N82KofFS0b4Pkljw/wwhWMcY3pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 173/343] habanalabs/gaudi: handle axi errors from NIC engines
Date:   Tue, 12 Apr 2022 08:29:51 +0200
Message-Id: <20220412062956.361016831@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oded Gabbay <ogabbay@kernel.org>

[ Upstream commit 26ef1c000bc21a192618c9ec651dd36ba63ca00c ]

Various AXI errors can occur in the NIC engines and are reported to
the driver by the f/w. Add code to print the errors and ack them to
the f/w.

Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/gaudi/gaudi.c | 48 +++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 013c6da2e3ca..b4dacea80151 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -7819,6 +7819,48 @@ static void gaudi_print_fw_alive_info(struct hl_device *hdev,
 		fw_alive->thread_id, fw_alive->uptime_seconds);
 }
 
+static void gaudi_print_nic_axi_irq_info(struct hl_device *hdev, u16 event_type,
+						void *data)
+{
+	char desc[64] = "", *type;
+	struct eq_nic_sei_event *eq_nic_sei = data;
+	u16 nic_id = event_type - GAUDI_EVENT_NIC_SEI_0;
+
+	switch (eq_nic_sei->axi_error_cause) {
+	case RXB:
+		type = "RXB";
+		break;
+	case RXE:
+		type = "RXE";
+		break;
+	case TXS:
+		type = "TXS";
+		break;
+	case TXE:
+		type = "TXE";
+		break;
+	case QPC_RESP:
+		type = "QPC_RESP";
+		break;
+	case NON_AXI_ERR:
+		type = "NON_AXI_ERR";
+		break;
+	case TMR:
+		type = "TMR";
+		break;
+	default:
+		dev_err(hdev->dev, "unknown NIC AXI cause %d\n",
+			eq_nic_sei->axi_error_cause);
+		type = "N/A";
+		break;
+	}
+
+	snprintf(desc, sizeof(desc), "NIC%d_%s%d", nic_id, type,
+			eq_nic_sei->id);
+	dev_err_ratelimited(hdev->dev, "Received H/W interrupt %d [\"%s\"]\n",
+		event_type, desc);
+}
+
 static int gaudi_non_hard_reset_late_init(struct hl_device *hdev)
 {
 	/* GAUDI doesn't support any reset except hard-reset */
@@ -8066,6 +8108,7 @@ static void gaudi_handle_eqe(struct hl_device *hdev,
 				struct hl_eq_entry *eq_entry)
 {
 	struct gaudi_device *gaudi = hdev->asic_specific;
+	u64 data = le64_to_cpu(eq_entry->data[0]);
 	u32 ctl = le32_to_cpu(eq_entry->hdr.ctl);
 	u32 fw_fatal_err_flag = 0;
 	u16 event_type = ((ctl & EQ_CTL_EVENT_TYPE_MASK)
@@ -8263,6 +8306,11 @@ static void gaudi_handle_eqe(struct hl_device *hdev,
 		hl_fw_unmask_irq(hdev, event_type);
 		break;
 
+	case GAUDI_EVENT_NIC_SEI_0 ... GAUDI_EVENT_NIC_SEI_4:
+		gaudi_print_nic_axi_irq_info(hdev, event_type, &data);
+		hl_fw_unmask_irq(hdev, event_type);
+		break;
+
 	case GAUDI_EVENT_DMA_IF_SEI_0 ... GAUDI_EVENT_DMA_IF_SEI_3:
 		gaudi_print_irq_info(hdev, event_type, false);
 		gaudi_print_sm_sei_info(hdev, event_type,
-- 
2.35.1




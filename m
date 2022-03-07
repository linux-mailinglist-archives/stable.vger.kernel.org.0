Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFA54CF73D
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235896AbiCGJpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239483AbiCGJjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:39:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341FF710C3;
        Mon,  7 Mar 2022 01:35:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9038FCE0EA3;
        Mon,  7 Mar 2022 09:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4A0C340F3;
        Mon,  7 Mar 2022 09:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645720;
        bh=QHeZbhsKAtDR0ZnRTik/K7NwB+77pHUkW1jMEsSkNIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LS8mU4gXcS/RS71K6cd5k3O0zm03Qa5J7Tq05vs+i612eltb+DJ6w/xNJz++amgxD
         OYyIsLkaV+7QmvKQQG0uGAKocdVPl5755q9EyJ1mNZpFSum5oJEtc8KbjoDDwWHheq
         JANITCz8+PbE1Rt8jZzA6dXPfutTZvHkPeMaS7Vo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/262] HID: amd_sfh: Add interrupt handler to process interrupts
Date:   Mon,  7 Mar 2022 10:16:00 +0100
Message-Id: <20220307091702.833738569@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit 7f016b35ca7623c71b31facdde080e8ce171a697 ]

On newer AMD platforms with SFH, it is observed that random interrupts
get generated on the SFH hardware and until this is cleared the firmware
sensor processing is stalled, resulting in no data been received to
driver side.

Add routines to handle these interrupts, so that firmware operations are
not stalled.

Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c | 40 ++++++++++++++++++++++++++
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.h |  1 +
 2 files changed, 41 insertions(+)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index f1efeeaa465a2..561bb27f42b10 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -102,6 +102,30 @@ static void amd_sfh_clear_intr(struct amd_mp2_dev *privdata)
 		privdata->mp2_ops->clear_intr(privdata);
 }
 
+static irqreturn_t amd_sfh_irq_handler(int irq, void *data)
+{
+	amd_sfh_clear_intr(data);
+
+	return IRQ_HANDLED;
+}
+
+static int amd_sfh_irq_init_v2(struct amd_mp2_dev *privdata)
+{
+	int rc;
+
+	pci_intx(privdata->pdev, true);
+
+	rc = devm_request_irq(&privdata->pdev->dev, privdata->pdev->irq,
+			      amd_sfh_irq_handler, 0, DRIVER_NAME, privdata);
+	if (rc) {
+		dev_err(&privdata->pdev->dev, "failed to request irq %d err=%d\n",
+			privdata->pdev->irq, rc);
+		return rc;
+	}
+
+	return 0;
+}
+
 void amd_start_sensor(struct amd_mp2_dev *privdata, struct amd_mp2_sensor_info info)
 {
 	union sfh_cmd_param cmd_param;
@@ -206,6 +230,7 @@ static void amd_mp2_pci_remove(void *privdata)
 	struct amd_mp2_dev *mp2 = privdata;
 	amd_sfh_hid_client_deinit(privdata);
 	mp2->mp2_ops->stop_all(mp2);
+	pci_intx(mp2->pdev, false);
 	amd_sfh_clear_intr(mp2);
 }
 
@@ -215,6 +240,7 @@ static const struct amd_mp2_ops amd_sfh_ops_v2 = {
 	.stop_all = amd_stop_all_sensor_v2,
 	.response = amd_sfh_wait_response_v2,
 	.clear_intr = amd_sfh_clear_intr_v2,
+	.init_intr = amd_sfh_irq_init_v2,
 };
 
 static const struct amd_mp2_ops amd_sfh_ops = {
@@ -240,6 +266,14 @@ static void mp2_select_ops(struct amd_mp2_dev *privdata)
 	}
 }
 
+static int amd_sfh_irq_init(struct amd_mp2_dev *privdata)
+{
+	if (privdata->mp2_ops->init_intr)
+		return privdata->mp2_ops->init_intr(privdata);
+
+	return 0;
+}
+
 static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct amd_mp2_dev *privdata;
@@ -273,6 +307,12 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
 
 	mp2_select_ops(privdata);
 
+	rc = amd_sfh_irq_init(privdata);
+	if (rc) {
+		dev_err(&pdev->dev, "amd_sfh_irq_init failed\n");
+		return rc;
+	}
+
 	rc = amd_sfh_hid_client_init(privdata);
 	if (rc) {
 		amd_sfh_clear_intr(privdata);
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
index ee9818d3082e3..00fc083dc1239 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
@@ -141,5 +141,6 @@ struct amd_mp2_ops {
 	 void (*stop_all)(struct amd_mp2_dev *privdata);
 	 int (*response)(struct amd_mp2_dev *mp2, u8 sid, u32 sensor_sts);
 	 void (*clear_intr)(struct amd_mp2_dev *privdata);
+	 int (*init_intr)(struct amd_mp2_dev *privdata);
 };
 #endif
-- 
2.34.1




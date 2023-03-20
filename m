Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47F36C080E
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbjCTBF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjCTBDR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:03:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2D923D95;
        Sun, 19 Mar 2023 17:57:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AB61611FC;
        Mon, 20 Mar 2023 00:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F217CC433EF;
        Mon, 20 Mar 2023 00:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273768;
        bh=oXcpe/O4c2WbWlDUT2vZedheqmY6RANycE72UAH12Uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eNeQX16l4PDie5KODBrpxuTtxXi2659Api4fU1s2O3NJPzutYNPDbuCm9yf6Vz/e8
         1tqzI5iwhRPIJm5wlDAgaakc1oc/zzqXORdi5pzC6TbZXQ4PScV0yoch9dORGvIiV7
         v9dNL0KPZBT6lz53WHPwKxW5TRUipvGuMZEa5aDiU/zo+Rv5AzuBsTjUjKmWb8eWQL
         6h/IfhlMhlMZA2QKKI0/aPRHVRNEV63dfu3p4YtIJJ2vqd1UZepLheCalvb/JBrx8r
         BcTvLOLdoD1FybdRI6d5k+2PM4X6Snp+24djj51EAMRmgG0OHjKm2A2XXwd3LaJXbP
         +lRUHcY9dL7Nw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Reka Norman <rekanorman@chromium.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        liqiong@nfschina.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 04/15] HID: intel-ish-hid: ipc: Fix potential use-after-free in work function
Date:   Sun, 19 Mar 2023 20:55:48 -0400
Message-Id: <20230320005559.1429040-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005559.1429040-1-sashal@kernel.org>
References: <20230320005559.1429040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reka Norman <rekanorman@chromium.org>

[ Upstream commit 8ae2f2b0a28416ed2f6d8478ac8b9f7862f36785 ]

When a reset notify IPC message is received, the ISR schedules a work
function and passes the ISHTP device to it via a global pointer
ishtp_dev. If ish_probe() fails, the devm-managed device resources
including ishtp_dev are freed, but the work is not cancelled, causing a
use-after-free when the work function tries to access ishtp_dev. Use
devm_work_autocancel() instead, so that the work is automatically
cancelled if probe fails.

Signed-off-by: Reka Norman <rekanorman@chromium.org>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ipc/ipc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/intel-ish-hid/ipc/ipc.c b/drivers/hid/intel-ish-hid/ipc/ipc.c
index a45ac7fa417b9..b950873c300b3 100644
--- a/drivers/hid/intel-ish-hid/ipc/ipc.c
+++ b/drivers/hid/intel-ish-hid/ipc/ipc.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2014-2016, Intel Corporation.
  */
 
+#include <linux/devm-helpers.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
@@ -594,7 +595,6 @@ static void	recv_ipc(struct ishtp_device *dev, uint32_t doorbell_val)
 	case MNG_RESET_NOTIFY:
 		if (!ishtp_dev) {
 			ishtp_dev = dev;
-			INIT_WORK(&fw_reset_work, fw_reset_work_fn);
 		}
 		schedule_work(&fw_reset_work);
 		break;
@@ -885,6 +885,7 @@ struct ishtp_device *ish_dev_init(struct pci_dev *pdev)
 {
 	struct ishtp_device *dev;
 	int	i;
+	int	ret;
 
 	dev = devm_kzalloc(&pdev->dev,
 			   sizeof(struct ishtp_device) + sizeof(struct ish_hw),
@@ -920,6 +921,12 @@ struct ishtp_device *ish_dev_init(struct pci_dev *pdev)
 		list_add_tail(&tx_buf->link, &dev->wr_free_list);
 	}
 
+	ret = devm_work_autocancel(&pdev->dev, &fw_reset_work, fw_reset_work_fn);
+	if (ret) {
+		dev_err(dev->devc, "Failed to initialise FW reset work\n");
+		return NULL;
+	}
+
 	dev->ops = &ish_hw_ops;
 	dev->devc = &pdev->dev;
 	dev->mtu = IPC_PAYLOAD_SIZE - sizeof(struct ishtp_msg_hdr);
-- 
2.39.2


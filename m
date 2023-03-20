Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4830A6C0887
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjCTBbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbjCTBbW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:31:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6299241CB;
        Sun, 19 Mar 2023 18:24:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFD65B80D41;
        Mon, 20 Mar 2023 00:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989D0C433EF;
        Mon, 20 Mar 2023 00:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273859;
        bh=yVemXlXUOkY+Omili823Wxq2eE4Spqxpx4OpajP0tIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWDmDNrZbWMZwgvEUiOcIHdH58Rueuvf9hFfv7MGIeEde6gtIJx2WFmadyFxRqW01
         95xrk8S+23H0dnEgKeMgtxwLbm8C14uUe9wu0Odd3IA3tG+3ZeZeEzcTT0tAgr5YRh
         CkWm9SS521FEt3hkzfYQtGHzOMd6MuxYg+Z48IxEbUFFM7GTw1DMCeac1usJmmIsvM
         cd7MEmQxpYTeBQC8orZkglOWIyFMQ8S93/ASZbpe+nwr2cT7GuOE92H+iGLsqdZnAa
         Fvb/kjCQPJ3y4u7Akb7us9Fwnrz4OXo186TuBJylfl6v4V+1hsmUHGC/JnNs77H0Or
         ofVrVbv9e9jcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Reka Norman <rekanorman@chromium.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        liqiong@nfschina.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 3/9] HID: intel-ish-hid: ipc: Fix potential use-after-free in work function
Date:   Sun, 19 Mar 2023 20:57:26 -0400
Message-Id: <20230320005732.1429533-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005732.1429533-1-sashal@kernel.org>
References: <20230320005732.1429533-1-sashal@kernel.org>
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
index a3106fcc22539..1d8aae83f50c1 100644
--- a/drivers/hid/intel-ish-hid/ipc/ipc.c
+++ b/drivers/hid/intel-ish-hid/ipc/ipc.c
@@ -13,6 +13,7 @@
  * more details.
  */
 
+#include <linux/devm-helpers.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
@@ -618,7 +619,6 @@ static void	recv_ipc(struct ishtp_device *dev, uint32_t doorbell_val)
 	case MNG_RESET_NOTIFY:
 		if (!ishtp_dev) {
 			ishtp_dev = dev;
-			INIT_WORK(&fw_reset_work, fw_reset_work_fn);
 		}
 		schedule_work(&fw_reset_work);
 		break;
@@ -909,6 +909,7 @@ struct ishtp_device *ish_dev_init(struct pci_dev *pdev)
 {
 	struct ishtp_device *dev;
 	int	i;
+	int	ret;
 
 	dev = kzalloc(sizeof(struct ishtp_device) + sizeof(struct ish_hw),
 		GFP_KERNEL);
@@ -942,6 +943,12 @@ struct ishtp_device *ish_dev_init(struct pci_dev *pdev)
 		list_add_tail(&tx_buf->link, &dev->wr_free_list_head.link);
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


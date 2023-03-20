Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B1F6C07E7
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjCTBC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbjCTBBA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:01:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA67234EF;
        Sun, 19 Mar 2023 17:57:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7914B80D49;
        Mon, 20 Mar 2023 00:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD948C433EF;
        Mon, 20 Mar 2023 00:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273834;
        bh=HGJeQnoObfbSLZ8AINAJNAeWLiQ6BHi5qwXuZ8RdO8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D0zShpSWMpWTCpYHbksuFoqULgYP/n8rr8imPOllG6YD5LakkTakWVyvv2mM8tmYw
         d3xk1PiFpA4jHYRtcUjRbW1Pfi0EOvEP5SDao4gdeQ3x8G0hprWd0t8xZK/peGwzPU
         Ssvs47saMF+7fyMNMgXdgtBmXteR7DRBMODhXUvsNuPbCpseDl41d+8CXFIRJx0WrP
         F0M1IxiOWAm5ud+n3llosKBWRc3E7MbyZWRNtdsefJCKgmC/C1rSjaJtQxCqADvTdM
         jlEl8417Hmt3CCJsIKB6nUVb/mf3mqLbrJvE75sN2NFLsw+hqXpg1EJAD7W+cR28wF
         kFezg6BZ0LjtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Reka Norman <rekanorman@chromium.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        liqiong@nfschina.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 3/9] HID: intel-ish-hid: ipc: Fix potential use-after-free in work function
Date:   Sun, 19 Mar 2023 20:57:01 -0400
Message-Id: <20230320005707.1429405-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005707.1429405-1-sashal@kernel.org>
References: <20230320005707.1429405-1-sashal@kernel.org>
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
index e00b9dbe220f1..abc94235100c6 100644
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
 
 	dev = devm_kzalloc(&pdev->dev,
 			   sizeof(struct ishtp_device) + sizeof(struct ish_hw),
@@ -945,6 +946,12 @@ struct ishtp_device *ish_dev_init(struct pci_dev *pdev)
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


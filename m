Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF03F65D2
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbfKJDJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:09:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728582AbfKJCoe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2920221848;
        Sun, 10 Nov 2019 02:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353873;
        bh=NW5M5tG5jivL/ewIrjwbSjVjsD2EhZihRfAaDgW/z/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwPECRHjgZlOvVXSDAGDQxDk6Lo5JXsLw7tIJ/1qdd9x5Cywc54CbBFs0+R04FECk
         39kcxynt1nF5PSx2K5xT8B3pKMtPCKGFt9F+3L+nNlQE9Ssn5NxRWZ5d+87Hr8afeW
         LzbatGfx+5FNSletuA8AewXc219Y+biOtPZL7dqY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stuart Hayes <stuart.w.hayes@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 152/191] firmware: dell_rbu: Make payload memory uncachable
Date:   Sat,  9 Nov 2019 21:39:34 -0500
Message-Id: <20191110024013.29782-152-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stuart Hayes <stuart.w.hayes@gmail.com>

[ Upstream commit 6aecee6ad41cf97c0270f72da032c10eef025bf0 ]

The dell_rbu driver takes firmware update payloads and puts them in memory so
the system BIOS can find them after a reboot.  This sometimes fails (though
rarely), because the memory containing the payload is in the CPU cache but
never gets written back to main memory before the system is rebooted (CPU
cache contents are lost on reboot).

With this patch, the payload memory will be changed to uncachable to ensure
that the payload is actually in main memory before the system is rebooted.

Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/dell_rbu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/firmware/dell_rbu.c b/drivers/firmware/dell_rbu.c
index fb8af5cb7c9bf..ccefa84f73057 100644
--- a/drivers/firmware/dell_rbu.c
+++ b/drivers/firmware/dell_rbu.c
@@ -45,6 +45,7 @@
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
 #include <linux/dma-mapping.h>
+#include <asm/set_memory.h>
 
 MODULE_AUTHOR("Abhay Salunke <abhay_salunke@dell.com>");
 MODULE_DESCRIPTION("Driver for updating BIOS image on DELL systems");
@@ -181,6 +182,11 @@ static int create_packet(void *data, size_t length)
 			packet_data_temp_buf = NULL;
 		}
 	}
+	/*
+	 * set to uncachable or it may never get written back before reboot
+	 */
+	set_memory_uc((unsigned long)packet_data_temp_buf, 1 << ordernum);
+
 	spin_lock(&rbu_data.lock);
 
 	newpacket->data = packet_data_temp_buf;
@@ -349,6 +355,8 @@ static void packet_empty_list(void)
 		 * to make sure there are no stale RBU packets left in memory
 		 */
 		memset(newpacket->data, 0, rbu_data.packetsize);
+		set_memory_wb((unsigned long)newpacket->data,
+			1 << newpacket->ordernum);
 		free_pages((unsigned long) newpacket->data,
 			newpacket->ordernum);
 		kfree(newpacket);
-- 
2.20.1


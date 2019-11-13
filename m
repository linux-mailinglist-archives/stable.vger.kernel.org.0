Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 734A3FA267
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731045AbfKMCCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:02:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:59292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731041AbfKMCCf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 21:02:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B89EB2246F;
        Wed, 13 Nov 2019 02:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610554;
        bh=3TcSAr33we8foAM+TykaFSMPb/1j0mn/8NsdaqDzg88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m1dsgrwuRMnGffgj19Tbi4bs2fAtxOZurxutWhyZ6vU9cDImyYLhBUUUuXI2XeAQX
         nPV8xzjwO48MnNB98Y5x7u33E9NzEu7wwLnQjmpkHLK9vhl3r8SRWiu34mYgIWn8+M
         2px8h3KGBgtj7RECTIG+RpGcIXURREenuTnGs7Rw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     He Zhe <zhe.he@windriver.com>, rostedt@goodmis.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 37/48] printk: Give error on attempt to set log buffer length to over 2G
Date:   Tue, 12 Nov 2019 21:01:20 -0500
Message-Id: <20191113020131.13356-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113020131.13356-1-sashal@kernel.org>
References: <20191113020131.13356-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: He Zhe <zhe.he@windriver.com>

[ Upstream commit e6fe3e5b7d16e8f146a4ae7fe481bc6e97acde1e ]

The current printk() is ready to handle log buffer size up to 2G.
Give an explicit error for users who want to use larger log buffer.

Also fix printk formatting to show the 2G as a positive number.

Link: http://lkml.kernel.org/r/20181008135916.gg4kkmoki5bgtco5@pathway.suse.cz
Cc: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Suggested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
[pmladek: Fixed to the really safe limit 2GB.]
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 5a1b2a914b4e5..699c18c9d7633 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -279,6 +279,7 @@ static u32 clear_idx;
 #define LOG_ALIGN __alignof__(struct printk_log)
 #endif
 #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
+#define LOG_BUF_LEN_MAX (u32)(1 << 31)
 static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
@@ -870,18 +871,23 @@ void log_buf_kexec_setup(void)
 static unsigned long __initdata new_log_buf_len;
 
 /* we practice scaling the ring buffer by powers of 2 */
-static void __init log_buf_len_update(unsigned size)
+static void __init log_buf_len_update(u64 size)
 {
+	if (size > (u64)LOG_BUF_LEN_MAX) {
+		size = (u64)LOG_BUF_LEN_MAX;
+		pr_err("log_buf over 2G is not supported.\n");
+	}
+
 	if (size)
 		size = roundup_pow_of_two(size);
 	if (size > log_buf_len)
-		new_log_buf_len = size;
+		new_log_buf_len = (unsigned long)size;
 }
 
 /* save requested log_buf_len since it's too early to process it */
 static int __init log_buf_len_setup(char *str)
 {
-	unsigned int size;
+	u64 size;
 
 	if (!str)
 		return -EINVAL;
@@ -951,7 +957,7 @@ void __init setup_log_buf(int early)
 	}
 
 	if (unlikely(!new_log_buf)) {
-		pr_err("log_buf_len: %ld bytes not available\n",
+		pr_err("log_buf_len: %lu bytes not available\n",
 			new_log_buf_len);
 		return;
 	}
@@ -964,8 +970,8 @@ void __init setup_log_buf(int early)
 	memcpy(log_buf, __log_buf, __LOG_BUF_LEN);
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
-	pr_info("log_buf_len: %d bytes\n", log_buf_len);
-	pr_info("early log buf free: %d(%d%%)\n",
+	pr_info("log_buf_len: %u bytes\n", log_buf_len);
+	pr_info("early log buf free: %u(%u%%)\n",
 		free, (free * 100) / __LOG_BUF_LEN);
 }
 
-- 
2.20.1


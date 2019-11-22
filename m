Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8607D106E34
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731158AbfKVLGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:06:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:33972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730087AbfKVLGC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:06:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 808F52070E;
        Fri, 22 Nov 2019 11:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420762;
        bh=aiz3eV8mf86aSfRxkTBxpeVCFF/Kh1Qwikco9jtuQ0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sVS7hrScp+rjv16JuxrSeylBwmX0UjsdUtG7jiRdHSsvR26+B045EoGOeWekpNQu0
         u3WO+B5d+7s5ivpykadVhUtvwNyzHwnE6BDHZAD12+/o+PyGsV1IfiRtaIWlLKCT8l
         +FuzbxRcSIkWv36biTKNPhuUxPzwxaeRUs1aMqBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, rostedt@goodmis.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        He Zhe <zhe.he@windriver.com>, Petr Mladek <pmladek@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 173/220] printk: Give error on attempt to set log buffer length to over 2G
Date:   Fri, 22 Nov 2019 11:28:58 +0100
Message-Id: <20191122100925.293272966@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 52390f5a1db11..c7b3d5489937d 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -438,6 +438,7 @@ static u32 clear_idx;
 /* record buffer */
 #define LOG_ALIGN __alignof__(struct printk_log)
 #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
+#define LOG_BUF_LEN_MAX (u32)(1 << 31)
 static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
@@ -1038,18 +1039,23 @@ void log_buf_vmcoreinfo_setup(void)
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
@@ -1119,7 +1125,7 @@ void __init setup_log_buf(int early)
 	}
 
 	if (unlikely(!new_log_buf)) {
-		pr_err("log_buf_len: %ld bytes not available\n",
+		pr_err("log_buf_len: %lu bytes not available\n",
 			new_log_buf_len);
 		return;
 	}
@@ -1132,8 +1138,8 @@ void __init setup_log_buf(int early)
 	memcpy(log_buf, __log_buf, __LOG_BUF_LEN);
 	logbuf_unlock_irqrestore(flags);
 
-	pr_info("log_buf_len: %d bytes\n", log_buf_len);
-	pr_info("early log buf free: %d(%d%%)\n",
+	pr_info("log_buf_len: %u bytes\n", log_buf_len);
+	pr_info("early log buf free: %u(%u%%)\n",
 		free, (free * 100) / __LOG_BUF_LEN);
 }
 
-- 
2.20.1




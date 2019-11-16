Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50776FEE5C
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730667AbfKPPvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:51:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730664AbfKPPvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:51:05 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4DB220891;
        Sat, 16 Nov 2019 15:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919465;
        bh=RLiTEN33ipYxT5RyWjY9r8DijsPzOFT9xk6mek4F8j8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HqaYxggq+wvW3L/nTmP6xRkZ3xQnzciSiKckMXpMCUv+6taNduqpwojrI/t+zpZqU
         4KN8vJ4dRgIkxAJfSe2Ma9DsVAPqvKa3dy9j6qVRqCQQs8bz8sx1Lij68iAsXZRleR
         QiFiIP5EJgdXi1R3cYa+G4WRU+jNuWeHAqxmpX34=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 02/99] printk: fix integer overflow in setup_log_buf()
Date:   Sat, 16 Nov 2019 10:49:25 -0500
Message-Id: <20191116155103.10971-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

[ Upstream commit d2130e82e9454304e9b91ba9da551b5989af8c27 ]

The way we calculate logbuf free space percentage overflows signed
integer:

	int free;

	free = __LOG_BUF_LEN - log_next_idx;
	pr_info("early log buf free: %u(%u%%)\n",
		free, (free * 100) / __LOG_BUF_LEN);

We support LOG_BUF_LEN of up to 1<<25 bytes. Since setup_log_buf() is
called during early init, logbuf is mostly empty, so

	__LOG_BUF_LEN - log_next_idx

is close to 1<<25. Thus when we multiply it by 100, we overflow signed
integer value range: 100 is 2^6 + 2^5 + 2^2.

Example, booting with LOG_BUF_LEN 1<<25 and log_buf_len=2G
boot param:

[    0.075317] log_buf_len: -2147483648 bytes
[    0.075319] early log buf free: 33549896(-28%)

Make "free" unsigned integer and use appropriate printk() specifier.

Link: http://lkml.kernel.org/r/20181010113308.9337-1-sergey.senozhatsky@gmail.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 6607d77afe55a..63528399dc25d 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1044,7 +1044,7 @@ void __init setup_log_buf(int early)
 {
 	unsigned long flags;
 	char *new_log_buf;
-	int free;
+	unsigned int free;
 
 	if (log_buf != __log_buf)
 		return;
-- 
2.20.1


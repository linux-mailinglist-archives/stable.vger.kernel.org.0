Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66650FA55D
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbfKMCWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:22:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:43000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727535AbfKMBxY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:53:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18613204EC;
        Wed, 13 Nov 2019 01:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610003;
        bh=KyMv468KYUxa0zlBPzJSuBJ/C6Qe6r6JSM8MqWf4Ufw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Cgwikjk8xTJnBxEN6br8wJr2saUoSV2HOjObqTDH6dbtR+8mM5sXKxoWZNKteIIF
         21ZYmYMShIH+4fBO5I/Z3Iq0jl4XnJRbZpkISN9Ory4PmGIinNfB1mFFJEwHSpurBP
         fpS+VLiV5SzfJ0YotvZGFp+Qe4SUhC49ekahW5qI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     He Zhe <zhe.he@windriver.com>, rostedt@goodmis.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 110/209] printk: Correct wrong casting
Date:   Tue, 12 Nov 2019 20:48:46 -0500
Message-Id: <20191113015025.9685-110-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: He Zhe <zhe.he@windriver.com>

[ Upstream commit 51a72ab7372d85c96104e58036f1b49ba11e5d2b ]

log_first_seq and console_seq are 64-bit unsigned integers.
Correct a wrong casting that might cut off the output.

Link: http://lkml.kernel.org/r/1538239553-81805-2-git-send-email-zhe.he@windriver.com
Cc: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: He Zhe <zhe.he@windriver.com>
[sergey.senozhatsky@gmail.com: More descriptive commit message]
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 11d70fd15e706..52390f5a1db11 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2358,8 +2358,9 @@ void console_unlock(void)
 		printk_safe_enter_irqsave(flags);
 		raw_spin_lock(&logbuf_lock);
 		if (console_seq < log_first_seq) {
-			len = sprintf(text, "** %u printk messages dropped **\n",
-				      (unsigned)(log_first_seq - console_seq));
+			len = sprintf(text,
+				      "** %llu printk messages dropped **\n",
+				      log_first_seq - console_seq);
 
 			/* messages are gone, move to first one */
 			console_seq = log_first_seq;
-- 
2.20.1


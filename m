Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D609E106DA0
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730659AbfKVLBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:01:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:54822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731220AbfKVLBm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:01:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80B1A20679;
        Fri, 22 Nov 2019 11:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420502;
        bh=KyMv468KYUxa0zlBPzJSuBJ/C6Qe6r6JSM8MqWf4Ufw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tj0wquWCTL3z/5ztb79/H7p/VmAvhTucVeWYnTmCRjnKG1sovW8cd8AmNFNgyIdz/
         MYQpl/rL9yc3dyhO2kvviD8v0zasxaNAjRljGUOP2qlFJgwgJ7EeOxgkFD9ltJdXPE
         YfUPO/gy7UKBmzq5yMsftAE3o0hjEVn8A7f4ltQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, rostedt@goodmis.org,
        He Zhe <zhe.he@windriver.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 121/220] printk: Correct wrong casting
Date:   Fri, 22 Nov 2019 11:28:06 +0100
Message-Id: <20191122100921.440779527@linuxfoundation.org>
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




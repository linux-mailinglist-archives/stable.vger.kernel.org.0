Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3E245C048
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345484AbhKXNGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:06:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345470AbhKXNEn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:04:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BEF361A04;
        Wed, 24 Nov 2021 12:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757429;
        bh=ba7OJ5zJD3+qN5ry1QYNEeab3gpRjeaTarwoS8KfAUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OyCgk6CIq092+Fkf3nD7Urhcgyg2C9kpSPzE0065dq0DNxfZ+PUgoj3suRACBQFmM
         d3cCRsrEbqz/1B2ZXqoPlVCAszJcSXSWlWRG2QkNoY/jhVDj+yYirOpQLkHam0Bchv
         Xk1W53cOs2NlxSgQhPzQFjB3WcJDRj4Jz+8ipGMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 166/323] samples/kretprobes: Fix return value if register_kretprobe() failed
Date:   Wed, 24 Nov 2021 12:55:56 +0100
Message-Id: <20211124115724.548321941@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit f76fbbbb5061fe14824ba5807c44bd7400a6b4e1 ]

Use the actual return value instead of always -1 if register_kretprobe()
failed.

E.g. without this patch:

 # insmod samples/kprobes/kretprobe_example.ko func=no_such_func
 insmod: ERROR: could not insert module samples/kprobes/kretprobe_example.ko: Operation not permitted

With this patch:

 # insmod samples/kprobes/kretprobe_example.ko func=no_such_func
 insmod: ERROR: could not insert module samples/kprobes/kretprobe_example.ko: Unknown symbol in module

Link: https://lkml.kernel.org/r/1635213091-24387-2-git-send-email-yangtiezhu@loongson.cn

Fixes: 804defea1c02 ("Kprobes: move kprobe examples to samples/")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/kprobes/kretprobe_example.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/kprobes/kretprobe_example.c b/samples/kprobes/kretprobe_example.c
index 7f9060f435cde..da6de5e78e1dd 100644
--- a/samples/kprobes/kretprobe_example.c
+++ b/samples/kprobes/kretprobe_example.c
@@ -83,7 +83,7 @@ static int __init kretprobe_init(void)
 	ret = register_kretprobe(&my_kretprobe);
 	if (ret < 0) {
 		pr_err("register_kretprobe failed, returned %d\n", ret);
-		return -1;
+		return ret;
 	}
 	pr_info("Planted return probe at %s: %p\n",
 			my_kretprobe.kp.symbol_name, my_kretprobe.kp.addr);
-- 
2.33.0




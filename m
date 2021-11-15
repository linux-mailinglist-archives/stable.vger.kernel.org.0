Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAB8450C07
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237830AbhKOReO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:34:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:46318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237806AbhKORah (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:30:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42CEB63299;
        Mon, 15 Nov 2021 17:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996795;
        bh=K4OC+GFHNE+vC1MJC5EXizHinVBDZ0GzWi5GjwmikeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rLNgqDhoXznlhKsWTtGOUZouTVLJhCXO7OunzkOXBrmz7ZHgGtWFfOAgnxnmqUDDZ
         J+VRYCzlH6xg6KXi5gxFQE4E8oCmo3+Eku9XTbSIbGhmWfo9ait9MzcguVegN4YsIn
         xapaqusnuGP8Sfd5LD4NhuUMLAC4Mz6/DkZja9q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 243/355] samples/kretprobes: Fix return value if register_kretprobe() failed
Date:   Mon, 15 Nov 2021 18:02:47 +0100
Message-Id: <20211115165321.605344217@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index 186315ca88b3f..2701549ee7b3a 100644
--- a/samples/kprobes/kretprobe_example.c
+++ b/samples/kprobes/kretprobe_example.c
@@ -84,7 +84,7 @@ static int __init kretprobe_init(void)
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




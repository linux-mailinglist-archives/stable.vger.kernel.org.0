Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E552B452663
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243231AbhKPCFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:05:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239954AbhKOSFL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3863632F8;
        Mon, 15 Nov 2021 17:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998039;
        bh=ihWfijKLHM+esI8o/vDEhqnlAAvHt+1vj5G5EN490Ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P5AkKnPiDTEoVHH6eDgk2DlDbk7cQI0ebednzJpkpun2TOAxepzBILJzWkfjM1TyI
         N6FiztqtRml4iYdnVx05g9g+7hR12HuQokXUWEgXyV9xioxU206grE9hwC9P5cYusc
         Hkti17HdsyWJFDbMMb9xZTAmbBAH17HMQ0El7f1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 366/575] samples/kretprobes: Fix return value if register_kretprobe() failed
Date:   Mon, 15 Nov 2021 18:01:31 +0100
Message-Id: <20211115165356.457903337@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 5dc1bf3baa98b..228321ecb1616 100644
--- a/samples/kprobes/kretprobe_example.c
+++ b/samples/kprobes/kretprobe_example.c
@@ -86,7 +86,7 @@ static int __init kretprobe_init(void)
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




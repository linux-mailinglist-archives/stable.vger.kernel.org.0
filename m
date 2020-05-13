Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36121D0D49
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387695AbgEMJvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:51:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387682AbgEMJvo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:51:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FD3920740;
        Wed, 13 May 2020 09:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363503;
        bh=iFVVwAqZMv4HlYQB0z0yB9f1G91U1CY+wl1KJSWMZog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YCza4XslP8mBHJzXN2x3lB8w1Za5xKzj098lXNY1KQGA2PoHSLVpr6r4qLMI0Lwi+
         NheZBBSImeEK3EQurE8yXXXO0ampvTe1CsmhYygaoMhfYzITGejuo9oL7hvFz68fg0
         Zv38lzpDGdd7/EidbNwgggy4i7GFNCmXnJWTOrbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 011/118] tracing/kprobes: Fix a double initialization typo
Date:   Wed, 13 May 2020 11:43:50 +0200
Message-Id: <20200513094418.661114296@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit dcbd21c9fca5e954fd4e3d91884907eb6d47187e ]

Fix a typo that resulted in an unnecessary double
initialization to addr.

Link: http://lkml.kernel.org/r/158779374968.6082.2337484008464939919.stgit@devnote2

Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Fixes: c7411a1a126f ("tracing/kprobe: Check whether the non-suffixed symbol is notrace")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_kprobe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index d0568af4a0ef6..0d9300c3b0846 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -453,7 +453,7 @@ static bool __within_notrace_func(unsigned long addr)
 
 static bool within_notrace_func(struct trace_kprobe *tk)
 {
-	unsigned long addr = addr = trace_kprobe_address(tk);
+	unsigned long addr = trace_kprobe_address(tk);
 	char symname[KSYM_NAME_LEN], *p;
 
 	if (!__within_notrace_func(addr))
-- 
2.20.1




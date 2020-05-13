Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302081D0CFF
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733200AbgEMJtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732597AbgEMJtN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:49:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C483520575;
        Wed, 13 May 2020 09:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363353;
        bh=Yu4TcK9D+DpQamB7b26U8i2tsNUfEJ3iL6TdNQu6NYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iz6etKBzXD6Z2Du7Sao6gSZrDRxXtjI/ip2r/0UNIcNzdDPk4UpU4Ng7Bw5cUx7qg
         rFgGlYUENVgxGscMjG/JIY1Q5sTQGOd+2i1XLDW6x55He/tTvEuQZLkUeV4OK4V/Xi
         Hd0w5AiWWpsHJmdT/7jyPB7yBbSAUOxAeu1FYLhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/90] tracing/kprobes: Fix a double initialization typo
Date:   Wed, 13 May 2020 11:44:00 +0200
Message-Id: <20200513094409.531117166@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
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
index 2f0f7fcee73e6..fba4b48451f6c 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -454,7 +454,7 @@ static bool __within_notrace_func(unsigned long addr)
 
 static bool within_notrace_func(struct trace_kprobe *tk)
 {
-	unsigned long addr = addr = trace_kprobe_address(tk);
+	unsigned long addr = trace_kprobe_address(tk);
 	char symname[KSYM_NAME_LEN], *p;
 
 	if (!__within_notrace_func(addr))
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECA4B137F1B
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbgAKKQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:16:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:60232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729229AbgAKKQp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:16:45 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7F442084D;
        Sat, 11 Jan 2020 10:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737804;
        bh=pIeuKxBRNWzEaQmzxMydhump/5ZTA/GnZiBi09gGPqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ng/yEpDyMS9GE5v8iQ7cb9Btm+V6PqsV6rGMqHZXxe9QGdNmonQ33BLeWZKPnRct
         uNTzjdYQxHeKZz7OlcwVWsaK3wckg4eGlEBEOiP7Xn64zScrIsrMPXRrroY/nM9fnw
         lSd/Xcx57c5ZlY/6jnESEzWmfE5+9emDZQWfJGLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Daniel T. Lee" <danieltimlee@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 31/84] samples: bpf: Replace symbol compare of trace_event
Date:   Sat, 11 Jan 2020 10:50:08 +0100
Message-Id: <20200111094857.969838944@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel T. Lee <danieltimlee@gmail.com>

[ Upstream commit bba1b2a890253528c45aa66cf856f289a215bfbc ]

Previously, when this sample is added, commit 1c47910ef8013
("samples/bpf: add perf_event+bpf example"), a symbol 'sys_read' and
'sys_write' has been used without no prefixes. But currently there are
no exact symbols with these under kallsyms and this leads to failure.

This commit changes exact compare to substring compare to keep compatible
with exact symbol or prefixed symbol.

Fixes: 1c47910ef8013 ("samples/bpf: add perf_event+bpf example")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20191205080114.19766-2-danieltimlee@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/trace_event_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/trace_event_user.c b/samples/bpf/trace_event_user.c
index d08046ab81f0..d33022447d6b 100644
--- a/samples/bpf/trace_event_user.c
+++ b/samples/bpf/trace_event_user.c
@@ -35,9 +35,9 @@ static void print_ksym(__u64 addr)
 		return;
 	sym = ksym_search(addr);
 	printf("%s;", sym->name);
-	if (!strcmp(sym->name, "sys_read"))
+	if (!strstr(sym->name, "sys_read"))
 		sys_read_seen = true;
-	else if (!strcmp(sym->name, "sys_write"))
+	else if (!strstr(sym->name, "sys_write"))
 		sys_write_seen = true;
 }
 
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1347C3CE5EC
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242662AbhGSPzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350478AbhGSPvE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:51:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89C5A61002;
        Mon, 19 Jul 2021 16:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712182;
        bh=pEpzXsLiEDb0yqp74RXrXBOkd57v70QiF7gA4fYfv1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0X1NfsL4snpFJWtIomcAkmFRsBgRUcLt8wDdMXBbhPi214Y8Xcqvs0o91hwiGVtoV
         mFS0biLjbWHcoa0qgZdLG7lvMM4wMbPRFkF2/NHQlP3EAs9sE0QMyHCr5SSOebilMA
         LdW0WMMkcyKCIUVx26+YQA6fgLunmTq32Zp9RDZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 281/292] static_call: Fix static_call_text_reserved() vs __init
Date:   Mon, 19 Jul 2021 16:55:43 +0200
Message-Id: <20210719144952.156996705@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 2bee6d16e4379326b1eea454e68c98b17456769e ]

It turns out that static_call_text_reserved() was reporting __init
text as being reserved past the time when the __init text was freed
and re-used.

This is mostly harmless and will at worst result in refusing a kprobe.

Fixes: 6333e8f73b83 ("static_call: Avoid kprobes on inline static_call()s")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/20210628113045.106211657@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/static_call.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/static_call.c b/kernel/static_call.c
index 2c5950b0b90e..7eba4912e529 100644
--- a/kernel/static_call.c
+++ b/kernel/static_call.c
@@ -292,13 +292,15 @@ static int addr_conflict(struct static_call_site *site, void *start, void *end)
 
 static int __static_call_text_reserved(struct static_call_site *iter_start,
 				       struct static_call_site *iter_stop,
-				       void *start, void *end)
+				       void *start, void *end, bool init)
 {
 	struct static_call_site *iter = iter_start;
 
 	while (iter < iter_stop) {
-		if (addr_conflict(iter, start, end))
-			return 1;
+		if (init || !static_call_is_init(iter)) {
+			if (addr_conflict(iter, start, end))
+				return 1;
+		}
 		iter++;
 	}
 
@@ -324,7 +326,7 @@ static int __static_call_mod_text_reserved(void *start, void *end)
 
 	ret = __static_call_text_reserved(mod->static_call_sites,
 			mod->static_call_sites + mod->num_static_call_sites,
-			start, end);
+			start, end, mod->state == MODULE_STATE_COMING);
 
 	module_put(mod);
 
@@ -459,8 +461,9 @@ static inline int __static_call_mod_text_reserved(void *start, void *end)
 
 int static_call_text_reserved(void *start, void *end)
 {
+	bool init = system_state < SYSTEM_RUNNING;
 	int ret = __static_call_text_reserved(__start_static_call_sites,
-			__stop_static_call_sites, start, end);
+			__stop_static_call_sites, start, end, init);
 
 	if (ret)
 		return ret;
-- 
2.30.2




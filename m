Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA1B3CE3C2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239913AbhGSPk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349648AbhGSPgE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:36:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AABEF61002;
        Mon, 19 Jul 2021 16:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711404;
        bh=qyNdRp9MHvsVnvAPETPEHeTbEufKz/opIo64pUZzVQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZUxeZwm0gw4PTsZ9d3CxaqI0bPPqANbinsDsNFjvDYyRWOvIzqobPbf/sNMRQF3n
         YKw4UyF2daKDg7W+DvJCn9sNKG78Wopo89duPtBJYpbOx9Tbsn2/3LtOJX1yu2VqV1
         1s2ShQtWRJ5Vvwgbo/m5fQ5NQnG3BmBZpWVD1MLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 340/351] static_call: Fix static_call_text_reserved() vs __init
Date:   Mon, 19 Jul 2021 16:54:46 +0200
Message-Id: <20210719144956.314560565@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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
index 723fcc9d20db..43ba0b1e0edb 100644
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




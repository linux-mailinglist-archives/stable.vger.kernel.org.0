Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEEDF3CE3BE
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344214AbhGSPk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349619AbhGSPgD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:36:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5301360FD7;
        Mon, 19 Jul 2021 16:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711401;
        bh=SYcAa8TmYSdGlsuEkk+9WtZsakEIO1w3XEBxp7uFzis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06Bdx6TMAOGJe0PaOR2RSj+s8bx+XqLOBLMFDy/qumBIVVyZFJ/JWPkf++IUORSfD
         1oUmusRT0f3qr4Xot0JXfUMf1KQt0lbIYhl4G4kRZvVKB1xMmc/KXPpTLmTcwY+I/s
         zg8YflhgbHE9VjbONPWRElSu0/Cuo1mnpesg2s3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 339/351] jump_label: Fix jump_label_text_reserved() vs __init
Date:   Mon, 19 Jul 2021 16:54:45 +0200
Message-Id: <20210719144956.282317813@linuxfoundation.org>
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

[ Upstream commit 9e667624c291753b8a5128f620f493d0b5226063 ]

It turns out that jump_label_text_reserved() was reporting __init text
as being reserved past the time when the __init text was freed and
re-used.

For a long time, this resulted in, at worst, not being able to kprobe
text that happened to land at the re-used address. However a recent
commit e7bf1ba97afd ("jump_label, x86: Emit short JMP") made it a
fatal mistake because it now needs to read the instruction in order to
determine the conflict -- an instruction that's no longer there.

Fixes: 4c3ef6d79328 ("jump label: Add jump_label_text_reserved() to reserve jump points")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/20210628113045.045141693@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/jump_label.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index ba39fbb1f8e7..af520ca26360 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -316,14 +316,16 @@ static int addr_conflict(struct jump_entry *entry, void *start, void *end)
 }
 
 static int __jump_label_text_reserved(struct jump_entry *iter_start,
-		struct jump_entry *iter_stop, void *start, void *end)
+		struct jump_entry *iter_stop, void *start, void *end, bool init)
 {
 	struct jump_entry *iter;
 
 	iter = iter_start;
 	while (iter < iter_stop) {
-		if (addr_conflict(iter, start, end))
-			return 1;
+		if (init || !jump_entry_is_init(iter)) {
+			if (addr_conflict(iter, start, end))
+				return 1;
+		}
 		iter++;
 	}
 
@@ -561,7 +563,7 @@ static int __jump_label_mod_text_reserved(void *start, void *end)
 
 	ret = __jump_label_text_reserved(mod->jump_entries,
 				mod->jump_entries + mod->num_jump_entries,
-				start, end);
+				start, end, mod->state == MODULE_STATE_COMING);
 
 	module_put(mod);
 
@@ -786,8 +788,9 @@ early_initcall(jump_label_init_module);
  */
 int jump_label_text_reserved(void *start, void *end)
 {
+	bool init = system_state < SYSTEM_RUNNING;
 	int ret = __jump_label_text_reserved(__start___jump_table,
-			__stop___jump_table, start, end);
+			__stop___jump_table, start, end, init);
 
 	if (ret)
 		return ret;
-- 
2.30.2




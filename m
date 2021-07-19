Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7BB3CE187
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239720AbhGSP0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:26:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348085AbhGSPYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05ACE61422;
        Mon, 19 Jul 2021 16:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710488;
        bh=bzAJFaqA633qEJK6/CJXsDy9zhJaM2uv59iOV6xizyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rohONbfbyl2HOdYUpDkkqrWZExtBc+c7FBknZ7uUauCTiyx0OlZ9yPJ6ZxpZHRArM
         51bpEwyYsrFXYt+Hrpw5sGoeLCVqG0u+gmQ5wIsJGp3KaoPrMHRn6W8fhhs2DczKRS
         F3tr6dwoTd+ka386N1DeDEbCh5hq6R9OA4ox/BwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 237/243] jump_label: Fix jump_label_text_reserved() vs __init
Date:   Mon, 19 Jul 2021 16:54:26 +0200
Message-Id: <20210719144948.573397991@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
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
index a0c325664190..4ae693ce71a4 100644
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9BD4D617
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfFTSEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:04:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbfFTSEI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:04:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 758E021655;
        Thu, 20 Jun 2019 18:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053848;
        bh=ehFxs3Y45qn6MCgbminxHnbEpP6fju9VVBe5cF608wM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tyE7CylkDmmahxTqn3OHqFUlDlPJ9YnRl/6P1B3g4Blb9WW3NQxabMBDIdxnlFpBd
         MCYeWeFeG9xiSixOYpRF9DyFEnx6Q5dxYg05Jnyz9UkVhdbrSYKqegRCV2xVA1YJfq
         8GKBC2843LhqrtAQ3lpo2Kp6q+7J0lWFZrmx/ZTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 018/117] objtool: Dont use ignore flag for fake jumps
Date:   Thu, 20 Jun 2019 19:55:52 +0200
Message-Id: <20190620174353.083911305@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
References: <20190620174351.964339809@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e6da9567959e164f82bc81967e0d5b10dee870b4 ]

The ignore flag is set on fake jumps in order to keep
add_jump_destinations() from setting their jump_dest, since it already
got set when the fake jump was created.

But using the ignore flag is a bit of a hack.  It's normally used to
skip validation of an instruction, which doesn't really make sense for
fake jumps.

Also, after the next patch, using the ignore flag for fake jumps can
trigger a false "why am I validating an ignored function?" warning.

Instead just add an explicit check in add_jump_destinations() to skip
fake jumps.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/71abc072ff48b2feccc197723a9c52859476c068.1557766718.git.jpoimboe@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index ae3446768181..95326c6a7a24 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -28,6 +28,8 @@
 #include <linux/hashtable.h>
 #include <linux/kernel.h>
 
+#define FAKE_JUMP_OFFSET -1
+
 struct alternative {
 	struct list_head list;
 	struct instruction *insn;
@@ -498,7 +500,7 @@ static int add_jump_destinations(struct objtool_file *file)
 		    insn->type != INSN_JUMP_UNCONDITIONAL)
 			continue;
 
-		if (insn->ignore)
+		if (insn->ignore || insn->offset == FAKE_JUMP_OFFSET)
 			continue;
 
 		rela = find_rela_by_dest_range(insn->sec, insn->offset,
@@ -645,10 +647,10 @@ static int handle_group_alt(struct objtool_file *file,
 		clear_insn_state(&fake_jump->state);
 
 		fake_jump->sec = special_alt->new_sec;
-		fake_jump->offset = -1;
+		fake_jump->offset = FAKE_JUMP_OFFSET;
 		fake_jump->type = INSN_JUMP_UNCONDITIONAL;
 		fake_jump->jump_dest = list_next_entry(last_orig_insn, list);
-		fake_jump->ignore = true;
+		fake_jump->func = orig_insn->func;
 	}
 
 	if (!special_alt->new_len) {
-- 
2.20.1




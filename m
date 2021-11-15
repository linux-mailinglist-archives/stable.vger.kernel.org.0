Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4424526C9
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347751AbhKPCKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:10:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:40726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239024AbhKOR7Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:59:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F201063337;
        Mon, 15 Nov 2021 17:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997764;
        bh=D5hL3oal0REvlv5f4yXlWGTwz3d2vr/JPHiuTOcw/Rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jeJFcCj2Jv8B+oeZGV2zzKy0ZWY4J50g30k1+FLXDMYJWGjx/mItArpoMl4Oq+OVO
         3Iv4jFlD85VHg9bckmgelrOm/NXgrKajtyIOHnqdY5aA1sNQ5g1+wlqIWynUG0dD7J
         X/yobhFkPSvF9/HASNeESZDKj77PREHAF3RfG6N4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 267/575] objtool: Fix static_call list generation
Date:   Mon, 15 Nov 2021 17:59:52 +0100
Message-Id: <20211115165353.010577069@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit a958c4fea768d2c378c89032ab41d38da2a24422 ]

Currently, objtool generates tail call entries in add_jump_destination()
but waits until validate_branch() to generate the regular call entries.
Move these to add_call_destination() for consistency.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Link: https://lkml.kernel.org/r/20210326151259.691529901@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 4261f93ce06f9..8932f41c387ff 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -954,6 +954,11 @@ static int add_call_destinations(struct objtool_file *file)
 		} else
 			insn->call_dest = reloc->sym;
 
+		if (insn->call_dest && insn->call_dest->static_call_tramp) {
+			list_add_tail(&insn->static_call_node,
+				      &file->static_call_list);
+		}
+
 		/*
 		 * Many compilers cannot disable KCOV with a function attribute
 		 * so they need a little help, NOP out any KCOV calls from noinstr
@@ -1668,6 +1673,9 @@ static int decode_sections(struct objtool_file *file)
 	if (ret)
 		return ret;
 
+	/*
+	 * Must be before add_{jump_call}_destination.
+	 */
 	ret = read_static_call_tramps(file);
 	if (ret)
 		return ret;
@@ -1680,6 +1688,10 @@ static int decode_sections(struct objtool_file *file)
 	if (ret)
 		return ret;
 
+	/*
+	 * Must be before add_call_destination(); it changes INSN_CALL to
+	 * INSN_JUMP.
+	 */
 	ret = read_intra_function_calls(file);
 	if (ret)
 		return ret;
@@ -2534,11 +2546,6 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 			if (dead_end_function(file, insn->call_dest))
 				return 0;
 
-			if (insn->type == INSN_CALL && insn->call_dest->static_call_tramp) {
-				list_add_tail(&insn->static_call_node,
-					      &file->static_call_list);
-			}
-
 			break;
 
 		case INSN_JUMP_CONDITIONAL:
-- 
2.33.0




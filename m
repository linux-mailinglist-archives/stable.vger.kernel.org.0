Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C683289A5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238663AbhCASBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:01:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236811AbhCARyI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:54:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C757C64F95;
        Mon,  1 Mar 2021 17:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619069;
        bh=9TAtc3AALJ+x24LXjdljtfOseMQZUmjCax3PlP1uWbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xakicuarfgxmuP4clAcNj9jJD5kAnw/d9LIcNInIQIe7PgpyqWjgycWVq6cGIk6go
         37tw7JTpUs3fReMRMovMbR9Zo3TQ2B+jiRxyZcfsq2gGeHLvqV8t+iwYrEQ4rHyDMX
         PKMmjPqJaGZJk/BTCeSUD6RWwEn21y7s8OFO8uKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 320/663] objtool: Fix ".cold" section suffix check for newer versions of GCC
Date:   Mon,  1 Mar 2021 17:09:28 +0100
Message-Id: <20210301161157.687094804@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit 34ca59e109bdf69704c33b8eeffaa4c9f71076e5 ]

With my version of GCC 9.3.1 the ".cold" subfunctions no longer have a
numbered suffix, so the trailing period is no longer there.

Presumably this doesn't yet trigger a user-visible bug since most of the
subfunction detection logic is duplicated.   I only found it when
testing vmlinux.o validation.

Fixes: 54262aa28301 ("objtool: Fix sibling call detection")
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/ca0b5a57f08a2fbb48538dd915cc253b5edabb40.1611263461.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 48e22e3c6f186..dc24aac08edd6 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -850,8 +850,8 @@ static int add_jump_destinations(struct objtool_file *file)
 			 * case where the parent function's only reference to a
 			 * subfunction is through a jump table.
 			 */
-			if (!strstr(insn->func->name, ".cold.") &&
-			    strstr(insn->jump_dest->func->name, ".cold.")) {
+			if (!strstr(insn->func->name, ".cold") &&
+			    strstr(insn->jump_dest->func->name, ".cold")) {
 				insn->func->cfunc = insn->jump_dest->func;
 				insn->jump_dest->func->pfunc = insn->func;
 
-- 
2.27.0




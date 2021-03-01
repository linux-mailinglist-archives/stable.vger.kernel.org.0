Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0D6328CD4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240465AbhCAS7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:59:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:58014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240458AbhCASxu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:53:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6A48650D5;
        Mon,  1 Mar 2021 17:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621061;
        bh=uP7mQNgwM7Rbwp/Ix+ydTucyo811l6od4IsmZCIrln8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=No28HAgVWr4HxUzt+UilebUWaJg/1eZBpLgJtmxSDpKXPCzNF62S+k9IUwD+dNO3K
         kdUc6YDrDFFR4gZUEbNCiw3aJdcR/g0F1yp0HdX8qH9sNt88UxL8GWEi0fSaqdv4W+
         IYTGqb1ctNLcxoVZHxx/9G8O5cevJ3GdHAIAPLXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 380/775] objtool: Fix error handling for STD/CLD warnings
Date:   Mon,  1 Mar 2021 17:09:08 +0100
Message-Id: <20210301161220.382803906@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit 6f567c9300a5ebd7b18c26dda1c8d6ffbdd0debd ]

Actually return an error (and display a backtrace, if requested) for
directional bit warnings.

Fixes: 2f0f9e9ad7b3 ("objtool: Add Direction Flag validation")
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/dc70f2adbc72f09526f7cab5b6feb8bf7f6c5ad4.1611263461.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 4bd30315eb62b..2e154f00ccec2 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2592,15 +2592,19 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 			break;
 
 		case INSN_STD:
-			if (state.df)
+			if (state.df) {
 				WARN_FUNC("recursive STD", sec, insn->offset);
+				return 1;
+			}
 
 			state.df = true;
 			break;
 
 		case INSN_CLD:
-			if (!state.df && func)
+			if (!state.df && func) {
 				WARN_FUNC("redundant CLD", sec, insn->offset);
+				return 1;
+			}
 
 			state.df = false;
 			break;
-- 
2.27.0




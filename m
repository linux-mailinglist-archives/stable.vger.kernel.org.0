Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3EF5328CB1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235339AbhCAS50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:57:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:57862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240505AbhCASvl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:51:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5289B651D9;
        Mon,  1 Mar 2021 17:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619063;
        bh=uP7mQNgwM7Rbwp/Ix+ydTucyo811l6od4IsmZCIrln8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPNYyNspdgriYo5/WQXLeZ60Zb8tbyf+f3x/8+i3I7QQmncBDJOZVXRXVAcVaFlVF
         gHwF6Nhyx6Jt2pi5+eZ1VRRN9wFeq+w8dle4Rwh+VWw26X/QUNnvy29eWOxqmxcrlT
         ztgU/N1SBBasHAdhVzY5xWpzB8ogTVJfF4uQSGtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 318/663] objtool: Fix error handling for STD/CLD warnings
Date:   Mon,  1 Mar 2021 17:09:26 +0100
Message-Id: <20210301161157.586030420@linuxfoundation.org>
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




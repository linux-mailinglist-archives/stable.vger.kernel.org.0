Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843B134C813
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbhC2ITg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:19:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232939AbhC2ITD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:19:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7492261580;
        Mon, 29 Mar 2021 08:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005942;
        bh=0m4JfSlrMTrCVvzYnSKX7M8SxB0GrqoW95y4dwsWLus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NCAyQgTKQtxB5C9cMwL1HSNeFvzmyEwP2Qh+8VcYQDQ6KG4m/5Pq++ALhQEYjbJD2
         RKF8IDHBQ7Dbx2c9FSviJOV4RgzaCRfIMZvOBejkeA12aD0V5rz8FBCmMcWqHYfP3V
         v+UNDre3gnt/+eYTAFZs5d4EP4j0TA4dInpfzg+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/221] static_call: Fix the module key fixup
Date:   Mon, 29 Mar 2021 09:56:30 +0200
Message-Id: <20210329075631.160677004@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 50bf8080a94d171e843fc013abec19d8ab9f50ae ]

Provided the target address of a R_X86_64_PC32 relocation is aligned,
the low two bits should be invariant between the relative and absolute
value.

Turns out the address is not aligned and things go sideways, ensure we
transfer the bits in the absolute form when fixing up the key address.

Fixes: 73f44fe19d35 ("static_call: Allow module use without exposing static_call_key")
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Link: https://lkml.kernel.org/r/20210225220351.GE4746@worktop.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/static_call.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/static_call.c b/kernel/static_call.c
index db64c2331a32..5d53c354fbe7 100644
--- a/kernel/static_call.c
+++ b/kernel/static_call.c
@@ -358,7 +358,8 @@ static int static_call_add_module(struct module *mod)
 	struct static_call_site *site;
 
 	for (site = start; site != stop; site++) {
-		unsigned long addr = (unsigned long)static_call_key(site);
+		unsigned long s_key = (long)site->key + (long)&site->key;
+		unsigned long addr = s_key & ~STATIC_CALL_SITE_FLAGS;
 		unsigned long key;
 
 		/*
@@ -382,8 +383,8 @@ static int static_call_add_module(struct module *mod)
 			return -EINVAL;
 		}
 
-		site->key = (key - (long)&site->key) |
-			    (site->key & STATIC_CALL_SITE_FLAGS);
+		key |= s_key & STATIC_CALL_SITE_FLAGS;
+		site->key = key - (long)&site->key;
 	}
 
 	return __static_call_init(mod, start, stop);
-- 
2.30.1




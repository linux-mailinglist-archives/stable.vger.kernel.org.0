Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9894526C2
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346526AbhKPCKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:10:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:40776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239110AbhKOR7Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:59:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B827632D3;
        Mon, 15 Nov 2021 17:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997761;
        bh=jeAAO9N6FU/lIk0v0Qimw6nQJ9ETI49fXE16TPPI/5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKahGOFbRj2O2boN9QAnTJrK2VAezTGmcCemM2Mp34aRvSADGwG8mp3XTlfseCWCj
         LXwENXbs1xrn7qI2paxZcUL4LEC+W335I1JHNXP6uxbQClKc8MoEwDLqcCC4CHVZyy
         jgXRkTYLX4hgyBogN3gXkute2t1rN80ij6/MHjKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 266/575] x86/xen: Mark cpu_bringup_and_idle() as dead_end_function
Date:   Mon, 15 Nov 2021 17:59:51 +0100
Message-Id: <20211115165352.971461860@linuxfoundation.org>
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

[ Upstream commit 9af9dcf11bda3e2c0e24c1acaacb8685ad974e93 ]

The asm_cpu_bringup_and_idle() function is required to push the return
value on the stack in order to make ORC happy, but the only reason
objtool doesn't complain is because of a happy accident.

The thing is that asm_cpu_bringup_and_idle() doesn't return, so
validate_branch() never terminates and falls through to the next
function, which in the normal case is the hypercall_page. And that, as
it happens, is 4095 NOPs and a RET.

Make asm_cpu_bringup_and_idle() terminate on it's own, by making the
function it calls as a dead-end. This way we no longer rely on what
code happens to come after.

Fixes: c3881eb58d56 ("x86/xen: Make the secondary CPU idle tasks reliable")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Link: https://lore.kernel.org/r/20210624095147.693801717@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index ec15cadbb3d3e..4261f93ce06f9 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -157,6 +157,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"rewind_stack_do_exit",
 		"kunit_try_catch_throw",
 		"xen_start_kernel",
+		"cpu_bringup_and_idle",
 	};
 
 	if (!func)
-- 
2.33.0




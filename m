Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301073F642C
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238999AbhHXRBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:01:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239165AbhHXQ76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:59:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9812A6140A;
        Tue, 24 Aug 2021 16:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824261;
        bh=jwqYVBow9G6nf7rTcPp76Tf4HgpwpHAd+aTJm5i6OUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5QPcuFiZ34fK2rbM1YpBd6ULykv0mML2DSohqA+DBEKUerwyaclBcoXaFxQcdjpe
         yMAsUW6rNzEj8Y1N9RiLIm79I372TIzCxT2RDgheCGqxXgZJObTv2LVcU/8WYatYq6
         5szNuFOFClXxAcsUVCg3bcn9hQBYO34f+7t7wmrirYbHz+S+9FZt/L8UPpIsMvlWY+
         EQdknLuezbL5c2yAkSCwmV7DifQ/134Xb4lnXgzwpsgylUCoqb9wTRV2t9C/7iToDt
         DRdBOCYnUBOCrmLDL13hj5HdPQc9I7KKfphF3bMk11cytqqBRXnO6LWDzXWvnTdlbT
         n3OER5TLuMzWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 094/127] tracing: define needed config DYNAMIC_FTRACE_WITH_ARGS
Date:   Tue, 24 Aug 2021 12:55:34 -0400
Message-Id: <20210824165607.709387-95-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

[ Upstream commit 12f9951d3f311acb1d4ffe8e839bc2c07983546f ]

Commit 2860cd8a2353 ("livepatch: Use the default ftrace_ops instead of
REGS when ARGS is available") intends to enable config LIVEPATCH when
ftrace with ARGS is available. However, the chain of configs to enable
LIVEPATCH is incomplete, as HAVE_DYNAMIC_FTRACE_WITH_ARGS is available,
but the definition of DYNAMIC_FTRACE_WITH_ARGS, combining DYNAMIC_FTRACE
and HAVE_DYNAMIC_FTRACE_WITH_ARGS, needed to enable LIVEPATCH, is missing
in the commit.

Fortunately, ./scripts/checkkconfigsymbols.py detects this and warns:

DYNAMIC_FTRACE_WITH_ARGS
Referencing files: kernel/livepatch/Kconfig

So, define the config DYNAMIC_FTRACE_WITH_ARGS analogously to the already
existing similar configs, DYNAMIC_FTRACE_WITH_REGS and
DYNAMIC_FTRACE_WITH_DIRECT_CALLS, in ./kernel/trace/Kconfig to connect the
chain of configs.

Link: https://lore.kernel.org/kernel-janitors/CAKXUXMwT2zS9fgyQHKUUiqo8ynZBdx2UEUu1WnV_q0OCmknqhw@mail.gmail.com/
Link: https://lkml.kernel.org/r/20210806195027.16808-1-lukas.bulwahn@gmail.com

Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: stable@vger.kernel.org
Fixes: 2860cd8a2353 ("livepatch: Use the default ftrace_ops instead of REGS when ARGS is available")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 7fa82778c3e6..682334e018dd 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -219,6 +219,11 @@ config DYNAMIC_FTRACE_WITH_DIRECT_CALLS
 	depends on DYNAMIC_FTRACE_WITH_REGS
 	depends on HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
 
+config DYNAMIC_FTRACE_WITH_ARGS
+	def_bool y
+	depends on DYNAMIC_FTRACE
+	depends on HAVE_DYNAMIC_FTRACE_WITH_ARGS
+
 config FUNCTION_PROFILER
 	bool "Kernel function profiler"
 	depends on FUNCTION_TRACER
-- 
2.30.2


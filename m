Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC1A3E2FE3
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 21:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbhHFTvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 15:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbhHFTvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 15:51:00 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F122BC0613CF;
        Fri,  6 Aug 2021 12:50:42 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id n12so2364675wrr.2;
        Fri, 06 Aug 2021 12:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7O3R+/YLffFIYvFcx+ISW6vN6f2/4fupamLlutQquIc=;
        b=c50ZRqd7ZJ6rDenkIu2zwLRWu610VC1kr2a2yRbI76WF7Ote8TGhdSFADq/5c50sOj
         d2rmnjr4Zl4jJm/bMbKe4V19IKJ340mNqZmMtTjiW+y/hXbWI6uL7tZyVeXBDjXnUTPb
         9N5lmDPxY74qUdW5DOzuPsX1DraD09dg3FU/mfLcXUfDefz/D4km6HWrjio+7btOe9jA
         VTPC55FP80lSZaOjnmG+QNCBx3tNIKuG2Jlq69+4UgvEtIf6i3OIjr7arnXdQUEP0Jsa
         WxKpMeWC6RD4yon3wE4dJlmGBy5TtNDqTAuVdonMVKAOHo9N8EtL2BqNY9NU29jl/O9m
         9SLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7O3R+/YLffFIYvFcx+ISW6vN6f2/4fupamLlutQquIc=;
        b=Rqu5aDbk6y9XQzuwmqlPFmSZkppjbJ7By3iXKJzQkH6jDEJEqKnD73uGcEhwNjXDCg
         aGK0GIGMjg4874cJGL9lM9N3sNm8d+3JzfF+aENqCk/yP3Svxm80nwXuhD5hKURcD4KR
         2+Vk12Ahxm5zquB4h0L59a3i1hY/fnGFbPrlcpoCsV97GdHrTt496UHz7ngOLws/DlJt
         CYyLyzQkXvY9t9rpCOVTdUIj0VPVyKpYnOieadL6UlbhTg5qN96yLh5pUQOG54/ltBrr
         a/v12VzSgHkXSO93LheOMVfquFiSanNjEcUBW87lIoXb/7mZ0cvy6PaE0eJ4TW3j5IUi
         sZBw==
X-Gm-Message-State: AOAM532k+KnJGDIovMQpDHYbzzDUbby4BazHq3d2eJJcForzzbuvItwO
        eoJevBxrxQpq9Mj1D5y1oiw=
X-Google-Smtp-Source: ABdhPJyVkry3+m5663VZZQh74vfTfSXLCzeg+mztE3FgXtryBM4F/fD+UDroRS8T07tJ8EED0JtNcw==
X-Received: by 2002:a5d:49c8:: with SMTP id t8mr12342235wrs.365.1628279441558;
        Fri, 06 Aug 2021 12:50:41 -0700 (PDT)
Received: from felia.fritz.box ([2001:16b8:2dc9:8d00:2198:3536:ca51:cd82])
        by smtp.gmail.com with ESMTPSA id y197sm13477902wmc.7.2021.08.06.12.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 12:50:41 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Miroslav Benes <mbenes@suse.cz>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] tracing: define needed config DYNAMIC_FTRACE_WITH_ARGS
Date:   Fri,  6 Aug 2021 21:50:27 +0200
Message-Id: <20210806195027.16808-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Fixes: 2860cd8a2353 ("livepatch: Use the default ftrace_ops instead of REGS when ARGS is available")
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---

Steven, thanks for the quick response; please pick this quick config fix.

 kernel/trace/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index d567b1717c4c..3ee23f4d437f 100644
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
2.17.1


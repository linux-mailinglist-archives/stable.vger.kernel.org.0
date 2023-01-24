Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F050E67A314
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 20:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbjAXTfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 14:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234311AbjAXTfY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 14:35:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B215FE8;
        Tue, 24 Jan 2023 11:35:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB8FFB81658;
        Tue, 24 Jan 2023 19:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B40C433A1;
        Tue, 24 Jan 2023 19:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674588920;
        bh=5Q9RH5AbJWZtGgmftwQz/FQpiCLe1j10EZBiFooZn74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pW8N4Ut3SLaSVFvlgBulTYOnf6gq6TZRxGXzEtE6LbR5ISq8QkH/pMExFG/gGA+X5
         94TFhVctfikTcAwdbWC+Oj9iesIp19vCgT+bnLcaBXcXcZyoUvU9aUJ6o5TTaxBeO1
         qKGAX2LNYj5g+vdSkaMOFC4n0MUXD6bdCPnbE/nNPzbdM7KTNnByUovK1SekjADuii
         d3pmN6xKGO9Dcstwdms/WkC5LhOCZWYNja+0hFWz2Tvl5gQaygi5gxiAR+whiPfObe
         lwp5AkZjFPnG9YxvaKO2Zq5oYqg5czKwdhTvHNdxTS9t3VKEnBbBptwoGbQWyjYSkN
         MJ1xZlpFRXhXQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Guo Ren <guoren@kernel.org>
Subject: [PATCH 5.10 10/20] csky: Fix function name in csky_alignment() and die()
Date:   Tue, 24 Jan 2023 11:29:54 -0800
Message-Id: <20230124193004.206841-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124193004.206841-1-ebiggers@kernel.org>
References: <20230124193004.206841-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 751971af2e3615dc5bd12674080bc795505fefeb upstream.

When building ARCH=csky defconfig:

arch/csky/kernel/traps.c: In function 'die':
arch/csky/kernel/traps.c:112:17: error: implicit declaration of function
'make_dead_task' [-Werror=implicit-function-declaration]
  112 |                 make_dead_task(SIGSEGV);
      |                 ^~~~~~~~~~~~~~

The function's name is make_task_dead(), change it so there is no more
build error.

Fixes: 0e25498f8cd4 ("exit: Add and use make_task_dead.")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Guo Ren <guoren@kernel.org>
Link: https://lkml.kernel.org/r/20211227184851.2297759-4-nathan@kernel.org
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/csky/abiv1/alignment.c | 2 +-
 arch/csky/kernel/traps.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/csky/abiv1/alignment.c b/arch/csky/abiv1/alignment.c
index 5e2fb45d605cf..2df115d0e2105 100644
--- a/arch/csky/abiv1/alignment.c
+++ b/arch/csky/abiv1/alignment.c
@@ -294,7 +294,7 @@ void csky_alignment(struct pt_regs *regs)
 				__func__, opcode, rz, rx, imm, addr);
 		show_regs(regs);
 		bust_spinlocks(0);
-		make_dead_task(SIGKILL);
+		make_task_dead(SIGKILL);
 	}
 
 	force_sig_fault(SIGBUS, BUS_ADRALN, (void __user *)addr);
diff --git a/arch/csky/kernel/traps.c b/arch/csky/kernel/traps.c
index 3c648305f2c30..15711efa14a4e 100644
--- a/arch/csky/kernel/traps.c
+++ b/arch/csky/kernel/traps.c
@@ -111,7 +111,7 @@ void die(struct pt_regs *regs, const char *str)
 	if (panic_on_oops)
 		panic("Fatal exception");
 	if (ret != NOTIFY_STOP)
-		make_dead_task(SIGSEGV);
+		make_task_dead(SIGSEGV);
 }
 
 void do_trap(struct pt_regs *regs, int signo, int code, unsigned long addr)
-- 
2.39.1


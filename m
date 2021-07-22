Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1D63D291C
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhGVQBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233880AbhGVP7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:59:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF9D6610CC;
        Thu, 22 Jul 2021 16:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972012;
        bh=9+IdieMSfv420ZSiFKtJD80BlLI/yvXbPJ3dZ5fX0fY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HioQ8w+uUSS+KRwWBKKTEYwel8l+oGoEJTj/Z4f91xyHVwkHlIpL4CCtcGdDM1ZQy
         OH/Lpp1quFnhn93gOEwzJ1a3QIvZ8ZGizc22izBTpqvHK8hKZS8Y4TeRSdvzRxGeE9
         9RH4zMB4YM4dAf+608INpBiJ8n4T1H8k/o2xhQ8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 112/125] kbuild: do not suppress Kconfig prompts for silent build
Date:   Thu, 22 Jul 2021 18:31:43 +0200
Message-Id: <20210722155628.439366123@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit d952cfaf0cffdbbb0433c67206b645131f17ca5f upstream.

When a new CONFIG option is available, Kbuild shows a prompt to get
the user input.

  $ make
  [ snip ]
  Core Scheduling for SMT (SCHED_CORE) [N/y/?] (NEW)

This is the only interactive place in the build process.

Commit 174a1dcc9642 ("kbuild: sink stdout from cmd for silent build")
suppressed Kconfig prompts as well because syncconfig is invoked by
the 'cmd' macro. You cannot notice the fact that Kconfig is waiting
for the user input.

Use 'kecho' to show the equivalent short log without suppressing stdout
from sub-make.

Fixes: 174a1dcc9642 ("kbuild: sink stdout from cmd for silent build")
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -704,11 +704,12 @@ $(KCONFIG_CONFIG):
 # This exploits the 'multi-target pattern rule' trick.
 # The syncconfig should be executed only once to make all the targets.
 # (Note: use the grouped target '&:' when we bump to GNU Make 4.3)
-quiet_cmd_syncconfig = SYNC    $@
-      cmd_syncconfig = $(MAKE) -f $(srctree)/Makefile syncconfig
-
+#
+# Do not use $(call cmd,...) here. That would suppress prompts from syncconfig,
+# so you cannot notice that Kconfig is waiting for the user input.
 %/config/auto.conf %/config/auto.conf.cmd %/generated/autoconf.h: $(KCONFIG_CONFIG)
-	+$(call cmd,syncconfig)
+	$(Q)$(kecho) "  SYNC    $@"
+	$(Q)$(MAKE) -f $(srctree)/Makefile syncconfig
 else # !may-sync-config
 # External modules and some install targets need include/generated/autoconf.h
 # and include/config/auto.conf but do not care if they are up-to-date.



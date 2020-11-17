Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D84A2B652C
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387606AbgKQNvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:51:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:39494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731863AbgKQNa0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:30:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89B7220781;
        Tue, 17 Nov 2020 13:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619825;
        bh=6eHn8nAKJXsNr4WwN8ijIbmWwkssilstN9Be98vSXbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPRLbM5Zhv+qtr83tbron4SbNDBkKCsqcEc8mqkKQOrYzfflsMhwXypEDH9gBjB0/
         9bjMLBXvq28k0Oi4rU7Ttk1vWWL3UjARB2GLTvOUqEvVWxcc7x+izyAhRoJbm/8Tl5
         Kawc1ujX1wnzCalqK7A/k1PrOJZ6Ke7ud/LEiLxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tommi Rantala <tommi.t.rantala@nokia.com>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 017/255] selftests: filter kselftest headers from command in lib.mk
Date:   Tue, 17 Nov 2020 14:02:37 +0100
Message-Id: <20201117122139.781377971@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tommi Rantala <tommi.t.rantala@nokia.com>

[ Upstream commit f825d3f7ed9305e7dd0a3e0a74673a4257d0cc53 ]

Commit 1056d3d2c97e ("selftests: enforce local header dependency in
lib.mk") added header dependency to the rule, but as the rule uses $^,
the headers are added to the compiler command line.

This can cause unexpected precompiled header files being generated when
compilation fails:

  $ echo { >> openat2_test.c

  $ make
  gcc -Wall -O2 -g -fsanitize=address -fsanitize=undefined  openat2_test.c
    tools/testing/selftests/kselftest_harness.h tools/testing/selftests/kselftest.h helpers.c
    -o tools/testing/selftests/openat2/openat2_test
  openat2_test.c:313:1: error: expected identifier or ‘(’ before ‘{’ token
    313 | {
        | ^
  make: *** [../lib.mk:140: tools/testing/selftests/openat2/openat2_test] Error 1

  $ file openat2_test*
  openat2_test:   GCC precompiled header (version 014) for C
  openat2_test.c: C source, ASCII text

Fix it by filtering out the headers, so that we'll only pass the actual
*.c files in the compiler command line.

Fixes: 1056d3d2c97e ("selftests: enforce local header dependency in lib.mk")
Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
Acked-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/lib.mk | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 7a17ea8157367..66f3317dc3654 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -137,7 +137,7 @@ endif
 ifeq ($(OVERRIDE_TARGETS),)
 LOCAL_HDRS := $(selfdir)/kselftest_harness.h $(selfdir)/kselftest.h
 $(OUTPUT)/%:%.c $(LOCAL_HDRS)
-	$(LINK.c) $^ $(LDLIBS) -o $@
+	$(LINK.c) $(filter-out $(LOCAL_HDRS),$^) $(LDLIBS) -o $@
 
 $(OUTPUT)/%.o:%.S
 	$(COMPILE.S) $^ -o $@
-- 
2.27.0




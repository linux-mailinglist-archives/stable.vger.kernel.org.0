Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF035178071
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732155AbgCCR4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:56:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732346AbgCCR4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:56:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FB8A20656;
        Tue,  3 Mar 2020 17:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258207;
        bh=GPrGqR4C1RaxmXPThvzNhzBjg4F8I9Wxl4QeqHftEbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjhjxpTtfCp91QQlTtnz4K9dGFG4/zOtk3zM5MClPa9FuXVLilDkYElQxhN3HuMg5
         AgN8CKHMWK5BuaTwMwjUpD+aelp+xwI5Wuh7bgg3JZc53IuBm3h7nBEojqE4Tg6nuk
         in8Jqt68w2MMTNoyxdwr8dT/RYg2cT9/pP0Q1QsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.4 112/152] selftests: Install settings files to fix TIMEOUT failures
Date:   Tue,  3 Mar 2020 18:43:30 +0100
Message-Id: <20200303174315.478536626@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit b9167c8078c3527de6da241c8a1a75a9224ed90a upstream.

Commit 852c8cbf34d3 ("selftests/kselftest/runner.sh: Add 45 second
timeout per test") added a 45 second timeout for tests, and also added
a way for tests to customise the timeout via a settings file.

For example the ftrace tests take multiple minutes to run, so they
were given longer in commit b43e78f65b1d ("tracing/selftests: Turn off
timeout setting").

This works when the tests are run from the source tree. However if the
tests are installed with "make -C tools/testing/selftests install",
the settings files are not copied into the install directory. When the
tests are then run from the install directory the longer timeouts are
not applied and the tests timeout incorrectly.

So add the settings files to TEST_FILES of the appropriate Makefiles
to cause the settings files to be installed using the existing install
logic.

Fixes: 852c8cbf34d3 ("selftests/kselftest/runner.sh: Add 45 second timeout per test")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/ftrace/Makefile    |    2 +-
 tools/testing/selftests/livepatch/Makefile |    2 ++
 tools/testing/selftests/rseq/Makefile      |    2 ++
 tools/testing/selftests/rtc/Makefile       |    2 ++
 4 files changed, 7 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/ftrace/Makefile
+++ b/tools/testing/selftests/ftrace/Makefile
@@ -2,7 +2,7 @@
 all:
 
 TEST_PROGS := ftracetest
-TEST_FILES := test.d
+TEST_FILES := test.d settings
 EXTRA_CLEAN := $(OUTPUT)/logs/*
 
 include ../lib.mk
--- a/tools/testing/selftests/livepatch/Makefile
+++ b/tools/testing/selftests/livepatch/Makefile
@@ -6,4 +6,6 @@ TEST_PROGS := \
 	test-callbacks.sh \
 	test-shadow-vars.sh
 
+TEST_FILES := settings
+
 include ../lib.mk
--- a/tools/testing/selftests/rseq/Makefile
+++ b/tools/testing/selftests/rseq/Makefile
@@ -19,6 +19,8 @@ TEST_GEN_PROGS_EXTENDED = librseq.so
 
 TEST_PROGS = run_param_test.sh
 
+TEST_FILES := settings
+
 include ../lib.mk
 
 $(OUTPUT)/librseq.so: rseq.c rseq.h rseq-*.h
--- a/tools/testing/selftests/rtc/Makefile
+++ b/tools/testing/selftests/rtc/Makefile
@@ -6,4 +6,6 @@ TEST_GEN_PROGS = rtctest
 
 TEST_GEN_PROGS_EXTENDED = setdate
 
+TEST_FILES := settings
+
 include ../lib.mk



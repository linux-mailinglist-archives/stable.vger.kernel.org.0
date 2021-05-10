Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECBA378846
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239119AbhEJLVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236814AbhEJLKa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:10:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 138546146E;
        Mon, 10 May 2021 11:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644741;
        bh=/xf+7x4AEiy/zFNMH/8OOITRPwL2zDSYp2kW7m6GlWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkSjKpNgd6b9M4mg7oquJ3GzyymAUCgKY5gzNIHZ0gCd6niBLSpDPp3dpmE+6dYIt
         bG2foN0A0bIDFOW79RrOz8hU3MYNuGO+8gqmqZN+NbuqLeL0LiRS9UzoGB7m8vHJn+
         iRzQ6LZ4BW1sfrSuJagz814SY8Dl2EG764gQVL7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Binderman <dcb314@hotmail.com>,
        Babu Moger <babu.moger@amd.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 206/384] selftests/resctrl: Enable gcc checks to detect buffer overflows
Date:   Mon, 10 May 2021 12:19:55 +0200
Message-Id: <20210510102021.676252866@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

[ Upstream commit a9d26a302dea29eb84f491b1340a57e56c631a71 ]

David reported a buffer overflow error in the check_results() function of
the cmt unit test and he suggested enabling _FORTIFY_SOURCE gcc compiler
option to automatically detect any such errors.

Feature Test Macros man page describes_FORTIFY_SOURCE as below

"Defining this macro causes some lightweight checks to be performed to
detect some buffer overflow errors when employing various string and memory
manipulation functions (for example, memcpy, memset, stpcpy, strcpy,
strncpy, strcat, strncat, sprintf, snprintf, vsprintf, vsnprintf, gets, and
wide character variants thereof). For some functions, argument consistency
is checked; for example, a check is made that open has been supplied with a
mode argument when the specified flags include O_CREAT. Not all problems
are detected, just some common cases.

If _FORTIFY_SOURCE is set to 1, with compiler optimization level 1 (gcc
-O1) and above, checks that shouldn't change the behavior of conforming
programs are performed.

With _FORTIFY_SOURCE set to 2, some more checking is added, but some
conforming programs might fail.

Some of the checks can be performed at compile time (via macros logic
implemented in header files), and result in compiler warnings; other checks
take place at run time, and result in a run-time error if the check fails.

Use of this macro requires compiler support, available with gcc since
version 4.0."

Fix the buffer overflow error in the check_results() function of the cmt
unit test and enable _FORTIFY_SOURCE gcc check to catch any future buffer
overflow errors.

Reported-by: David Binderman <dcb314@hotmail.com>
Suggested-by: David Binderman <dcb314@hotmail.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/Makefile   | 2 +-
 tools/testing/selftests/resctrl/cqm_test.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/resctrl/Makefile b/tools/testing/selftests/resctrl/Makefile
index d585cc1948cc..6bcee2ec91a9 100644
--- a/tools/testing/selftests/resctrl/Makefile
+++ b/tools/testing/selftests/resctrl/Makefile
@@ -1,5 +1,5 @@
 CC = $(CROSS_COMPILE)gcc
-CFLAGS = -g -Wall
+CFLAGS = -g -Wall -O2 -D_FORTIFY_SOURCE=2
 SRCS=$(wildcard *.c)
 OBJS=$(SRCS:.c=.o)
 
diff --git a/tools/testing/selftests/resctrl/cqm_test.c b/tools/testing/selftests/resctrl/cqm_test.c
index c8756152bd61..5e7308ac63be 100644
--- a/tools/testing/selftests/resctrl/cqm_test.c
+++ b/tools/testing/selftests/resctrl/cqm_test.c
@@ -86,7 +86,7 @@ static int check_results(struct resctrl_val_param *param, int no_of_bits)
 		return errno;
 	}
 
-	while (fgets(temp, 1024, fp)) {
+	while (fgets(temp, sizeof(temp), fp)) {
 		char *token = strtok(temp, ":\t");
 		int fields = 0;
 
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACD04062F0
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbhIJAqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:46:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234068AbhIJAWg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:22:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64B866023D;
        Fri, 10 Sep 2021 00:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233286;
        bh=RlZw90XY9G6njygefb+zNxz90JJFSXonM1BLS1TirNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EIEiaY83HDQBVkXpCXJ89giGDT+ki1NyY1OKhdloAPh1eDv15cVyMCcoj9TCUWgCf
         kg93cAvgIZx911cxwqe290A5UxHNj2IQswjke0JWsPZNWhcnMnSEcrq3lCWxYE8G8p
         Xr2GjVSh0GFZ1VLvyjXL3BVa4HLMDZhrgz5J2oLF3EzpNxDlNp2YClZTxATU8ZzByb
         b+Hik33IXFJ4v7JwM43CgjEvKNj9Uv5qj0ZTDayem8daOsd2EXH+dzXa8g7uHNQcbU
         kKq7ya9HPm1BIsiCntoC/95R6HSU1wpAwz3ZICL4jdTJSkVfTmcoXktvezUdFvhuee
         s1ScaS9ForrUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Baolin Wang <baolin.wang@linux.alibaba.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 42/53] selftests: openat2: Fix testing failure for O_LARGEFILE flag
Date:   Thu,  9 Sep 2021 20:20:17 -0400
Message-Id: <20210910002028.175174-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002028.175174-1-sashal@kernel.org>
References: <20210910002028.175174-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baolin Wang <baolin.wang@linux.alibaba.com>

[ Upstream commit d538ddb97e066571e4fc58b832f40739621b42bb ]

The openat2 test suite fails on ARM64 because the definition of
O_LARGEFILE is different on ARM64. Fix the problem by defining
the correct O_LARGEFILE definition on ARM64.

"openat2 unexpectedly returned # 3['.../tools/testing/selftests/openat2']
with 208000 (!= 208000)
not ok 102 openat2 with incompatible flags (O_PATH | O_LARGEFILE) fails
with -22 (Invalid argument)"

Fixed change log to improve formatting and clarity:
Shuah Khan <skhan@linuxfoundation.org>

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Aleksa Sarai <cyphar@cyphar.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/openat2/openat2_test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/openat2/openat2_test.c b/tools/testing/selftests/openat2/openat2_test.c
index b386367c606b..5354cef55c6c 100644
--- a/tools/testing/selftests/openat2/openat2_test.c
+++ b/tools/testing/selftests/openat2/openat2_test.c
@@ -22,7 +22,11 @@
  * XXX: This is wrong on {mips, parisc, powerpc, sparc}.
  */
 #undef	O_LARGEFILE
+#ifdef __aarch64__
+#define	O_LARGEFILE 0x20000
+#else
 #define	O_LARGEFILE 0x8000
+#endif
 
 struct open_how_ext {
 	struct open_how inner;
-- 
2.30.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC11406199
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240881AbhIJAnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:43:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232603AbhIJATB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88458611C1;
        Fri, 10 Sep 2021 00:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233062;
        bh=jDLUIqhUySRT60VoYyyhUFSxMrnREFvtTvBQAlbctco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWQ+6HnubmlS/2lPRAsbiAwMKgucaJRdw9lYYD5rPdSyvhA6U1JxblyX47dOCgkN4
         XWW1FXINFfDk1AqxYRPrQ4n94HrWfaWsKQWSJDLkywnHCIk0L4CAoOZZqpv6zImwRt
         Ouuvx5c1cM7YZHR2eO0HAriWSY2F3lB+fdQAJRbJKW0+XuMRmX+2ZAitIipWKA5S6j
         uhY3lFF1YWIX0Nu+Cv7OEKfTKzLZqTkdNqV7f8lyk5AvGu7lD2Mh9muF3cU98wg7Nq
         HxGPetrqqwU3GcsASl16tHWJ1WA+EkHHlJdrxKKyurRseM40kLm/asNkL7sdWHjwNc
         YXLNCh2go/FdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Baolin Wang <baolin.wang@linux.alibaba.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 75/99] selftests: openat2: Fix testing failure for O_LARGEFILE flag
Date:   Thu,  9 Sep 2021 20:15:34 -0400
Message-Id: <20210910001558.173296-75-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
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
index d7ec1e7da0d0..1bddbe934204 100644
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


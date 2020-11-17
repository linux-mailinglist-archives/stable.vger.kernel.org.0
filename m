Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88912B6318
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731954AbgKQNev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:34:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732168AbgKQNeW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:34:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9DC52078E;
        Tue, 17 Nov 2020 13:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620061;
        bh=umLz3Ny5unA35GO4UGLFZMYWWaZDmOBQvjHulUFh4q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OtZSp8sqswoHQ+xukBaC2N62lnIxCiiXzD5d9OArgT8PqEUOzSGeCCHepeNvsRoNF
         odFJvuED+ydy7S0Yszt/PR32RafsucQwEepIh15wrbZJGRXZnfXRi6EilQzyriYoT1
         sFVc69Q4yRSIDeK4qfZHjmAEa/NRjcCRM4bi1JHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tommi Rantala <tommi.t.rantala@nokia.com>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 065/255] selftests: core: use SKIP instead of XFAIL in close_range_test.c
Date:   Tue, 17 Nov 2020 14:03:25 +0100
Message-Id: <20201117122142.116163624@linuxfoundation.org>
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

[ Upstream commit 1d44d0dd61b6121b49f25b731f2f7f605cb3c896 ]

XFAIL is gone since commit 9847d24af95c ("selftests/harness: Refactor XFAIL
into SKIP"), use SKIP instead.

Fixes: 9847d24af95c ("selftests/harness: Refactor XFAIL into SKIP")
Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/core/close_range_test.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/core/close_range_test.c b/tools/testing/selftests/core/close_range_test.c
index c99b98b0d461f..575b391ddc78d 100644
--- a/tools/testing/selftests/core/close_range_test.c
+++ b/tools/testing/selftests/core/close_range_test.c
@@ -44,7 +44,7 @@ TEST(close_range)
 		fd = open("/dev/null", O_RDONLY | O_CLOEXEC);
 		ASSERT_GE(fd, 0) {
 			if (errno == ENOENT)
-				XFAIL(return, "Skipping test since /dev/null does not exist");
+				SKIP(return, "Skipping test since /dev/null does not exist");
 		}
 
 		open_fds[i] = fd;
@@ -52,7 +52,7 @@ TEST(close_range)
 
 	EXPECT_EQ(-1, sys_close_range(open_fds[0], open_fds[100], -1)) {
 		if (errno == ENOSYS)
-			XFAIL(return, "close_range() syscall not supported");
+			SKIP(return, "close_range() syscall not supported");
 	}
 
 	EXPECT_EQ(0, sys_close_range(open_fds[0], open_fds[50], 0));
@@ -108,7 +108,7 @@ TEST(close_range_unshare)
 		fd = open("/dev/null", O_RDONLY | O_CLOEXEC);
 		ASSERT_GE(fd, 0) {
 			if (errno == ENOENT)
-				XFAIL(return, "Skipping test since /dev/null does not exist");
+				SKIP(return, "Skipping test since /dev/null does not exist");
 		}
 
 		open_fds[i] = fd;
@@ -197,7 +197,7 @@ TEST(close_range_unshare_capped)
 		fd = open("/dev/null", O_RDONLY | O_CLOEXEC);
 		ASSERT_GE(fd, 0) {
 			if (errno == ENOENT)
-				XFAIL(return, "Skipping test since /dev/null does not exist");
+				SKIP(return, "Skipping test since /dev/null does not exist");
 		}
 
 		open_fds[i] = fd;
-- 
2.27.0




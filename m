Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9612ACE42
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732225AbgKJEIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 23:08:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:54002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731705AbgKJDxe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:53:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE0932080A;
        Tue, 10 Nov 2020 03:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980413;
        bh=RxdypS5yFALZA7A6ct64lelo/+SmNXp/dWCwIyV0Fao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbsxOM+G7UDXFWTyzPPo5OaUOvWCBE8aKo+eZ/3j9/Kw4dGcOpoEMdRAmk/EEUh2K
         LvufCuVnu8QlFgvhq+8MlA0fbIegSAl9LOT5WL74vN6awc73qDBBfqwYNO7dxPEw9+
         5FPaW2N9NEryx9lRGBdKhXI4naHqp//IYTGIv4iU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tommi Rantala <tommi.t.rantala@nokia.com>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 10/55] selftests: pidfd: fix compilation errors due to wait.h
Date:   Mon,  9 Nov 2020 22:52:33 -0500
Message-Id: <20201110035318.423757-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035318.423757-1-sashal@kernel.org>
References: <20201110035318.423757-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tommi Rantala <tommi.t.rantala@nokia.com>

[ Upstream commit 1948172fdba5ad643529ddcd00a601c0caa913ed ]

Drop unneeded <linux/wait.h> header inclusion to fix pidfd compilation
errors seen in Fedora 32:

In file included from pidfd_open_test.c:9:
../../../../usr/include/linux/wait.h:17:16: error: expected identifier before numeric constant
   17 | #define P_ALL  0
      |                ^

Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/pidfd/pidfd_open_test.c | 1 -
 tools/testing/selftests/pidfd/pidfd_poll_test.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/tools/testing/selftests/pidfd/pidfd_open_test.c b/tools/testing/selftests/pidfd/pidfd_open_test.c
index b9fe75fc3e517..8a59438ccc78b 100644
--- a/tools/testing/selftests/pidfd/pidfd_open_test.c
+++ b/tools/testing/selftests/pidfd/pidfd_open_test.c
@@ -6,7 +6,6 @@
 #include <inttypes.h>
 #include <limits.h>
 #include <linux/types.h>
-#include <linux/wait.h>
 #include <sched.h>
 #include <signal.h>
 #include <stdbool.h>
diff --git a/tools/testing/selftests/pidfd/pidfd_poll_test.c b/tools/testing/selftests/pidfd/pidfd_poll_test.c
index 4b115444dfe90..6108112753573 100644
--- a/tools/testing/selftests/pidfd/pidfd_poll_test.c
+++ b/tools/testing/selftests/pidfd/pidfd_poll_test.c
@@ -3,7 +3,6 @@
 #define _GNU_SOURCE
 #include <errno.h>
 #include <linux/types.h>
-#include <linux/wait.h>
 #include <poll.h>
 #include <signal.h>
 #include <stdbool.h>
-- 
2.27.0


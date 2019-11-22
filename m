Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE281078F8
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 20:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfKVTyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 14:54:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727275AbfKVTtR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 14:49:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C24F20658;
        Fri, 22 Nov 2019 19:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574452157;
        bh=sujIkRHrGw4eY/KTasIs6iMCrU8CKRJ35rDad+eWp1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZGzY/Y2a6hiZ2nnL8Ydl5/ZtWt7xGN3WyK3TTpB6zZF3/xs359SRS/uClkw7s5aG
         hMTz+jaD2xUW4aBI/EY2LctiBstb68pzjkT4SFLN8eGvo0rElr2bh5s1OjrMZnIuMD
         dIGxfpNS4DSTdkNgX5hSryANXAUjMTyXjcdsL8pM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 14/25] selftests: kvm: fix build with glibc >= 2.30
Date:   Fri, 22 Nov 2019 14:48:47 -0500
Message-Id: <20191122194859.24508-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122194859.24508-1-sashal@kernel.org>
References: <20191122194859.24508-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit e37f9f139f62deddff90c7298ae3a85026a71067 ]

Glibc-2.30 gained gettid() wrapper, selftests fail to compile:

lib/assert.c:58:14: error: static declaration of ‘gettid’ follows non-static declaration
   58 | static pid_t gettid(void)
      |              ^~~~~~
In file included from /usr/include/unistd.h:1170,
                 from include/test_util.h:18,
                 from lib/assert.c:10:
/usr/include/bits/unistd_ext.h:34:16: note: previous declaration of ‘gettid’ was here
   34 | extern __pid_t gettid (void) __THROW;
      |                ^~~~~~

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/lib/assert.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/assert.c b/tools/testing/selftests/kvm/lib/assert.c
index cd01144d27c8d..d306677065699 100644
--- a/tools/testing/selftests/kvm/lib/assert.c
+++ b/tools/testing/selftests/kvm/lib/assert.c
@@ -56,7 +56,7 @@ static void test_dump_stack(void)
 #pragma GCC diagnostic pop
 }
 
-static pid_t gettid(void)
+static pid_t _gettid(void)
 {
 	return syscall(SYS_gettid);
 }
@@ -73,7 +73,7 @@ test_assert(bool exp, const char *exp_str,
 		fprintf(stderr, "==== Test Assertion Failure ====\n"
 			"  %s:%u: %s\n"
 			"  pid=%d tid=%d - %s\n",
-			file, line, exp_str, getpid(), gettid(),
+			file, line, exp_str, getpid(), _gettid(),
 			strerror(errno));
 		test_dump_stack();
 		if (fmt) {
-- 
2.20.1


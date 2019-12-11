Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A46EF11B5AF
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731920AbfLKPQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:16:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:43836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731919AbfLKPQh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:16:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31A622465B;
        Wed, 11 Dec 2019 15:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077396;
        bh=sujIkRHrGw4eY/KTasIs6iMCrU8CKRJ35rDad+eWp1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=up//WdcJkiTIsnKL+OABL6l822FIeCm7C8dVl5P7+/Op4MP74yZXPKHDAJ1i01ExY
         2lIjtFh0LsG2kN7f3viKG9zzr/m0Hr/fgCBTa0ZzgYZwIk/qgxWr5jqDd7bn4TFsL3
         N3GlE/AKP/SWwLoQ9v0qPGb0NY7LtZ7rsC/tW0Dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 023/243] selftests: kvm: fix build with glibc >= 2.30
Date:   Wed, 11 Dec 2019 16:03:05 +0100
Message-Id: <20191211150340.502096048@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




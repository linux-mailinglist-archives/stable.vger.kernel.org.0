Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFD0811B756
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731477AbfLKQHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:07:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731155AbfLKPMb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 044EF2467D;
        Wed, 11 Dec 2019 15:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077150;
        bh=QoVN+P9+xdGb6qaKlf/1i1RsDFqo704BUrWg5HC1kvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KCqSxwH0Lj9L0XjLbRng2GyAWN9XBSdAnAmOKuKdDkys/qGx1FM1OkY8LQ4AmJPDm
         Uaexj02u7xhkP6ziS47OCfubncCYm82Z+y7e2tkXkOjnH/IDTlPOT162shhBZKgE7y
         e3zeEGa5AABIbHyuZqFLSwmAgKIkmzrnsxH5CGek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 035/105] selftests: kvm: fix build with glibc >= 2.30
Date:   Wed, 11 Dec 2019 16:05:24 +0100
Message-Id: <20191211150233.955493927@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
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
index 4911fc77d0f6a..d1cf9f6e0e6bc 100644
--- a/tools/testing/selftests/kvm/lib/assert.c
+++ b/tools/testing/selftests/kvm/lib/assert.c
@@ -55,7 +55,7 @@ static void test_dump_stack(void)
 #pragma GCC diagnostic pop
 }
 
-static pid_t gettid(void)
+static pid_t _gettid(void)
 {
 	return syscall(SYS_gettid);
 }
@@ -72,7 +72,7 @@ test_assert(bool exp, const char *exp_str,
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




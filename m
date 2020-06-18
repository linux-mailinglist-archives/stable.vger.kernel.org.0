Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB3F1FDBE1
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbgFRBP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:15:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729474AbgFRBP2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:15:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79B192193E;
        Thu, 18 Jun 2020 01:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442928;
        bh=Z0RcWYenrpj8+WEO56fwKNjTcwN2Tnh89HFmd30u+7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehoTLYQtnp4AKHJwIefrdbJzkk2JiZ5I4Ck2iL0SPCJkSMC9Gl40+AWCZKkKjyNjq
         FqoukQB20oB+dDCnHtXDGKJ8aNjIjs4xcxmYBnJUirol6uGSQaXJjREA4r3h2O7Kd/
         RzJ/8TqDfrIvr8GunPBi/2LeZUXfqjUNb8v15b6E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Marcelo Bandeira Condotta <mcondotta@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 342/388] KVM: selftests: Fix build with "make ARCH=x86_64"
Date:   Wed, 17 Jun 2020 21:07:19 -0400
Message-Id: <20200618010805.600873-342-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit b80db73dc8be7022adae1b4414a1bebce50fe915 ]

Marcelo reports that kvm selftests fail to build with
"make ARCH=x86_64":

gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99
 -fno-stack-protector -fno-PIE -I../../../../tools/include
 -I../../../../tools/arch/x86_64/include  -I../../../../usr/include/
 -Iinclude -Ilib -Iinclude/x86_64 -I.. -c lib/kvm_util.c
 -o /var/tmp/20200604202744-bin/lib/kvm_util.o

In file included from lib/kvm_util.c:11:
include/x86_64/processor.h:14:10: fatal error: asm/msr-index.h: No such
 file or directory

 #include <asm/msr-index.h>
          ^~~~~~~~~~~~~~~~~
compilation terminated.

"make ARCH=x86", however, works. The problem is that arch specific headers
for x86_64 live in 'tools/arch/x86/include', not in
'tools/arch/x86_64/include'.

Fixes: 66d69e081b52 ("selftests: fix kvm relocatable native/cross builds and installs")
Reported-by: Marcelo Bandeira Condotta <mcondotta@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20200605142028.550068-1-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 42f4f49f2a48..2c85b9dd86f5 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -80,7 +80,11 @@ LIBKVM += $(LIBKVM_$(UNAME_M))
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
 LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
+ifeq ($(ARCH),x86_64)
+LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/x86/include
+else
 LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
+endif
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
 	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
-- 
2.25.1


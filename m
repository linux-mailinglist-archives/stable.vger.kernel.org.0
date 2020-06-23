Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6762205DCA
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388632AbgFWUQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:16:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389434AbgFWUQe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:16:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66D8720702;
        Tue, 23 Jun 2020 20:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943394;
        bh=qO2w1WAQY0W9g78yumPqSmR/mtWdlrTUoYZHbi4d/Rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fj+4v35jNaure/ghmjDanBlNgI9Oz7hXP4+K5nC1O0b0WSeaWLjR4aXEYV8plRnHm
         naQAYLlq6wWDWUvGfniV7H6t4pZV11KmSwBUneQmcpYakLG6pHbdcVaBG/Eff5qgT2
         hQW0z3jIWuKYCR7vfcD0rwHzcBrEkIz9znTwhbwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Bandeira Condotta <mcondotta@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 334/477] KVM: selftests: Fix build with "make ARCH=x86_64"
Date:   Tue, 23 Jun 2020 21:55:31 +0200
Message-Id: <20200623195423.325563135@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 42f4f49f2a488..2c85b9dd86f58 100644
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




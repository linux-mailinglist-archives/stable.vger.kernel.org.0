Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEE023D21E
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 22:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbgHEUJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 16:09:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgHEQce (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 12:32:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E67E233EF;
        Wed,  5 Aug 2020 15:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596642813;
        bh=ysS3LGq+470SGw6FYTetlB33DoPN5s8hyLYUhLe+03M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JllupMgGlKTLXmtpiHjPZcnaEmnCr0V+WsDeHZA9YXLMvLeqg+Wd/ROLuK4m2mJiu
         wFOhrdYHSJCyh6GLl1Cwj53tG8YCqkVLDinsUumsJkQj7N4bpGDyzHAifJIT8iEHds
         I5BoyQC92mRaKOYelfOhIGxp4sQPnJ0yBcqEc1Q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 3/8] ARM: percpu.h: fix build error
Date:   Wed,  5 Aug 2020 17:53:29 +0200
Message-Id: <20200805153507.162602782@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200805153507.005753845@linuxfoundation.org>
References: <20200805153507.005753845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

commit aa54ea903abb02303bf55855fb51e3fcee135d70 upstream.

Fix build error for the case:
  defined(CONFIG_SMP) && !defined(CONFIG_CPU_V6)

config: keystone_defconfig

  CC      arch/arm/kernel/signal.o
  In file included from ../include/linux/random.h:14,
                    from ../arch/arm/kernel/signal.c:8:
  ../arch/arm/include/asm/percpu.h: In function ‘__my_cpu_offset’:
  ../arch/arm/include/asm/percpu.h:29:34: error: ‘current_stack_pointer’ undeclared (first use in this function); did you mean ‘user_stack_pointer’?
      : "Q" (*(const unsigned long *)current_stack_pointer));
                                     ^~~~~~~~~~~~~~~~~~~~~
                                     user_stack_pointer

Fixes: f227e3ec3b5c ("random32: update the net random state on interrupt and activity")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/percpu.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/include/asm/percpu.h
+++ b/arch/arm/include/asm/percpu.h
@@ -16,6 +16,8 @@
 #ifndef _ASM_ARM_PERCPU_H_
 #define _ASM_ARM_PERCPU_H_
 
+#include <asm/thread_info.h>
+
 /*
  * Same as asm-generic/percpu.h, except that we store the per cpu offset
  * in the TPIDRPRW. TPIDRPRW only exists on V6K and V7



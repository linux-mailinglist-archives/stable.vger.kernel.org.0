Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884B223CC58
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 18:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgHEQiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 12:38:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbgHEQgo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 12:36:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5D3923359;
        Wed,  5 Aug 2020 15:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596642745;
        bh=47QAnSMoOVMr8QHQNgdXK4N904/7dAfTkxp4OLgXePU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEB9vWxKVx75SK2HgWg+TsUma12Z7uFKrRgueSdbbCHriEi9rcMEjSv6yTOza7E7r
         tAB7FiXWtrNi282O8OMg9P8BVxJDNdy+IHGq1MGTJ9coLTjmFF8spfOYCHOsn1fnI5
         JW5dTJsYQNZm/tG1pX7pK6DOY2x50rhY32Juoy6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.7 2/6] ARM: percpu.h: fix build error
Date:   Wed,  5 Aug 2020 17:52:29 +0200
Message-Id: <20200805153507.086876812@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200805153506.978105994@linuxfoundation.org>
References: <20200805153506.978105994@linuxfoundation.org>
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
@@ -5,6 +5,8 @@
 #ifndef _ASM_ARM_PERCPU_H_
 #define _ASM_ARM_PERCPU_H_
 
+#include <asm/thread_info.h>
+
 /*
  * Same as asm-generic/percpu.h, except that we store the per cpu offset
  * in the TPIDRPRW. TPIDRPRW only exists on V6K and V7



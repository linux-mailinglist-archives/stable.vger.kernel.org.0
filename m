Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBEE323CFD6
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 21:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbgHETZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 15:25:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728344AbgHERPS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 13:15:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E1BA2337F;
        Wed,  5 Aug 2020 15:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596642773;
        bh=1w22+LBQnaR1M+1m8sFWAvv4+c7MzGzRZ17tDJnZxak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ErfTKyug8PRwLfcIOWDvraLY1ZaaPGDNG2OYgk7oF25asCAoUq28wT76AzvvLeyvx
         SA4tuz6TrPHCYcZt2mOYpy+O5RPUtA/e1drmiDsenuRXpMfiTb9T17fwLaMyHDURai
         O5Rvt1djQ5ynXUfqsPJyIwpDTfv6WEmcJVDzjx8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 6/9] [PATCH] arm64: Workaround circular dependency in pointer_auth.h
Date:   Wed,  5 Aug 2020 17:52:43 +0200
Message-Id: <20200805153507.352774488@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200805153507.053638231@linuxfoundation.org>
References: <20200805153507.053638231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

With the backport of f227e3ec3b5c ("random32: update the net random
state on interrupt and activity") and its associated fixes, the
arm64 build explodes early:

In file included from ../include/linux/smp.h:67,
                  from ../include/linux/percpu.h:7,
                  from ../include/linux/prandom.h:12,
                  from ../include/linux/random.h:118,
                  from ../arch/arm64/include/asm/pointer_auth.h:6,
                  from ../arch/arm64/include/asm/processor.h:39,
                  from ../include/linux/mutex.h:19,
                  from ../include/linux/kernfs.h:12,
                  from ../include/linux/sysfs.h:16,
                  from ../include/linux/kobject.h:20,
                  from ../include/linux/of.h:17,
                  from ../include/linux/irqdomain.h:35,
                  from ../include/linux/acpi.h:13,
                  from ../include/acpi/apei.h:9,
                  from ../include/acpi/ghes.h:5,
                  from ../include/linux/arm_sdei.h:8,
                  from ../arch/arm64/kernel/asm-offsets.c:10:
../arch/arm64/include/asm/smp.h:100:29: error: field ‘ptrauth_key’ has
incomplete type

This is due to struct ptrauth_keys_kernel not being defined before
we transitively include asm/smp.h from linux/random.h.

Paper over it by moving the inclusion of linux/random.h *after* the
type has been defined.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/pointer_auth.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/pointer_auth.h
+++ b/arch/arm64/include/asm/pointer_auth.h
@@ -3,7 +3,6 @@
 #define __ASM_POINTER_AUTH_H
 
 #include <linux/bitops.h>
-#include <linux/random.h>
 
 #include <asm/cpufeature.h>
 #include <asm/memory.h>
@@ -30,6 +29,13 @@ struct ptrauth_keys {
 	struct ptrauth_key apga;
 };
 
+/*
+ * Only include random.h once ptrauth_keys_* structures are defined
+ * to avoid yet another circular include hell (random.h * ends up
+ * including asm/smp.h, which requires ptrauth_keys_kernel).
+ */
+#include <linux/random.h>
+
 static inline void ptrauth_keys_init(struct ptrauth_keys *keys)
 {
 	if (system_supports_address_auth()) {



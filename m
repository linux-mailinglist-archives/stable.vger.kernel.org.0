Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843192474E0
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388456AbgHQTQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:16:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730474AbgHQPjM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:39:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9AF8208E4;
        Mon, 17 Aug 2020 15:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678751;
        bh=adrKwjKBYwAGO2tCI25+wx390wp6p3FolWXMxPZgFos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OrYHAoDS8R29Wu2s+EQejofZvZJ5gX2XrfBCBv/cvcReKuKW7NcPNAjE2lv3dQzys
         ZcDeuO6AubJDTmPSFlJH2MPiQRhbPV3JGpIyY2YtqYEgpXIoBrPc48QBdaWE095wv2
         iMsLbNtVZFSGN445XyQBqK2MajlqroCuDC5ja/0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.8 441/464] Revert "parisc: Improve interrupt handling in arch_spin_lock_flags()"
Date:   Mon, 17 Aug 2020 17:16:34 +0200
Message-Id: <20200817143854.900561251@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 3d05b8aebc5f10ee3ab129b61100196855dd7249 upstream.

This reverts commit 2772f0efd5bbd5413db3d22e363b779ca0fa5310.
It turns out that we want to implement the spinlock code differently.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v5.7+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/include/asm/spinlock.h |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

--- a/arch/parisc/include/asm/spinlock.h
+++ b/arch/parisc/include/asm/spinlock.h
@@ -10,34 +10,25 @@
 static inline int arch_spin_is_locked(arch_spinlock_t *x)
 {
 	volatile unsigned int *a = __ldcw_align(x);
-	smp_mb();
 	return *a == 0;
 }
 
-static inline void arch_spin_lock(arch_spinlock_t *x)
-{
-	volatile unsigned int *a;
-
-	a = __ldcw_align(x);
-	while (__ldcw(a) == 0)
-		while (*a == 0)
-			cpu_relax();
-}
+#define arch_spin_lock(lock) arch_spin_lock_flags(lock, 0)
 
 static inline void arch_spin_lock_flags(arch_spinlock_t *x,
 					 unsigned long flags)
 {
 	volatile unsigned int *a;
-	unsigned long flags_dis;
 
 	a = __ldcw_align(x);
-	while (__ldcw(a) == 0) {
-		local_save_flags(flags_dis);
-		local_irq_restore(flags);
+	while (__ldcw(a) == 0)
 		while (*a == 0)
-			cpu_relax();
-		local_irq_restore(flags_dis);
-	}
+			if (flags & PSW_SM_I) {
+				local_irq_enable();
+				cpu_relax();
+				local_irq_disable();
+			} else
+				cpu_relax();
 }
 #define arch_spin_lock_flags arch_spin_lock_flags
 



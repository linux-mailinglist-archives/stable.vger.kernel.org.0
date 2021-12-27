Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B847847FFD5
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239309AbhL0PlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:41:21 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42042 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239488AbhL0Pjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:39:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E2DEFCE1070;
        Mon, 27 Dec 2021 15:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4757C36AE7;
        Mon, 27 Dec 2021 15:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619591;
        bh=wQwIfeMq5N/Ew3jURX6tFLuWiq3YBkEI2oAzxNQptHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oN948XAjfvkat1oGFSwXAzE0iGH2aT/F5YJgqJMQZLq0F2va6dX9t3Gbw9L+XtZWs
         +Naf3PWV4Gvrzw/Ll4nDlP168ilUtuFnY+Q5sQ9yIcKOVEc0vu/Tijckth4us6102y
         VZ249GpldEWVCB2HCo6MrNEVgOuXrJaSVvqlVEA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 45/76] parisc: Fix mask used to select futex spinlock
Date:   Mon, 27 Dec 2021 16:31:00 +0100
Message-Id: <20211227151326.269594782@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John David Anglin <dave.anglin@bell.net>

commit d3a5a68cff47f6eead84504c3c28376b85053242 upstream.

The address bits used to select the futex spinlock need to match those used in
the LWS code in syscall.S. The mask 0x3f8 only selects 7 bits.  It should
select 8 bits.

This change fixes the glibc nptl/tst-cond24 and nptl/tst-cond25 tests.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Fixes: 53a42b6324b8 ("parisc: Switch to more fine grained lws locks")
Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/futex.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/parisc/include/asm/futex.h
+++ b/arch/parisc/include/asm/futex.h
@@ -16,7 +16,7 @@ static inline void
 _futex_spin_lock_irqsave(u32 __user *uaddr, unsigned long int *flags)
 {
 	extern u32 lws_lock_start[];
-	long index = ((long)uaddr & 0x3f8) >> 1;
+	long index = ((long)uaddr & 0x7f8) >> 1;
 	arch_spinlock_t *s = (arch_spinlock_t *)&lws_lock_start[index];
 	local_irq_save(*flags);
 	arch_spin_lock(s);
@@ -26,7 +26,7 @@ static inline void
 _futex_spin_unlock_irqrestore(u32 __user *uaddr, unsigned long int *flags)
 {
 	extern u32 lws_lock_start[];
-	long index = ((long)uaddr & 0x3f8) >> 1;
+	long index = ((long)uaddr & 0x7f8) >> 1;
 	arch_spinlock_t *s = (arch_spinlock_t *)&lws_lock_start[index];
 	arch_spin_unlock(s);
 	local_irq_restore(*flags);



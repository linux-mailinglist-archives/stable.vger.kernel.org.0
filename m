Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D040D4800E5
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239940AbhL0Pv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240279AbhL0PsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:48:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67266C061374;
        Mon, 27 Dec 2021 07:43:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3029FB810A2;
        Mon, 27 Dec 2021 15:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787E1C36AEB;
        Mon, 27 Dec 2021 15:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619825;
        bh=wQwIfeMq5N/Ew3jURX6tFLuWiq3YBkEI2oAzxNQptHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PoPD+SYjUP+ySLQq/UK5jwE6vX6Ya3QGZvHryV5lS99NqB5+G+N4QvSTEiF14GhMs
         VnitHtUoZ//FWJor2gMAeDPoM8PlEsteYrQTsZZaTqbAci12d3DU2v7Cz4VPw9LQ+j
         f2RbyG5vKEVaIpDThpdmJAlvIMda6R0CxqdfzqzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 081/128] parisc: Fix mask used to select futex spinlock
Date:   Mon, 27 Dec 2021 16:30:56 +0100
Message-Id: <20211227151334.205360391@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
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



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2321ABCE91
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441760AbfIXQxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:53:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441745AbfIXQwn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:52:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1CB92054F;
        Tue, 24 Sep 2019 16:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343963;
        bh=iPEH/I3u7cWV6fjDgTXUXyANlZ47x/PQT5QxbCG2sac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A8NatXUsqdsFpiPWg1mHkn8Kdz08Uzt1VzKnkZqY2TKVlFPcL7ErkrWywM7+R5mdS
         2W2NQxHkZL4PS2lC+ylytlq8FHLSEkKY3DsuUwXq7v6QLwh6jMZRNeyZRXhOZleq7s
         aPdPmS5pedgwmdJ07F4hkuOnIP9Fmzzod++Wb4U0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.4 12/14] powerpc/64s/exception: machine check use correct cfar for late handler
Date:   Tue, 24 Sep 2019 12:52:10 -0400
Message-Id: <20190924165214.28857-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924165214.28857-1-sashal@kernel.org>
References: <20190924165214.28857-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 0b66370c61fcf5fcc1d6901013e110284da6e2bb ]

Bare metal machine checks run an "early" handler in real mode before
running the main handler which reports the event.

The main handler runs exactly as a normal interrupt handler, after the
"windup" which sets registers back as they were at interrupt entry.
CFAR does not get restored by the windup code, so that will be wrong
when the handler is run.

Restore the CFAR to the saved value before running the late handler.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190802105709.27696-8-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/exceptions-64s.S | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index a44f1755dc4bf..536718ed033fc 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1465,6 +1465,10 @@ machine_check_handle_early:
 	RFI_TO_USER_OR_KERNEL
 9:
 	/* Deliver the machine check to host kernel in V mode. */
+BEGIN_FTR_SECTION
+	ld	r10,ORIG_GPR3(r1)
+	mtspr	SPRN_CFAR,r10
+END_FTR_SECTION_IFSET(CPU_FTR_CFAR)
 	MACHINE_CHECK_HANDLER_WINDUP
 	b	machine_check_pSeries
 
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762C52265B9
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731584AbgGTP4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:56:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731825AbgGTP4o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:56:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0A302065E;
        Mon, 20 Jul 2020 15:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260604;
        bh=EGhIgVIAG6evw4B0i/8BjerJYr4VaR5XyLTu0Dr1Er4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=at6Lua5ttpAMofbWGNHUA5uCLWRuauH83SNgBHlHQ7BEgCdC9NS5Qf0BC2mwRHjFW
         Ol+EbisnIhAI495LcQiNUNIOw8PD4ItXEAHdA9ZLASArwVokQ6mOaMRVMfRGJG+hEo
         rcp9iWMJqOSeGUlt04wytn/eiFOll/XO68+MngKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.4 028/215] arm64: arch_timer: Allow an workaround descriptor to disable compat vdso
Date:   Mon, 20 Jul 2020 17:35:10 +0200
Message-Id: <20200720152821.520281513@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit c1fbec4ac0d701f350a581941d35643d5a9cd184 upstream.

As we are about to disable the vdso for compat tasks in some circumstances,
let's allow a workaround descriptor to express exactly that.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200706163802.1836732-3-maz@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/arch_timer.h  |    1 +
 drivers/clocksource/arm_arch_timer.c |    3 +++
 2 files changed, 4 insertions(+)

--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -58,6 +58,7 @@ struct arch_timer_erratum_workaround {
 	u64 (*read_cntvct_el0)(void);
 	int (*set_next_event_phys)(unsigned long, struct clock_event_device *);
 	int (*set_next_event_virt)(unsigned long, struct clock_event_device *);
+	bool disable_compat_vdso;
 };
 
 DECLARE_PER_CPU(const struct arch_timer_erratum_workaround *,
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -562,6 +562,9 @@ void arch_timer_enable_workaround(const
 	if (wa->read_cntvct_el0) {
 		clocksource_counter.archdata.clock_mode = VDSO_CLOCKMODE_NONE;
 		vdso_default = VDSO_CLOCKMODE_NONE;
+	} else if (wa->disable_compat_vdso && vdso_default != VDSO_CLOCKMODE_NONE) {
+		vdso_default = VDSO_CLOCKMODE_ARCHTIMER_NOCOMPAT;
+		clocksource_counter.archdata.clock_mode = vdso_default;
 	}
 }
 



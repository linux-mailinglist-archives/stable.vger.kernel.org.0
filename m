Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC3631381A
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhBHPgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:36:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:38206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233833AbhBHPay (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:30:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4836864F32;
        Mon,  8 Feb 2021 15:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797434;
        bh=P1RTl2tBCk28goeiL9TdQOiQWUIG305zfykMvOZ6Zb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wF+6gHPPizRZOGwOoMf1DTib111BdSRQNO5WgYodLpiKsaANOEq4LErh92z2di0hF
         lzTZVJCRPEgtXQiQ0TS9yPobn7kk4nOm1i5LSe3kPPOlPirrfj9Qovd6Yll2o5B8Lg
         3QdsHlHO54MTbezRQKj11cz4iUGLvsQRvnuzZrJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 109/120] x86/debug: Prevent data breakpoints on cpu_dr7
Date:   Mon,  8 Feb 2021 16:01:36 +0100
Message-Id: <20210208145822.727707820@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

commit 3943abf2dbfae9ea4d2da05c1db569a0603f76da upstream.

local_db_save() is called at the start of exc_debug_kernel(), reads DR7 and
disables breakpoints to prevent recursion.

When running in a guest (X86_FEATURE_HYPERVISOR), local_db_save() reads the
per-cpu variable cpu_dr7 to check whether a breakpoint is active or not
before it accesses DR7.

A data breakpoint on cpu_dr7 therefore results in infinite #DB recursion.

Disallow data breakpoints on cpu_dr7 to prevent that.

Fixes: 84b6a3491567a("x86/entry: Optimize local_db_save() for virt")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210204152708.21308-2-jiangshanlai@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/hw_breakpoint.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -307,6 +307,14 @@ static inline bool within_cpu_entry(unsi
 				(unsigned long)&per_cpu(cpu_tlbstate, cpu),
 				sizeof(struct tlb_state)))
 			return true;
+
+		/*
+		 * When in guest (X86_FEATURE_HYPERVISOR), local_db_save()
+		 * will read per-cpu cpu_dr7 before clear dr7 register.
+		 */
+		if (within_area(addr, end, (unsigned long)&per_cpu(cpu_dr7, cpu),
+				sizeof(cpu_dr7)))
+			return true;
 	}
 
 	return false;



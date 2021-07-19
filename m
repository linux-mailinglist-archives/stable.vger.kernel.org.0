Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2358B3CDDDA
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344436AbhGSPBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343855AbhGSO7X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E183A61353;
        Mon, 19 Jul 2021 15:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709055;
        bh=5MbsnozhPTJL9h5KtJUwuo/wLMDLSOJeNoVttIPL/bE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJDuXDfmQv9QcbT89scIAo4YwZFERmfUcZQSwdmAH613QlVcFAptL+aAIJ4KRDfuV
         DpkaXQv2wquPP0M/Fw/MiM0bkfTD6uaXrSOa5XPRVNAnxLjkRFWq56YemIvlSTBqQp
         FizMOhiVUbge8O12/EsLVVmoKWEoCTLHSylNahvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 218/421] powerpc: Offline CPU in stop_this_cpu()
Date:   Mon, 19 Jul 2021 16:50:29 +0200
Message-Id: <20210719144953.897089678@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit bab26238bbd44d5a4687c0a64fd2c7f2755ea937 ]

printk_safe_flush_on_panic() has special lock breaking code for the case
where we panic()ed with the console lock held. It relies on panic IPI
causing other CPUs to mark themselves offline.

Do as most other architectures do.

This effectively reverts commit de6e5d38417e ("powerpc: smp_send_stop do
not offline stopped CPUs"), unfortunately it may result in some false
positive warnings, but the alternative is more situations where we can
crash without getting messages out.

Fixes: de6e5d38417e ("powerpc: smp_send_stop do not offline stopped CPUs")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210623041245.865134-1-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/smp.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index a9ec4467705c..14adfeacfa46 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -570,6 +570,8 @@ static void nmi_stop_this_cpu(struct pt_regs *regs)
 	/*
 	 * IRQs are already hard disabled by the smp_handle_nmi_ipi.
 	 */
+	set_cpu_online(smp_processor_id(), false);
+
 	spin_begin();
 	while (1)
 		spin_cpu_relax();
@@ -585,6 +587,15 @@ void smp_send_stop(void)
 static void stop_this_cpu(void *dummy)
 {
 	hard_irq_disable();
+
+	/*
+	 * Offlining CPUs in stop_this_cpu can result in scheduler warnings,
+	 * (see commit de6e5d38417e), but printk_safe_flush_on_panic() wants
+	 * to know other CPUs are offline before it breaks locks to flush
+	 * printk buffers, in case we panic()ed while holding the lock.
+	 */
+	set_cpu_online(smp_processor_id(), false);
+
 	spin_begin();
 	while (1)
 		spin_cpu_relax();
-- 
2.30.2




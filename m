Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F53EFA47B
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbfKMCRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:17:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbfKMB4G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:56:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4307222CF;
        Wed, 13 Nov 2019 01:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610166;
        bh=ETy3/oLlODMF6IqyyikE3r7NS0VCBoZzrTvaSa//SfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EavFTl58i4xagNZZMB5z3YiC1bALAzr29wT70OVM2lXTG0Lju8QyNSzw0jnilS7FO
         W5rUSAOUOfAFd3Dv4yDW5HFXkVCNlIfVJynqHiqZO2tfwrKADUnTjFVAcWZ5JxNe6A
         Kb/AVhHxk1qh+QTyuCdf5+bE2A+7sxu6VWte0+p0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 207/209] powerpc/time: Fix clockevent_decrementer initalisation for PR KVM
Date:   Tue, 12 Nov 2019 20:50:23 -0500
Message-Id: <20191113015025.9685-207-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit b4d16ab58c41ff0125822464bdff074cebd0fe47 ]

In the recent commit 8b78fdb045de ("powerpc/time: Use
clockevents_register_device(), fixing an issue with large
decrementer") we changed the way we initialise the decrementer
clockevent(s).

We no longer initialise the mult & shift values of
decrementer_clockevent itself.

This has the effect of breaking PR KVM, because it uses those values
in kvmppc_emulate_dec(). The symptom is guest kernels spin forever
mid-way through boot.

For now fix it by assigning back to decrementer_clockevent the mult
and shift values.

Fixes: 8b78fdb045de ("powerpc/time: Use clockevents_register_device(), fixing an issue with large decrementer")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/time.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 6a1f0a084ca35..7707990c4c169 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -988,6 +988,10 @@ static void register_decrementer_clockevent(int cpu)
 
 	printk_once(KERN_DEBUG "clockevent: %s mult[%x] shift[%d] cpu[%d]\n",
 		    dec->name, dec->mult, dec->shift, cpu);
+
+	/* Set values for KVM, see kvm_emulate_dec() */
+	decrementer_clockevent.mult = dec->mult;
+	decrementer_clockevent.shift = dec->shift;
 }
 
 static void enable_large_decrementer(void)
-- 
2.20.1


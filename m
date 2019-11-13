Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83870FA1C8
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfKMB71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:59:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:53982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730273AbfKMB70 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:59:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A05F2053B;
        Wed, 13 Nov 2019 01:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610366;
        bh=xYtSWAppVOZfMLxMc2is88PZzdaTy5OfeiBTGRCVlDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCIGXwa9f4DIuzPWXKiFtJhS+QV6SzFmIDIeii9bEK8nkITx4Xp/iyr1cW6c8b+Fu
         UP03qMzWukq1X/kyyng3L8OEmJksBmdDSn/3lRYCyXAimfJZ6lwZ8lQ4Gd1O21nGq+
         MHP/zucRxRUGjvxm83ezIKbm6DtebtzPuY+29Vpw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 114/115] powerpc/time: Fix clockevent_decrementer initalisation for PR KVM
Date:   Tue, 12 Nov 2019 20:56:21 -0500
Message-Id: <20191113015622.11592-114-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
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
index 870e75d304591..7c7c5a16284d2 100644
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCED490CD6
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241353AbiAQQ7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 11:59:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47444 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241283AbiAQQ70 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 11:59:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73307B810A2;
        Mon, 17 Jan 2022 16:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4875DC36AE7;
        Mon, 17 Jan 2022 16:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438764;
        bh=FjNJmuvmKPUn0Y/tUQqXZwC+h96sYOLijJ9A1+62c5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HfGDyL0S1f7qT1+BTl7o3GSbgfNpQbHY91UPAIuXS6jL8ymvS7vKDmy4JSZToov44
         Ips/F2UK4ZMSFpWhtevZq0awqZo5bpfaKkUk67JEQGdn8R7Tweijh3bHzL/KKLWzbB
         bnEUZKQmZyJys/c0gMyXUVNjPLZE2WY9LqdyV4rB62OFhNn2nbwIR0+1Ziw2m/kSdQ
         IsW1QIguiQc/j4BneE1PvO/y8oknlvygMaHfxKjmIJ24vpggVWJeyqKBnqdcS0lKUT
         ua7Jw53lbqYt9a7iNVr428S8+I9ADw1CthH45iYV4amlMBCY8Z9K1ee8w5hFH2Wg64
         VFmMe1ZVau1fQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Erhard Furtner <erhard_f@mailbox.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.16 13/52] powerpc/powermac: Add missing lockdep_register_key()
Date:   Mon, 17 Jan 2022 11:58:14 -0500
Message-Id: <20220117165853.1470420-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit df1f679d19edb9eeb67cc2f96b29375f21991945 ]

KeyWest i2c @0xf8001003 irq 42 /uni-n@f8000000/i2c@f8001000
BUG: key c2d00cbc has not been registered!
------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 0 PID: 1 at kernel/locking/lockdep.c:4801 lockdep_init_map_type+0x4c0/0xb4c
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.15.5-gentoo-PowerMacG4 #9
NIP:  c01a9428 LR: c01a9428 CTR: 00000000
REGS: e1033cf0 TRAP: 0700   Not tainted  (5.15.5-gentoo-PowerMacG4)
MSR:  00029032 <EE,ME,IR,DR,RI>  CR: 24002002  XER: 00000000

GPR00: c01a9428 e1033db0 c2d1cf20 00000016 00000004 00000001 c01c0630 e1033a73
GPR08: 00000000 00000000 00000000 e1033db0 24002004 00000000 f8729377 00000003
GPR16: c1829a9c 00000000 18305357 c1416fc0 c1416f80 c006ac60 c2d00ca8 c1416f00
GPR24: 00000000 c21586f0 c2160000 00000000 c2d00cbc c2170000 c216e1a0 c2160000
NIP [c01a9428] lockdep_init_map_type+0x4c0/0xb4c
LR [c01a9428] lockdep_init_map_type+0x4c0/0xb4c
Call Trace:
[e1033db0] [c01a9428] lockdep_init_map_type+0x4c0/0xb4c (unreliable)
[e1033df0] [c1c177b8] kw_i2c_add+0x334/0x424
[e1033e20] [c1c18294] pmac_i2c_init+0x9ec/0xa9c
[e1033e80] [c1c1a790] smp_core99_probe+0xbc/0x35c
[e1033eb0] [c1c03cb0] kernel_init_freeable+0x190/0x5a4
[e1033f10] [c000946c] kernel_init+0x28/0x154
[e1033f30] [c0035148] ret_from_kernel_thread+0x14/0x1c

Add missing lockdep_register_key()

Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/69e4f55565bb45ebb0843977801b245af0c666fe.1638264741.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powermac/low_i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/powermac/low_i2c.c b/arch/powerpc/platforms/powermac/low_i2c.c
index f77a59b5c2e1a..de34fa34c42d8 100644
--- a/arch/powerpc/platforms/powermac/low_i2c.c
+++ b/arch/powerpc/platforms/powermac/low_i2c.c
@@ -582,6 +582,7 @@ static void __init kw_i2c_add(struct pmac_i2c_host_kw *host,
 	bus->close = kw_i2c_close;
 	bus->xfer = kw_i2c_xfer;
 	mutex_init(&bus->mutex);
+	lockdep_register_key(&bus->lock_key);
 	lockdep_set_class(&bus->mutex, &bus->lock_key);
 	if (controller == busnode)
 		bus->flags = pmac_i2c_multibus;
-- 
2.34.1


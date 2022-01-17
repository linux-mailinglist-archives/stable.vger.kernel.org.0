Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9519B490E22
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242867AbiAQRHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:07:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52742 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242182AbiAQRFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:05:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65A8FB81157;
        Mon, 17 Jan 2022 17:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D600C36AE3;
        Mon, 17 Jan 2022 17:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439119;
        bh=pL5DlckTYc8ipxH4UEVjfwKGkrjZDg8g6YwWLt+WjKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXOQjrlztgVReAyUi1KTAc3NNRf6GcuOyjYwQxwJng1uVGcbrrymePWCLYsoUXv3/
         EmTGJPgCbJDzRg/N0R4K3+mWXNI/zIBGxPRyF9JPkTCr9aBGUoC5mTq6rIPwIpouok
         zrean8h5yYU4iXOr0WuVJGnPGYCEhJO+sd83sHB0Rdc8BbnxjpBQd+/Q+l1wSJdUqc
         bWmT503pxfAIO8vvlTo5TkzI6RPDYAWNpQ5Z/htX1rav+eZYl3bgg8YbXjeflfjX4h
         x4MQ2p+joIcJTGZH4Vqn0GU6yYYsjLN3iceAO2ko5QX45mwPQIXX39XUDfPRupiVYx
         bvzUHnf5brYIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Erhard Furtner <erhard_f@mailbox.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 11/21] powerpc/powermac: Add missing lockdep_register_key()
Date:   Mon, 17 Jan 2022 12:04:43 -0500
Message-Id: <20220117170454.1472347-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170454.1472347-1-sashal@kernel.org>
References: <20220117170454.1472347-1-sashal@kernel.org>
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
index bf4be4b53b44d..c93ba97b3cb67 100644
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


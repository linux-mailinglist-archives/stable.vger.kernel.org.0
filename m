Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6455CCAC17
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732180AbfJCQFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731287AbfJCQFQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:05:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D447207FF;
        Thu,  3 Oct 2019 16:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118715;
        bh=gAU5FFtkt4JrXlIGSESoZ5d/KBuNhSLtdre5Bf76G9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IkdJXTlAg1shSPSvuYbFsCnEPGSS2iAUVd/8ZGsmdELiBm+iIOyQ34HvIEwdhaJU9
         wsx4k0r+dHUabaBmoEiF7QV7Q3WQZ2Z6/lQPvUBQ4WoHeuz9C8GDZYTJZIE4La1RUB
         eDvxArX/kPOU2PsNEVm9KEZ9W3gp+5144hYQN9ZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Araneda <luaraneda@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH 4.9 111/129] ARM: zynq: Use memcpy_toio instead of memcpy on smp bring-up
Date:   Thu,  3 Oct 2019 17:53:54 +0200
Message-Id: <20191003154409.643189494@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
References: <20191003154318.081116689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Araneda <luaraneda@gmail.com>

commit b7005d4ef4f3aa2dc24019ffba03a322557ac43d upstream.

This fixes a kernel panic on memcpy when
FORTIFY_SOURCE is enabled.

The initial smp implementation on commit aa7eb2bb4e4a
("arm: zynq: Add smp support")
used memcpy, which worked fine until commit ee333554fed5
("ARM: 8749/1: Kconfig: Add ARCH_HAS_FORTIFY_SOURCE")
enabled overflow checks at runtime, producing a read
overflow panic.

The computed size of memcpy args are:
- p_size (dst): 4294967295 = (size_t) -1
- q_size (src): 1
- size (len): 8

Additionally, the memory is marked as __iomem, so one of
the memcpy_* functions should be used for read/write.

Fixes: aa7eb2bb4e4a ("arm: zynq: Add smp support")
Signed-off-by: Luis Araneda <luaraneda@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-zynq/platsmp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-zynq/platsmp.c
+++ b/arch/arm/mach-zynq/platsmp.c
@@ -65,7 +65,7 @@ int zynq_cpun_start(u32 address, int cpu
 			* 0x4: Jump by mov instruction
 			* 0x8: Jumping address
 			*/
-			memcpy((__force void *)zero, &zynq_secondary_trampoline,
+			memcpy_toio(zero, &zynq_secondary_trampoline,
 							trampoline_size);
 			writel(address, zero + trampoline_size);
 



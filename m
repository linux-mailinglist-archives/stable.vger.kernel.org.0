Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1410A40E5DA
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244849AbhIPRP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:15:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344405AbhIPRNX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:13:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83AF861A3B;
        Thu, 16 Sep 2021 16:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810328;
        bh=lImvXFqv8F4CpYEnM2+99TdewWuYd0/Ydfc+dsWapjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pnkgQxNEdjW6ABNJrlhARGr3DRB6SATV+r2cEwXIMQEqaVRvFtIWaamuCVibqiErA
         WAmDnGi6TYe0Br3H16rg0CrRaiuxl1rvwHOuy6nQae3XiKpPFPKKlGvPyxXNLFy62M
         CnTwK86CWvkaHBNk0hdmtBw7gxvZ3dEPfVFvCRcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Jonas Bonn <jonas@southpole.se>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Stafford Horne <shorne@gmail.com>,
        openrisc@lists.librecores.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 101/432] openrisc: dont printk() unconditionally
Date:   Thu, 16 Sep 2021 17:57:30 +0200
Message-Id: <20210916155814.205641252@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 946e1052cdcc7e585ee5d1e72528ca49fb295243 ]

Don't call printk() when CONFIG_PRINTK is not set.
Fixes the following build errors:

or1k-linux-ld: arch/openrisc/kernel/entry.o: in function `_external_irq_handler':
(.text+0x804): undefined reference to `printk'
(.text+0x804): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `printk'

Fixes: 9d02a4283e9c ("OpenRISC: Boot code")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Cc: openrisc@lists.librecores.org
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/kernel/entry.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/openrisc/kernel/entry.S b/arch/openrisc/kernel/entry.S
index bc657e55c15f..98e4f97db515 100644
--- a/arch/openrisc/kernel/entry.S
+++ b/arch/openrisc/kernel/entry.S
@@ -547,6 +547,7 @@ EXCEPTION_ENTRY(_external_irq_handler)
 	l.bnf	1f			// ext irq enabled, all ok.
 	l.nop
 
+#ifdef CONFIG_PRINTK
 	l.addi  r1,r1,-0x8
 	l.movhi r3,hi(42f)
 	l.ori	r3,r3,lo(42f)
@@ -560,6 +561,7 @@ EXCEPTION_ENTRY(_external_irq_handler)
 		.string "\n\rESR interrupt bug: in _external_irq_handler (ESR %x)\n\r"
 		.align 4
 	.previous
+#endif
 
 	l.ori	r4,r4,SPR_SR_IEE	// fix the bug
 //	l.sw	PT_SR(r1),r4
-- 
2.30.2




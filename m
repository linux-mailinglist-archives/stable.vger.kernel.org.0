Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5AE190FAD
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgCXNWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729131AbgCXNWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:22:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9397A206F6;
        Tue, 24 Mar 2020 13:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056129;
        bh=bsVMTFks6CJCc2U67i947WHYTc+3oSIbcH7Igvdr4us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIapsORghSOHhxRGWcoHiAtbqE53NIcblY1AgryimtAfmJhJQ/9zBM2kFY7J9wQZs
         X+i0VXr99UcudD1bbnwY185/S/YaJMMxR44IO2Hxq6ZorcnhrV5fRGQuRFuAmQITYo
         Cccdk8W761Pp6gx4eOxs3Y8WhJNPyQs5hCzurQac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 030/119] riscv: Force flat memory model with no-mmu
Date:   Tue, 24 Mar 2020 14:10:15 +0100
Message-Id: <20200324130811.391353825@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

[ Upstream commit aa2734202acc506d09c8e641db4da161f902df27 ]

Compilation errors trigger if ARCH_SPARSEMEM_ENABLE is enabled for
a nommu kernel. Since the sparsemem model does not make sense anyway
for the nommu case, do not allow selecting this option to always use
the flatmem model.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index fa7dc03459e7f..1be11c23fa335 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -121,6 +121,7 @@ config ARCH_FLATMEM_ENABLE
 
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
+	depends on MMU
 	select SPARSEMEM_VMEMMAP_ENABLE
 
 config ARCH_SELECT_MEMORY_MODEL
-- 
2.20.1




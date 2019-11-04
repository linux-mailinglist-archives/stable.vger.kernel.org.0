Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5EF0EEE5C
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387561AbfKDWOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:14:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:41160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390206AbfKDWIS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:08:18 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7406B214D9;
        Mon,  4 Nov 2019 22:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905298;
        bh=ApFT2yRZPjE5kYFWb07gNAkCn4f1C3IPuAu8B/kloaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WE35N7c0cIFxG876U3NWyZI25S5gydTOVy0Z4TU3M+xDh7pSx9z2lO3HegFDrUggu
         qhQq+uSgDV36oLlQOP+4eZ6FHoxp7a+xr4PEqcpMBcaVo/dNs8NALBRsdXXdiZJEgt
         TJpDXOemJyQSdH4VKCcCi+RWvN6n17J1z+Z2V3W8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Chen <vincent.chen@sifive.com>,
        Christoph Hellwig <hch@lst.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 055/163] riscv: avoid sending a SIGTRAP to a user thread trapped in WARN()
Date:   Mon,  4 Nov 2019 22:44:05 +0100
Message-Id: <20191104212144.120530569@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Chen <vincent.chen@sifive.com>

[ Upstream commit e0c0fc18f10d5080cddde0e81505fd3e952c20c4 ]

On RISC-V, when the kernel runs code on behalf of a user thread, and the
kernel executes a WARN() or WARN_ON(), the user thread will be sent
a bogus SIGTRAP.  Fix the RISC-V kernel code to not send a SIGTRAP when
a WARN()/WARN_ON() is executed.

Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
[paul.walmsley@sifive.com: fixed subject]
Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 055a937aca70a..82f42a55451eb 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -134,7 +134,7 @@ asmlinkage void do_trap_break(struct pt_regs *regs)
 			break;
 		case BUG_TRAP_TYPE_WARN:
 			regs->sepc += get_break_insn_length(regs->sepc);
-			break;
+			return;
 		case BUG_TRAP_TYPE_BUG:
 #endif /* CONFIG_GENERIC_BUG */
 		default:
-- 
2.20.1




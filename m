Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEE10DD1A2
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbfJRWEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:04:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728366AbfJRWEe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF6E1222D1;
        Fri, 18 Oct 2019 22:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436274;
        bh=ApFT2yRZPjE5kYFWb07gNAkCn4f1C3IPuAu8B/kloaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLaazqccVC1w9LktKM01EE9p/yydtlC58IRMscYSVrbK15O9iQ2BRuH0y+1aXRJWT
         eo8fPvVRSgDf7xT7KrXDT+uIZFLaLx4UbkXJsZyzXkZb5lU4eEt5BoJfw8Jl7MAWkU
         9naslxYnrZZlgKuEhWBJdevxKFQ5/t35/icvlhPM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Chen <vincent.chen@sifive.com>,
        Christoph Hellwig <hch@lst.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 53/89] riscv: avoid sending a SIGTRAP to a user thread trapped in WARN()
Date:   Fri, 18 Oct 2019 18:02:48 -0400
Message-Id: <20191018220324.8165-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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


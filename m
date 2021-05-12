Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547A437CCCD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235919AbhELQru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:47:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243570AbhELQld (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA9236197C;
        Wed, 12 May 2021 16:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835500;
        bh=vEXn2+QEnkphoNPm6RRdHN5YvdmqZSX3NzzcoXql7Lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=COLpOHiJfdPxEoj+/8ROgLPRGRfV7zfmsim2j/41/HRhvikIX9GY+JBfIxSqOBlmq
         Qdgc/PfohTbDyEIzrY9boL/kCDld3lzBLxaYS+hOpk1OCzvmK4EEDM+s90hVDii31q
         6yWK7HhAEArAm0zPTFfrgapVMfsAG9B54yI4uX+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 368/677] x86/kprobes: Retrieve correct opcode for group instruction
Date:   Wed, 12 May 2021 16:46:54 +0200
Message-Id: <20210512144849.552383168@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit d60ad3d46f1d04a282c56159f1deb675c12733fd ]

Since the opcodes start from 0xff are group5 instruction group which is
not 2 bytes opcode but the extended opcode determined by the MOD/RM byte.

The commit abd82e533d88 ("x86/kprobes: Do not decode opcode in resume_execution()")
used insn->opcode.bytes[1], but that is not correct. We have to refer
the insn->modrm.bytes[1] instead.

Fixes: abd82e533d88 ("x86/kprobes: Do not decode opcode in resume_execution()")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/161469872400.49483.18214724458034233166.stgit@devnote2
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kprobes/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index df776cdca327..08674e7a5d7b 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -448,7 +448,11 @@ static void set_resume_flags(struct kprobe *p, struct insn *insn)
 		break;
 #endif
 	case 0xff:
-		opcode = insn->opcode.bytes[1];
+		/*
+		 * Since the 0xff is an extended group opcode, the instruction
+		 * is determined by the MOD/RM byte.
+		 */
+		opcode = insn->modrm.bytes[0];
 		if ((opcode & 0x30) == 0x10) {
 			/*
 			 * call absolute, indirect
-- 
2.30.2




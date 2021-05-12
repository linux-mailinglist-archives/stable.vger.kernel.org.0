Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A0737C53F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbhELPjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:39:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233501AbhELPbN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:31:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F9A261979;
        Wed, 12 May 2021 15:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832571;
        bh=3SM62GvkMFZGnJLjb/hj4gbkYcd99YoCE/nieeEMq2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCUAxeAw8VlROkm3niA3Jsgnt1yf5RlHiRyJNP5slr8yzPRlvhfheCHxr3ddEXT2w
         mA6EaSs7rWJVvxjkruTPl8XzLiFunJrBc6/PAC4T0c7PIRvUzLTAmbz907nG4i3ju2
         JFoy21bc9R9yjgvsPb2u2g7TjJ1zbNVivHQPNO/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 301/530] x86/kprobes: Fix to check non boostable prefixes correctly
Date:   Wed, 12 May 2021 16:46:51 +0200
Message-Id: <20210512144829.694715643@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 6dd3b8c9f58816a1354be39559f630cd1bd12159 ]

There are 2 bugs in the can_boost() function because of using
x86 insn decoder. Since the insn->opcode never has a prefix byte,
it can not find CS override prefix in it. And the insn->attr is
the attribute of the opcode, thus inat_is_address_size_prefix(
insn->attr) always returns false.

Fix those by checking each prefix bytes with for_each_insn_prefix
loop and getting the correct attribute for each prefix byte.
Also, this removes unlikely, because this is a slow path.

Fixes: a8d11cd0714f ("kprobes/x86: Consolidate insn decoder users for copying code")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/161666691162.1120877.2808435205294352583.stgit@devnote2
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kprobes/core.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 39f7d8c3c064..535da74c124e 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -159,6 +159,8 @@ NOKPROBE_SYMBOL(skip_prefixes);
 int can_boost(struct insn *insn, void *addr)
 {
 	kprobe_opcode_t opcode;
+	insn_byte_t prefix;
+	int i;
 
 	if (search_exception_tables((unsigned long)addr))
 		return 0;	/* Page fault may occur on this address. */
@@ -171,9 +173,14 @@ int can_boost(struct insn *insn, void *addr)
 	if (insn->opcode.nbytes != 1)
 		return 0;
 
-	/* Can't boost Address-size override prefix */
-	if (unlikely(inat_is_address_size_prefix(insn->attr)))
-		return 0;
+	for_each_insn_prefix(insn, i, prefix) {
+		insn_attr_t attr;
+
+		attr = inat_get_opcode_attribute(prefix);
+		/* Can't boost Address-size override prefix and CS override prefix */
+		if (prefix == 0x2e || inat_is_address_size_prefix(attr))
+			return 0;
+	}
 
 	opcode = insn->opcode.bytes[0];
 
@@ -198,8 +205,8 @@ int can_boost(struct insn *insn, void *addr)
 		/* clear and set flags are boostable */
 		return (opcode == 0xf5 || (0xf7 < opcode && opcode < 0xfe));
 	default:
-		/* CS override prefix and call are not boostable */
-		return (opcode != 0x2e && opcode != 0x9a);
+		/* call is not boostable */
+		return opcode != 0x9a;
 	}
 }
 
-- 
2.30.2




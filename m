Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736F547AE71
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237954AbhLTPBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34030 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237542AbhLTO4Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:56:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1502B80EF2;
        Mon, 20 Dec 2021 14:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E154C36AF8;
        Mon, 20 Dec 2021 14:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012181;
        bh=KbG2sf3M/w5o6lkbivBdu3cIy6jqTVRS6yXejm+KbIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bh74io0nFtOhNIz1nh4on71SK2n1bf6LWyyDU2FUmfmFYk1rBWOqGwUtQYJlZWTmq
         mWbkrIaE+73lijRBFGmBbXUXiPRqa7q7EFJlJVNMzELaiAUt1BxRFOL14mcx0ChLnb
         zOxr+3a3nluBIEHgWK53Vv1/NkQXpQcVXX6G7LJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/177] bpf: Fix extable fixup offset.
Date:   Mon, 20 Dec 2021 15:34:20 +0100
Message-Id: <20211220143043.773689575@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 433956e91200734d09958673a56df02d00a917c2 ]

The prog - start_of_ldx is the offset before the faulting ldx to the location
after it, so this will be used to adjust pt_regs->ip for jumping over it and
continuing, and with old temp it would have been fixed up to the wrong offset,
causing crash.

Fixes: 4c5de127598e ("bpf: Emit explicit NULL pointer checks for PROBE_LDX instructions.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 9ea57389c554b..462d8e68b3f43 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1332,7 +1332,7 @@ st:			if (is_imm8(insn->off))
 				 * End result: x86 insn "mov rbx, qword ptr [rax+0x14]"
 				 * of 4 bytes will be ignored and rbx will be zero inited.
 				 */
-				ex->fixup = (prog - temp) | (reg2pt_regs[dst_reg] << 8);
+				ex->fixup = (prog - start_of_ldx) | (reg2pt_regs[dst_reg] << 8);
 			}
 			break;
 
-- 
2.33.0




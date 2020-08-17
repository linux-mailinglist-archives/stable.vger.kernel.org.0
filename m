Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B4624733C
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403776AbgHQSxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387823AbgHQPv5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:51:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB23D2072E;
        Mon, 17 Aug 2020 15:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679511;
        bh=vLVCELfJ5xUJYRbUxXEgmD7kf3j/T/A1DBP4LsAtY4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MrzahYsXFRvHRjcaRr749YdfvXhCfXmf8wiuLEYOO6dQLUtXzyphGUYa1EnmGN4e9
         M5uK/1s+oJHlmLSbcxeZctMd6nG/u/b4OwvFYb3W+cESVEq4CHz4eECpr9cKgEKfs/
         IOXII+poprjK8vnCLaF8AobIz8WR8L6helqBx8rM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 238/393] s390/bpf: Tolerate not converging code shrinking
Date:   Mon, 17 Aug 2020 17:14:48 +0200
Message-Id: <20200817143831.164467346@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 1491b73311a15bb5beeab5d30e03bff761ef6c18 ]

"BPF_MAXINSNS: Maximum possible literals" unnecessarily falls back to
the interpreter because of failing sanity check in bpf_set_addr. The
problem is that there are a lot of branches that can be shrunk, and
doing so opens up the possibility to shrink even more. This process
does not converge after 3 passes, causing code offsets to change during
the codegen pass, which must never happen.

Fix by inserting nops during codegen pass in order to preserve code
offets.

Fixes: 4e9b4a6883dd ("s390/bpf: Use relative long branches")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200717165326.6786-5-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 650b89eb693e6..95809599ebffd 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -489,6 +489,24 @@ static void save_restore_regs(struct bpf_jit *jit, int op, u32 stack_depth)
 	} while (re <= last);
 }
 
+static void bpf_skip(struct bpf_jit *jit, int size)
+{
+	if (size >= 6 && !is_valid_rel(size)) {
+		/* brcl 0xf,size */
+		EMIT6_PCREL_RIL(0xc0f4000000, size);
+		size -= 6;
+	} else if (size >= 4 && is_valid_rel(size)) {
+		/* brc 0xf,size */
+		EMIT4_PCREL(0xa7f40000, size);
+		size -= 4;
+	}
+	while (size >= 2) {
+		/* bcr 0,%0 */
+		_EMIT2(0x0700);
+		size -= 2;
+	}
+}
+
 /*
  * Emit function prologue
  *
@@ -1502,7 +1520,14 @@ static bool bpf_is_new_addr_sane(struct bpf_jit *jit, int i)
  */
 static int bpf_set_addr(struct bpf_jit *jit, int i)
 {
-	if (!bpf_is_new_addr_sane(jit, i))
+	int delta;
+
+	if (is_codegen_pass(jit)) {
+		delta = jit->prg - jit->addrs[i];
+		if (delta < 0)
+			bpf_skip(jit, -delta);
+	}
+	if (WARN_ON_ONCE(!bpf_is_new_addr_sane(jit, i)))
 		return -1;
 	jit->addrs[i] = jit->prg;
 	return 0;
-- 
2.25.1




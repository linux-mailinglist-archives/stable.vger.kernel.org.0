Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E081206318
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388527AbgFWUQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:16:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389463AbgFWUQr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:16:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE6A22064B;
        Tue, 23 Jun 2020 20:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943407;
        bh=q0lWZkJ15DYkEqUCjsgfyxJj9vcb1etOMZ4vffxnIcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQAjiux07+JkDF4Gkup+7jIvwQfRt07Vlm74FhqFfUhNd/8ny/VCOWSzOuofIeFfx
         NJxwzwOQJOjOHG487TLld4hBLkqm+xSCq8O542DY/bQvRUv++QV8Q1zTxYDRlf2Dwn
         CpB6i/hewRlQZrjr/JEj7pdjl7pvGmd2fxW42c4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 380/477] bpf: Undo internal BPF_PROBE_MEM in BPF insns dump
Date:   Tue, 23 Jun 2020 21:56:17 +0200
Message-Id: <20200623195425.494708006@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 29fcb05bbf1a7008900bb9bee347bdbfc7171036 ]

BPF_PROBE_MEM is kernel-internal implmementation details. When dumping BPF
instructions to user-space, it needs to be replaced back with BPF_MEM mode.

Fixes: 2a02759ef5f8 ("bpf: Add support for BTF pointers to interpreter")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200613002115.1632142-1-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 5e52765161f91..c8acc8f375836 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2924,6 +2924,7 @@ static struct bpf_insn *bpf_insn_prepare_dump(const struct bpf_prog *prog)
 	struct bpf_insn *insns;
 	u32 off, type;
 	u64 imm;
+	u8 code;
 	int i;
 
 	insns = kmemdup(prog->insnsi, bpf_prog_insn_size(prog),
@@ -2932,21 +2933,27 @@ static struct bpf_insn *bpf_insn_prepare_dump(const struct bpf_prog *prog)
 		return insns;
 
 	for (i = 0; i < prog->len; i++) {
-		if (insns[i].code == (BPF_JMP | BPF_TAIL_CALL)) {
+		code = insns[i].code;
+
+		if (code == (BPF_JMP | BPF_TAIL_CALL)) {
 			insns[i].code = BPF_JMP | BPF_CALL;
 			insns[i].imm = BPF_FUNC_tail_call;
 			/* fall-through */
 		}
-		if (insns[i].code == (BPF_JMP | BPF_CALL) ||
-		    insns[i].code == (BPF_JMP | BPF_CALL_ARGS)) {
-			if (insns[i].code == (BPF_JMP | BPF_CALL_ARGS))
+		if (code == (BPF_JMP | BPF_CALL) ||
+		    code == (BPF_JMP | BPF_CALL_ARGS)) {
+			if (code == (BPF_JMP | BPF_CALL_ARGS))
 				insns[i].code = BPF_JMP | BPF_CALL;
 			if (!bpf_dump_raw_ok())
 				insns[i].imm = 0;
 			continue;
 		}
+		if (BPF_CLASS(code) == BPF_LDX && BPF_MODE(code) == BPF_PROBE_MEM) {
+			insns[i].code = BPF_LDX | BPF_SIZE(code) | BPF_MEM;
+			continue;
+		}
 
-		if (insns[i].code != (BPF_LD | BPF_IMM | BPF_DW))
+		if (code != (BPF_LD | BPF_IMM | BPF_DW))
 			continue;
 
 		imm = ((u64)insns[i + 1].imm << 32) | (u32)insns[i].imm;
-- 
2.25.1




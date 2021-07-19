Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0769F3CE365
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242778AbhGSPhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:37:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347712AbhGSPfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D042061492;
        Mon, 19 Jul 2021 16:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711172;
        bh=ulJ/G6wjWazRSvOCapZDdOegzo5tfYJMdms8YEZU7Gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jRZwKDMJpcfFgTKC5cFx1sXnVdvKJYw6eDJ66eyqHxzsd91sxGqsC8vobEgnM/M+m
         9lBbglP+th48Pat9QStHiq3Cg7MpitwEtFc6W71FUJgNTNHGo2cCTmkQANqqIN4cUA
         x/xQ9gLjOnTaUlxZfdC2xYCIWBuS/QeToU93c0H0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 255/351] powerpc/bpf: Fix detecting BPF atomic instructions
Date:   Mon, 19 Jul 2021 16:53:21 +0200
Message-Id: <20210719144953.390810559@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

[ Upstream commit 419ac821766cbdb9fd85872bb3f1a589df05c94c ]

Commit 91c960b0056672 ("bpf: Rename BPF_XADD and prepare to encode other
atomics in .imm") converted BPF_XADD to BPF_ATOMIC and added a way to
distinguish instructions based on the immediate field. Existing JIT
implementations were updated to check for the immediate field and to
reject programs utilizing anything more than BPF_ADD (such as BPF_FETCH)
in the immediate field.

However, the check added to powerpc64 JIT did not look at the correct
BPF instruction. Due to this, such programs would be accepted and
incorrectly JIT'ed resulting in soft lockups, as seen with the atomic
bounds test. Fix this by looking at the correct immediate value.

Fixes: 91c960b0056672 ("bpf: Rename BPF_XADD and prepare to encode other atomics in .imm")
Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/4117b430ffaa8cd7af042496f87fd7539e4f17fd.1625145429.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/net/bpf_jit_comp64.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 57a8c1153851..94411af24013 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -667,7 +667,7 @@ emit_clear:
 		 * BPF_STX ATOMIC (atomic ops)
 		 */
 		case BPF_STX | BPF_ATOMIC | BPF_W:
-			if (insn->imm != BPF_ADD) {
+			if (imm != BPF_ADD) {
 				pr_err_ratelimited(
 					"eBPF filter atomic op code %02x (@%d) unsupported\n",
 					code, i);
@@ -689,7 +689,7 @@ emit_clear:
 			PPC_BCC_SHORT(COND_NE, tmp_idx);
 			break;
 		case BPF_STX | BPF_ATOMIC | BPF_DW:
-			if (insn->imm != BPF_ADD) {
+			if (imm != BPF_ADD) {
 				pr_err_ratelimited(
 					"eBPF filter atomic op code %02x (@%d) unsupported\n",
 					code, i);
-- 
2.30.2




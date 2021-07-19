Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A483CE56E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349133AbhGSPuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241312AbhGSPqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:46:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A92AD61355;
        Mon, 19 Jul 2021 16:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712004;
        bh=kf5+CRsypA0+w/C48+bQ+w0/522bxgSGt4b3cn1oU/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=onozmVa/qCxjKd447M+NLv/L2v0+HDHsWPwV6wc8G3VbgJuj4D7s/i42fVNgpB9zV
         FXGHdAuAurNLp3Y1YP4RevvbXG8WDuHV7OdEUR/ATYZwAg7aKJek/MNjo0vQMi+0eK
         MYy9ux6sQLU749gcEU9GkNeq6iMZdYbk+3GHbLZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 213/292] powerpc/bpf: Fix detecting BPF atomic instructions
Date:   Mon, 19 Jul 2021 16:54:35 +0200
Message-Id: <20210719144950.000132515@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
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
index aaf1a887f653..2657bf542985 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -686,7 +686,7 @@ emit_clear:
 		 * BPF_STX ATOMIC (atomic ops)
 		 */
 		case BPF_STX | BPF_ATOMIC | BPF_W:
-			if (insn->imm != BPF_ADD) {
+			if (imm != BPF_ADD) {
 				pr_err_ratelimited(
 					"eBPF filter atomic op code %02x (@%d) unsupported\n",
 					code, i);
@@ -708,7 +708,7 @@ emit_clear:
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F2C14819B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733219AbgAXLVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:21:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:59390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391040AbgAXLVS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:21:18 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDD1E214AF;
        Fri, 24 Jan 2020 11:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864877;
        bh=W5+b0vwn4o5f8wVFUj2p7qTxj4DyO6rGRMdNK5197fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F45yKamNQh8Z9xz3KlByATzsl8rRUahhJpDvxv5PsZszBP2XOznfn8tguly7dDDcX
         oxmTtUScM9V7g1tBP16Bo4SXGzBFebN0zR16jrzFLSnRwWEq0LW+bdHQ2titzO4uy3
         4+NM33OD4DtmisqsgLyOWwiGknImDzQ078+G6uU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiong Wang <jiong.wang@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 368/639] nfp: bpf: fix static check error through tightening shift amount adjustment
Date:   Fri, 24 Jan 2020 10:28:58 +0100
Message-Id: <20200124093133.165700968@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiong Wang <jiong.wang@netronome.com>

[ Upstream commit 69e168ebdcfcb87ce7252d4857d570f99996fa27 ]

NFP shift instruction has something special. If shift direction is left
then shift amount of 1 to 31 is specified as 32 minus the amount to shift.

But no need to do this for indirect shift which has shift amount be 0. Even
after we do this subtraction, shift amount 0 will be turned into 32 which
will eventually be encoded the same as 0 because only low 5 bits are
encoded, but shift amount be 32 will fail the FIELD_PREP check done later
on shift mask (0x1f), due to 32 is out of mask range. Such error has been
observed when compiling nfp/bpf/jit.c using gcc 8.3 + O3.

This issue has started when indirect shift support added after which the
incoming shift amount to __emit_shf could be 0, therefore it is at that
time shift amount adjustment inside __emit_shf should have been tightened.

Fixes: 991f5b3651f6 ("nfp: bpf: support logic indirect shifts (BPF_[L|R]SH | BPF_X)")
Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Reported-by: Pablo Cascón <pablo.cascon@netronome.com
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/bpf/jit.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/jit.c b/drivers/net/ethernet/netronome/nfp/bpf/jit.c
index 4e18d95e548f1..c3ce0fb47a0f0 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/jit.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/jit.c
@@ -326,7 +326,18 @@ __emit_shf(struct nfp_prog *nfp_prog, u16 dst, enum alu_dst_ab dst_ab,
 		return;
 	}
 
-	if (sc == SHF_SC_L_SHF)
+	/* NFP shift instruction has something special. If shift direction is
+	 * left then shift amount of 1 to 31 is specified as 32 minus the amount
+	 * to shift.
+	 *
+	 * But no need to do this for indirect shift which has shift amount be
+	 * 0. Even after we do this subtraction, shift amount 0 will be turned
+	 * into 32 which will eventually be encoded the same as 0 because only
+	 * low 5 bits are encoded, but shift amount be 32 will fail the
+	 * FIELD_PREP check done later on shift mask (0x1f), due to 32 is out of
+	 * mask range.
+	 */
+	if (sc == SHF_SC_L_SHF && shift)
 		shift = 32 - shift;
 
 	insn = OP_SHF_BASE |
-- 
2.20.1




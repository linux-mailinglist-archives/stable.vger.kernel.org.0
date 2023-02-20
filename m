Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA2369CDAC
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbjBTNvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbjBTNvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:51:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37CE1E2AE
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:51:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 708C2B80D1F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C157EC433D2;
        Mon, 20 Feb 2023 13:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901093;
        bh=NA8eaa3N6WiAed1UFZNfCwa2C1XGd/4k4g+Ho2x+GBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rtz7r1H+fPKtXjfRe9oKY9x8WITe9jS6LUG3eAHaM1FLZ8+PNpeNrN9fYa4ruf1RX
         fDsITBQV5XhIBITLW0n/uQOJoIolkCt8LO78RY8dBKDfsEeRBJQ2hL8D9K8B5Z6QEB
         JEdZf40ytx2f8GoXiRkniSYMMh/dDeYEAFVe3ub4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guo Ren <guoren@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>,
        Bjorn Topel <bjorn.topel@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 03/83] riscv: kprobe: Fixup misaligned load text
Date:   Mon, 20 Feb 2023 14:35:36 +0100
Message-Id: <20230220133553.792226107@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

[ Upstream commit eb7423273cc9922ee2d05bf660c034d7d515bb91 ]

The current kprobe would cause a misaligned load for the probe point.
This patch fixup it with two half-word loads instead.

Fixes: c22b0bcb1dd0 ("riscv: Add kprobes supported")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/linux-riscv/878rhig9zj.fsf@all.your.base.are.belong.to.us/
Reported-by: Bjorn Topel <bjorn.topel@gmail.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/r/20230204063531.740220-1-guoren@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/probes/kprobes.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/probes/kprobes.c b/arch/riscv/kernel/probes/kprobes.c
index b53aa0209e079..7548b1d62509c 100644
--- a/arch/riscv/kernel/probes/kprobes.c
+++ b/arch/riscv/kernel/probes/kprobes.c
@@ -65,16 +65,18 @@ static bool __kprobes arch_check_kprobe(struct kprobe *p)
 
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
-	unsigned long probe_addr = (unsigned long)p->addr;
+	u16 *insn = (u16 *)p->addr;
 
-	if (probe_addr & 0x1)
+	if ((unsigned long)insn & 0x1)
 		return -EILSEQ;
 
 	if (!arch_check_kprobe(p))
 		return -EILSEQ;
 
 	/* copy instruction */
-	p->opcode = *p->addr;
+	p->opcode = (kprobe_opcode_t)(*insn++);
+	if (GET_INSN_LENGTH(p->opcode) == 4)
+		p->opcode |= (kprobe_opcode_t)(*insn) << 16;
 
 	/* decode instruction */
 	switch (riscv_probe_decode_insn(p->addr, &p->ainsn.api)) {
-- 
2.39.0




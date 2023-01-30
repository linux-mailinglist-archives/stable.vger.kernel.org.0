Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802AD681272
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237704AbjA3OVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:21:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237709AbjA3OU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:20:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0B938B64
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:19:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CFA461014
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420F4C433EF;
        Mon, 30 Jan 2023 14:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088321;
        bh=fpReE+b5+GjmPdd6xk2PqV/Ar4GK3VsfGhgIRkBBu68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ejmBtTW9Gd6uQ1yJyIcC+WFLG3sWgxB2kmd/bBk7qIzQzDh0xdlPbvAEbqKu1LD9W
         +c6VSSO5w0p72QkcfcGbCU1icc6r4xojv1hyF4TGKEdAtg7mRhrP8gwAGEBrklq+kv
         JmO8zqu3c2Cyc26fS3hzeQorAxDr0+bNHRB1Wy3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liao Chang <liaochang1@huawei.com>,
        Guo Ren <guoren@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 185/204] riscv/kprobe: Fix instruction simulation of JALR
Date:   Mon, 30 Jan 2023 14:52:30 +0100
Message-Id: <20230130134324.686085518@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
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

From: Liao Chang <liaochang1@huawei.com>

[ Upstream commit ca0254998be4d74cf6add70ccfab0d2dbd362a10 ]

Set kprobe at 'jalr 1140(ra)' of vfs_write results in the following
crash:

[   32.092235] Unable to handle kernel access to user memory without uaccess routines at virtual address 00aaaaaad77b1170
[   32.093115] Oops [#1]
[   32.093251] Modules linked in:
[   32.093626] CPU: 0 PID: 135 Comm: ftracetest Not tainted 6.2.0-rc2-00013-gb0aa5e5df0cb-dirty #16
[   32.093985] Hardware name: riscv-virtio,qemu (DT)
[   32.094280] epc : ksys_read+0x88/0xd6
[   32.094855]  ra : ksys_read+0xc0/0xd6
[   32.095016] epc : ffffffff801cda80 ra : ffffffff801cdab8 sp : ff20000000d7bdc0
[   32.095227]  gp : ffffffff80f14000 tp : ff60000080f9cb40 t0 : ffffffff80f13e80
[   32.095500]  t1 : ffffffff8000c29c t2 : ffffffff800dbc54 s0 : ff20000000d7be60
[   32.095716]  s1 : 0000000000000000 a0 : ffffffff805a64ae a1 : ffffffff80a83708
[   32.095921]  a2 : ffffffff80f160a0 a3 : 0000000000000000 a4 : f229b0afdb165300
[   32.096171]  a5 : f229b0afdb165300 a6 : ffffffff80eeebd0 a7 : 00000000000003ff
[   32.096411]  s2 : ff6000007ff76800 s3 : fffffffffffffff7 s4 : 00aaaaaad77b1170
[   32.096638]  s5 : ffffffff80f160a0 s6 : ff6000007ff76800 s7 : 0000000000000030
[   32.096865]  s8 : 00ffffffc3d97be0 s9 : 0000000000000007 s10: 00aaaaaad77c9410
[   32.097092]  s11: 0000000000000000 t3 : ffffffff80f13e48 t4 : ffffffff8000c29c
[   32.097317]  t5 : ffffffff8000c29c t6 : ffffffff800dbc54
[   32.097505] status: 0000000200000120 badaddr: 00aaaaaad77b1170 cause: 000000000000000d
[   32.098011] [<ffffffff801cdb72>] ksys_write+0x6c/0xd6
[   32.098222] [<ffffffff801cdc06>] sys_write+0x2a/0x38
[   32.098405] [<ffffffff80003c76>] ret_from_syscall+0x0/0x2

Since the rs1 and rd might be the same one, such as 'jalr 1140(ra)',
hence it requires obtaining the target address from rs1 followed by
updating rd.

Fixes: c22b0bcb1dd0 ("riscv: Add kprobes supported")
Signed-off-by: Liao Chang <liaochang1@huawei.com>
Reviewed-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/20230116064342.2092136-1-liaochang1@huawei.com
[Palmer: Pick Guo's cleanup]
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/probes/simulate-insn.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/probes/simulate-insn.c b/arch/riscv/kernel/probes/simulate-insn.c
index d73e96f6ed7c..a20568bd1f1a 100644
--- a/arch/riscv/kernel/probes/simulate-insn.c
+++ b/arch/riscv/kernel/probes/simulate-insn.c
@@ -71,11 +71,11 @@ bool __kprobes simulate_jalr(u32 opcode, unsigned long addr, struct pt_regs *reg
 	u32 rd_index = (opcode >> 7) & 0x1f;
 	u32 rs1_index = (opcode >> 15) & 0x1f;
 
-	ret = rv_insn_reg_set_val(regs, rd_index, addr + 4);
+	ret = rv_insn_reg_get_val(regs, rs1_index, &base_addr);
 	if (!ret)
 		return ret;
 
-	ret = rv_insn_reg_get_val(regs, rs1_index, &base_addr);
+	ret = rv_insn_reg_set_val(regs, rd_index, addr + 4);
 	if (!ret)
 		return ret;
 
-- 
2.39.0




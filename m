Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A5C69449B
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 12:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjBMLd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 06:33:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBMLd6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 06:33:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51492118
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 03:33:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 523E560F6B
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 11:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B94AC433EF;
        Mon, 13 Feb 2023 11:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676288036;
        bh=40cZyGEVNnMgPJZmJ0uIXweyVxFXkFC4I/l3QSCiSvE=;
        h=Subject:To:Cc:From:Date:From;
        b=u34MBlGObHjbYea9IuYcdaQ+u8/V5YUvrymQa9gkg6aXvC95hseQchf04WbXWoB+m
         WiSITL4r2yZEOoEVmKfngqQRYnM8B1Tn3hCd6CaVd5XYLCdFUelJhihJ+PYk6HJlWc
         SftHE4Iu1fqY302Am+9jmqflrSOW3RmvfiRvJEfE=
Subject: FAILED: patch "[PATCH] riscv: kprobe: Fixup misaligned load text" failed to apply to 5.15-stable tree
To:     guoren@kernel.org, bjorn.topel@gmail.com, bjorn@kernel.org,
        guoren@linux.alibaba.com, palmer@rivosinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Feb 2023 12:33:54 +0100
Message-ID: <1676288034150141@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

eb7423273cc9 ("riscv: kprobe: Fixup misaligned load text")
9c89bb8e3272 ("kprobes: treewide: Cleanup the error messages for kprobes")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From eb7423273cc9922ee2d05bf660c034d7d515bb91 Mon Sep 17 00:00:00 2001
From: Guo Ren <guoren@kernel.org>
Date: Sat, 4 Feb 2023 01:35:31 -0500
Subject: [PATCH] riscv: kprobe: Fixup misaligned load text
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/arch/riscv/kernel/probes/kprobes.c b/arch/riscv/kernel/probes/kprobes.c
index 41c7481afde3..2bedec37d092 100644
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6FE4D02AD
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 16:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236252AbiCGP0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 10:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243734AbiCGP0G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 10:26:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699B190CD9
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 07:25:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21D62B815E2
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 15:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B28C340E9;
        Mon,  7 Mar 2022 15:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646666708;
        bh=tAnyq2Ahtbi5n/3ZF1ZO8QSkb/X0PXbMiPP1RzLNunU=;
        h=Subject:To:Cc:From:Date:From;
        b=dDqB8ESQLcSnGFax6m4MBB/EZbHgu5qYa8Qmk4Z/adOVqL3pjpiSQgFZ/zxLr+s/2
         HN1ycH9+wJOpqJP1S9sNeGwfHbYdkN9Nja8GmnxlxTHBN27h5Qeamf3C/2xdVsP+64
         hv90yUZLf4V7e7yTdB3dBzajH6MjJ0ebtMgsEOJI=
Subject: FAILED: patch "[PATCH] bpf, arm64: Use emit_addr_mov_i64() for BPF_PSEUDO_FUNC" failed to apply to 5.15-stable tree
To:     houtao1@huawei.com, daniel@iogearbox.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Mar 2022 16:25:06 +0100
Message-ID: <164666670621020@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e4a41c2c1fa916547e63440c73a51a5eb06247af Mon Sep 17 00:00:00 2001
From: Hou Tao <houtao1@huawei.com>
Date: Fri, 31 Dec 2021 23:10:18 +0800
Subject: [PATCH] bpf, arm64: Use emit_addr_mov_i64() for BPF_PSEUDO_FUNC

The following error is reported when running "./test_progs -t for_each"
under arm64:

  bpf_jit: multi-func JIT bug 58 != 56
  [...]
  JIT doesn't support bpf-to-bpf calls

The root cause is the size of BPF_PSEUDO_FUNC instruction increases
from 2 to 3 after the address of called bpf-function is settled and
there are two bpf-to-bpf calls in test_pkt_access. The generated
instructions are shown below:

  0x48:  21 00 C0 D2    movz x1, #0x1, lsl #32
  0x4c:  21 00 80 F2    movk x1, #0x1

  0x48:  E1 3F C0 92    movn x1, #0x1ff, lsl #32
  0x4c:  41 FE A2 F2    movk x1, #0x17f2, lsl #16
  0x50:  81 70 9F F2    movk x1, #0xfb84

Fixing it by using emit_addr_mov_i64() for BPF_PSEUDO_FUNC, so
the size of jited image will not change.

Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211231151018.3781550-1-houtao1@huawei.com

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 07aad85848fa..e96d4d87291f 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -792,7 +792,10 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		u64 imm64;
 
 		imm64 = (u64)insn1.imm << 32 | (u32)imm;
-		emit_a64_mov_i64(dst, imm64, ctx);
+		if (bpf_pseudo_func(insn))
+			emit_addr_mov_i64(dst, imm64, ctx);
+		else
+			emit_a64_mov_i64(dst, imm64, ctx);
 
 		return 1;
 	}


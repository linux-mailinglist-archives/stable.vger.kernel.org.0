Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C043B6AF2B2
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbjCGSz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233536AbjCGSy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:54:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBFA9F229
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:42:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 71793CE1C82
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B60C4339C;
        Tue,  7 Mar 2023 18:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214555;
        bh=yPOuzc+md8jm8p0ca7Ypz54Wmw9F1jEj7lpVEvbTQV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KVYjJjL94bpQHnu6PmEx5bSFatNfkRHHVpb7a0SzqJh8ZskC/5oX68a4iT3Zmva+I
         beh9ujZm4juoiZ1kjRt5n6WAxzwJBLJMJd7I1y32+6jcHgYiaHT1g9Fx3RktUyONZo
         HlVSd/HRfx++J8rd0INexR/+HxAZongWEdrNqyj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Greentime Hu <greentime.hu@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>, Guo Ren <guoren@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 859/885] riscv: jump_label: Fixup unaligned arch_static_branch function
Date:   Tue,  7 Mar 2023 18:03:13 +0100
Message-Id: <20230307170039.074438582@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Chiu <andy.chiu@sifive.com>

commit 9ddfc3cd806081ce1f6c9c2f988cbb031f35d28f upstream.

Runtime code patching must be done at a naturally aligned address, or we
may execute on a partial instruction.

We have encountered problems traced back to static jump functions during
the test. We switched the tracer randomly for every 1~5 seconds on a
dual-core QEMU setup and found the kernel sucking at a static branch
where it jumps to itself.

The reason is that the static branch was 2-byte but not 4-byte aligned.
Then, the kernel would patch the instruction, either J or NOP, with two
half-word stores if the machine does not have efficient unaligned
accesses. Thus, moments exist where half of the NOP mixes with the other
half of the J when transitioning the branch. In our particular case, on
a little-endian machine, the upper half of the NOP was mixed with the
lower part of the J when enabling the branch, resulting in a jump that
jumped to itself. Conversely, it would result in a HINT instruction when
disabling the branch, but it might not be observable.

ARM64 does not have this problem since all instructions must be 4-byte
aligned.

Fixes: ebc00dde8a97 ("riscv: Add jump-label implementation")
Link: https://lore.kernel.org/linux-riscv/20220913094252.3555240-6-andy.chiu@sifive.com/
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/20230206090440.1255001-1-guoren@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/jump_label.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/riscv/include/asm/jump_label.h
+++ b/arch/riscv/include/asm/jump_label.h
@@ -18,6 +18,7 @@ static __always_inline bool arch_static_
 					       const bool branch)
 {
 	asm_volatile_goto(
+		"	.align		2			\n\t"
 		"	.option push				\n\t"
 		"	.option norelax				\n\t"
 		"	.option norvc				\n\t"
@@ -39,6 +40,7 @@ static __always_inline bool arch_static_
 						    const bool branch)
 {
 	asm_volatile_goto(
+		"	.align		2			\n\t"
 		"	.option push				\n\t"
 		"	.option norelax				\n\t"
 		"	.option norvc				\n\t"



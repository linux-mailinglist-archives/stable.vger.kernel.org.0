Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58D066499E
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239520AbjAJSXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239311AbjAJSWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:22:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C9C58D2E
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC15261846
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A9FC433D2;
        Tue, 10 Jan 2023 18:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374811;
        bh=OqJS7mdcDFWczlCp7zGtOy4ei+eCaRVuC/4bgPswZSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mDpHqrG5mjMAX/LuZ2GUOaKDGE6tBDJjTqflGKCFvjsUZNDIwOcBbCaGzCK6jK+PY
         oz6hQS9DzmbsVE+sk8aV2OH6irZ1UF0fyg/0nqkj3wavhxaN1uslNRsoS9+H2TtyZo
         UGLCzLw6n02RB96QOlSNRO3u7LhkgnJ6iAr0WSfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 142/159] riscv, kprobes: Stricter c.jr/c.jalr decoding
Date:   Tue, 10 Jan 2023 19:04:50 +0100
Message-Id: <20230110180022.970591715@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Björn Töpel <bjorn@rivosinc.com>

commit b2d473a6019ef9a54b0156ecdb2e0398c9fa6a24 upstream.

In the compressed instruction extension, c.jr, c.jalr, c.mv, and c.add
is encoded the following way (each instruction is 16b):

---+-+-----------+-----------+--
100 0 rs1[4:0]!=0       00000 10 : c.jr
100 1 rs1[4:0]!=0       00000 10 : c.jalr
100 0  rd[4:0]!=0 rs2[4:0]!=0 10 : c.mv
100 1  rd[4:0]!=0 rs2[4:0]!=0 10 : c.add

The following logic is used to decode c.jr and c.jalr:

  insn & 0xf007 == 0x8002 => instruction is an c.jr
  insn & 0xf007 == 0x9002 => instruction is an c.jalr

When 0xf007 is used to mask the instruction, c.mv can be incorrectly
decoded as c.jr, and c.add as c.jalr.

Correct the decoding by changing the mask from 0xf007 to 0xf07f.

Fixes: c22b0bcb1dd0 ("riscv: Add kprobes supported")
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/20230102160748.1307289-1-bjorn@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/probes/simulate-insn.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/kernel/probes/simulate-insn.h
+++ b/arch/riscv/kernel/probes/simulate-insn.h
@@ -31,9 +31,9 @@ __RISCV_INSN_FUNCS(fence,	0x7f, 0x0f);
 	} while (0)
 
 __RISCV_INSN_FUNCS(c_j,		0xe003, 0xa001);
-__RISCV_INSN_FUNCS(c_jr,	0xf007, 0x8002);
+__RISCV_INSN_FUNCS(c_jr,	0xf07f, 0x8002);
 __RISCV_INSN_FUNCS(c_jal,	0xe003, 0x2001);
-__RISCV_INSN_FUNCS(c_jalr,	0xf007, 0x9002);
+__RISCV_INSN_FUNCS(c_jalr,	0xf07f, 0x9002);
 __RISCV_INSN_FUNCS(c_beqz,	0xe003, 0xc001);
 __RISCV_INSN_FUNCS(c_bnez,	0xe003, 0xe001);
 __RISCV_INSN_FUNCS(c_ebreak,	0xffff, 0x9002);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F2856FC96
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbiGKJpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233606AbiGKJo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:44:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96043E75F;
        Mon, 11 Jul 2022 02:22:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C96BB80D2C;
        Mon, 11 Jul 2022 09:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D363C34115;
        Mon, 11 Jul 2022 09:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531321;
        bh=PyFmHW+SAkR6HsxRgSb5+k3Fe6DCWDzbWPlYeRLRIkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=incqfgm8uuDIcTAMphNhFF6cJaJ1OE4ZuX3W4fw+UlaikdI5odC0UsWmzeCN0E2Ow
         nDQ5pyjxaHlg5dHmus761hEMs2VYKyW8f+zbweEXnI7grBXd9bqP8z1amM6hUJFDxD
         ZwLJjcTDUgyaZV35dtPysI2hvJHKyNDJRqZ6PHLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/230] bpf, arm64: Use emit_addr_mov_i64() for BPF_PSEUDO_FUNC
Date:   Mon, 11 Jul 2022 11:05:02 +0200
Message-Id: <20220711090605.389897644@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit e4a41c2c1fa916547e63440c73a51a5eb06247af ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 95439bbe5df8..4895b4d7e150 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -788,7 +788,10 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		u64 imm64;
 
 		imm64 = (u64)insn1.imm << 32 | (u32)imm;
-		emit_a64_mov_i64(dst, imm64, ctx);
+		if (bpf_pseudo_func(insn))
+			emit_addr_mov_i64(dst, imm64, ctx);
+		else
+			emit_a64_mov_i64(dst, imm64, ctx);
 
 		return 1;
 	}
-- 
2.35.1




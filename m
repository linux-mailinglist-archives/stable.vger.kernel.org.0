Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD6758FF98
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbiHKPbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235775AbiHKPa6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:30:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136DF95694;
        Thu, 11 Aug 2022 08:30:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F54B615BB;
        Thu, 11 Aug 2022 15:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C88C43140;
        Thu, 11 Aug 2022 15:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660231808;
        bh=6H4moB9QsrEB+NA2Gjt3GQdw4j7lCm+5w+xZmhZ6CbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l5nZjappeqm5Ly//Evkhjv55KIIxtSODg/8eeQpj4bWKs+Crilo8BTfSR84cqC1l1
         bCwTEGK2kSc6tzh1Ffl1LEFZ8xcWukM1Ve9qx0Nxt55/4CQZSXjAJWZV9zLifMZ99P
         GkKC27DQncfljOQ3jACRZoiccHz+0SZEnUosa+Fx2tPghmiEuRUp6SE2K/c35+Z91R
         rfNekvZdAXvNvSCGVfOabfh/qXrE6G0r+FAtMgm83UN3KkC/olP3DeYQ0cy0M7nC/2
         PQprLy1Nwpc2vX/oQZvVz3Uor+IXTPPGI3oySW2G1WKA7MC64oKJ9lfVScxck2E/Z7
         SvM5cB8Snxzkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, daniel@iogearbox.net,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 014/105] libbpf: Fix an error in 64bit relocation value computation
Date:   Thu, 11 Aug 2022 11:26:58 -0400
Message-Id: <20220811152851.1520029-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Yonghong Song <yhs@fb.com>

[ Upstream commit b58b2b3a31228bd9aaed9b96e9452dafd0d46024 ]

Currently, the 64bit relocation value in the instruction
is computed as follows:
  __u64 imm = insn[0].imm + ((__u64)insn[1].imm << 32)

Suppose insn[0].imm = -1 (0xffffffff) and insn[1].imm = 1.
With the above computation, insn[0].imm will first sign-extend
to 64bit -1 (0xffffffffFFFFFFFF) and then add 0x1FFFFFFFF,
producing incorrect value 0xFFFFFFFF. The correct value
should be 0x1FFFFFFFF.

Changing insn[0].imm to __u32 first will prevent 64bit sign
extension and fix the issue. Merging high and low 32bit values
also changed from '+' to '|' to be consistent with other
similar occurences in kernel and libbpf.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Dave Marchevsky <davemarchevsky@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20220607062610.3717378-1-yhs@fb.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/relo_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/relo_core.c b/tools/lib/bpf/relo_core.c
index ba4453dfd1ed..a9216b65724a 100644
--- a/tools/lib/bpf/relo_core.c
+++ b/tools/lib/bpf/relo_core.c
@@ -1024,7 +1024,7 @@ int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
 			return -EINVAL;
 		}
 
-		imm = insn[0].imm + ((__u64)insn[1].imm << 32);
+		imm = (__u32)insn[0].imm | ((__u64)insn[1].imm << 32);
 		if (res->validate && imm != orig_val) {
 			pr_warn("prog '%s': relo #%d: unexpected insn #%d (LDIMM64) value: got %llu, exp %u -> %u\n",
 				prog_name, relo_idx,
-- 
2.35.1


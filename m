Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7702F59017B
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236870AbiHKPwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236878AbiHKPwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:52:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385E89DFB3;
        Thu, 11 Aug 2022 08:44:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74157B82156;
        Thu, 11 Aug 2022 15:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23204C433C1;
        Thu, 11 Aug 2022 15:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232644;
        bh=zy+RadlHKf4+6wfk/N//I1iIxx7CK8Pr5EdABxD750Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGZHlYWN5aBWIEK/HM6aPSpJGoOZq02ulHqCK0aLqM3K/xoJcyU4+MYmInPL3m1IK
         N9e0P8KReVldyIiozcyqo+6R4ia2QSpJJlBpa0gUAqwO9gnia1HrCDDlTSuF1zPghN
         mWGRgKO3uDbBaXIccOmszCesmLVpHW0GqUZIXm1CzL19MktF9eCegv1q5QehsBsM6O
         IvkZrB75/X5cE8QSYuGWagEM6oXfmM7WzlNwOm4CX4hFMq2q+e0pZBggz04f1uVO9X
         UpGvosCrP4HRvFtgPrRIiAlNyf0OVDXedtvnGOgstErwCe4EKD0AdJXFwoU2/HYgHa
         9ydHaG+nWGD0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, daniel@iogearbox.net,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 14/93] libbpf: Fix an error in 64bit relocation value computation
Date:   Thu, 11 Aug 2022 11:41:08 -0400
Message-Id: <20220811154237.1531313-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
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
index f946f23eab20..80862906df3f 100644
--- a/tools/lib/bpf/relo_core.c
+++ b/tools/lib/bpf/relo_core.c
@@ -1025,7 +1025,7 @@ int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
 			return -EINVAL;
 		}
 
-		imm = insn[0].imm + ((__u64)insn[1].imm << 32);
+		imm = (__u32)insn[0].imm | ((__u64)insn[1].imm << 32);
 		if (res->validate && imm != orig_val) {
 			pr_warn("prog '%s': relo #%d: unexpected insn #%d (LDIMM64) value: got %llu, exp %u -> %u\n",
 				prog_name, relo_idx,
-- 
2.35.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0622C73D74
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392753AbfGXURK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:17:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbfGXTug (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:50:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13D19214AF;
        Wed, 24 Jul 2019 19:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997835;
        bh=VK2FOKVM+mAdFLy+ZkfZrbS9woxb2lUpgS0oIIwKRzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dxV0p87kAZVnGWZ8NH1FQPOb/2hG6vrKMLP8G4QfrURsM7/nethO8lIrJr6E2x0vJ
         iJtEHuk+TEfQniscx5H2S4tTCV0AXn7NI+qpqWGPGsB51BIUKhaifcooxlExdcQKLu
         ZFtmrIOoMPkgykx+jhPCoOA4LOAoj7p0oFdA9xC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jiong Wang <jiong.wang@netronome.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 158/371] bpf: fix BPF_ALU32 | BPF_ARSH on BE arches
Date:   Wed, 24 Jul 2019 21:18:30 +0200
Message-Id: <20190724191737.066355805@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 75672dda27bd00109a84cd975c17949ad9c45663 ]

Yauheni reported the following code do not work correctly on BE arches:

       ALU_ARSH_X:
               DST = (u64) (u32) ((*(s32 *) &DST) >> SRC);
               CONT;
       ALU_ARSH_K:
               DST = (u64) (u32) ((*(s32 *) &DST) >> IMM);
               CONT;

and are causing failure of test_verifier test 'arsh32 on imm 2' on BE
arches.

The code is taking address and interpreting memory directly, so is not
endianness neutral. We should instead perform standard C type casting on
the variable. A u64 to s32 conversion will drop the high 32-bit and reserve
the low 32-bit as signed integer, this is all we want.

Fixes: 2dc6b100f928 ("bpf: interpreter support BPF_ALU | BPF_ARSH")
Reported-by: Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 06ba9c5f156b..932fd3fa5a5a 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1367,10 +1367,10 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 		insn++;
 		CONT;
 	ALU_ARSH_X:
-		DST = (u64) (u32) ((*(s32 *) &DST) >> SRC);
+		DST = (u64) (u32) (((s32) DST) >> SRC);
 		CONT;
 	ALU_ARSH_K:
-		DST = (u64) (u32) ((*(s32 *) &DST) >> IMM);
+		DST = (u64) (u32) (((s32) DST) >> IMM);
 		CONT;
 	ALU64_ARSH_X:
 		(*(s64 *) &DST) >>= SRC;
-- 
2.20.1




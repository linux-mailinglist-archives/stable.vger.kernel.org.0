Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3280395C66
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbhEaNca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:32:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232200AbhEaNa2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:30:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FA9A61424;
        Mon, 31 May 2021 13:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467385;
        bh=5M2+Vo6Jk3Y+bh6eAHj6OVt2po33/88yIIcYy70EeYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cImlv3+g5dI0Lzsak1hNl70GO6zz2wVv8qy/Dv+PVELL0XlhzRXAY84CLah+mDstN
         6elSJXcVt9pfijuCIAVE40D/NWx0Xdj8Hvltw9/NpYL69kKVGMn/DqWHz9a+m92xVG
         teisEHgjYDbNILNlipkfl4Vf0x6yQXivMPuH7fdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 046/116] bpf, test_verifier: switch bpf_get_stacks 0 s> r8 test
Date:   Mon, 31 May 2021 15:13:42 +0200
Message-Id: <20210531130641.741241614@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ no upstream commit ]

Switch the comparison, so that is_branch_taken() will recognize that below
branch is never taken:

  [...]
  17: [...] R1_w=inv0 [...] R8_w=inv(id=0,smin_value=-2147483648,smax_value=-1,umin_value=18446744071562067968,var_off=(0xffffffff80000000; 0x7fffffff)) [...]
  17: (67) r8 <<= 32
  18: [...] R8_w=inv(id=0,smax_value=-4294967296,umin_value=9223372036854775808,umax_value=18446744069414584320,var_off=(0x8000000000000000; 0x7fffffff00000000)) [...]
  18: (c7) r8 s>>= 32
  19: [...] R8_w=inv(id=0,smin_value=-2147483648,smax_value=-1,umin_value=18446744071562067968,var_off=(0xffffffff80000000; 0x7fffffff)) [...]
  19: (6d) if r1 s> r8 goto pc+16
  [...] R1_w=inv0 [...] R8_w=inv(id=0,smin_value=-2147483648,smax_value=-1,umin_value=18446744071562067968,var_off=(0xffffffff80000000; 0x7fffffff)) [...]
  [...]

Currently we check for is_branch_taken() only if either K is source, or source
is a scalar value that is const. For upstream it would be good to extend this
properly to check whether dst is const and src not.

For the sake of the test_verifier, it is probably not needed here:

  # ./test_verifier 101
  #101/p bpf_get_stack return R0 within range OK
  Summary: 1 PASSED, 0 SKIPPED, 0 FAILED

I haven't seen this issue in test_progs* though, they are passing fine:

  # ./test_progs-no_alu32 -t get_stack
  Switching to flavor 'no_alu32' subdirectory...
  #20 get_stack_raw_tp:OK
  Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED

  # ./test_progs -t get_stack
  #20 get_stack_raw_tp:OK
  Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[OP: backport to 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -12263,7 +12263,7 @@ static struct bpf_test tests[] = {
 			BPF_MOV64_REG(BPF_REG_8, BPF_REG_0),
 			BPF_ALU64_IMM(BPF_LSH, BPF_REG_8, 32),
 			BPF_ALU64_IMM(BPF_ARSH, BPF_REG_8, 32),
-			BPF_JMP_REG(BPF_JSGT, BPF_REG_1, BPF_REG_8, 16),
+			BPF_JMP_REG(BPF_JSLT, BPF_REG_8, BPF_REG_1, 16),
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_9, BPF_REG_8),
 			BPF_MOV64_REG(BPF_REG_2, BPF_REG_7),
 			BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_8),



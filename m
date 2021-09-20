Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63186411FB8
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345300AbhITRo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:44:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353007AbhITRnS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:43:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 056FF61B56;
        Mon, 20 Sep 2021 17:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157748;
        bh=F5ab1dKS3zh2eAk3ATJKaVCpYoTpuE1LGjOcbu/8rQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5AFYzRmWxWOaJTfZ61jqeivxxgAYQWVr4RbRuRjgGQMU0BB+9nSflPOCV9zYQmox
         Hc3TnkdZDyC84rTYCFZxQyA5sSN10EfdgcWPqICmdjPfkfF+bYSUBh4ZlH3sBdCStK
         LmFfl+h7CA4OOff2118aZKU8wrguX+vJdUBTWriU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 132/293] bpf: Sanity check max value for var_off stack access
Date:   Mon, 20 Sep 2021 18:41:34 +0200
Message-Id: <20210920163937.788876284@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ignatov <rdna@fb.com>

commit 107c26a70ca81bfc33657366ad69d02fdc9efc9d upstream.

As discussed in [1] max value of variable offset has to be checked for
overflow on stack access otherwise verifier would accept code like this:

  0: (b7) r2 = 6
  1: (b7) r3 = 28
  2: (7a) *(u64 *)(r10 -16) = 0
  3: (7a) *(u64 *)(r10 -8) = 0
  4: (79) r4 = *(u64 *)(r1 +168)
  5: (c5) if r4 s< 0x0 goto pc+4
   R1=ctx(id=0,off=0,imm=0) R2=inv6 R3=inv28
   R4=inv(id=0,umax_value=9223372036854775807,var_off=(0x0;
   0x7fffffffffffffff)) R10=fp0,call_-1 fp-8=mmmmmmmm fp-16=mmmmmmmm
  6: (17) r4 -= 16
  7: (0f) r4 += r10
  8: (b7) r5 = 8
  9: (85) call bpf_getsockopt#57
  10: (b7) r0 = 0
  11: (95) exit

, where R4 obviosly has unbounded max value.

Fix it by checking that reg->smax_value is inside (-BPF_MAX_VAR_OFF;
BPF_MAX_VAR_OFF) range.

reg->smax_value is used instead of reg->umax_value because stack
pointers are calculated using negative offset from fp. This is opposite
to e.g. map access where offset must be non-negative and where
umax_value is used.

Also dedicated verbose logs are added for both min and max bound check
failures to have diagnostics consistent with variable offset handling in
check_map_access().

[1] https://marc.info/?l=linux-netdev&m=155433357510597&w=2

Fixes: 2011fccfb61b ("bpf: Support variable offset stack access from helpers")
Reported-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1833,16 +1833,28 @@ static int check_stack_boundary(struct b
 		if (meta && meta->raw_mode)
 			meta = NULL;
 
+		if (reg->smax_value >= BPF_MAX_VAR_OFF ||
+		    reg->smax_value <= -BPF_MAX_VAR_OFF) {
+			verbose(env, "R%d unbounded indirect variable offset stack access\n",
+				regno);
+			return -EACCES;
+		}
 		min_off = reg->smin_value + reg->off;
-		max_off = reg->umax_value + reg->off;
+		max_off = reg->smax_value + reg->off;
 		err = __check_stack_boundary(env, regno, min_off, access_size,
 					     zero_size_allowed);
-		if (err)
+		if (err) {
+			verbose(env, "R%d min value is outside of stack bound\n",
+				regno);
 			return err;
+		}
 		err = __check_stack_boundary(env, regno, max_off, access_size,
 					     zero_size_allowed);
-		if (err)
+		if (err) {
+			verbose(env, "R%d max value is outside of stack bound\n",
+				regno);
 			return err;
+		}
 	}
 
 	if (meta && meta->raw_mode) {



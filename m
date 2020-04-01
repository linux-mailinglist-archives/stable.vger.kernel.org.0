Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9620419AFA5
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732545AbgDAQTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:19:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732582AbgDAQTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:19:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2796320857;
        Wed,  1 Apr 2020 16:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585757992;
        bh=Lqx1ub1hOVFl4G+vhvUmsxHr6ZVArNl5EwY5HU/jw1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D0l9L7Y8NQbnuABd2RHBD9uLetH8DU3fB/aZpbHHwHI36VZgAr/ms80vUtIDL2IF1
         ckdiUuVn7nw5qB4gHPkm5RHpPxVG6tmKMN8mFsWfx8Er5fxmYvIssWaTxH7RKqOjuf
         fhqme1l3g7mFZAUYVFXZMIYgDXwbb5y2/zWHtI0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.5 01/30] bpf: update jmp32 test cases to fix range bound deduction
Date:   Wed,  1 Apr 2020 18:17:05 +0200
Message-Id: <20200401161416.202881749@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161414.345528747@linuxfoundation.org>
References: <20200401161414.345528747@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ no upstream commit ]

Since commit f2d67fec0b43 ("bpf: Undo incorrect __reg_bound_offset32 handling")
has been backported to stable, we also need to update related test cases that
started to (expectedly) fail on stable. Given the functionality has been reverted
we need to move the result to REJECT.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/bpf/verifier/jmp32.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/bpf/verifier/jmp32.c
+++ b/tools/testing/selftests/bpf/verifier/jmp32.c
@@ -768,7 +768,8 @@
 	},
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.fixup_map_hash_48b = { 4 },
-	.result = ACCEPT,
+	.result = REJECT,
+	.errstr = "R8 unbounded memory access",
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
@@ -796,7 +797,8 @@
 	},
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.fixup_map_hash_48b = { 4 },
-	.result = ACCEPT,
+	.result = REJECT,
+	.errstr = "R8 unbounded memory access",
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
@@ -824,6 +826,7 @@
 	},
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.fixup_map_hash_48b = { 4 },
-	.result = ACCEPT,
+	.result = REJECT,
+	.errstr = "R8 unbounded memory access",
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },



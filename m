Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB28719AF90
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732179AbgDAQTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:19:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgDAQTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:19:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F127A20658;
        Wed,  1 Apr 2020 16:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585757959;
        bh=K8SpIw2adgr5Nz4CqNMwL+oky9vY+IXX71FWKu/zc4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MuGbYTwdoXxnwFsq+udiotU60srb1u5399mmivzTCYrgBogtqqLHs9EbhkIhqR/ZI
         TPoM3egTWONdFjgc7PcuLAnO9PZe8YTnsPat5umv2AeE6LaZElHxa8DPLUg2brL0Ez
         VidKLvvwuNTVd8Xcb6WSif7rFCUFoiTe9hiz3ohI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.6 01/10] bpf: update jmp32 test cases to fix range bound deduction
Date:   Wed,  1 Apr 2020 18:17:17 +0200
Message-Id: <20200401161416.121489863@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161413.974936041@linuxfoundation.org>
References: <20200401161413.974936041@linuxfoundation.org>
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
@@ -783,7 +783,8 @@
 	},
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.fixup_map_hash_48b = { 4 },
-	.result = ACCEPT,
+	.result = REJECT,
+	.errstr = "R8 unbounded memory access",
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
@@ -811,7 +812,8 @@
 	},
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.fixup_map_hash_48b = { 4 },
-	.result = ACCEPT,
+	.result = REJECT,
+	.errstr = "R8 unbounded memory access",
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
@@ -839,6 +841,7 @@
 	},
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.fixup_map_hash_48b = { 4 },
-	.result = ACCEPT,
+	.result = REJECT,
+	.errstr = "R8 unbounded memory access",
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CFE3E257B
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244102AbhHFIUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:20:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244103AbhHFISu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:18:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 920FD6121F;
        Fri,  6 Aug 2021 08:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237904;
        bh=kxkZ5pjcqKOV9vNovoFF0tKjKjrZ5+0Q2p484H/DDIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sqQoREjrX0wImP84HN9cWiUdWOJAxPgowBfqWQxlSAj7OYHwGGvdD3qmAKm0R8USH
         2cqd6//lBjFYy5uD89AKnACkV0fnE0LRftOEDohMSjLUv82D1Yrl7OOYedURS6YLCa
         +0uRZw1MY3eLXNh69lVVeKZVlE05A4MxGnk1shtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 22/23] bpf, selftests: Add a verifier test for assigning 32bit reg states to 64bit ones
Date:   Fri,  6 Aug 2021 10:16:54 +0200
Message-Id: <20210806081112.900244614@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081112.104686873@linuxfoundation.org>
References: <20210806081112.104686873@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

commit cf66c29bd7534813d2e1971fab71e25fe87c7e0a upstream

Added a verifier test for assigning 32bit reg states to
64bit where 32bit reg holds a constant value of 0.

Without previous kernel verifier.c fix, the test in
this patch will fail.

Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/159077335867.6014.2075350327073125374.stgit@john-Precision-5820-Tower
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/verifier/bounds.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/tools/testing/selftests/bpf/verifier/bounds.c
+++ b/tools/testing/selftests/bpf/verifier/bounds.c
@@ -545,3 +545,25 @@
 	},
 	.result = ACCEPT
 },
+{
+	"assigning 32bit bounds to 64bit for wA = 0, wB = wA",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_8, BPF_REG_1,
+		    offsetof(struct __sk_buff, data_end)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_1,
+		    offsetof(struct __sk_buff, data)),
+	BPF_MOV32_IMM(BPF_REG_9, 0),
+	BPF_MOV32_REG(BPF_REG_2, BPF_REG_9),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_7),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_6, BPF_REG_2),
+	BPF_MOV64_REG(BPF_REG_3, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, 8),
+	BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_8, 1),
+	BPF_LDX_MEM(BPF_W, BPF_REG_5, BPF_REG_6, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = ACCEPT,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},



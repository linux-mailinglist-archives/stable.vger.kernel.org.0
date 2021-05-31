Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16ED7395C5D
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbhEaNbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232563AbhEaN3b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:29:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EEF5613F1;
        Mon, 31 May 2021 13:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467374;
        bh=8VCZdGKQ7EY/u9kiLpcdwgbmCfVG9LiE87K1OqJjFZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NprCoIo7swXaNq5DbKiOdmt/ScoWdNULY+3G0O/s6KkAInA4j2cmVJT7wimRvUCKr
         uCk6VAvZ3Elx0Atw7Ar5KQjBplFUxG1/uLucR8CZczNn6F33MNb05oiyXw/YGvJpF0
         XAPYUn4ltx/HBaoxLGedu1Qqh3BeJ2bGMO573Bhw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrey Ignatov <rdna@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 042/116] selftests/bpf: Test narrow loads with off > 0 in test_verifier
Date:   Mon, 31 May 2021 15:13:38 +0200
Message-Id: <20210531130641.588975603@linuxfoundation.org>
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

From: Andrey Ignatov <rdna@fb.com>

commit 6c2afb674dbda9b736b8f09c976516e1e788860a upstream

Test the following narrow loads in test_verifier for context __sk_buff:
* off=1, size=1 - ok;
* off=2, size=1 - ok;
* off=3, size=1 - ok;
* off=0, size=2 - ok;
* off=1, size=2 - fail;
* off=0, size=2 - ok;
* off=3, size=2 - fail.

Signed-off-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |   48 ++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -2002,29 +2002,27 @@ static struct bpf_test tests[] = {
 		.result = ACCEPT,
 	},
 	{
-		"check skb->hash byte load not permitted 1",
+		"check skb->hash byte load permitted 1",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
 				    offsetof(struct __sk_buff, hash) + 1),
 			BPF_EXIT_INSN(),
 		},
-		.errstr = "invalid bpf_context access",
-		.result = REJECT,
+		.result = ACCEPT,
 	},
 	{
-		"check skb->hash byte load not permitted 2",
+		"check skb->hash byte load permitted 2",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
 				    offsetof(struct __sk_buff, hash) + 2),
 			BPF_EXIT_INSN(),
 		},
-		.errstr = "invalid bpf_context access",
-		.result = REJECT,
+		.result = ACCEPT,
 	},
 	{
-		"check skb->hash byte load not permitted 3",
+		"check skb->hash byte load permitted 3",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 #if __BYTE_ORDER == __LITTLE_ENDIAN
@@ -2036,8 +2034,7 @@ static struct bpf_test tests[] = {
 #endif
 			BPF_EXIT_INSN(),
 		},
-		.errstr = "invalid bpf_context access",
-		.result = REJECT,
+		.result = ACCEPT,
 	},
 	{
 		"check cb access: byte, wrong type",
@@ -2149,7 +2146,7 @@ static struct bpf_test tests[] = {
 		.result = ACCEPT,
 	},
 	{
-		"check skb->hash half load not permitted",
+		"check skb->hash half load permitted 2",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 #if __BYTE_ORDER == __LITTLE_ENDIAN
@@ -2161,6 +2158,37 @@ static struct bpf_test tests[] = {
 #endif
 			BPF_EXIT_INSN(),
 		},
+		.result = ACCEPT,
+	},
+	{
+		"check skb->hash half load not permitted, unaligned 1",
+		.insns = {
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+			BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+				    offsetof(struct __sk_buff, hash) + 1),
+#else
+			BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+				    offsetof(struct __sk_buff, hash) + 3),
+#endif
+			BPF_EXIT_INSN(),
+		},
+		.errstr = "invalid bpf_context access",
+		.result = REJECT,
+	},
+	{
+		"check skb->hash half load not permitted, unaligned 3",
+		.insns = {
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+			BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+				    offsetof(struct __sk_buff, hash) + 3),
+#else
+			BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+				    offsetof(struct __sk_buff, hash) + 1),
+#endif
+			BPF_EXIT_INSN(),
+		},
 		.errstr = "invalid bpf_context access",
 		.result = REJECT,
 	},



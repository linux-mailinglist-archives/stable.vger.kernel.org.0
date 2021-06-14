Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34CCE3A6384
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235416AbhFNLOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:14:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234131AbhFNLL7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:11:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CF9761458;
        Mon, 14 Jun 2021 10:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667692;
        bh=S0arLeFgiygFNv2SwSBpMgnp3DpjxMX41fEk6gYS1c0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vX83eOedq8WtcTQPx+MmOj1QDiFgQDA5cGo3lVx2utAA2wU+m6OyTNqZMbVdphi7j
         D4RU3KavT7Wmgn13irogXBFRWVXK5clkxT3w1A8qYTRUOFaa8txP4zyVDxVYPJ+r9j
         cx/miv+zl/veCnZ7hKWCBcNz2Tvd6j7It86WKQAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 038/173] bpf, selftests: Adjust few selftest result_unpriv outcomes
Date:   Mon, 14 Jun 2021 12:26:10 +0200
Message-Id: <20210614102659.427415368@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 1bad6fd52be4ce12d207e2820ceb0f29ab31fc53 ]

Given we don't need to simulate the speculative domain for registers with
immediates anymore since the verifier uses direct imm-based rewrites instead
of having to mask, we can also lift a few cases that were previously rejected.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/verifier/stack_ptr.c       | 2 --
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c | 8 --------
 2 files changed, 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/stack_ptr.c b/tools/testing/selftests/bpf/verifier/stack_ptr.c
index 07eaa04412ae..8ab94d65f3d5 100644
--- a/tools/testing/selftests/bpf/verifier/stack_ptr.c
+++ b/tools/testing/selftests/bpf/verifier/stack_ptr.c
@@ -295,8 +295,6 @@
 	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1, 0),
 	BPF_EXIT_INSN(),
 	},
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "invalid write to stack R1 off=0 size=1",
 	.result = ACCEPT,
 	.retval = 42,
 },
diff --git a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
index e5913fd3b903..7ae2859d495c 100644
--- a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
+++ b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
@@ -300,8 +300,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
@@ -371,8 +369,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
@@ -472,8 +468,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
@@ -766,8 +760,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
-- 
2.30.2




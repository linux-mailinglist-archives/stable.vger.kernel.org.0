Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654303E2591
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243952AbhHFIUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:20:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244017AbhHFIT4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:19:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DC84611CE;
        Fri,  6 Aug 2021 08:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237980;
        bh=Qu27UQFO8jORTADI8/bf30PqQmjO4O0AKYuIGAXgvoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WkRAzYhaqSUg1NcZHpLkUoNuggByvY2R41rErMNPwgmTmjdnlfX54hQdK94Cgbyer
         m6/duyzWge1NtpDrSAKw7MIOfFcMNkEnCAYzk2ff9OlgrKRBh2JrH82edi/ZapL8LS
         G1DxWfwk/qBP9TCbLgolWxWH/1UenGFYjo511Te4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 27/30] bpf, selftests: Adjust few selftest result_unpriv outcomes
Date:   Fri,  6 Aug 2021 10:17:05 +0200
Message-Id: <20210806081114.046059421@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.126861800@linuxfoundation.org>
References: <20210806081113.126861800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 1bad6fd52be4ce12d207e2820ceb0f29ab31fc53 upstream

Given we don't need to simulate the speculative domain for registers with
immediates anymore since the verifier uses direct imm-based rewrites instead
of having to mask, we can also lift a few cases that were previously rejected.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/verifier/stack_ptr.c       |    2 --
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c |    8 --------
 2 files changed, 10 deletions(-)

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
--- a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
+++ b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
@@ -302,8 +302,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
@@ -373,8 +371,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
@@ -474,8 +470,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
@@ -768,8 +762,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C1B395C62
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbhEaNb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:31:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231991AbhEaN3x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:29:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEC2F613AF;
        Mon, 31 May 2021 13:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467377;
        bh=SUrRf8iBGYWl19SOM1QeZ9WV2xjeVDEb6+bjiEz+SHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CzjoO88WVG6G83dQOD5R3oPVKmM6R7O51hV4F8Uzkn31vN18ZybiiQZyfpot5jiCM
         w4vfvNNQARVLs0ChDKEaL4K/fMhDe3gVFE9LMCbQQupsa3jV0Qm827wGW/IrMKHjvT
         Er9PG0Z5Uir6sEEtOC0cm+pe7buviwQpBOqayoQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 043/116] selftests/bpf: add selftest part of "bpf: improve verifier branch analysis"
Date:   Mon, 31 May 2021 15:13:39 +0200
Message-Id: <20210531130641.621755183@linuxfoundation.org>
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

From: Ovidiu Panait <ovidiu.panait@windriver.com>

Backport the missing selftest part of commit 7da6cd690c43 ("bpf: improve
verifier branch analysis") in order to fix the following test_verifier
failures:

...
Unexpected success to load!
0: (b7) r0 = 0
1: (75) if r0 s>= 0x0 goto pc+1
3: (95) exit
processed 3 insns (limit 131072), stack depth 0
Unexpected success to load!
0: (b7) r0 = 0
1: (75) if r0 s>= 0x0 goto pc+1
3: (95) exit
processed 3 insns (limit 131072), stack depth 0
...

The changesets apply with a minor context difference.

Fixes: 7da6cd690c43 ("bpf: improve verifier branch analysis")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -7867,7 +7867,7 @@ static struct bpf_test tests[] = {
 			BPF_JMP_IMM(BPF_JA, 0, 0, -7),
 		},
 		.fixup_map1 = { 4 },
-		.errstr = "R0 invalid mem access 'inv'",
+		.errstr = "unbounded min value",
 		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
@@ -9850,7 +9850,7 @@ static struct bpf_test tests[] = {
 		"check deducing bounds from const, 5",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
-			BPF_JMP_IMM(BPF_JSGE, BPF_REG_0, 0, 1),
+			BPF_JMP_IMM(BPF_JSGE, BPF_REG_0, 1, 1),
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88B433B65A
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhCON5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229900AbhCON5N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 212E264EEE;
        Mon, 15 Mar 2021 13:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816633;
        bh=brXWXpnYW6YQL0ESqPRMZqTazFW2xCed+nZ3A+nBLeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v0bZvNhH93Buf0tddVffN/+OF6Gf/zqR4BURUGFQbSadmf7OY3TzeCq3WxlD3+W23
         yOBUGI+O/fmIOYVOsG8DqW8WTOTJYmec+O0TYPO7lXQo5iSjrnQdqompZHOO2y2N7v
         jbxrqvuHzrtCDYKwxC2WDjew6V77i9zH1FXt6bWM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.10 024/290] selftests/bpf: Mask bpf_csum_diff() return value to 16 bits in test_verifier
Date:   Mon, 15 Mar 2021 14:51:57 +0100
Message-Id: <20210315135542.755067257@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Yauheni Kaliuta <yauheni.kaliuta@redhat.com>

commit 6185266c5a853bb0f2a459e3ff594546f277609b upstream.

The verifier test labelled "valid read map access into a read-only array
2" calls the bpf_csum_diff() helper and checks its return value. However,
architecture implementations of csum_partial() (which is what the helper
uses) differ in whether they fold the return value to 16 bit or not. For
example, x86 version has ...

	if (unlikely(odd)) {
		result = from32to16(result);
		result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
	}

... while generic lib/checksum.c does:

	result = from32to16(result);
	if (odd)
		result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);

This makes the helper return different values on different architectures,
breaking the test on non-x86. To fix this, add an additional instruction
to always mask the return value to 16 bits, and update the expected return
value accordingly.

Fixes: fb2abb73e575 ("bpf, selftest: test {rd, wr}only flags and direct value access")
Signed-off-by: Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210228103017.320240-1-yauheni.kaliuta@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/verifier/array_access.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/bpf/verifier/array_access.c
+++ b/tools/testing/selftests/bpf/verifier/array_access.c
@@ -250,12 +250,13 @@
 	BPF_MOV64_IMM(BPF_REG_5, 0),
 	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
 		     BPF_FUNC_csum_diff),
+	BPF_ALU64_IMM(BPF_AND, BPF_REG_0, 0xffff),
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.fixup_map_array_ro = { 3 },
 	.result = ACCEPT,
-	.retval = -29,
+	.retval = 65507,
 },
 {
 	"invalid write map access into a read-only array 1",



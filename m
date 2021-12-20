Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572CD47AED4
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237680AbhLTPEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240830AbhLTPCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:02:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B3EC08EE1B;
        Mon, 20 Dec 2021 06:51:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BB36B80EEE;
        Mon, 20 Dec 2021 14:51:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98884C36AE7;
        Mon, 20 Dec 2021 14:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011895;
        bh=1HYDcfgLRI6VYYcgWRMJO6ETRy7id3QRJm1mfwlJ3cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oSoC4ntWc3xgTFKqJh9lQzhlOCn9wQ4NYPE0mMxazfSz2Dswn8yU9VsQkxSgPE1/R
         V0bXjW16SMF93i3DCQslGtjzLydiEUeQ4N7Lsux99JGPlachDeH6qUf4/0UPUuLP9j
         UQLNbpXUB5Z8wYECEQ74Lh9CCBiyJCiVccw5w/FM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, n4ke4mry@gmail.com,
        Brendan Jackman <jackmanb@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 013/177] bpf: Fix kernel address leakage in atomic fetch
Date:   Mon, 20 Dec 2021 15:32:43 +0100
Message-Id: <20211220143040.522500425@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 7d3baf0afa3aa9102d6a521a8e4c41888bb79882 upstream.

The change in commit 37086bfdc737 ("bpf: Propagate stack bounds to registers
in atomics w/ BPF_FETCH") around check_mem_access() handling is buggy since
this would allow for unprivileged users to leak kernel pointers. For example,
an atomic fetch/and with -1 on a stack destination which holds a spilled
pointer will migrate the spilled register type into a scalar, which can then
be exported out of the program (since scalar != pointer) by dumping it into
a map value.

The original implementation of XADD was preventing this situation by using
a double call to check_mem_access() one with BPF_READ and a subsequent one
with BPF_WRITE, in both cases passing -1 as a placeholder value instead of
register as per XADD semantics since it didn't contain a value fetch. The
BPF_READ also included a check in check_stack_read_fixed_off() which rejects
the program if the stack slot is of __is_pointer_value() if dst_regno < 0.
The latter is to distinguish whether we're dealing with a regular stack spill/
fill or some arithmetical operation which is disallowed on non-scalars, see
also 6e7e63cbb023 ("bpf: Forbid XADD on spilled pointers for unprivileged
users") for more context on check_mem_access() and its handling of placeholder
value -1.

One minimally intrusive option to fix the leak is for the BPF_FETCH case to
initially check the BPF_READ case via check_mem_access() with -1 as register,
followed by the actual load case with non-negative load_reg to propagate
stack bounds to registers.

Fixes: 37086bfdc737 ("bpf: Propagate stack bounds to registers in atomics w/ BPF_FETCH")
Reported-by: <n4ke4mry@gmail.com>
Acked-by: Brendan Jackman <jackmanb@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4417,13 +4417,19 @@ static int check_atomic(struct bpf_verif
 		load_reg = -1;
 	}
 
-	/* check whether we can read the memory */
+	/* Check whether we can read the memory, with second call for fetch
+	 * case to simulate the register fill.
+	 */
 	err = check_mem_access(env, insn_idx, insn->dst_reg, insn->off,
-			       BPF_SIZE(insn->code), BPF_READ, load_reg, true);
+			       BPF_SIZE(insn->code), BPF_READ, -1, true);
+	if (!err && load_reg >= 0)
+		err = check_mem_access(env, insn_idx, insn->dst_reg, insn->off,
+				       BPF_SIZE(insn->code), BPF_READ, load_reg,
+				       true);
 	if (err)
 		return err;
 
-	/* check whether we can write into the same memory */
+	/* Check whether we can write into the same memory. */
 	err = check_mem_access(env, insn_idx, insn->dst_reg, insn->off,
 			       BPF_SIZE(insn->code), BPF_WRITE, -1, true);
 	if (err)



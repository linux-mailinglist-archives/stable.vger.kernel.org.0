Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED72497E6D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 13:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238082AbiAXMBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 07:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbiAXMBo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 07:01:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC929C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 04:01:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83B9060DFC
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 12:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115F1C340E1;
        Mon, 24 Jan 2022 12:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643025702;
        bh=jxTrd20CtGat917YbW8Ern9pIxkWIJ6TqtZ6eDmzmTc=;
        h=Subject:To:Cc:From:Date:From;
        b=aIN1Fo9Uhs1xztvySwIES6Dgs6snuIpBJuv8zstttCA9eN3CSt5o7Xo3Iv3SMfLk9
         DTJm1tZzUuJytAYC7Y9fZygTeIAzUXBVEOKh4XwDcRgD0+SCduqujxFQRELALrqlS/
         Rm6dkaAheU/ywJ8/anC3FqcLNSPllglKni8rWdKo=
Subject: FAILED: patch "[PATCH] bpf: Fix out of bounds access for ringbuf helpers" failed to apply to 5.15-stable tree
To:     daniel@iogearbox.net, ast@kernel.org, john.fastabend@gmail.com,
        tr3e.wang@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 13:01:31 +0100
Message-ID: <16430256912363@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 64620e0a1e712a778095bd35cbb277dc2259281f Mon Sep 17 00:00:00 2001
From: Daniel Borkmann <daniel@iogearbox.net>
Date: Tue, 11 Jan 2022 14:43:41 +0000
Subject: [PATCH] bpf: Fix out of bounds access for ringbuf helpers

Both bpf_ringbuf_submit() and bpf_ringbuf_discard() have ARG_PTR_TO_ALLOC_MEM
in their bpf_func_proto definition as their first argument. They both expect
the result from a prior bpf_ringbuf_reserve() call which has a return type of
RET_PTR_TO_ALLOC_MEM_OR_NULL.

Meaning, after a NULL check in the code, the verifier will promote the register
type in the non-NULL branch to a PTR_TO_MEM and in the NULL branch to a known
zero scalar. Generally, pointer arithmetic on PTR_TO_MEM is allowed, so the
latter could have an offset.

The ARG_PTR_TO_ALLOC_MEM expects a PTR_TO_MEM register type. However, the non-
zero result from bpf_ringbuf_reserve() must be fed into either bpf_ringbuf_submit()
or bpf_ringbuf_discard() but with the original offset given it will then read
out the struct bpf_ringbuf_hdr mapping.

The verifier missed to enforce a zero offset, so that out of bounds access
can be triggered which could be used to escalate privileges if unprivileged
BPF was enabled (disabled by default in kernel).

Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
Reported-by: <tr3e.wang@gmail.com> (SecCoder Security Lab)
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e0b3f4d683eb..c72c57a6684f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5318,9 +5318,15 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 	case PTR_TO_BUF:
 	case PTR_TO_BUF | MEM_RDONLY:
 	case PTR_TO_STACK:
+		/* Some of the argument types nevertheless require a
+		 * zero register offset.
+		 */
+		if (arg_type == ARG_PTR_TO_ALLOC_MEM)
+			goto force_off_check;
 		break;
 	/* All the rest must be rejected: */
 	default:
+force_off_check:
 		err = __check_ptr_off_reg(env, reg, regno,
 					  type == PTR_TO_BTF_ID);
 		if (err < 0)


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E63E497E6C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 13:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238083AbiAXMBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 07:01:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60242 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbiAXMBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 07:01:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3756B80EFC
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 12:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26042C340E1;
        Mon, 24 Jan 2022 12:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643025693;
        bh=fP80l8yFUOYRk7po9NvS8JeBzm8R0WAoIzJ1fq3m9U8=;
        h=Subject:To:Cc:From:Date:From;
        b=PpggzsBXwt8JZA16O4q4xoSGlcpbxaMDYhh8n6jKBx8VRDIbhjRBhBdS3f+xy/1Qy
         ytYpbSqSGIhG0vCCWEsTBbXG0cq1FZSne0qAcmwSjUGbN67KwOa0FSwyRHHaJ5W/Lp
         ionXDxzH2G4KLPdNrHZPlHlR2vVemLi703YLhh3k=
Subject: FAILED: patch "[PATCH] bpf: Fix out of bounds access for ringbuf helpers" failed to apply to 5.16-stable tree
To:     daniel@iogearbox.net, ast@kernel.org, john.fastabend@gmail.com,
        tr3e.wang@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 13:01:30 +0100
Message-ID: <1643025690131243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539E0341C20
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbhCSMTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:19:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229889AbhCSMSo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:18:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA2FF6146D;
        Fri, 19 Mar 2021 12:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156324;
        bh=G7sN4DW9jHH8TwPn2/krCexOXpqC2iefVuKJ+qTH60g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOj93Zkbn3fcp90YcE0yPA/vUZvPrQR9C0bgpa5QYeKVsS6elasNQjvllZdcYwvTh
         EOFqzHjj6Cvkw/Dj3jNQTAvTJNwfNEs/pi6BRlkbmVB9PXA3z8mAfI6/Y2f44+jBK0
         wJUOR2599VR3jUCPp2sRdyaMpYlDsfnPu6o5ShCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Piotr Krysiuk <piotras@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 4.19 4/8] bpf: Fix off-by-one for area size in creating mask to left
Date:   Fri, 19 Mar 2021 13:18:23 +0100
Message-Id: <20210319121744.251889200@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121744.114946147@linuxfoundation.org>
References: <20210319121744.114946147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Piotr Krysiuk <piotras@gmail.com>

commit 10d2bb2e6b1d8c4576c56a748f697dbeb8388899 upstream.

retrieve_ptr_limit() computes the ptr_limit for registers with stack and
map_value type. ptr_limit is the size of the memory area that is still
valid / in-bounds from the point of the current position and direction
of the operation (add / sub). This size will later be used for masking
the operation such that attempting out-of-bounds access in the speculative
domain is redirected to remain within the bounds of the current map value.

When masking to the right the size is correct, however, when masking to
the left, the size is off-by-one which would lead to an incorrect mask
and thus incorrect arithmetic operation in the non-speculative domain.
Piotr found that if the resulting alu_limit value is zero, then the
BPF_MOV32_IMM() from the fixup_bpf_calls() rewrite will end up loading
0xffffffff into AX instead of sign-extending to the full 64 bit range,
and as a result, this allows abuse for executing speculatively out-of-
bounds loads against 4GB window of address space and thus extracting the
contents of kernel memory via side-channel.

Fixes: 979d63d50c0c ("bpf: prevent out of bounds speculation on pointer arithmetic")
Signed-off-by: Piotr Krysiuk <piotras@gmail.com>
Co-developed-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2740,13 +2740,13 @@ static int retrieve_ptr_limit(const stru
 	case PTR_TO_STACK:
 		off = ptr_reg->off + ptr_reg->var_off.value;
 		if (mask_to_left)
-			*ptr_limit = MAX_BPF_STACK + off;
+			*ptr_limit = MAX_BPF_STACK + off + 1;
 		else
 			*ptr_limit = -off;
 		return 0;
 	case PTR_TO_MAP_VALUE:
 		if (mask_to_left) {
-			*ptr_limit = ptr_reg->umax_value + ptr_reg->off;
+			*ptr_limit = ptr_reg->umax_value + ptr_reg->off + 1;
 		} else {
 			off = ptr_reg->smin_value + ptr_reg->off;
 			*ptr_limit = ptr_reg->map_ptr->value_size - off;



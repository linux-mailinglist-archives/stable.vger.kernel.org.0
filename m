Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D4B39FFC9
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbhFHSgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:36:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234388AbhFHSem (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:34:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA17C613B9;
        Tue,  8 Jun 2021 18:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177114;
        bh=YWx7Wpz/nixlUUeiM88xb7Aa0wPZrmfma7RLTzvvMLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bxEob4yHrTq6Xh47BrOw1xgQoLdlesewW0tYy64MBThemc3fwfJFw6gIsxgztVuSw
         9rE1JhH6/Qde7B+aL0CNzfAN3PHUfE/6M1g0WGUDM0LMH9u7SZbMFCwztdh3ksYL5M
         eriaeLEuH7mIvn4VNyUh1H+ev0xuel5AxgUUEHCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jann Horn <jannh@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Frank van der Linden <fllinden@amazon.com>
Subject: [PATCH 4.14 37/47] bpf/verifier: disallow pointer subtraction
Date:   Tue,  8 Jun 2021 20:27:20 +0200
Message-Id: <20210608175931.695295703@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175930.477274100@linuxfoundation.org>
References: <20210608175930.477274100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

commit dd066823db2ac4e22f721ec85190817b58059a54 upstream.

Subtraction of pointers was accidentally allowed for unpriv programs
by commit 82abbf8d2fc4. Revert that part of commit.

Fixes: 82abbf8d2fc4 ("bpf: do not allow root to mangle valid pointers")
Reported-by: Jann Horn <jannh@google.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
[fllinden@amazon.com: backport to 4.14]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2754,7 +2754,7 @@ static int adjust_reg_min_max_vals(struc
 				 * an arbitrary scalar. Disallow all math except
 				 * pointer subtraction
 				 */
-				if (opcode == BPF_SUB){
+				if (opcode == BPF_SUB && env->allow_ptr_leaks) {
 					mark_reg_unknown(regs, insn->dst_reg);
 					return 0;
 				}



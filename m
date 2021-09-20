Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6345D411FBC
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345466AbhITRpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353005AbhITRnS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:43:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8D6C61B71;
        Mon, 20 Sep 2021 17:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157744;
        bh=ZTcogegeiHMo//rdXoOLS40olM09Mwxz3I6ssu7qfCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qsc7GIAfBESJ52UCuVPbaTtxi1puDlbqhh17gyhgXLdtbXKdKCFDcVi3l/ySICHmR
         XcKqVcm3cPSH1qh3HyqxMsBqPitaKe1uI/smPc2Qml9GaCJpNHxv3wzdq1mAnewFtn
         DYV1oTNGdRYpmtq4qCY//n+VzkV7w9wPfpMFT1lg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 131/293] bpf: Reject indirect var_off stack access in unpriv mode
Date:   Mon, 20 Sep 2021 18:41:33 +0200
Message-Id: <20210920163937.756222682@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ignatov <rdna@fb.com>

commit 088ec26d9c2da9d879ab73e3f4117f9df6c566ee upstream.

Proper support of indirect stack access with variable offset in
unprivileged mode (!root) requires corresponding support in Spectre
masking for stack ALU in retrieve_ptr_limit().

There are no use-case for variable offset in unprivileged mode though so
make verifier reject such accesses for simplicity.

Pointer arithmetics is one (and only?) way to cause variable offset and
it's already rejected in unpriv mode so that verifier won't even get to
helper function whose argument contains variable offset, e.g.:

  0: (7a) *(u64 *)(r10 -16) = 0
  1: (7a) *(u64 *)(r10 -8) = 0
  2: (61) r2 = *(u32 *)(r1 +0)
  3: (57) r2 &= 4
  4: (17) r2 -= 16
  5: (0f) r2 += r10
  variable stack access var_off=(0xfffffffffffffff0; 0x4) off=-16 size=1R2
  stack pointer arithmetic goes out of range, prohibited for !root

Still it looks like a good idea to reject variable offset indirect stack
access for unprivileged mode in check_stack_boundary() explicitly.

Fixes: 2011fccfb61b ("bpf: Support variable offset stack access from helpers")
Reported-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
[OP: drop comment in retrieve_ptr_limit()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1811,6 +1811,19 @@ static int check_stack_boundary(struct b
 		if (err)
 			return err;
 	} else {
+		/* Variable offset is prohibited for unprivileged mode for
+		 * simplicity since it requires corresponding support in
+		 * Spectre masking for stack ALU.
+		 * See also retrieve_ptr_limit().
+		 */
+		if (!env->allow_ptr_leaks) {
+			char tn_buf[48];
+
+			tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
+			verbose(env, "R%d indirect variable offset stack access prohibited for !root, var_off=%s\n",
+				regno, tn_buf);
+			return -EACCES;
+		}
 		/* Only initialized buffer on stack is allowed to be accessed
 		 * with variable offset. With uninitialized buffer it's hard to
 		 * guarantee that whole memory is marked as initialized on



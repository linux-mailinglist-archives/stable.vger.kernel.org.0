Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D863E3D5ECB
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235948AbhGZPLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:11:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236334AbhGZPJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:09:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D961E60FC0;
        Mon, 26 Jul 2021 15:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314539;
        bh=Ez2iXjcBb2CSL3sGLSdZag3kRmF/1so0+XLqvSdlhgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wazhDsbA2UMKOsADNHPwilqjaV3286s9qPjvG1icasvOqJ4bP1IZ7IjsxfuQH695f
         kWel3NpH7iud6E42P7r62ujbxzS/gOyOUJriIuPJeNpGhZvGt37FXYqXcs1ksXL+4Y
         qQ09cAL72SDgDikXsgKggjqsQovOEIQdQlImjAWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 63/82] KVM: PPC: Book3S: Fix H_RTAS rets buffer overflow
Date:   Mon, 26 Jul 2021 17:39:03 +0200
Message-Id: <20210726153830.218024204@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit f62f3c20647ebd5fb6ecb8f0b477b9281c44c10a upstream.

The kvmppc_rtas_hcall() sets the host rtas_args.rets pointer based on
the rtas_args.nargs that was provided by the guest. That guest nargs
value is not range checked, so the guest can cause the host rets pointer
to be pointed outside the args array. The individual rtas function
handlers check the nargs and nrets values to ensure they are correct,
but if they are not, the handlers store a -3 (0xfffffffd) failure
indication in rets[0] which corrupts host memory.

Fix this by testing up front whether the guest supplied nargs and nret
would exceed the array size, and fail the hcall directly without storing
a failure indication to rets[0].

Also expand on a comment about why we kill the guest and try not to
return errors directly if we have a valid rets[0] pointer.

Fixes: 8e591cb72047 ("KVM: PPC: Book3S: Add infrastructure to implement kernel-side RTAS calls")
Cc: stable@vger.kernel.org # v3.10+
Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/book3s_rtas.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kvm/book3s_rtas.c
+++ b/arch/powerpc/kvm/book3s_rtas.c
@@ -243,6 +243,17 @@ int kvmppc_rtas_hcall(struct kvm_vcpu *v
 	 * value so we can restore it on the way out.
 	 */
 	orig_rets = args.rets;
+	if (be32_to_cpu(args.nargs) >= ARRAY_SIZE(args.args)) {
+		/*
+		 * Don't overflow our args array: ensure there is room for
+		 * at least rets[0] (even if the call specifies 0 nret).
+		 *
+		 * Each handler must then check for the correct nargs and nret
+		 * values, but they may always return failure in rets[0].
+		 */
+		rc = -EINVAL;
+		goto fail;
+	}
 	args.rets = &args.args[be32_to_cpu(args.nargs)];
 
 	mutex_lock(&vcpu->kvm->arch.rtas_token_lock);
@@ -270,9 +281,17 @@ int kvmppc_rtas_hcall(struct kvm_vcpu *v
 fail:
 	/*
 	 * We only get here if the guest has called RTAS with a bogus
-	 * args pointer. That means we can't get to the args, and so we
-	 * can't fail the RTAS call. So fail right out to userspace,
-	 * which should kill the guest.
+	 * args pointer or nargs/nret values that would overflow the
+	 * array. That means we can't get to the args, and so we can't
+	 * fail the RTAS call. So fail right out to userspace, which
+	 * should kill the guest.
+	 *
+	 * SLOF should actually pass the hcall return value from the
+	 * rtas handler call in r3, so enter_rtas could be modified to
+	 * return a failure indication in r3 and we could return such
+	 * errors to the guest rather than failing to host userspace.
+	 * However old guests that don't test for failure could then
+	 * continue silently after errors, so for now we won't do this.
 	 */
 	return rc;
 }



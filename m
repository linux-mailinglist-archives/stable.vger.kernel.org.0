Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6362BA80D
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgKTLEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:04:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:51674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727927AbgKTLEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:04:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 063A722264;
        Fri, 20 Nov 2020 11:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870259;
        bh=AXeEyN0tDmgZ2EJAiNAQ6b3q5GlXxh4ZszoGSVLm3LA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNKc53Nz+oXJDMw3Z7pG6NfaYMwFM+ElKt2Am+zq/wGukzYmjAu2Ah0xdAxqSKLAC
         gHoZr2al1bYYTAXanUb9BM40gMggfcL7jWLL/z6lzf7gvXp3EfVGSWzpfapnf3yoBn
         B3Re/GPRAQPvUapcYGpOyizvWa6lUhzdItHgkQsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        David Edmondson <david.edmondson@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.9 15/16] KVM: x86: clflushopt should be treated as a no-op by emulation
Date:   Fri, 20 Nov 2020 12:03:20 +0100
Message-Id: <20201120104540.480652694@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104539.706905067@linuxfoundation.org>
References: <20201120104539.706905067@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Edmondson <david.edmondson@oracle.com>

commit 51b958e5aeb1e18c00332e0b37c5d4e95a3eff84 upstream.

The instruction emulator ignores clflush instructions, yet fails to
support clflushopt. Treat both similarly.

Fixes: 13e457e0eebf ("KVM: x86: Emulator does not decode clflush well")
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
Message-Id: <20201103120400.240882-1-david.edmondson@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3934,6 +3934,12 @@ static int em_clflush(struct x86_emulate
 	return X86EMUL_CONTINUE;
 }
 
+static int em_clflushopt(struct x86_emulate_ctxt *ctxt)
+{
+	/* emulating clflushopt regardless of cpuid */
+	return X86EMUL_CONTINUE;
+}
+
 static int em_movsxd(struct x86_emulate_ctxt *ctxt)
 {
 	ctxt->dst.val = (s32) ctxt->src.val;
@@ -4423,7 +4429,7 @@ static const struct opcode group11[] = {
 };
 
 static const struct gprefix pfx_0f_ae_7 = {
-	I(SrcMem | ByteOp, em_clflush), N, N, N,
+	I(SrcMem | ByteOp, em_clflush), I(SrcMem | ByteOp, em_clflushopt), N, N,
 };
 
 static const struct group_dual group15 = { {



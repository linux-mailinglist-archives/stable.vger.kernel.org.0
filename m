Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639A22BA86A
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgKTLHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:07:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:55582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728574AbgKTLHj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:07:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA1A72242B;
        Fri, 20 Nov 2020 11:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870458;
        bh=mxNmIyagPMLRvA5eqp5SOiO2EHaVGpG/k5mcacWFkg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gk0IIQzTDkUjOqRblwmbJ2ot0SDsD6NrXciyxZxUaVHZlhkfl3wtxKbdvoV0vHfLg
         bW5s1eBdgY/58iLCYkGzoV3IzKdO+WQRr+c90yqe3yXpBeZ4K6DqtqYKYcnN+wuO3a
         +O1L2Grvi1pA/bLNZfqNNug930netpXDLD5FvgRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        David Edmondson <david.edmondson@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.9 13/14] KVM: x86: clflushopt should be treated as a no-op by emulation
Date:   Fri, 20 Nov 2020 12:03:51 +0100
Message-Id: <20201120104541.815985797@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104541.168007611@linuxfoundation.org>
References: <20201120104541.168007611@linuxfoundation.org>
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
@@ -4032,6 +4032,12 @@ static int em_clflush(struct x86_emulate
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
@@ -4571,7 +4577,7 @@ static const struct opcode group11[] = {
 };
 
 static const struct gprefix pfx_0f_ae_7 = {
-	I(SrcMem | ByteOp, em_clflush), N, N, N,
+	I(SrcMem | ByteOp, em_clflush), I(SrcMem | ByteOp, em_clflushopt), N, N,
 };
 
 static const struct group_dual group15 = { {



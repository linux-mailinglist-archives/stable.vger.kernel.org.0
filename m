Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BABA2BA8A2
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgKTLJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:09:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728388AbgKTLG0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:06:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C54F206E3;
        Fri, 20 Nov 2020 11:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870385;
        bh=J6jQKE/UZP5uU4IlM2NWyorOOshnTi1QfvDyzJgSTbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0PHAkoADupJp9hUpp4PunIGSr9iLmIr+98RrmjUYdEhqZ8mvTyCent3AmZRrjAOru
         MR0vYPpKGs7Q/Mu1/0GTZ0LwB5Au9vGOFQ4KFQ6/iy3DbHOL7pt0a8OIwIGVjbZDWA
         J2DeV/CrybIPhY4K1N4wBvEza8AZOXQ69bAg1NpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        David Edmondson <david.edmondson@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 13/14] KVM: x86: clflushopt should be treated as a no-op by emulation
Date:   Fri, 20 Nov 2020 12:03:34 +0100
Message-Id: <20201120104540.471604502@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104539.806156260@linuxfoundation.org>
References: <20201120104539.806156260@linuxfoundation.org>
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
@@ -3994,6 +3994,12 @@ static int em_clflush(struct x86_emulate
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
@@ -4507,7 +4513,7 @@ static const struct opcode group11[] = {
 };
 
 static const struct gprefix pfx_0f_ae_7 = {
-	I(SrcMem | ByteOp, em_clflush), N, N, N,
+	I(SrcMem | ByteOp, em_clflush), I(SrcMem | ByteOp, em_clflushopt), N, N,
 };
 
 static const struct group_dual group15 = { {



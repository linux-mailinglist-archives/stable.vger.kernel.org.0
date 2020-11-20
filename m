Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E9A2BA8AE
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgKTLFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:05:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728141AbgKTLFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:05:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07BFD2222F;
        Fri, 20 Nov 2020 11:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870316;
        bh=dYGwS1A+Tqb1nmQc5CIKp73qSOM9f78XfKZWtjhm3pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yMX6LSb856VoQQ5mTQLMPvSyc12z7rnVQTOTD22Ezp/KADlwz7tytl2GYsNgwE8hn
         V9q264r01AfNpwUxmam6U2o0xR1D81JQ15i1YzpdF41lrQF/wfuqYxF/hR6Ovna0ys
         FBFNOAsRDCS9lGz+5DaqCjN000RGv22CZsPeABQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        David Edmondson <david.edmondson@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.14 16/17] KVM: x86: clflushopt should be treated as a no-op by emulation
Date:   Fri, 20 Nov 2020 12:03:27 +0100
Message-Id: <20201120104541.217925922@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104540.414709708@linuxfoundation.org>
References: <20201120104540.414709708@linuxfoundation.org>
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
@@ -3949,6 +3949,12 @@ static int em_clflush(struct x86_emulate
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
@@ -4463,7 +4469,7 @@ static const struct opcode group11[] = {
 };
 
 static const struct gprefix pfx_0f_ae_7 = {
-	I(SrcMem | ByteOp, em_clflush), N, N, N,
+	I(SrcMem | ByteOp, em_clflush), I(SrcMem | ByteOp, em_clflushopt), N, N,
 };
 
 static const struct group_dual group15 = { {



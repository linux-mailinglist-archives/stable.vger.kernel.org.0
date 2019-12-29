Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA4FA12C56B
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbfL2Rf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:35:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:40816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729764AbfL2Rf7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:35:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 033FF206CB;
        Sun, 29 Dec 2019 17:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640958;
        bh=CAaJ7YqaVHX3CZcc9mY/Z28h0vyaztCdHIRznZRQQmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OL/v4OPn4kQVJ3otwz8FFtmlO7UQ9yYG4sXorLEDX+oSGcS/L+jDblkP6j7Ehiw7f
         oH9eh86GoiFEFFsMjCRM/sMLy/rKa2/4+5pbYq3c8NViYyD3Q051VxxOqP7rXgABmY
         txvrH6LXGJ/QHfATGxd/QvrhS9MCFQCPV13Y1LRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.19 208/219] KVM: arm64: Ensure params is initialised when looking up sys register
Date:   Sun, 29 Dec 2019 18:20:10 +0100
Message-Id: <20191229162541.559477727@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit 1ce74e96c2407df2b5867e5d45a70aacb8923c14 upstream.

Commit 4b927b94d5df ("KVM: arm/arm64: vgic: Introduce find_reg_by_id()")
introduced 'find_reg_by_id()', which looks up a system register only if
the 'id' index parameter identifies a valid system register. As part of
the patch, existing callers of 'find_reg()' were ported over to the new
interface, but this breaks 'index_to_sys_reg_desc()' in the case that the
initial lookup in the vCPU target table fails because we will then call
into 'find_reg()' for the system register table with an uninitialised
'param' as the key to the lookup.

GCC 10 is bright enough to spot this (amongst a tonne of false positives,
but hey!):

  | arch/arm64/kvm/sys_regs.c: In function ‘index_to_sys_reg_desc.part.0.isra’:
  | arch/arm64/kvm/sys_regs.c:983:33: warning: ‘params.Op2’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  |   983 |   (u32)(x)->CRn, (u32)(x)->CRm, (u32)(x)->Op2);
  | [...]

Revert the hunk of 4b927b94d5df which breaks 'index_to_sys_reg_desc()' so
that the old behaviour of checking the index upfront is restored.

Fixes: 4b927b94d5df ("KVM: arm/arm64: vgic: Introduce find_reg_by_id()")
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191212094049.12437-1-will@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kvm/sys_regs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2174,8 +2174,11 @@ static const struct sys_reg_desc *index_
 	if ((id & KVM_REG_ARM_COPROC_MASK) != KVM_REG_ARM64_SYSREG)
 		return NULL;
 
+	if (!index_to_params(id, &params))
+		return NULL;
+
 	table = get_target_table(vcpu->arch.target, true, &num);
-	r = find_reg_by_id(id, &params, table, num);
+	r = find_reg(&params, table, num);
 	if (!r)
 		r = find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 



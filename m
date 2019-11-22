Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A464C106F50
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbfKVKwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:52:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:36000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727846AbfKVKw2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:52:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46ACB20656;
        Fri, 22 Nov 2019 10:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419947;
        bh=kk9s2ECVWRZh6QKxhKPAVyCqzJNCNwA+1D7J7+tmnYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3MLsTwTIBoRnJTpolK5RDqQCyMGyM7TpgNBAyldQhi6k+VrD+MJ+jZI0VA6yQ93e
         n302IPkJ+PtuU3Q8Uv6b+mKDndh/GJ2uUXT1syKREL6J3zywXZtnsKd6VZH/Hm8kCV
         7jBbFsFyIf0B3mUvbMMMoXt7ise1fyx9q5xgvj5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cameron Kaiser <spectre@floodgap.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 062/122] KVM: PPC: Book3S PR: Exiting split hack mode needs to fixup both PC and LR
Date:   Fri, 22 Nov 2019 11:28:35 +0100
Message-Id: <20191122100805.666729402@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cameron Kaiser <spectre@floodgap.com>

[ Upstream commit 1006284c5e411872333967b1970c2ca46a9e225f ]

When an OS (currently only classic Mac OS) is running in KVM-PR and makes a
linked jump from code with split hack addressing enabled into code that does
not, LR is not correctly updated and reflects the previously munged PC.

To fix this, this patch undoes the address munge when exiting split
hack mode so that code relying on LR being a proper address will now
execute. This does not affect OS X or other operating systems running
on KVM-PR.

Signed-off-by: Cameron Kaiser <spectre@floodgap.com>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index d38280b01ef08..1eda812499376 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -79,8 +79,11 @@ void kvmppc_unfixup_split_real(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.hflags & BOOK3S_HFLAG_SPLIT_HACK) {
 		ulong pc = kvmppc_get_pc(vcpu);
+		ulong lr = kvmppc_get_lr(vcpu);
 		if ((pc & SPLIT_HACK_MASK) == SPLIT_HACK_OFFS)
 			kvmppc_set_pc(vcpu, pc & ~SPLIT_HACK_MASK);
+		if ((lr & SPLIT_HACK_MASK) == SPLIT_HACK_OFFS)
+			kvmppc_set_lr(vcpu, lr & ~SPLIT_HACK_MASK);
 		vcpu->arch.hflags &= ~BOOK3S_HFLAG_SPLIT_HACK;
 	}
 }
-- 
2.20.1




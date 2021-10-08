Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1133B42699C
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241430AbhJHLjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:39:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242524AbhJHLiJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:38:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8467561506;
        Fri,  8 Oct 2021 11:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692780;
        bh=J+N4+GuPHs+9eKhVz/mss9L3pm6/VT3HUUc/79tPF9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2C+TJy31ay2jspnNB+IZsV41BchC6b0IN9PE8VK33e4MaLKFh7+UvkpCPuS7SgAn
         APa3X7rHtVi0qixeOi+fpoQnGva2L6BSvRO8JhRAaam6LGXdbgkth0la3E/QBHLUPl
         WAyOB5TEFja0acacffpxrKdo/imfcaZPBoJ04lh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 42/48] KVM: x86: reset pdptrs_from_userspace when exiting smm
Date:   Fri,  8 Oct 2021 13:28:18 +0200
Message-Id: <20211008112721.450195654@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit 37687c403a641f251cb2ef2e7830b88aa0647ba9 ]

When exiting SMM, pdpts are loaded again from the guest memory.

This fixes a theoretical bug, when exit from SMM triggers entry to the
nested guest which re-uses some of the migration
code which uses this flag as a workaround for a legacy userspace.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20210913140954.165665-4-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6d5d6e93f5c4..07d3d8aa50a9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7659,6 +7659,13 @@ static void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm)
 
 		/* Process a latched INIT or SMI, if any.  */
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
+
+		/*
+		 * Even if KVM_SET_SREGS2 loaded PDPTRs out of band,
+		 * on SMM exit we still need to reload them from
+		 * guest memory
+		 */
+		vcpu->arch.pdptrs_from_userspace = false;
 	}
 
 	kvm_mmu_reset_context(vcpu);
-- 
2.33.0




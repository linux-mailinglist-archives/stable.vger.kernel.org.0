Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BE537CEBB
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238877AbhELRGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:06:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240281AbhELQuX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:50:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A6A361D5C;
        Wed, 12 May 2021 16:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836189;
        bh=rkH33oavsixEVA2CNdaTd/xX5qkbEuQW0AXOntpVmcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Td7sXkapb74ykEfqZaLhjzHsfwuPq4/aji1P6SdzekZeTO1J5PB5Ed7r8UDino4wj
         j0uCQmWUtvj8vGN86pMDR/tAHfy7iSM8EHdxWZ0ou5rQE6iR1irCPNS37X0nbKt7Vg
         oqdcyAkivjeEyfh4vYVWQ1kZb825rZ1GD8xUsKj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 647/677] KVM: SVM: Free sev_asid_bitmap during init if SEV setup fails
Date:   Wed, 12 May 2021 16:51:33 +0200
Message-Id: <20210512144858.858960369@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit f31b88b35f90f6b7ae4abc1015494a285f459221 ]

Free sev_asid_bitmap if the reclaim bitmap allocation fails, othwerise
KVM will unnecessarily keep the bitmap when SEV is not fully enabled.

Freeing the page is also necessary to avoid introducing a bug when a
future patch eliminates svm_sev_enabled() in favor of using the global
'sev' flag directly.  While sev_hardware_enabled() checks max_sev_asid,
which is true even if KVM setup fails, 'sev' will be true if and only
if KVM setup fully succeeds.

Fixes: 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations")
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422021125.3417167-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d5ccb929643a..019130011d0f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1348,8 +1348,11 @@ void __init sev_hardware_setup(void)
 		goto out;
 
 	sev_reclaim_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
-	if (!sev_reclaim_asid_bitmap)
+	if (!sev_reclaim_asid_bitmap) {
+		bitmap_free(sev_asid_bitmap);
+		sev_asid_bitmap = NULL;
 		goto out;
+	}
 
 	pr_info("SEV supported: %u ASIDs\n", max_sev_asid - min_sev_asid + 1);
 	sev_supported = true;
-- 
2.30.2




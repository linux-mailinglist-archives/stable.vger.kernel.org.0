Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F38DF15EF9E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389166AbgBNRtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:49:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388555AbgBNP7Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:59:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F4B42067D;
        Fri, 14 Feb 2020 15:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695965;
        bh=dkc3DcPnSfReoLTVZWTryE+VHvgOIvMyhzYaUJQ6280=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tSspkLhQDnihXztlp3RZJWkBJX+yAafv9LQy2bpOZzT1brmgkmrcJvHQcAp4TVi7Q
         GFPTa0glBcAZZqxypUOyoBxU/jHhh6nScqDPK1WhrxouQCmEERCcnYoGqN5sm0wpYH
         S+7f8RB2eeUQLh6oP3nVclTOepK8iFgxe21VlFJk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bharata B Rao <bharata@linux.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.5 493/542] KVM: PPC: Book3S HV: Release lock on page-out failure path
Date:   Fri, 14 Feb 2020 10:48:05 -0500
Message-Id: <20200214154854.6746-493-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bharata B Rao <bharata@linux.ibm.com>

[ Upstream commit e032e3b55b6f487e48c163c5dca74086f147a169 ]

When migrate_vma_setup() fails in kvmppc_svm_page_out(),
release kvm->arch.uvmem_lock before returning.

Fixes: ca9f4942670 ("KVM: PPC: Book3S HV: Support for running secure guests")
Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 2de264fc31563..5914fbfa5e0a7 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -543,7 +543,7 @@ kvmppc_svm_page_out(struct vm_area_struct *vma, unsigned long start,
 
 	ret = migrate_vma_setup(&mig);
 	if (ret)
-		return ret;
+		goto out;
 
 	spage = migrate_pfn_to_page(*mig.src);
 	if (!spage || !(*mig.src & MIGRATE_PFN_MIGRATE))
-- 
2.20.1


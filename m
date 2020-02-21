Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9EF16722C
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730447AbgBUIAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:00:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731124AbgBUIAw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:00:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB3AD222C4;
        Fri, 21 Feb 2020 08:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272051;
        bh=dkc3DcPnSfReoLTVZWTryE+VHvgOIvMyhzYaUJQ6280=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cEiYJZ3WOZdkoA+IoMLN918codmGpjmeEECsvKecYVlJKMW8JAsOgBjcjvp/YdqIs
         laDaCq8oKSBmrl6qCuIwjelps8yxxNTYCaX22xBn5ktqIhuq7u88YJBdb8GmdZaH0q
         tPN3OS1lswUxqG1yJosJlh1jnTFYaL9rHX0eH6BY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bharata B Rao <bharata@linux.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 360/399] KVM: PPC: Book3S HV: Release lock on page-out failure path
Date:   Fri, 21 Feb 2020 08:41:25 +0100
Message-Id: <20200221072435.741813944@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A202E122D
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgLWCTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:19:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728732AbgLWCTn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E5782222D;
        Wed, 23 Dec 2020 02:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689955;
        bh=V7rwdwLlU058iCwzKlQQbYplj2Ad9qdqUpMp0PLzKh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UyTH5SGTmUQ6w94sJcJXy5Z50Yk9F5umwpX3E7UCt1s2wjlKYX9UTy5hp9iCYDD69
         C2XEP+9h91vSAu1S0XtlJ21PsquR2PUpXpQk4Woliva8dhURh8OICuYfcLUjiBkdQ7
         6/wOz7XNvj9hNhjNemeVx8oYKwoLzh2C78kXoX5XXeNb/DR5L1jrD9hiOOygogDmZ2
         36GuM+pEHPVZNkKXV06fPO9hdlhIjm7uTaFF9Z0tU54SaTKUON+X3asSg2S9mmWoxZ
         6BHI+2Xrhbh7qFhY4MT6K+t14KZW77fgdZ2p6/1GkA6CU1RrKcfT4IAbAPYQO/PwUs
         nF3E8dUM3sirg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 048/130] MIPS: vdso: Use vma page protection for remapping
Date:   Tue, 22 Dec 2020 21:16:51 -0500
Message-Id: <20201223021813.2791612-48-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

[ Upstream commit 724d554a117a0552c2c982f0b5cd1d685274d678 ]

MIPS protection bits are setup during runtime so using defines like
PAGE_READONLY ignores these runtime changes. To fix this we simply
use the page protection of the setup vma.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/vdso.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/vdso.c b/arch/mips/kernel/vdso.c
index bc35f8499111b..cea83d2866e34 100644
--- a/arch/mips/kernel/vdso.c
+++ b/arch/mips/kernel/vdso.c
@@ -157,7 +157,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 		gic_pfn = virt_to_phys(mips_gic_base + MIPS_GIC_USER_OFS) >> PAGE_SHIFT;
 
 		ret = io_remap_pfn_range(vma, base, gic_pfn, gic_size,
-					 pgprot_noncached(PAGE_READONLY));
+					 pgprot_noncached(vma->vm_page_prot));
 		if (ret)
 			goto out;
 	}
@@ -165,7 +165,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	/* Map data page. */
 	ret = remap_pfn_range(vma, data_addr,
 			      virt_to_phys(vdso_data) >> PAGE_SHIFT,
-			      PAGE_SIZE, PAGE_READONLY);
+			      PAGE_SIZE, vma->vm_page_prot);
 	if (ret)
 		goto out;
 
-- 
2.27.0


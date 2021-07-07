Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695973BE834
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 14:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbhGGMuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 08:50:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:50098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231553AbhGGMuT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Jul 2021 08:50:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F48561CBA;
        Wed,  7 Jul 2021 12:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625662058;
        bh=gukKuOU+K3iXHkSgkCLU6NTLSUIka9ASAdZNdEySi4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXsd82lnNIUovk1YbdGXzrvkSOfN41Fa+IeAOsdRvnLyAHTcND0gpPB3GmA8rowyL
         dN60WpPC6teWtXvhtLVLeKZcJApRpg6LrbvRk9yZHB+LgmO9Z9RHzq7H6bF7SMNL5m
         71bgQdFmaUb0gqlgDmNNmlWdYvZlTiimcmn/SWKv25kEoYY4tPuGH2bM8fToDliBbB
         F5YI2C5KhbXHmJbT4uHuHGi/b/mivSEyFTEGPGmgeM8aBJRBvZu9upAoYX5ZuVbXWJ
         1JWPUKl0gzVwKyIq3jfcsMafgMWF9/WsvcgT8Hi977kcZMEMeH/UD5qudeEL2d+Znx
         H2b6A7dBIWvqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Re: Linux 5.13.1
Date:   Wed,  7 Jul 2021 08:47:35 -0400
Message-Id: <20210707124735.2443267-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210707124735.2443267-1-sashal@kernel.org>
References: <20210707124735.2443267-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 0565caea0362..069607cfe283 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 13
-SUBLEVEL = 0
+SUBLEVEL = 1
 EXTRAVERSION =
 NAME = Opossums on Parade
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9c7ced0e3171..682e82956ea5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -320,6 +320,7 @@ union kvm_mmu_extended_role {
 		unsigned int cr4_pke:1;
 		unsigned int cr4_smap:1;
 		unsigned int cr4_smep:1;
+		unsigned int cr4_la57:1;
 		unsigned int maxphyaddr:6;
 	};
 };
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8d5876dfc6b7..a54f72c31be9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4476,6 +4476,7 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu)
 	ext.cr4_smap = !!kvm_read_cr4_bits(vcpu, X86_CR4_SMAP);
 	ext.cr4_pse = !!is_pse(vcpu);
 	ext.cr4_pke = !!kvm_read_cr4_bits(vcpu, X86_CR4_PKE);
+	ext.cr4_la57 = !!kvm_read_cr4_bits(vcpu, X86_CR4_LA57);
 	ext.maxphyaddr = cpuid_maxphyaddr(vcpu);
 
 	ext.valid = 1;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ef2265f86b91..04220581579c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5058,7 +5058,7 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 
 	/* Already populated array? */
 	if (unlikely(page_array && nr_pages - nr_populated == 0))
-		return 0;
+		return nr_populated;
 
 	/* Use the single page allocator for one page. */
 	if (nr_pages - nr_populated == 1)

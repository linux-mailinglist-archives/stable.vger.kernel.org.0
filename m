Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0715810623A
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729722AbfKVGC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:02:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729714AbfKVGC0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:02:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 525B320659;
        Fri, 22 Nov 2019 06:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402545;
        bh=TPBoOGY1A57r86SWMy5IOTPBBr3mVxs/0C9ZC3nG3N8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0gpQXVMG5M3L5DzMbyyK7qB8eMZRPkNC2rZJrtFLZXzparX80KcKTZro1gkDXK9Jr
         rgUqo18lhoSZpGSPq029kt6J40u8dEb8XWZO0PYkjKEEc9HIqrTtHgYsLAB+szqQK2
         bdU6s1ll3FYq6V2B2iVKY08Ttgi3t5rCrmpOZGbg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Sam Bobroff <sbobroff@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 51/91] powerpc/powernv/eeh/npu: Fix uninitialized variables in opal_pci_eeh_freeze_status
Date:   Fri, 22 Nov 2019 01:00:49 -0500
Message-Id: <20191122060129.4239-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit c20577014f85f36d4e137d3d52a1f61225b4a3d2 ]

The current implementation of the OPAL_PCI_EEH_FREEZE_STATUS call in
skiboot's NPU driver does not touch the pci_error_type parameter so
it might have garbage but the powernv code analyzes it nevertheless.

This initializes pcierr and fstate to zero in all call sites.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: Sam Bobroff <sbobroff@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/eeh-powernv.c | 8 ++++----
 arch/powerpc/platforms/powernv/pci-ioda.c    | 4 ++--
 arch/powerpc/platforms/powernv/pci.c         | 4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/eeh-powernv.c b/arch/powerpc/platforms/powernv/eeh-powernv.c
index 2354ea51e8714..6189c4cf56c3f 100644
--- a/arch/powerpc/platforms/powernv/eeh-powernv.c
+++ b/arch/powerpc/platforms/powernv/eeh-powernv.c
@@ -546,8 +546,8 @@ static void pnv_eeh_get_phb_diag(struct eeh_pe *pe)
 static int pnv_eeh_get_phb_state(struct eeh_pe *pe)
 {
 	struct pnv_phb *phb = pe->phb->private_data;
-	u8 fstate;
-	__be16 pcierr;
+	u8 fstate = 0;
+	__be16 pcierr = 0;
 	s64 rc;
 	int result = 0;
 
@@ -585,8 +585,8 @@ static int pnv_eeh_get_phb_state(struct eeh_pe *pe)
 static int pnv_eeh_get_pe_state(struct eeh_pe *pe)
 {
 	struct pnv_phb *phb = pe->phb->private_data;
-	u8 fstate;
-	__be16 pcierr;
+	u8 fstate = 0;
+	__be16 pcierr = 0;
 	s64 rc;
 	int result;
 
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 8015e40bc7ee4..3ec673b4ca6ce 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -599,8 +599,8 @@ static int pnv_ioda_unfreeze_pe(struct pnv_phb *phb, int pe_no, int opt)
 static int pnv_ioda_get_pe_state(struct pnv_phb *phb, int pe_no)
 {
 	struct pnv_ioda_pe *slave, *pe;
-	u8 fstate, state;
-	__be16 pcierr;
+	u8 fstate = 0, state;
+	__be16 pcierr = 0;
 	s64 rc;
 
 	/* Sanity check on PE number */
diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index db7b8020f68ef..98cc8ba07c233 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -482,8 +482,8 @@ static void pnv_pci_handle_eeh_config(struct pnv_phb *phb, u32 pe_no)
 static void pnv_pci_config_check_eeh(struct pci_dn *pdn)
 {
 	struct pnv_phb *phb = pdn->phb->private_data;
-	u8	fstate;
-	__be16	pcierr;
+	u8	fstate = 0;
+	__be16	pcierr = 0;
 	unsigned int pe_no;
 	s64	rc;
 
-- 
2.20.1


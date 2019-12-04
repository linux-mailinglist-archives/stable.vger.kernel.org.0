Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19D4411337C
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731574AbfLDSMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:12:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731569AbfLDSMN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:12:13 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F04D20675;
        Wed,  4 Dec 2019 18:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483132;
        bh=TPBoOGY1A57r86SWMy5IOTPBBr3mVxs/0C9ZC3nG3N8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RYZE+no1jB7KLPB/ydqS3w/9BWpEXZTGTPvi3KVFQgtdYZRAH7XEJHxurViCzLLtw
         ujWDcnYW0ETfSc8Op24LwEE2bqTBDe3HL0S7CeAAmsyWbQ5DcUu/TTUc5xO0GWDr0p
         0c9X8ghFNyVo+ITsnOjgpKkgy/DeL+GSbPaPxfcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Sam Bobroff <sbobroff@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 064/125] powerpc/powernv/eeh/npu: Fix uninitialized variables in opal_pci_eeh_freeze_status
Date:   Wed,  4 Dec 2019 18:56:09 +0100
Message-Id: <20191204175322.856176544@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




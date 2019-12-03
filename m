Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F07C5111D60
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbfLCWwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:52:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730052AbfLCWws (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:52:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B1312084F;
        Tue,  3 Dec 2019 22:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413567;
        bh=NxGRVXtjD/aXIsPUuHL37B5BbTj3nmk8XEn0YOKo7Kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3VOa6QLshv1UmoHbSxhpMjCM1HodXuGUL0DwTnFqJjRLDjAWliuMY9HIdGy8HOO0
         U+4Wk8dkiVG2G6FPiy+/Xnr5+KwLAWoVDSDVIl1w5p7in84znVOTIVpfr6AUM/YtGb
         UOpVO3bj1HV8LMD48HHDDjNfKHSbxx8ZL2aRQa6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Sam Bobroff <sbobroff@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 170/321] powerpc/powernv/eeh/npu: Fix uninitialized variables in opal_pci_eeh_freeze_status
Date:   Tue,  3 Dec 2019 23:33:56 +0100
Message-Id: <20191203223435.978451990@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
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
index 3c1beae29f2d8..9dd5b8909178b 100644
--- a/arch/powerpc/platforms/powernv/eeh-powernv.c
+++ b/arch/powerpc/platforms/powernv/eeh-powernv.c
@@ -578,8 +578,8 @@ static void pnv_eeh_get_phb_diag(struct eeh_pe *pe)
 static int pnv_eeh_get_phb_state(struct eeh_pe *pe)
 {
 	struct pnv_phb *phb = pe->phb->private_data;
-	u8 fstate;
-	__be16 pcierr;
+	u8 fstate = 0;
+	__be16 pcierr = 0;
 	s64 rc;
 	int result = 0;
 
@@ -617,8 +617,8 @@ static int pnv_eeh_get_phb_state(struct eeh_pe *pe)
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
index 326ca6288bb12..ee63749a2d47e 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -605,8 +605,8 @@ static int pnv_ioda_unfreeze_pe(struct pnv_phb *phb, int pe_no, int opt)
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
index 13aef2323bbca..db230a35609bf 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -602,8 +602,8 @@ static void pnv_pci_handle_eeh_config(struct pnv_phb *phb, u32 pe_no)
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




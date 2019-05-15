Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C14A1F371
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfEOLCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:02:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbfEOLCt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:02:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3656A216FD;
        Wed, 15 May 2019 11:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918168;
        bh=MssDB12zE7v7+lx5h55D6vGmX//645lmACRKe8OHhyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJbax8H0SDyxOkZG2vsS0xnDlwXNGYEs8ynS79cVOj5e5onoA9D88/7ai+SfcMhx+
         ux+UlRhvhWP/wpkGpMWVyULePmibQEQTdvXcGdl0hM9BhfZoypCqTj5sjk+qezAT2u
         panTIhNPCVI6dy2mR2HFdijhcg79wVSkxqFwTavs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 024/266] powerpc/pseries: Set or clear security feature flags
Date:   Wed, 15 May 2019 12:52:11 +0200
Message-Id: <20190515090723.398874702@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit f636c14790ead6cc22cf62279b1f8d7e11a67116 upstream.

Now that we have feature flags for security related things, set or
clear them based on what we receive from the hypercall.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/setup.c |   43 +++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -67,6 +67,7 @@
 #include <asm/eeh.h>
 #include <asm/reg.h>
 #include <asm/plpar_wrappers.h>
+#include <asm/security_features.h>
 
 #include "pseries.h"
 
@@ -499,6 +500,40 @@ static void __init find_and_init_phbs(vo
 	of_pci_check_probe_only();
 }
 
+static void init_cpu_char_feature_flags(struct h_cpu_char_result *result)
+{
+	if (result->character & H_CPU_CHAR_SPEC_BAR_ORI31)
+		security_ftr_set(SEC_FTR_SPEC_BAR_ORI31);
+
+	if (result->character & H_CPU_CHAR_BCCTRL_SERIALISED)
+		security_ftr_set(SEC_FTR_BCCTRL_SERIALISED);
+
+	if (result->character & H_CPU_CHAR_L1D_FLUSH_ORI30)
+		security_ftr_set(SEC_FTR_L1D_FLUSH_ORI30);
+
+	if (result->character & H_CPU_CHAR_L1D_FLUSH_TRIG2)
+		security_ftr_set(SEC_FTR_L1D_FLUSH_TRIG2);
+
+	if (result->character & H_CPU_CHAR_L1D_THREAD_PRIV)
+		security_ftr_set(SEC_FTR_L1D_THREAD_PRIV);
+
+	if (result->character & H_CPU_CHAR_COUNT_CACHE_DISABLED)
+		security_ftr_set(SEC_FTR_COUNT_CACHE_DISABLED);
+
+	/*
+	 * The features below are enabled by default, so we instead look to see
+	 * if firmware has *disabled* them, and clear them if so.
+	 */
+	if (!(result->character & H_CPU_BEHAV_FAVOUR_SECURITY))
+		security_ftr_clear(SEC_FTR_FAVOUR_SECURITY);
+
+	if (!(result->character & H_CPU_BEHAV_L1D_FLUSH_PR))
+		security_ftr_clear(SEC_FTR_L1D_FLUSH_PR);
+
+	if (!(result->character & H_CPU_BEHAV_BNDS_CHK_SPEC_BAR))
+		security_ftr_clear(SEC_FTR_BNDS_CHK_SPEC_BAR);
+}
+
 void pseries_setup_rfi_flush(void)
 {
 	struct h_cpu_char_result result;
@@ -512,6 +547,8 @@ void pseries_setup_rfi_flush(void)
 
 	rc = plpar_get_cpu_characteristics(&result);
 	if (rc == H_SUCCESS) {
+		init_cpu_char_feature_flags(&result);
+
 		if (result.character & H_CPU_CHAR_L1D_FLUSH_TRIG2)
 			types |= L1D_FLUSH_MTTRIG;
 		if (result.character & H_CPU_CHAR_L1D_FLUSH_ORI30)
@@ -522,6 +559,12 @@ void pseries_setup_rfi_flush(void)
 			enable = false;
 	}
 
+	/*
+	 * We're the guest so this doesn't apply to us, clear it to simplify
+	 * handling of it elsewhere.
+	 */
+	security_ftr_clear(SEC_FTR_L1D_FLUSH_HV);
+
 	setup_rfi_flush(types, enable);
 }
 



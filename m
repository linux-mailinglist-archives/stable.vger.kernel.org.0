Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2E541F36A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbfEOMOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:14:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbfEOLE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:04:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 581952084F;
        Wed, 15 May 2019 11:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918268;
        bh=+Nfxmm7lbWMddJMtJcLgssgOl6bNr/c+aGn3MoJoo5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0macTT4qtsd6PyOMtqhP8lz7l50F81k706LLovhwnAqGHIMLr09qelA2c7sFZ7MAT
         BlxSpsu9Fty+wLPckWn+FST6AoEVTLZDjvFgJ9AMV0PlE7aDRfU10nrhJ/RlTKmivK
         G+cxYIeSHszLkW2L+jDb8/mKK1reNvt6HbfJaS34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 028/266] powerpc/powernv: Use the security flags in pnv_setup_rfi_flush()
Date:   Wed, 15 May 2019 12:52:15 +0200
Message-Id: <20190515090723.513820801@linuxfoundation.org>
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

commit 37c0bdd00d3ae83369ab60a6712c28e11e6458d5 upstream.

Now that we have the security flags we can significantly simplify the
code in pnv_setup_rfi_flush(), because we can use the flags instead of
checking device tree properties and because the security flags have
pessimistic defaults.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/powernv/setup.c |   41 ++++++++-------------------------
 1 file changed, 10 insertions(+), 31 deletions(-)

--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -65,7 +65,7 @@ static void init_fw_feat_flags(struct de
 	if (fw_feature_is("enabled", "fw-bcctrl-serialized", np))
 		security_ftr_set(SEC_FTR_BCCTRL_SERIALISED);
 
-	if (fw_feature_is("enabled", "inst-spec-barrier-ori31,31,0", np))
+	if (fw_feature_is("enabled", "inst-l1d-flush-ori30,30,0", np))
 		security_ftr_set(SEC_FTR_L1D_FLUSH_ORI30);
 
 	if (fw_feature_is("enabled", "inst-l1d-flush-trig2", np))
@@ -98,11 +98,10 @@ static void pnv_setup_rfi_flush(void)
 {
 	struct device_node *np, *fw_features;
 	enum l1d_flush_type type;
-	int enable;
+	bool enable;
 
 	/* Default to fallback in case fw-features are not available */
 	type = L1D_FLUSH_FALLBACK;
-	enable = 1;
 
 	np = of_find_node_by_name(NULL, "ibm,opal");
 	fw_features = of_get_child_by_name(np, "fw-features");
@@ -110,40 +109,20 @@ static void pnv_setup_rfi_flush(void)
 
 	if (fw_features) {
 		init_fw_feat_flags(fw_features);
+		of_node_put(fw_features);
 
-		np = of_get_child_by_name(fw_features, "inst-l1d-flush-trig2");
-		if (np && of_property_read_bool(np, "enabled"))
+		if (security_ftr_enabled(SEC_FTR_L1D_FLUSH_TRIG2))
 			type = L1D_FLUSH_MTTRIG;
 
-		of_node_put(np);
-
-		np = of_get_child_by_name(fw_features, "inst-l1d-flush-ori30,30,0");
-		if (np && of_property_read_bool(np, "enabled"))
+		if (security_ftr_enabled(SEC_FTR_L1D_FLUSH_ORI30))
 			type = L1D_FLUSH_ORI;
-
-		of_node_put(np);
-
-		/* Enable unless firmware says NOT to */
-		enable = 2;
-		np = of_get_child_by_name(fw_features, "needs-l1d-flush-msr-hv-1-to-0");
-		if (np && of_property_read_bool(np, "disabled"))
-			enable--;
-
-		of_node_put(np);
-
-		np = of_get_child_by_name(fw_features, "needs-l1d-flush-msr-pr-0-to-1");
-		if (np && of_property_read_bool(np, "disabled"))
-			enable--;
-
-		np = of_get_child_by_name(fw_features, "speculation-policy-favor-security");
-		if (np && of_property_read_bool(np, "disabled"))
-			enable = 0;
-
-		of_node_put(np);
-		of_node_put(fw_features);
 	}
 
-	setup_rfi_flush(type, enable > 0);
+	enable = security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) && \
+		 (security_ftr_enabled(SEC_FTR_L1D_FLUSH_PR)   || \
+		  security_ftr_enabled(SEC_FTR_L1D_FLUSH_HV));
+
+	setup_rfi_flush(type, enable);
 }
 
 static void __init pnv_setup_arch(void)



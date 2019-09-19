Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A395B8463
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405657AbfISWK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:10:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393535AbfISWK0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:10:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E47C21920;
        Thu, 19 Sep 2019 22:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931025;
        bh=Ov6xLFQ1v2QQcBXiK649r5jt25ebyAzDbX3CZoFlSEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wsi4SpWiEIdsvJaYi7IKe6+reg1ogseHy7i29Gakcy/C/W9zdxLV2TUq6aSia9gD6
         X3UHJYCoayvaNHqagmoImr4jBkojGmI86qUp+GYoLJmlOQk5Enuay+dd1kD+mX3MjR
         wlgs3zIR4l6B3KDSBE6ZlPIgqHWO7JnAI8eo+CxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Kosuke Tatsukawa <tatsu@ab.jp.nec.com>,
        Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 099/124] tools/power turbostat: Fix Haswell Core systems
Date:   Fri, 20 Sep 2019 00:03:07 +0200
Message-Id: <20190919214822.682987329@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Len Brown <len.brown@intel.com>

[ Upstream commit cd188af5282d9f9e65f63915b13239bafc746f8d ]

turbostat: cpu0: msr offset 0x630 read failed: Input/output error

because Haswell Core does not have C8-C10.

Output C8-C10 only on Haswell ULT.

Fixes: f5a4c76ad7de ("tools/power turbostat: consolidate duplicate model numbers")

Reported-by: Prarit Bhargava <prarit@redhat.com>
Suggested-by: Kosuke Tatsukawa <tatsu@ab.jp.nec.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 752cb4c0fde6b..56c3e041d4f93 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -3211,6 +3211,7 @@ int probe_nhm_msrs(unsigned int family, unsigned int model)
 		break;
 	case INTEL_FAM6_HASWELL_CORE:	/* HSW */
 	case INTEL_FAM6_HASWELL_X:	/* HSX */
+	case INTEL_FAM6_HASWELL_ULT:	/* HSW */
 	case INTEL_FAM6_HASWELL_GT3E:	/* HSW */
 	case INTEL_FAM6_BROADWELL_CORE:	/* BDW */
 	case INTEL_FAM6_BROADWELL_GT3E:	/* BDW */
@@ -3407,6 +3408,7 @@ int has_config_tdp(unsigned int family, unsigned int model)
 	case INTEL_FAM6_IVYBRIDGE:	/* IVB */
 	case INTEL_FAM6_HASWELL_CORE:	/* HSW */
 	case INTEL_FAM6_HASWELL_X:	/* HSX */
+	case INTEL_FAM6_HASWELL_ULT:	/* HSW */
 	case INTEL_FAM6_HASWELL_GT3E:	/* HSW */
 	case INTEL_FAM6_BROADWELL_CORE:	/* BDW */
 	case INTEL_FAM6_BROADWELL_GT3E:	/* BDW */
@@ -3843,6 +3845,7 @@ void rapl_probe_intel(unsigned int family, unsigned int model)
 	case INTEL_FAM6_SANDYBRIDGE:
 	case INTEL_FAM6_IVYBRIDGE:
 	case INTEL_FAM6_HASWELL_CORE:	/* HSW */
+	case INTEL_FAM6_HASWELL_ULT:	/* HSW */
 	case INTEL_FAM6_HASWELL_GT3E:	/* HSW */
 	case INTEL_FAM6_BROADWELL_CORE:	/* BDW */
 	case INTEL_FAM6_BROADWELL_GT3E:	/* BDW */
@@ -4034,6 +4037,7 @@ void perf_limit_reasons_probe(unsigned int family, unsigned int model)
 
 	switch (model) {
 	case INTEL_FAM6_HASWELL_CORE:	/* HSW */
+	case INTEL_FAM6_HASWELL_ULT:	/* HSW */
 	case INTEL_FAM6_HASWELL_GT3E:	/* HSW */
 		do_gfx_perf_limit_reasons = 1;
 	case INTEL_FAM6_HASWELL_X:	/* HSX */
@@ -4253,6 +4257,7 @@ int has_snb_msrs(unsigned int family, unsigned int model)
 	case INTEL_FAM6_IVYBRIDGE_X:	/* IVB Xeon */
 	case INTEL_FAM6_HASWELL_CORE:	/* HSW */
 	case INTEL_FAM6_HASWELL_X:	/* HSW */
+	case INTEL_FAM6_HASWELL_ULT:	/* HSW */
 	case INTEL_FAM6_HASWELL_GT3E:	/* HSW */
 	case INTEL_FAM6_BROADWELL_CORE:	/* BDW */
 	case INTEL_FAM6_BROADWELL_GT3E:	/* BDW */
@@ -4286,7 +4291,7 @@ int has_hsw_msrs(unsigned int family, unsigned int model)
 		return 0;
 
 	switch (model) {
-	case INTEL_FAM6_HASWELL_CORE:
+	case INTEL_FAM6_HASWELL_ULT:	/* HSW */
 	case INTEL_FAM6_BROADWELL_CORE:	/* BDW */
 	case INTEL_FAM6_SKYLAKE_MOBILE:	/* SKL */
 	case INTEL_FAM6_CANNONLAKE_MOBILE:	/* CNL */
@@ -4570,9 +4575,6 @@ unsigned int intel_model_duplicates(unsigned int model)
 	case INTEL_FAM6_XEON_PHI_KNM:
 		return INTEL_FAM6_XEON_PHI_KNL;
 
-	case INTEL_FAM6_HASWELL_ULT:
-		return INTEL_FAM6_HASWELL_CORE;
-
 	case INTEL_FAM6_BROADWELL_X:
 	case INTEL_FAM6_BROADWELL_XEON_D:	/* BDX-DE */
 		return INTEL_FAM6_BROADWELL_X;
-- 
2.20.1




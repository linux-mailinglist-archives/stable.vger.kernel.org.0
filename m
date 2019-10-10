Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B74BD25D7
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387791AbfJJIjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:39:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387796AbfJJIjM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:39:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C957C21920;
        Thu, 10 Oct 2019 08:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696751;
        bh=1ubGTSIf4g5yWehZPwsLb5vP6YV0ff65tPT/8BFHHbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2urd2PKW193lWRyIMegw+4DaABkcFmjg+df6fFMCuqcNPt7swb2ysPbFjVdSMbTD
         i/A6jpus30hCRU0GftPoAby49BJHG52sriEut4rTL3dyYP7hIkDgb+AcF1AHl/g7BK
         SuEfBYZ3q6cWRUmtEUa0z1qn8+A//OXOrbjbmzSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.3 032/148] powerpc/book3s64/mm: Dont do tlbie fixup for some hardware revisions
Date:   Thu, 10 Oct 2019 10:34:53 +0200
Message-Id: <20191010083613.087192900@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

commit 677733e296b5c7a37c47da391fc70a43dc40bd67 upstream.

The store ordering vs tlbie issue mentioned in commit
a5d4b5891c2f ("powerpc/mm: Fixup tlbie vs store ordering issue on
POWER9") is fixed for Nimbus 2.3 and Cumulus 1.3 revisions. We don't
need to apply the fixup if we are running on them

We can only do this on PowerNV. On pseries guest with KVM we still
don't support redoing the feature fixup after migration. So we should
be enabling all the workarounds needed, because whe can possibly
migrate between DD 2.3 and DD 2.2

Fixes: a5d4b5891c2f ("powerpc/mm: Fixup tlbie vs store ordering issue on POWER9")
Cc: stable@vger.kernel.org # v4.16+
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190924035254.24612-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/dt_cpu_ftrs.c |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/dt_cpu_ftrs.c
+++ b/arch/powerpc/kernel/dt_cpu_ftrs.c
@@ -691,9 +691,35 @@ static bool __init cpufeatures_process_f
 	return true;
 }
 
+/*
+ * Handle POWER9 broadcast tlbie invalidation issue using
+ * cpu feature flag.
+ */
+static __init void update_tlbie_feature_flag(unsigned long pvr)
+{
+	if (PVR_VER(pvr) == PVR_POWER9) {
+		/*
+		 * Set the tlbie feature flag for anything below
+		 * Nimbus DD 2.3 and Cumulus DD 1.3
+		 */
+		if ((pvr & 0xe000) == 0) {
+			/* Nimbus */
+			if ((pvr & 0xfff) < 0x203)
+				cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_BUG;
+		} else if ((pvr & 0xc000) == 0) {
+			/* Cumulus */
+			if ((pvr & 0xfff) < 0x103)
+				cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_BUG;
+		} else {
+			WARN_ONCE(1, "Unknown PVR");
+			cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_BUG;
+		}
+	}
+}
+
 static __init void cpufeatures_cpu_quirks(void)
 {
-	int version = mfspr(SPRN_PVR);
+	unsigned long version = mfspr(SPRN_PVR);
 
 	/*
 	 * Not all quirks can be derived from the cpufeatures device tree.
@@ -712,10 +738,10 @@ static __init void cpufeatures_cpu_quirk
 
 	if ((version & 0xffff0000) == 0x004e0000) {
 		cur_cpu_spec->cpu_features &= ~(CPU_FTR_DAWR);
-		cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_BUG;
 		cur_cpu_spec->cpu_features |= CPU_FTR_P9_TIDR;
 	}
 
+	update_tlbie_feature_flag(version);
 	/*
 	 * PKEY was not in the initial base or feature node
 	 * specification, but it should become optional in the next


